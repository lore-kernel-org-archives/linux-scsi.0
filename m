Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208EEC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 06:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080C12065F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 06:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgGMGT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 02:19:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:43290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgGMGT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 02:19:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7E530AD3F;
        Mon, 13 Jul 2020 06:19:56 +0000 (UTC)
Subject: Re: [PATCH] scsi: allow state transitions BLOCK -> BLOCK
To:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20200702142436.98336-1-hare@suse.de>
 <1593700443.9652.2.camel@HansenPartnership.com>
 <0c1ce7fc-98ba-0a14-d1a7-889bf1ce794f@suse.de>
 <2dd291ba-1e59-5e88-de96-5d3965f20317@acm.org>
 <819ce023-93c3-249d-2221-97438f229e03@suse.de>
 <b4842dfd-f385-64a9-6421-03765f60d0d9@acm.org>
 <97d4882d-2f26-de93-672a-6395e8fedf0c@suse.de>
 <a2db3f6a-44de-2d2c-6dd1-69d5af8f7e84@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b31a9be0-1e42-f49f-d5e7-e4568dafa8b2@suse.de>
Date:   Mon, 13 Jul 2020 08:19:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a2db3f6a-44de-2d2c-6dd1-69d5af8f7e84@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/20 6:13 AM, Bart Van Assche wrote:
> On 2020-07-05 23:22, Hannes Reinecke wrote:
>> That will still have a duplicate call as scsi_target_block() has been called already (cf scsi_target_block() in line 539 right at the start of srp_reconnect_rport()).
>>
>> (And I don't think we need the WARN_ON_ONCE() here; we are checking for rport->state == SRP_RPORT_BLOCKED just before that line...)
> 
> How about the patch below? The approach implemented by that
> patch is only to call scsi_target_block() after a successful
> transition to the SRP_RPORT_BLOCKED state and to only call
> scsi_target_unblock() when leaving the SRP_RPORT_BLOCKED state.
> 
> Thanks,
> 
> Bart.
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index d4d1104fac99..0334f86f0879 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -402,13 +402,9 @@ static void __rport_fail_io_fast(struct srp_rport *rport)
> 
>   	lockdep_assert_held(&rport->mutex);
> 
> +	WARN_ON_ONCE(rport->state != SRP_RPORT_BLOCKED);
>   	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
>   		return;
> -	/*
> -	 * Call scsi_target_block() to wait for ongoing shost->queuecommand()
> -	 * calls before invoking i->f->terminate_rport_io().
> -	 */
> -	scsi_target_block(rport->dev.parent);
>   	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
> 
>   	/* Involve the LLD if possible to terminate all I/O on the rport. */
> @@ -541,7 +537,8 @@ int srp_reconnect_rport(struct srp_rport *rport)
>   	res = mutex_lock_interruptible(&rport->mutex);
>   	if (res)
>   		goto out;
> -	scsi_target_block(&shost->shost_gendev);
> +	if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0)
> +		scsi_target_block(&shost->shost_gendev);
>   	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
>   	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
>   		 dev_name(&shost->shost_gendev), rport->state, res);
> @@ -569,9 +566,9 @@ int srp_reconnect_rport(struct srp_rport *rport)
>   		 * and dev_loss off. Mark the port as failed and start the TL
>   		 * failure timers if these had not yet been started.
>   		 */
> +		WARN_ON_ONCE(srp_rport_set_state(rport, SRP_RPORT_BLOCKED));
> +		scsi_target_block(rport->dev.parent);
>   		__rport_fail_io_fast(rport);
> -		scsi_target_unblock(&shost->shost_gendev,
> -				    SDEV_TRANSPORT_OFFLINE);
>   		__srp_start_tl_fail_timers(rport);
>   	} else if (rport->state != SRP_RPORT_BLOCKED) {
>   		scsi_target_unblock(&shost->shost_gendev,
> 

That doesn't look correct.
We just set the portstate to 'blocked' in the first hunk.
So the only way for this bit to make any sense would be if the portstate 
would _not_ blocked, _and_ we have a valid state transition to 'blocked'.
But this cannot happen, as the state can't change in between those two 
calls, and the first state change didn't succeed. So this state change 
won't succeed, either, and the WARN_ON will always trigger here.

Plus this whole hunk is reached from an if condition:

	} else if (rport->state == SRP_RPORT_RUNNING) {

which (after the first hunk) is never viable, as the transition RUNNINNG 
-> BLOCKED is allowed. Hence the first hunk will always transition to 
BLOCKED, and this whole block can never be reached.

I think this should be sufficient:

diff --git a/drivers/scsi/scsi_transport_srp.c 
b/drivers/scsi/scsi_transport_srp.c
index d4d1104fac99..180b323f46b8 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -404,11 +404,6 @@ static void __rport_fail_io_fast(struct srp_rport 
*rport)

         if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
                 return;
-       /*
-        * Call scsi_target_block() to wait for ongoing 
shost->queuecommand()
-        * calls before invoking i->f->terminate_rport_io().
-        */
-       scsi_target_block(rport->dev.parent);
         scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);

         /* Involve the LLD if possible to terminate all I/O on the 
rport. */
@@ -570,8 +565,6 @@ int srp_reconnect_rport(struct srp_rport *rport)
                  * failure timers if these had not yet been started.
                  */
                 __rport_fail_io_fast(rport);
-               scsi_target_unblock(&shost->shost_gendev,
-                                   SDEV_TRANSPORT_OFFLINE);
                 __srp_start_tl_fail_timers(rport);
         } else if (rport->state != SRP_RPORT_BLOCKED) {
                 scsi_target_unblock(&shost->shost_gendev,


Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

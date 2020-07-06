Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2D1C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B702075B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgGFGWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:22:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:46190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgGFGWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jul 2020 02:22:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E95BB157;
        Mon,  6 Jul 2020 06:22:04 +0000 (UTC)
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
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <97d4882d-2f26-de93-672a-6395e8fedf0c@suse.de>
Date:   Mon, 6 Jul 2020 08:22:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b4842dfd-f385-64a9-6421-03765f60d0d9@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/6/20 4:30 AM, Bart Van Assche wrote:
> On 2020-07-02 22:30, Hannes Reinecke wrote:
>> And it's called from srp_reconnect_rport() and __rport_fail_io_fast(),
>> so we have this call chain:
>>
>> srp_reconnect_rport()
>>    - scsi_target_block()
>>    -> __rport_fail_io_fast()
>>         - scsi_target_block()
> 
> How about the (untested) patch below?
> 
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index d4d1104fac99..bfb240675f06 100644
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
> @@ -569,9 +565,9 @@ int srp_reconnect_rport(struct srp_rport *rport)
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
That will still have a duplicate call as scsi_target_block() has been 
called already (cf scsi_target_block() in line 539 right at the start of 
srp_reconnect_rport()).

(And I don't think we need the WARN_ON_ONCE() here; we are checking for 
rport->state == SRP_RPORT_BLOCKED just before that line...)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A09C64E8A
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D5020825
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgK3Tnl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 14:43:41 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:59373 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgK3Tnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 14:43:40 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 582CE2EAB4E;
        Mon, 30 Nov 2020 14:42:59 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id Xpjzrty-J49n; Mon, 30 Nov 2020 14:32:40 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id B47E72EAB43;
        Mon, 30 Nov 2020 14:42:58 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v1 3/3] scsi_debug: iouring iopoll support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20201015133721.63476-1-kashyap.desai@broadcom.com>
 <56c55fed-3034-9fbf-b089-a07e74d9b05b@interlog.com>
 <1d8b5c319efd67aadd411632ee519295@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <290fc0c0-924e-7b05-d6d7-6af8aeaf855e@interlog.com>
Date:   Mon, 30 Nov 2020 14:42:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d8b5c319efd67aadd411632ee519295@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-30 4:06 a.m., Kashyap Desai wrote:
>>
>> On 2020-10-15 9:37 a.m., Kashyap Desai wrote:
>>> Add support of iouring iopoll interface in scsi_debug.
>>> This feature requires shared hosttag support in kernel and driver.
>>
>> I am continuing to test this patch. There is one fix shown inline below
>> plus a
>> question near the end.
> 
> Hi Doug,  I have created add-on patch which includes all your comment. I am
> also able to see the issue you reported and below patch fix it.
> I will hold V2 revision of the series and I will wait for your Review-by and
> Tested-by Tag.
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4d9cc6af588c..fb328253086d 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5675,6 +5675,7 @@ MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer
> length granularity exponent
>   MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout,
> 8->recovered_err... (def=0)");
>   MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get
> new store (def=0)");
>   MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
> +MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to
> max(submit_queues - 1)");
>   MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
>   MODULE_PARM_DESC(random, "If set, uniformly randomize command duration
> between 0 and delay_in_ns");
>   MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
> @@ -5683,7 +5684,6 @@ MODULE_PARM_DESC(sector_size, "logical block size in
> bytes (def=512)");
>   MODULE_PARM_DESC(statistics, "collect statistics on commands, queues
> (def=0)");
>   MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
>   MODULE_PARM_DESC(submit_queues, "support for block multi-queue (def=1)");
> -MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues");
>   MODULE_PARM_DESC(tur_ms_to_ready, "TEST UNIT READY millisecs before initial
> good status (def=0)");
>   MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba
> (def=0)");
>   MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in
> blocks (def=1)");
> @@ -7199,7 +7199,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost,
> unsigned int queue_num)
>          do {
>                  spin_lock_irqsave(&sqp->qc_lock, iflags);
>                  qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
> -               if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE)))
> +               if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
>                          goto out;
> 
>                  sqcp = &sqp->qc_arr[qc_idx];
> @@ -7477,10 +7477,17 @@ static int sdebug_driver_probe(struct device *dev)
>                  hpnt->host_tagset = 1;
> 
>          /* poll queues are possible for nr_hw_queues > 1 */
> -       if (hpnt->nr_hw_queues == 1)
> +       if (hpnt->nr_hw_queues == 1 || (poll_queues < 1)) {
> +               pr_warn("%s: trim poll_queues to 0. poll_q/nr_hw = (%d/%d)
> \n",
> +                        my_name, poll_queues, hpnt->nr_hw_queues);
>                  poll_queues = 0;
> +       }
> 
> -       /* poll queues  */
> +       /*
> +        * Poll queues don't need interrupts, but we need at least one I/O
> queue
> +        * left over for non-polled I/O.
> +        * If condition not met, trim poll_queues to 1 (just for
> simplicity).
> +        */
>          if (poll_queues >= submit_queues) {
>                  pr_warn("%s: trim poll_queues to 1\n", my_name);
>                  poll_queues = 1;
> 
>

Kashyap,
I struggled with this patch, first the line wrap, then the last two
patch segments not applying. Could you send me the scsi_debug.c file
attached to an email?

>>> +	do {
>>> +		spin_lock_irqsave(&sqp->qc_lock, iflags);
>>> +		qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
>>> +		if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE)))
>>
>> The above line IMO needs to be:
>> 		if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
>>
>> If not, when sdebug_max_queue < SDEBUG_CANQUEUE and there is no
>> request waiting then "scp is NULL, ..." is reported suggesting there is an
>> error.
> 
> BTW -  Is below piece of code at sdebug_q_cmd_complete() requires similar
> change ?
> Use sdebug_max_queue instead of SDEBUG_CANQUEUE
>          if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE))) {
>                  pr_err("wild qc_idx=%d\n", qc_idx);
>                  return;
>          }

Yes, I need to look at this. sdebug_max_queue is initialized to
SDEBUG_CANQUEUE but then can be overridden by the invocation line parameters.
Several arrays in structures are sized by SDEBUG_CANQUEUE which will
remain. But most SDEBUG_CANQUEUE uses inside driver functions can probably
be replaced by sdebug_max_queue when I confirm that it is safe. Since
sdebug_max_queue <= SDEBUG_CANQUEUE and the fields in between should
always be zero, the current situation just leads to wasted cycles.

Doug Gilbert


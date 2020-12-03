Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D85DC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 19:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4DA0221EC
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 19:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgLCTKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:10:00 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:60176 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgLCTJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 14:09:59 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 48F7A2EA21C;
        Thu,  3 Dec 2020 14:09:18 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id vaotILf9rNDk; Thu,  3 Dec 2020 13:58:47 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 8D6922EA01A;
        Thu,  3 Dec 2020 14:09:17 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 3/4] scsi_debug : iouring iopoll support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20201203034100.29716-1-kashyap.desai@broadcom.com>
 <20201203034100.29716-4-kashyap.desai@broadcom.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <97ab044f-7426-6182-f3c3-cfd179637009@interlog.com>
Date:   Thu, 3 Dec 2020 14:09:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203034100.29716-4-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

See my comment further down.

On 2020-12-02 10:40 p.m., Kashyap Desai wrote:
> Add support of iouring iopoll interface in scsi_debug.
> This feature requires shared hosttag support in kernel and driver.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Tested-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> Cc: dgilbert@interlog.com
> Cc: linux-block@vger.kernel.org
> ---
>   drivers/scsi/scsi_debug.c | 130 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 130 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 24c0f7ec0351..4ced913f2b39 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -829,6 +829,7 @@ static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
>   static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
>   
>   static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
> +static int poll_queues; /* iouring iopoll interface.*/
>   static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
>   
>   static DEFINE_RWLOCK(atomic_rw);
> @@ -5432,6 +5433,14 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   	cmnd->host_scribble = (unsigned char *)sqcp;
>   	sd_dp = sqcp->sd_dp;
>   	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +
> +	/* Do not complete IO from default completion path.
> +	 * Let it to be on queue.
> +	 * Completion should happen from mq_poll interface.
> +	 */
> +	if ((sqp - sdebug_q_arr) >= (submit_queues - poll_queues))
> +		return 0;
> +
>   	if (!sd_dp) {
>   		sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
>   		if (!sd_dp) {
> @@ -5615,6 +5624,7 @@ module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
>   module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
>   module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
>   module_param_named(submit_queues, submit_queues, int, S_IRUGO);
> +module_param_named(poll_queues, poll_queues, int, S_IRUGO);
>   module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
>   module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
>   module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
> @@ -5677,6 +5687,7 @@ MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent
>   MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
>   MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get new store (def=0)");
>   MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
> +MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to max(submit_queues - 1)");
>   MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
>   MODULE_PARM_DESC(random, "If set, uniformly randomize command duration between 0 and delay_in_ns");
>   MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
> @@ -7200,6 +7211,104 @@ static int resp_not_ready(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	return check_condition_result;
>   }
>   
> +static int sdebug_map_queues(struct Scsi_Host *shost)
> +{
> +	int i, qoff;
> +
> +	if (shost->nr_hw_queues == 1)
> +		return 0;
> +
> +	for (i = 0, qoff = 0; i < HCTX_MAX_TYPES; i++) {
> +		struct blk_mq_queue_map *map = &shost->tag_set.map[i];
> +
> +		map->nr_queues  = 0;
> +
> +		if (i == HCTX_TYPE_DEFAULT)
> +			map->nr_queues = submit_queues - poll_queues;
> +		else if (i == HCTX_TYPE_POLL)
> +			map->nr_queues = poll_queues;
> +
> +		if (!map->nr_queues) {
> +			BUG_ON(i == HCTX_TYPE_DEFAULT);
> +			continue;
> +		}
> +
> +		map->queue_offset = qoff;
> +		blk_mq_map_queues(map);
> +
> +		qoff += map->nr_queues;
> +	}
> +
> +	return 0;
> +
> +}
> +
> +static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
> +{
> +	int qc_idx;
> +	int retiring = 0;
> +	unsigned long iflags;
> +	struct sdebug_queue *sqp;
> +	struct sdebug_queued_cmd *sqcp;
> +	struct scsi_cmnd *scp;
> +	struct sdebug_dev_info *devip;
> +	int num_entries = 0;
> +
> +	sqp = sdebug_q_arr + queue_num;
> +
> +	do {
> +		spin_lock_irqsave(&sqp->qc_lock, iflags);
> +		qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
> +		if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
> +			goto out;

If you are rolling this patchset again, perhaps you could change the "if"
above to:
		if (likely(qc_idx >= sdebug_max_queue))

since find_first_bit() returns unsigned long. Also, if we are polling,
unless the storage is extremely fast, we should see find_first_bit()
not finding any bits set most of the time. In that case it will return 
sdebug_max_queue, so flag it as (more) likely. That should also indicate
to someone reading the code that the "goto out" in this case is _not_
an error path and may well be the fast path.

Doug Gilbert

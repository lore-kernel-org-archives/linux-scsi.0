Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CB8C6379D
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 16:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E9B206F9
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 16:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390418AbgKXQi5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:38:57 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:59825 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390337AbgKXQi4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 11:38:56 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 7CD692EA0FA;
        Tue, 24 Nov 2020 11:38:55 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id qWgJReFE2muH; Tue, 24 Nov 2020 11:29:01 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id BEE702EA106;
        Tue, 24 Nov 2020 11:38:54 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v1 3/3] scsi_debug: iouring iopoll support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20201015133721.63476-1-kashyap.desai@broadcom.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <56c55fed-3034-9fbf-b089-a07e74d9b05b@interlog.com>
Date:   Tue, 24 Nov 2020 11:38:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201015133721.63476-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-15 9:37 a.m., Kashyap Desai wrote:
> Add support of iouring iopoll interface in scsi_debug.
> This feature requires shared hosttag support in kernel and driver.

I am continuing to test this patch. There is one fix shown inline below
plus a question near the end.

Doug Gilbert

> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: dgilbert@interlog.com
> Cc: linux-block@vger.kernel.org
> ---
>   drivers/scsi/scsi_debug.c | 123 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 123 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a87e40aec11f..4d9cc6af588c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -826,6 +826,7 @@ static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
>   static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
>   
>   static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
> +static int poll_queues; /* iouring iopoll interface.*/
>   static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
>   
>   static DEFINE_RWLOCK(atomic_rw);
> @@ -5422,6 +5423,14 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
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
> @@ -5604,6 +5613,7 @@ module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
>   module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
>   module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
>   module_param_named(submit_queues, submit_queues, int, S_IRUGO);
> +module_param_named(poll_queues, poll_queues, int, S_IRUGO);
>   module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
>   module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
>   module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
> @@ -5673,6 +5683,7 @@ MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
>   MODULE_PARM_DESC(statistics, "collect statistics on commands, queues (def=0)");
>   MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
>   MODULE_PARM_DESC(submit_queues, "support for block multi-queue (def=1)");
> +MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues");
>   MODULE_PARM_DESC(tur_ms_to_ready, "TEST UNIT READY millisecs before initial good status (def=0)");
>   MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
>   MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
> @@ -7140,6 +7151,104 @@ static int resp_not_ready(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
> +		if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE)))

The above line IMO needs to be:
		if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))

If not, when sdebug_max_queue < SDEBUG_CANQUEUE and there is no request waiting
then "scp is NULL, ..." is reported suggesting there is an error.

> +			goto out;
> +
> +		sqcp = &sqp->qc_arr[qc_idx];
> +		scp = sqcp->a_cmnd;
> +		if (unlikely(scp == NULL)) {
> +			pr_err("scp is NULL, queue_num=%d, qc_idx=%d from %s\n",
> +			       queue_num, qc_idx, __func__);
> +			goto out;
> +		}
> +		devip = (struct sdebug_dev_info *)scp->device->hostdata;
> +		if (likely(devip))
> +			atomic_dec(&devip->num_in_q);
> +		else
> +			pr_err("devip=NULL from %s\n", __func__);
> +		if (unlikely(atomic_read(&retired_max_queue) > 0))
> +			retiring = 1;
> +
> +		sqcp->a_cmnd = NULL;
> +		if (unlikely(!test_and_clear_bit(qc_idx, sqp->in_use_bm))) {
> +			pr_err("Unexpected completion sqp %p queue_num=%d qc_idx=%d from %s\n",
> +				sqp, queue_num, qc_idx, __func__);
> +			goto out;
> +		}
> +
> +		if (unlikely(retiring)) {	/* user has reduced max_queue */
> +			int k, retval;
> +
> +			retval = atomic_read(&retired_max_queue);
> +			if (qc_idx >= retval) {
> +				pr_err("index %d too large\n", retval);
> +				goto out;
> +			}
> +			k = find_last_bit(sqp->in_use_bm, retval);
> +			if ((k < sdebug_max_queue) || (k == retval))
> +				atomic_set(&retired_max_queue, 0);
> +			else
> +				atomic_set(&retired_max_queue, k + 1);
> +		}
> +		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +		scp->scsi_done(scp); /* callback to mid level */
> +		num_entries++;
> +	} while (1);
> +
> +out:
> +	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +	return num_entries;
> +}
> +
> +
>   static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   				   struct scsi_cmnd *scp)
>   {
> @@ -7318,6 +7427,8 @@ static struct scsi_host_template sdebug_driver_template = {
>   	.ioctl =		scsi_debug_ioctl,
>   	.queuecommand =		scsi_debug_queuecommand,
>   	.change_queue_depth =	sdebug_change_qdepth,
> +	.map_queues =		sdebug_map_queues,
> +	.mq_poll =		sdebug_blk_mq_poll,
>   	.eh_abort_handler =	scsi_debug_abort,
>   	.eh_device_reset_handler = scsi_debug_device_reset,
>   	.eh_target_reset_handler = scsi_debug_target_reset,
> @@ -7365,6 +7476,18 @@ static int sdebug_driver_probe(struct device *dev)
>   	if (sdebug_host_max_queue)
>   		hpnt->host_tagset = 1;
>   
> +	/* poll queues are possible for nr_hw_queues > 1 */
> +	if (hpnt->nr_hw_queues == 1)
> +		poll_queues = 0;
> +
> +	/* poll queues  */
> +	if (poll_queues >= submit_queues) {

So the above line rules out poll_queues == submit_queues; is that the
intention? If so, a short explanation of why in a comment would be
helpful. Helpful at least to me who would like to document this option.

> +		pr_warn("%s: trim poll_queues to 1\n", my_name);
> +		poll_queues = 1;
> +	}
> +	if (poll_queues)
> +		hpnt->nr_maps = 3;
> +
>   	sdbg_host->shost = hpnt;
>   	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
>   	if ((hpnt->this_id >= 0) && (sdebug_num_tgts > hpnt->this_id))
> 


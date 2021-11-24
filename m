Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409F5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 11:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbhKXLSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 06:18:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:17006 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240855AbhKXLSg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 06:18:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215285176"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="215285176"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 03:15:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="740957588"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2021 03:15:07 -0800
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <49dceca8-7391-1b58-1384-e57f134a4e2d@intel.com>
Date:   Wed, 24 Nov 2021 13:15:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/11/2021 13:02, Adrian Hunter wrote:
> On 19/11/2021 21:57, Bart Van Assche wrote:
>> The only functional change in this patch is the addition of a
>> blk_mq_start_request() call in ufshcd_issue_devman_upiu_cmd().
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 46 +++++++++++++++++++++++++--------------
>>  1 file changed, 30 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index fced4528ee90..dfa5f127342b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2933,6 +2933,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>  {
>>  	struct request_queue *q = hba->cmd_queue;
>>  	DECLARE_COMPLETION_ONSTACK(wait);
>> +	struct scsi_cmnd *scmd;
>>  	struct request *req;
>>  	struct ufshcd_lrb *lrbp;
>>  	int err;
>> @@ -2945,15 +2946,18 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>  	 * Even though we use wait_event() which sleeps indefinitely,
>>  	 * the maximum wait time is bounded by SCSI request timeout.
>>  	 */
>> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
>> -	if (IS_ERR(req)) {
>> -		err = PTR_ERR(req);
>> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
> 
> We do not need the block layer, nor SCSI commands which begs the question,
> why involve them at all?
> 
> For example, the following is much simpler and seems to work:

Applied on top of patches 7 - 10, where patch 10 has the unintended
removal of blk_mq_free_request() that would have been removed here
instead.

> 
> 
>  drivers/scsi/ufs/ufshcd.c | 52 +++++++--------------------------------
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 10 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d125d8792ace5..bdfac3e9991ee 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -128,8 +128,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
>  enum {
>  	UFSHCD_MAX_CHANNEL	= 0,
>  	UFSHCD_MAX_ID		= 1,
> -	UFSHCD_CMD_PER_LUN	= 32,
> -	UFSHCD_CAN_QUEUE	= 32,
> +	UFSHCD_NUM_RESERVED	= 1,
> +	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
> +	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
>  };
>  
>  static const char *const ufshcd_state_name[] = {
> @@ -2189,6 +2190,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>  	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
>  	hba->nutmrs =
>  	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
> +	hba->reserved_slot = hba->nutrs - 1;
>  
>  	/* Read crypto capabilities */
>  	err = ufshcd_hba_init_crypto_capabilities(hba);
> @@ -2931,31 +2933,13 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
>  static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  		enum dev_cmd_type cmd_type, int timeout)
>  {
> -	struct request_queue *q = hba->cmd_queue;
>  	DECLARE_COMPLETION_ONSTACK(wait);
> -	struct request *req;
>  	struct ufshcd_lrb *lrbp;
>  	int err;
> -	int tag;
> +	int tag = hba->reserved_slot;
>  
>  	down_read(&hba->clk_scaling_lock);
>  
> -	/*
> -	 * Get free slot, sleep if slots are unavailable.
> -	 * Even though we use wait_event() which sleeps indefinitely,
> -	 * the maximum wait time is bounded by SCSI request timeout.
> -	 */
> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
> -	if (IS_ERR(req)) {
> -		err = PTR_ERR(req);
> -		goto out_unlock;
> -	}
> -	tag = req->tag;
> -	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> -	/* Set the timeout such that the SCSI error handler is not activated. */
> -	req->timeout = msecs_to_jiffies(2 * timeout);
> -	blk_mq_start_request(req);
> -
>  	lrbp = &hba->lrb[tag];
>  	WARN_ON(lrbp->cmd);
>  	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
> @@ -2970,10 +2954,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>  	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
>  				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
> -
>  out:
> -	blk_mq_free_request(req);
> -out_unlock:
>  	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> @@ -4955,11 +4936,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
>   */
>  static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
>  {
> -	struct ufs_hba *hba = shost_priv(sdev->host);
> -
> -	if (depth > hba->nutrs)
> -		depth = hba->nutrs;
> -	return scsi_change_queue_depth(sdev, depth);
> +	return scsi_change_queue_depth(sdev, min(depth, sdev->host->can_queue));
>  }
>  
>  static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
> @@ -6706,24 +6683,14 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  					enum dev_cmd_type cmd_type,
>  					enum query_opcode desc_op)
>  {
> -	struct request_queue *q = hba->cmd_queue;
>  	DECLARE_COMPLETION_ONSTACK(wait);
> -	struct request *req;
>  	struct ufshcd_lrb *lrbp;
>  	int err = 0;
> -	int tag;
> +	int tag = hba->reserved_slot;
>  	u8 upiu_flags;
>  
>  	down_read(&hba->clk_scaling_lock);
>  
> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
> -	if (IS_ERR(req)) {
> -		err = PTR_ERR(req);
> -		goto out_unlock;
> -	}
> -	tag = req->tag;
> -	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> -
>  	lrbp = &hba->lrb[tag];
>  	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
> @@ -6791,7 +6758,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
>  				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
>  
> -out_unlock:
>  	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> @@ -9516,8 +9482,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	/* Configure LRB */
>  	ufshcd_host_memory_configure(hba);
>  
> -	host->can_queue = hba->nutrs;
> -	host->cmd_per_lun = hba->nutrs;
> +	host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
> +	host->cmd_per_lun = hba->nutrs - UFSHCD_NUM_RESERVED;
>  	host->max_id = UFSHCD_MAX_ID;
>  	host->max_lun = UFS_MAX_LUNS;
>  	host->max_channel = UFSHCD_MAX_CHANNEL;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e9bc07c69a801..1addb2c906bae 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -836,6 +836,7 @@ struct ufs_hba {
>  	u32 capabilities;
>  	int nutrs;
>  	int nutmrs;
> +	int reserved_slot; /* Protected by dev_cmd.lock */
>  	u32 ufs_version;
>  	const struct ufs_hba_variant_ops *vops;
>  	struct ufs_hba_variant_params *vps;
> 


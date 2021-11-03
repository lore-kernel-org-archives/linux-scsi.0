Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C25BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 06:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 005C46115B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 06:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKCG6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 02:58:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:32034 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKCG6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 02:58:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="231291604"
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="231291604"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 23:56:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="449680467"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2021 23:56:08 -0700
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
Date:   Wed, 3 Nov 2021 08:56:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211103000529.1549411-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/11/2021 02:05, Bart Van Assche wrote:
> The following deadlock has been observed on a test setup:
> * All tags allocated.
> * The SCSI error handler calls ufshcd_eh_host_reset_handler()
> * ufshcd_eh_host_reset_handler() queues work that calls ufshcd_err_handler()
> * ufshcd_err_handler() locks up as follows:
> 
> Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
> Call trace:
>  __switch_to+0x298/0x5d8
>  __schedule+0x6cc/0xa94
>  schedule+0x12c/0x298
>  blk_mq_get_tag+0x210/0x480
>  __blk_mq_alloc_request+0x1c8/0x284
>  blk_get_request+0x74/0x134
>  ufshcd_exec_dev_cmd+0x68/0x640
>  ufshcd_verify_dev_init+0x68/0x35c
>  ufshcd_probe_hba+0x12c/0x1cb8
>  ufshcd_host_reset_and_restore+0x88/0x254
>  ufshcd_reset_and_restore+0xd0/0x354
>  ufshcd_err_handler+0x408/0xc58
>  process_one_work+0x24c/0x66c
>  worker_thread+0x3e8/0xa4c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
> 
> Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
> request.

It is worth noting that the error handler itself could always find
a free slot, either by waiting for one, or by taking the reset
path which clears all slots.

However, the problem would then be places that cause the error
handler to wait, like sysfs (due to hba->host_sem), exception
event handler (due to cancel_work_sync(&hba->eeh_work)), or
potentially any other dev cmd user (due to hba->dev_cmd.lock).

Once the layering and locking is sorted out, it might be possible
to get rid of the reserved tag, if there was a performance
benefit.

More to the point though, for the reasons above, you need to
change the other dev cmd path also
i.e. ufshcd_issue_devman_upiu_cmd()

For UFS-specific patch sets please always cc me on all patches
in a series including the cover letter.

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9d964b979aa2..6b0101169974 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2904,12 +2904,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  
>  	down_read(&hba->clk_scaling_lock);
>  
> -	/*
> -	 * Get free slot, sleep if slots are unavailable.
> -	 * Even though we use wait_event() which sleeps indefinitely,
> -	 * the maximum wait time is bounded by SCSI request timeout.
> -	 */
> -	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);

ufshcd_issue_devman_upiu_cmd() needs this also.

>  	if (IS_ERR(req)) {
>  		err = PTR_ERR(req);
>  		goto out_unlock;
> @@ -4919,11 +4914,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
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
> @@ -8124,7 +8115,8 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
> -	.can_queue		= UFSHCD_CAN_QUEUE,
> +	.can_queue		= UFSHCD_CAN_QUEUE - 1,
> +	.reserved_tags		= 1,

Number of reserved tags needs to be #define'd

>  	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
>  	.max_host_blocked	= 1,
>  	.track_queue_depth	= 1,
> @@ -9485,8 +9477,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	/* Configure LRB */
>  	ufshcd_host_memory_configure(hba);
>  
> -	host->can_queue = hba->nutrs;
> -	host->cmd_per_lun = hba->nutrs;
> +	host->can_queue = hba->nutrs - 1;
> +	host->cmd_per_lun = hba->nutrs - 1;

Number of reserved tags needs to be #define'd

>  	host->max_id = UFSHCD_MAX_ID;
>  	host->max_lun = UFS_MAX_LUNS;
>  	host->max_channel = UFSHCD_MAX_CHANNEL;
> 


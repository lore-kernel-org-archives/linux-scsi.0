Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0562C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 08:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356075AbhLBI3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 03:29:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:43658 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241248AbhLBI3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Dec 2021 03:29:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="236596833"
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="236596833"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 00:25:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="602639731"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga002.fm.intel.com with ESMTP; 02 Dec 2021 00:25:52 -0800
Subject: Re: [PATCH v3 10/17] scsi: ufs: Fix a deadlock in the error handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-11-bvanassche@acm.org>
 <25844cd2-872a-514f-4384-6ee877418dc7@intel.com>
 <ab84bffe-fd84-82c6-d4f2-3ee73e7a850e@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e65a5cd1-7397-c04e-953d-194781a79f3e@intel.com>
Date:   Thu, 2 Dec 2021 10:25:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ab84bffe-fd84-82c6-d4f2-3ee73e7a850e@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/12/2021 23:26, Bart Van Assche wrote:
> On 12/1/21 5:48 AM, Adrian Hunter wrote:
>> I think cmd_queue is not used anymore after this.
> 
> Let's remove cmd_queue via a separate patch. I have started testing this patch:
> 
> Subject: [PATCH] scsi: ufs: Remove hba->cmd_queue
> 
> Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 11 +----------
>  drivers/scsi/ufs/ufshcd.h |  2 --
>  2 files changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5b3efc880246..d379c2b0c058 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9409,7 +9409,6 @@ void ufshcd_remove(struct ufs_hba *hba)
>      ufs_sysfs_remove_nodes(hba->dev);
>      blk_cleanup_queue(hba->tmf_queue);
>      blk_mq_free_tag_set(&hba->tmf_tag_set);
> -    blk_cleanup_queue(hba->cmd_queue);
>      scsi_remove_host(hba->host);
>      /* disable interrupts */
>      ufshcd_disable_intr(hba, hba->intr_mask);
> @@ -9630,12 +9629,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>          goto out_disable;
>      }
> 
> -    hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
> -    if (IS_ERR(hba->cmd_queue)) {
> -        err = PTR_ERR(hba->cmd_queue);
> -        goto out_remove_scsi_host;
> -    }
> -
>      hba->tmf_tag_set = (struct blk_mq_tag_set) {
>          .nr_hw_queues    = 1,
>          .queue_depth    = hba->nutmrs,
> @@ -9644,7 +9637,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>      };
>      err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
>      if (err < 0)
> -        goto free_cmd_queue;
> +        goto out_remove_scsi_host;
>      hba->tmf_queue = blk_mq_init_queue(&hba->tmf_tag_set);
>      if (IS_ERR(hba->tmf_queue)) {
>          err = PTR_ERR(hba->tmf_queue);
> @@ -9713,8 +9706,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>      blk_cleanup_queue(hba->tmf_queue);
>  free_tmf_tag_set:
>      blk_mq_free_tag_set(&hba->tmf_tag_set);
> -free_cmd_queue:
> -    blk_cleanup_queue(hba->cmd_queue);
>  out_remove_scsi_host:
>      scsi_remove_host(hba->host);
>  out_disable:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 411c6015bbfe..88c20f3608c2 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -738,7 +738,6 @@ struct ufs_hba_monitor {
>   * @host: Scsi_Host instance of the driver
>   * @dev: device handle
>   * @lrb: local reference block
> - * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
>   * @outstanding_tasks: Bits representing outstanding task requests
>   * @outstanding_lock: Protects @outstanding_reqs.
>   * @outstanding_reqs: Bits representing outstanding transfer requests
> @@ -805,7 +804,6 @@ struct ufs_hba {
> 
>      struct Scsi_Host *host;
>      struct device *dev;
> -    struct request_queue *cmd_queue;
>      /*
>       * This field is to keep a reference to "scsi_device" corresponding to
>       * "UFS device" W-LU.


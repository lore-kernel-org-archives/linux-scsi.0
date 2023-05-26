Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7D4C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 07:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242278AbjEZHL4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 03:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbjEZHLy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 03:11:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC5C9E
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 00:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685085113; x=1716621113;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y/Of7pnMiZXMEq13xQXjETweMC6Cf1luQ3RuYALCNqU=;
  b=E6/BelOlA3TGjprwS6ueQSwp3G7efBdZehOsdyK+WdeK0C7O40T4UfxU
   F/Q6FqkTVpISzdUVdIkc5IsYVcOMCPl/MMd2ohjmZf5NnBC96E1jcoA8x
   9KNflYzzjNgL4ColOyUqZSxbW/nnJMmowqKM47XINL4GtgrdhOhbd8qAB
   Rvav/dU9HGxxGhgHbECKWKAxzqhXWIGMRMADgarvY0k7H4BFboyiLSiNw
   //qGzxdJeeXlMW0F3Tt7LF/+FLLm83yWgecCA2JAz1hYsxY6bbgQEYxs+
   IG60JvKijEnPs+3Jv03TqbiVwJfnbhbmK9CgyTqxMeHWf7Mke5Cttbl0m
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="417621007"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="417621007"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 00:11:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="682637032"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="682637032"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.249.40.66])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 00:11:51 -0700
Message-ID: <182cc063-e897-cd7d-d859-809da0e4fc2d@intel.com>
Date:   Fri, 26 May 2023 10:11:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-4-bvanassche@acm.org>
 <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
 <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
 <cac55dea-ec77-2802-f975-89a1cb1c734f@intel.com>
 <2d37028b-c7a1-f2ac-abb5-e85c00aceba2@acm.org>
 <096e1a7e-ea0d-de46-ef82-02a755635640@intel.com>
 <6112c17a-15f3-4517-c73f-8cbbdde20a6b@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <6112c17a-15f3-4517-c73f-8cbbdde20a6b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/05/23 00:16, Bart Van Assche wrote:
> On 5/23/23 22:55, Adrian Hunter wrote:
>> On 23/05/23 22:57, Bart Van Assche wrote:
>>> On 5/23/23 12:19, Adrian Hunter wrote:
>>>> On 23/05/23 20:10, Bart Van Assche wrote:
>>>>> The overhead of BLK_MQ_F_BLOCKING is small relative to the
>>>>> time required to queue a UFS command so I think enabling BLK_MQ_F_BLOCKING for all UFS host controllers is fine.
>>>>
>>>> Doesn't it also force the queue to be run asynchronously always?
>>>>
>>>> But in any case, it doesn't seem like something to force on drivers just because it would take a bit more coding to make it optional.
>>>
>>> Making BLK_MQ_F_BLOCKING optional would complicate testing of the UFS driver. Although it is possible to make BLK_MQ_F_BLOCKING optional, I'm wondering whether it is worth it? I haven't noticed any performance difference in my tests with BLK_MQ_F_BLOCKING enabled compared to BLK_MQ_F_BLOCKING disabled.
>>
>> It is hard to know the effects, especially wrt to future hardware.
> 
> Are you perhaps referring to performance effects? I think the block
> layer can be modified to run the queue synchronously in most cases even
> if BLK_MQ_F_BLOCKING is set. The patch below works fine but is probably
> not acceptable for upstream because it uses in_atomic(): [ ... ]

Why would we want to when we don't have to?

>> What about something like this? [ ... ]
> 
> This introduces a redundancy and a potential for a conflict between the
> "nonblocking" flag and the UFSHCD_CAP_CLK_GATING flag. It is unfortunate
> that hba->caps is set so late otherwise we could use the result of
> (hba->caps & UFSHCD_CAP_CLK_GATING) to check whether or not
> BLK_MQ_F_BLOCKING is needed.
> 
> Additionally, this patch introduces a use-after-free issue since it
> causes scsi_host_alloc() to store a pointer to a stack variable (sht)
> into a SCSI host structure.

So with those fixed and the vops->may_block instead of vops->nonblocking:


diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 82321b8b32bc..6a4389f02b4e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2027,6 +2027,11 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 
+	if (!hba->host->hostt->queuecommand_may_block) {
+		dev_warn(hba->dev, "Nonblocking queue, so clock gating is not enabled!\n");
+		return;
+	}
+
 	hba->clk_gating.state = CLKS_ON;
 
 	hba->clk_gating.delay_ms = 150;
@@ -8708,33 +8713,41 @@ static struct ufs_hba_variant_params ufs_hba_vps = {
 	.ondemand_data.downdifferential	= 5,
 };
 
-static const struct scsi_host_template ufshcd_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= UFSHCD,
-	.proc_name		= UFSHCD,
-	.map_queues		= ufshcd_map_queues,
-	.queuecommand		= ufshcd_queuecommand,
-	.mq_poll		= ufshcd_poll,
-	.slave_alloc		= ufshcd_slave_alloc,
-	.slave_configure	= ufshcd_slave_configure,
-	.slave_destroy		= ufshcd_slave_destroy,
-	.change_queue_depth	= ufshcd_change_queue_depth,
-	.eh_abort_handler	= ufshcd_abort,
-	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
-	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
-	.eh_timed_out		= ufshcd_eh_timed_out,
-	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
-	.can_queue		= UFSHCD_CAN_QUEUE,
-	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
-	.max_sectors		= (1 << 20) / SECTOR_SIZE, /* 1 MiB */
-	.max_host_blocked	= 1,
-	.track_queue_depth	= 1,
-	.skip_settle_delay	= 1,
+#define UFSHCD_SHT_COMMON \
+	.module			= THIS_MODULE,				\
+	.name			= UFSHCD,				\
+	.proc_name		= UFSHCD,				\
+	.map_queues		= ufshcd_map_queues,			\
+	.queuecommand		= ufshcd_queuecommand,			\
+	.mq_poll		= ufshcd_poll,				\
+	.slave_alloc		= ufshcd_slave_alloc,			\
+	.slave_configure	= ufshcd_slave_configure,		\
+	.slave_destroy		= ufshcd_slave_destroy,			\
+	.change_queue_depth	= ufshcd_change_queue_depth,		\
+	.eh_abort_handler	= ufshcd_abort,				\
+	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,	\
+	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,	\
+	.eh_timed_out		= ufshcd_eh_timed_out,			\
+	.this_id		= -1,					\
+	.sg_tablesize		= SG_ALL,				\
+	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,			\
+	.can_queue		= UFSHCD_CAN_QUEUE,			\
+	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,		\
+	.max_sectors		= (1 << 20) / SECTOR_SIZE, /* 1 MiB */	\
+	.max_host_blocked	= 1,					\
+	.track_queue_depth	= 1,					\
+	.skip_settle_delay	= 1,					\
+	.sdev_groups		= ufshcd_driver_groups,			\
+	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS
+
+static const struct scsi_host_template ufshcd_sht_blocking = {
+	UFSHCD_SHT_COMMON,
 	.queuecommand_may_block = true,
-	.sdev_groups		= ufshcd_driver_groups,
-	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
+};
+
+static const struct scsi_host_template ufshcd_sht_nonblocking = {
+	UFSHCD_SHT_COMMON,
+	.queuecommand_may_block = false,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
@@ -10049,13 +10062,16 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
+ * __ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
+ * @vops: pointer to variant specific operations
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
+int __ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle,
+			const struct ufs_hba_variant_ops *vops)
 {
+	const struct scsi_host_template *sht;
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	int err = 0;
@@ -10067,8 +10083,12 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		goto out_error;
 	}
 
-	host = scsi_host_alloc(&ufshcd_driver_template,
-				sizeof(struct ufs_hba));
+	if (vops && vops->may_block)
+		sht = &ufshcd_sht_blocking;
+	else
+		sht = &ufshcd_sht_nonblocking;
+
+	host = scsi_host_alloc(sht, sizeof(struct ufs_hba));
 	if (!host) {
 		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
@@ -10078,6 +10098,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
+	hba->vops = vops;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
@@ -10089,7 +10110,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 out_error:
 	return err;
 }
-EXPORT_SYMBOL(ufshcd_alloc_host);
+EXPORT_SYMBOL(__ufshcd_alloc_host);
 
 /* This function exists because blk_mq_alloc_tag_set() requires this. */
 static blk_status_t ufshcd_queue_tmf(struct blk_mq_hw_ctx *hctx,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8039c2b72502..dbeb879b47d1 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -274,6 +274,7 @@ struct ufs_pwr_mode_info {
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
+ * @may_block: queuecommand may block (required with UFSHCD_CAP_CLK_GATING)
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
  * @get_ufs_hci_version: called to get UFS HCI version
@@ -310,6 +311,7 @@ struct ufs_pwr_mode_info {
  */
 struct ufs_hba_variant_ops {
 	const char *name;
+	bool	may_block;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
@@ -1225,7 +1227,20 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 	ufshcd_writel(hba, tmp, reg);
 }
 
-int ufshcd_alloc_host(struct device *, struct ufs_hba **);
+int __ufshcd_alloc_host(struct device *, struct ufs_hba **,
+			const struct ufs_hba_variant_ops *);
+
+/**
+ * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
+ * @dev: pointer to device handle
+ * @hba_handle: driver private handle
+ * Returns 0 on success, non-zero value on failure
+ */
+static inline int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
+{
+	return __ufshcd_alloc_host(dev, hba_handle, NULL);
+}
+
 void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);



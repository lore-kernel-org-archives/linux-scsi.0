Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF97C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 05:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbjEXFze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 01:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbjEXFze (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 01:55:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DD013E
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 22:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684907732; x=1716443732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/y6QZyP6oGgpOoUvs6983Ko1pPCTbV0bZpwcScQRwoI=;
  b=TVo2uXd0Bky8eG6FvprV8w6WHIZvKG+PNCKv63nLTZqIQTKe+fynj6Bt
   ib5zcbgm22bQzgbsk2jpsIPTAOQtkNDpXow7ldZ6l+O2IWk9t8zM7fk2o
   1kKn8vUYM582prASFva2sTrjw8Dp+pQkyQq7GmGVHd3ZRgUhkf4pOZcEf
   zNwkYGKzgY+Q6WbBSrR8ryNSgSqRqlzfddLDQC7HW6mFDXc4haKf76tCC
   D+k8EOvungvHRKDyd4wZMN0ep00+Z7XnvIok3sZkUFayqFyobqSpiyn0Q
   nOLlsSIcpO1uySkW73LdThStuVwu0iVOd9hoSgObfoHSdRAJpDyDv9tbN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="439817374"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="439817374"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 22:55:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="654689389"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="654689389"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.223.197])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 22:55:30 -0700
Message-ID: <096e1a7e-ea0d-de46-ef82-02a755635640@intel.com>
Date:   Wed, 24 May 2023 08:55:26 +0300
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <2d37028b-c7a1-f2ac-abb5-e85c00aceba2@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/05/23 22:57, Bart Van Assche wrote:
> On 5/23/23 12:19, Adrian Hunter wrote:
>> On 23/05/23 20:10, Bart Van Assche wrote:
>>> The overhead of BLK_MQ_F_BLOCKING is small relative to the time required to
>>> queue a UFS command so I think enabling BLK_MQ_F_BLOCKING for all UFS host
>>> controllers is fine.
>>
>> Doesn't it also force the queue to be run asynchronously always?
>>
>> But in any case, it doesn't seem like something to force on drivers
>> just because it would take a bit more coding to make it optional.
> Making BLK_MQ_F_BLOCKING optional would complicate testing of the UFS driver. Although it is possible to make BLK_MQ_F_BLOCKING optional, I'm wondering whether it is worth it? I haven't noticed any performance difference in my tests with BLK_MQ_F_BLOCKING enabled compared to BLK_MQ_F_BLOCKING disabled.

It is hard to know the effects, especially wrt to future hardware.

What about something like this?

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 82321b8b32bc..301c0b2a406d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10049,13 +10049,16 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
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
+	struct scsi_host_template sht = ufshcd_driver_template;
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	int err = 0;
@@ -10067,8 +10070,10 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		goto out_error;
 	}
 
-	host = scsi_host_alloc(&ufshcd_driver_template,
-				sizeof(struct ufs_hba));
+	if (vops && vops->nonblocking)
+		sht.queuecommand_may_block = false;
+
+	host = scsi_host_alloc(&sht, sizeof(struct ufs_hba));
 	if (!host) {
 		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
@@ -10078,6 +10083,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
+	hba->vops = vops;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
@@ -10089,7 +10095,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 out_error:
 	return err;
 }
-EXPORT_SYMBOL(ufshcd_alloc_host);
+EXPORT_SYMBOL(__ufshcd_alloc_host);
 
 /* This function exists because blk_mq_alloc_tag_set() requires this. */
 static blk_status_t ufshcd_queue_tmf(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 9c911787f84c..ce42b822fcb6 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -447,6 +447,7 @@ static int ufs_intel_mtl_init(struct ufs_hba *hba)
 
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
+	.nonblocking		= true,
 	.init			= ufs_intel_common_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
@@ -455,6 +456,7 @@ static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 
 static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 	.name                   = "intel-pci",
+	.nonblocking		= true,
 	.init			= ufs_intel_ehl_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
@@ -463,6 +465,7 @@ static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 
 static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.name                   = "intel-pci",
+	.nonblocking		= true,
 	.init			= ufs_intel_lkf_init,
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
@@ -475,6 +478,7 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 
 static struct ufs_hba_variant_ops ufs_intel_adl_hba_vops = {
 	.name			= "intel-pci",
+	.nonblocking		= true,
 	.init			= ufs_intel_adl_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
@@ -484,6 +488,7 @@ static struct ufs_hba_variant_ops ufs_intel_adl_hba_vops = {
 
 static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.name                   = "intel-pci",
+	.nonblocking		= true,
 	.init			= ufs_intel_mtl_init,
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
@@ -538,6 +543,7 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 static int
 ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	const struct ufs_hba_variant_ops *vops;
 	struct ufs_host *ufs_host;
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
@@ -559,14 +565,14 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mmio_base = pcim_iomap_table(pdev)[0];
 
-	err = ufshcd_alloc_host(&pdev->dev, &hba);
+	vops = (const struct ufs_hba_variant_ops *)id->driver_data;
+
+	err = __ufshcd_alloc_host(&pdev->dev, &hba, vops);
 	if (err) {
 		dev_err(&pdev->dev, "Allocation failed\n");
 		return err;
 	}
 
-	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
-
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8039c2b72502..dbf2312ad756 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -274,6 +274,8 @@ struct ufs_pwr_mode_info {
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
+ * @nonblocking: queuecommand will not block (incompatible with
+ *               UFSHCD_CAP_CLK_GATING)
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
  * @get_ufs_hci_version: called to get UFS HCI version
@@ -310,6 +312,7 @@ struct ufs_pwr_mode_info {
  */
 struct ufs_hba_variant_ops {
 	const char *name;
+	bool nonblocking;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
@@ -1225,7 +1228,20 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
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



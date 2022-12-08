Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5684FC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 23:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiLHXo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiLHXoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 18:44:22 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2345B79CAA
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 15:44:11 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id d3so3091211plr.10
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2022 15:44:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O64+uA3pZU185zLaMLCd0DTEL2g+wjqX3mpu4cWaP4w=;
        b=tfggnVdoIrr4+xK9uJWL9VnzyBk8FdARIlQjb/Aa1Jd+ccGraBz1qaRC5RjR+z7UTc
         dC0Jf1sGNaaa242a7IU4qpb+GWbWv4MkehE72S9YntvZFQoGe7erf5RT8+AaZQFgPvKM
         0rwLunQQE0uMhjJ4WIu8iLU19fM8/IaVpbFINVYyY96g78mJ2JnhPci8X7/yppRhq9bL
         ldYEIjCjazG0AmNpw+Q/Tnth0vhMMuATmCkY7nOsqOEgNdH4s+ULfuU0dE01jLQ8khnf
         o+4BVOyqPG+hSV4CEjIqUiWhM1TC6NeAL+XJ8UEhGmz5/+aW5GTNCEs/FvTFzz2PXS3V
         Agtw==
X-Gm-Message-State: ANoB5pk5pjh+pXwfFaJ7KKeRaZVOI4TogJd5vPXiMuk6E/xW4+7ysixR
        CYKhQFTaq5i2NDKzuHi2tw4=
X-Google-Smtp-Source: AA0mqf4JT4+XP4QtVF42x1BNN0tnpZ80Mly82Nxx9ZoYOa9SRHg5Yve6eYaBE6RSqIsezXECMBVkKw==
X-Received: by 2002:a17:90a:348e:b0:219:8cbb:c158 with SMTP id p14-20020a17090a348e00b002198cbbc158mr3618111pjb.5.1670543051169;
        Thu, 08 Dec 2022 15:44:11 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090a2f8f00b00213d28a6dedsm148553pjd.13.2022.12.08.15.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 15:44:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Eric Biggers <ebiggers@google.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 3/3] scsi: ufs: Allow UFS host drivers to override the sg entry size
Date:   Thu,  8 Dec 2022 15:43:58 -0800
Message-Id: <20221208234358.252031-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
In-Reply-To: <20221208234358.252031-1-bvanassche@acm.org>
References: <20221208234358.252031-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Modify the UFSHCD core to allow 'struct ufshcd_sg_entry' to be
variable-length. The default is the standard length, but variants can
override ufs_hba::sg_entry_size with a larger value if there are
vendor-specific fields following the standard ones.

This is needed to support inline encryption with ufs-exynos (FMP).

Cc: Eric Biggers <ebiggers@google.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
[ bvanassche: edited commit message and introduced CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++---------------------
 drivers/ufs/host/Kconfig  |  4 ++++
 include/ufs/ufshcd.h      | 30 ++++++++++++++++++++++++++++++
 include/ufs/ufshci.h      |  9 +++++++--
 4 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a7d1cf2377e1..62ee2c1ff83d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -528,7 +528,7 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 		prdt_length = le16_to_cpu(
 			lrbp->utr_descriptor_ptr->prd_table_length);
 		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
-			prdt_length /= sizeof(struct ufshcd_sg_entry);
+			prdt_length /= ufshcd_sg_entry_size(hba);
 
 		dev_err(hba->dev,
 			"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
@@ -537,7 +537,7 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 
 		if (pr_prdt)
 			ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr,
-				sizeof(struct ufshcd_sg_entry) * prdt_length);
+				ufshcd_sg_entry_size(hba) * prdt_length);
 	}
 }
 
@@ -2418,7 +2418,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  */
 static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct ufshcd_sg_entry *prd_table;
+	struct ufshcd_sg_entry *prd;
 	struct scatterlist *sg;
 	struct scsi_cmnd *cmd;
 	int sg_segments;
@@ -2433,13 +2433,12 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
 			lrbp->utr_descriptor_ptr->prd_table_length =
-				cpu_to_le16((sg_segments *
-					sizeof(struct ufshcd_sg_entry)));
+				cpu_to_le16(sg_segments * ufshcd_sg_entry_size(hba));
 		else
 			lrbp->utr_descriptor_ptr->prd_table_length =
 				cpu_to_le16(sg_segments);
 
-		prd_table = lrbp->ucd_prdt_ptr;
+		prd = lrbp->ucd_prdt_ptr;
 
 		scsi_for_each_sg(cmd, sg, sg_segments, i) {
 			const unsigned int len = sg_dma_len(sg);
@@ -2453,9 +2452,10 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 * indicates 4 bytes, '7' indicates 8 bytes, etc."
 			 */
 			WARN_ONCE(len > 256 * 1024, "len = %#x\n", len);
-			prd_table[i].size = cpu_to_le32(len - 1);
-			prd_table[i].addr = cpu_to_le64(sg->dma_address);
-			prd_table[i].reserved = 0;
+			prd->size = cpu_to_le32(len - 1);
+			prd->addr = cpu_to_le64(sg->dma_address);
+			prd->reserved = 0;
+			prd = (void *)prd + ufshcd_sg_entry_size(hba);
 		}
 	} else {
 		lrbp->utr_descriptor_ptr->prd_table_length = 0;
@@ -2745,10 +2745,11 @@ static void ufshcd_map_queues(struct Scsi_Host *shost)
 
 static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 {
-	struct utp_transfer_cmd_desc *cmd_descp = hba->ucdl_base_addr;
+	struct utp_transfer_cmd_desc *cmd_descp = (void *)hba->ucdl_base_addr +
+		i * sizeof_utp_transfer_cmd_desc(hba);
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
-		i * sizeof(struct utp_transfer_cmd_desc);
+		i * sizeof_utp_transfer_cmd_desc(hba);
 	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
 				       response_upiu);
 	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
@@ -2756,11 +2757,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 	lrb->utr_descriptor_ptr = utrdlp + i;
 	lrb->utrd_dma_addr = hba->utrdl_dma_addr +
 		i * sizeof(struct utp_transfer_req_desc);
-	lrb->ucd_req_ptr = (struct utp_upiu_req *)(cmd_descp + i);
+	lrb->ucd_req_ptr = (struct utp_upiu_req *)cmd_descp->command_upiu;
 	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
-	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
+	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp->response_upiu;
 	lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
-	lrb->ucd_prdt_ptr = cmd_descp[i].prd_table;
+	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp->prd_table;
 	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
 }
 
@@ -3669,7 +3670,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	size_t utmrdl_size, utrdl_size, ucdl_size;
 
 	/* Allocate memory for UTP command descriptors */
-	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
+	ucdl_size = sizeof_utp_transfer_cmd_desc(hba) * hba->nutrs;
 	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
 						  ucdl_size,
 						  &hba->ucdl_dma_addr,
@@ -3763,7 +3764,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	prdt_offset =
 		offsetof(struct utp_transfer_cmd_desc, prd_table);
 
-	cmd_desc_size = sizeof(struct utp_transfer_cmd_desc);
+	cmd_desc_size = sizeof_utp_transfer_cmd_desc(hba);
 	cmd_desc_dma_addr = hba->ucdl_dma_addr;
 
 	for (i = 0; i < hba->nutrs; i++) {
@@ -9658,6 +9659,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
+	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
 
@@ -10036,11 +10038,6 @@ static int __init ufshcd_core_init(void)
 {
 	int ret;
 
-	/* Verify that there are no gaps in struct utp_transfer_cmd_desc. */
-	static_assert(sizeof(struct utp_transfer_cmd_desc) ==
-		      2 * ALIGNED_UPIU_SIZE +
-			      SG_ALL * sizeof(struct ufshcd_sg_entry));
-
 	ufs_debugfs_init();
 
 	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 4cc2dbd79ed0..7f01f453e792 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -124,3 +124,7 @@ config SCSI_UFS_EXYNOS
 
 	  Select this if you have UFS host controller on Samsung Exynos SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
+	bool
+	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 5cf81dff60aa..e03f111947b6 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -754,6 +754,7 @@ struct ufs_hba_monitor {
  * @vops: pointer to variant specific operations
  * @vps: pointer to variant specific parameters
  * @priv: pointer to variant specific private data
+ * @sg_entry_size: size of struct ufshcd_sg_entry (may include variant fields)
  * @irq: Irq number of the controller
  * @is_irq_enabled: whether or not the UFS controller interrupt is enabled.
  * @dev_ref_clk_freq: reference clock frequency
@@ -877,6 +878,9 @@ struct ufs_hba {
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;
 	void *priv;
+#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
+	size_t sg_entry_size;
+#endif
 	unsigned int irq;
 	bool is_irq_enabled;
 	enum ufs_ref_clk_freq dev_ref_clk_freq;
@@ -980,6 +984,32 @@ struct ufs_hba {
 	bool complete_put;
 };
 
+#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
+static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
+{
+	return hba->sg_entry_size;
+}
+
+static inline void ufshcd_set_sg_entry_size(struct ufs_hba *hba, size_t sg_entry_size)
+{
+	WARN_ON_ONCE(sg_entry_size < sizeof(struct ufshcd_sg_entry));
+	hba->sg_entry_size = sg_entry_size;
+}
+#else
+static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
+{
+	return sizeof(struct ufshcd_sg_entry);
+}
+
+#define ufshcd_set_sg_entry_size(hba, sg_entry_size)                   \
+	({ (void)(hba); BUILD_BUG_ON(sg_entry_size != sizeof(struct ufshcd_sg_entry)); })
+#endif
+
+static inline size_t sizeof_utp_transfer_cmd_desc(const struct ufs_hba *hba)
+{
+	return sizeof(struct utp_transfer_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
+}
+
 /* Returns true if clocks can be gated. Otherwise false */
 static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
 {
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index f525566a0864..e145a478afa2 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -422,18 +422,23 @@ struct ufshcd_sg_entry {
 	__le64    addr;
 	__le32    reserved;
 	__le32    size;
+	/*
+	 * followed by variant-specific fields if
+	 * CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE has been defined.
+	 */
 };
 
 /**
  * struct utp_transfer_cmd_desc - UTP Command Descriptor (UCD)
  * @command_upiu: Command UPIU Frame address
  * @response_upiu: Response UPIU Frame address
- * @prd_table: Physical Region Descriptor
+ * @prd_table: Physical Region Descriptor: an array of SG_ALL struct
+ *	ufshcd_sg_entry's.  Variant-specific fields may be present after each.
  */
 struct utp_transfer_cmd_desc {
 	u8 command_upiu[ALIGNED_UPIU_SIZE];
 	u8 response_upiu[ALIGNED_UPIU_SIZE];
-	struct ufshcd_sg_entry    prd_table[SG_ALL];
+	u8 prd_table[];
 };
 
 /**

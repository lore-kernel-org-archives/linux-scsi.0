Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4DCC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiKHXfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiKHXfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:35:08 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F283528B1
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:35:07 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so291444pji.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vGp6sCUx00hiAl7FB41458XrhEES98oxDv48F8jrkZU=;
        b=dCoSNvWP9HpAyo8NBcOhvpGB7JSXiRCleyCHJaqImdFft9C0ii6Yymr63WV9Cp7pXS
         eBZymVUKpX5YhzIe5G/Ou++opUflyUzdAMKWgyspON/jJiNkuTCdXtcvVPhfwA+0n4CR
         Oazn0c+OKW43qLrDeTn8mTQoWCuZDDFeHcpKmMQuAAUHIWEZ2BSOL8fbtYP24ffO8SVh
         U1h+y+bDI1boJAM7w6iXibmrGBBAQw2wNnvQC3Ewaj37Z7HrECQF3oGlr3as7IcDZs55
         ikcDdREpNS3eqgwo/k8VbTO2EVf/x7SiYIF2HHQQMNi+V3kWH8QiTzqOmoURAUg0NKs7
         k76w==
X-Gm-Message-State: ANoB5plgbME8VEypz9mEObnVnMGW/ikGT54Ruo3yJFNcPE779g7dulUs
        FOqfE5TSJuSQcTgS7us2Bu8=
X-Google-Smtp-Source: AA0mqf54qeJu+OcY+ql4HmKzHpDeWLn8PFP5uhQaIgy9mnGgMvvXMEweuSi+RHJv7pAYKaXupxxr5Q==
X-Received: by 2002:a17:902:c3d1:b0:188:758f:f473 with SMTP id j17-20020a170902c3d100b00188758ff473mr18605315plj.113.1667950506531;
        Tue, 08 Nov 2022 15:35:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7982a000000b005618189b0ffsm6918088pfl.104.2022.11.08.15.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:35:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the sg entry size
Date:   Tue,  8 Nov 2022 15:33:39 -0800
Message-Id: <20221108233339.412808-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
In-Reply-To: <20221108233339.412808-1-bvanassche@acm.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
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
Signed-off-by: Eric Biggers <ebiggers@google.com>
[ bvanassche: edited commit message and introduced CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++---------------------
 drivers/ufs/host/Kconfig  | 10 ++++++++++
 include/ufs/ufshcd.h      | 32 ++++++++++++++++++++++++++++++++
 include/ufs/ufshci.h      |  9 +++++++--
 4 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fa1c84731b8e..6df24aed970f 100644
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
 
@@ -2445,7 +2445,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  */
 static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct ufshcd_sg_entry *prd_table;
+	struct ufshcd_sg_entry *prd;
 	struct scatterlist *sg;
 	struct scsi_cmnd *cmd;
 	int sg_segments;
@@ -2460,13 +2460,12 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
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
@@ -2480,9 +2479,10 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -2772,10 +2772,11 @@ static void ufshcd_map_queues(struct Scsi_Host *shost)
 
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
@@ -2783,11 +2784,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
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
 
@@ -3696,7 +3697,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	size_t utmrdl_size, utrdl_size, ucdl_size;
 
 	/* Allocate memory for UTP command descriptors */
-	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
+	ucdl_size = sizeof_utp_transfer_cmd_desc(hba) * hba->nutrs;
 	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
 						  ucdl_size,
 						  &hba->ucdl_dma_addr,
@@ -3790,7 +3791,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	prdt_offset =
 		offsetof(struct utp_transfer_cmd_desc, prd_table);
 
-	cmd_desc_size = sizeof(struct utp_transfer_cmd_desc);
+	cmd_desc_size = sizeof_utp_transfer_cmd_desc(hba);
 	cmd_desc_dma_addr = hba->ucdl_dma_addr;
 
 	for (i = 0; i < hba->nutrs; i++) {
@@ -9661,6 +9662,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
+	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
 
@@ -10039,11 +10041,6 @@ static int __init ufshcd_core_init(void)
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
index 4cc2dbd79ed0..49017abdac92 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -124,3 +124,13 @@ config SCSI_UFS_EXYNOS
 
 	  Select this if you have UFS host controller on Samsung Exynos SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
+	bool "Variable size UTP physical region descriptor"
+	help
+	  In the UFSHCI 3.0 standard the Physical Region Descriptor (PRD) is a
+	  data structure used for transferring data between host and UFS
+	  device. This data structure describes a single region in physical
+	  memory. Although the standard requires that this data structure has a
+	  size of 16 bytes, for some controllers this data structure has a
+	  different size. Enable this option for UFS controllers that need it.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bd45818bf0e8..c6854514e40e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -754,6 +754,9 @@ struct ufs_hba_monitor {
  * @vops: pointer to variant specific operations
  * @vps: pointer to variant specific parameters
  * @priv: pointer to variant specific private data
+#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
+ * @sg_entry_size: size of struct ufshcd_sg_entry (may include variant fields)
+#endif
  * @irq: Irq number of the controller
  * @is_irq_enabled: whether or not the UFS controller interrupt is enabled.
  * @dev_ref_clk_freq: reference clock frequency
@@ -877,6 +880,9 @@ struct ufs_hba {
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;
 	void *priv;
+#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
+	size_t sg_entry_size;
+#endif
 	unsigned int irq;
 	bool is_irq_enabled;
 	enum ufs_ref_clk_freq dev_ref_clk_freq;
@@ -980,6 +986,32 @@ struct ufs_hba {
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

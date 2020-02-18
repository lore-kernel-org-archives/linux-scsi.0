Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775C2C34031
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CDE22173E
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bYB/unib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgBRXpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:45:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgBRXpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 18:45:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=O45maSQt1qF2oe/60xby1i7f+1wZkD0xhQwrsxNNLPQ=; b=bYB/unibzbdrJay1Ex3FUdy7wh
        ACep0c74qD4vXZEQrvDhRj2XhOWPnky65gcvab/3piwg/0oL3EpBTPaLIxLHpHDyj8/5Sl+I3sMgK
        Pf7jC1VhQ6cEV+JElIURhq9+IOzbJS5cOjusPzGFCYvEp+iV1LF6C+odxpJn2A4NGMt+1Q6S7/qp0
        jH+iBnYQj7tzjoQf9nEQ4UEPz/4X5jbakpmyQ/V4HSoUrbsLzrSKHcpeuvjqhdfvrR91kJ8qibhuJ
        +K3ccM0U3gXP1fH0p/Gj2UAaMC6lFulkdMSCh5ZmUNQ6vFudWv03EqEtU0KhNTvmpJ3GE2HxNtLag
        hEHx2iVQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4CY2-00055f-Gu; Tue, 18 Feb 2020 23:45:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-scsi@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/2] ufshcd: remove unused quirks
Date:   Tue, 18 Feb 2020 15:44:49 -0800
Message-Id: <20200218234450.69412-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218234450.69412-1-hch@lst.de>
References: <20200218234450.69412-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove various quirks that don't have users, as well as the dead code
keyed off them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ufs/ufshcd.c | 120 +++++---------------------------------
 drivers/scsi/ufs/ufshcd.h |  22 -------
 2 files changed, 13 insertions(+), 129 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abd0e6b05f79..2eb86851af7a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -642,11 +642,7 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
-		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
-	else
-		ufshcd_writel(hba, ~(1 << pos),
-				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -656,10 +652,7 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
-		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
-	else
-		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
@@ -2093,13 +2086,8 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		return sg_segments;
 
 	if (sg_segments) {
-		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
-			lrbp->utr_descriptor_ptr->prd_table_length =
-				cpu_to_le16((u16)(sg_segments *
-					sizeof(struct ufshcd_sg_entry)));
-		else
-			lrbp->utr_descriptor_ptr->prd_table_length =
-				cpu_to_le16((u16) (sg_segments));
+		lrbp->utr_descriptor_ptr->prd_table_length =
+			cpu_to_le16((u16) (sg_segments));
 
 		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
 
@@ -3403,21 +3391,12 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
 
 		/* Response upiu and prdt offset should be in double words */
-		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
-			utrdlp[i].response_upiu_offset =
-				cpu_to_le16(response_offset);
-			utrdlp[i].prd_table_offset =
-				cpu_to_le16(prdt_offset);
-			utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
-		} else {
-			utrdlp[i].response_upiu_offset =
-				cpu_to_le16((response_offset >> 2));
-			utrdlp[i].prd_table_offset =
-				cpu_to_le16((prdt_offset >> 2));
-			utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
-		}
+		utrdlp[i].response_upiu_offset =
+			cpu_to_le16((response_offset >> 2));
+		utrdlp[i].prd_table_offset =
+			cpu_to_le16((prdt_offset >> 2));
+		utrdlp[i].response_upiu_length =
+			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].utrd_dma_addr = hba->utrdl_dma_addr +
@@ -3460,52 +3439,6 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 			"dme-link-startup: error code %d\n", ret);
 	return ret;
 }
-/**
- * ufshcd_dme_reset - UIC command for DME_RESET
- * @hba: per adapter instance
- *
- * DME_RESET command is issued in order to reset UniPro stack.
- * This function now deal with cold reset.
- *
- * Returns 0 on success, non-zero value on failure
- */
-static int ufshcd_dme_reset(struct ufs_hba *hba)
-{
-	struct uic_command uic_cmd = {0};
-	int ret;
-
-	uic_cmd.command = UIC_CMD_DME_RESET;
-
-	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-	if (ret)
-		dev_err(hba->dev,
-			"dme-reset: error code %d\n", ret);
-
-	return ret;
-}
-
-/**
- * ufshcd_dme_enable - UIC command for DME_ENABLE
- * @hba: per adapter instance
- *
- * DME_ENABLE command is issued in order to enable UniPro stack.
- *
- * Returns 0 on success, non-zero value on failure
- */
-static int ufshcd_dme_enable(struct ufs_hba *hba)
-{
-	struct uic_command uic_cmd = {0};
-	int ret;
-
-	uic_cmd.command = UIC_CMD_DME_ENABLE;
-
-	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-	if (ret)
-		dev_err(hba->dev,
-			"dme-reset: error code %d\n", ret);
-
-	return ret;
-}
 
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 {
@@ -4217,7 +4150,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
 }
 
 /**
- * ufshcd_hba_execute_hce - initialize the controller
+ * ufshcd_hba_enable - initialize the controller
  * @hba: per adapter instance
  *
  * The controller resets itself and controller firmware initialization
@@ -4226,7 +4159,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
+int ufshcd_hba_enable(struct ufs_hba *hba)
 {
 	int retry;
 
@@ -4274,32 +4207,6 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 
 	return 0;
 }
-
-int ufshcd_hba_enable(struct ufs_hba *hba)
-{
-	int ret;
-
-	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
-		ufshcd_set_link_off(hba);
-		ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
-
-		/* enable UIC related interrupts */
-		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
-		ret = ufshcd_dme_reset(hba);
-		if (!ret) {
-			ret = ufshcd_dme_enable(hba);
-			if (!ret)
-				ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
-			if (ret)
-				dev_err(hba->dev,
-					"Host controller enable failed with non-hce\n");
-		}
-	} else {
-		ret = ufshcd_hba_execute_hce(hba);
-	}
-
-	return ret;
-}
 EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
 
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
@@ -4869,8 +4776,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba) &&
-	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
+	if (ufshcd_is_intr_aggr_allowed(hba))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2ae6c7c8528c..9c2b80f87b9f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -612,28 +612,6 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		0x20
 
-	/*
-	 * This quirk needs to be enabled if the host contoller regards
-	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
-	 */
-	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			0x80
-
-	/*
-	 * Clear handling for transfer/task request list is just opposite.
-	 */
-	#define UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		0x100
-
-	/*
-	 * This quirk needs to be enabled if host controller doesn't allow
-	 * that the interrupt aggregation timer and counter are reset by s/w.
-	 */
-	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		0x200
-
-	/*
-	 * This quirks needs to be enabled if host controller cannot be
-	 * enabled via HCE register.
-	 */
-	#define UFSHCI_QUIRK_BROKEN_HCE				0x400
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.24.1


Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3CEC3404C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD5E2173E
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UTHpxAfh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBRXpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:45:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgBRXpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 18:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IHUJYItcDDU/OeAN1gGr74TVCKMfi4duJPgNqccaa9k=; b=UTHpxAfhGipnUq+NniFWY/1RXT
        4hLub/Gvqhqn4JMACMsVFS9yiUDwYFzqNcFvoChRm23uuoKnMsN0mfmezvuQOBff/HCroBOQYJv6+
        sHTM6Tm6qYWDKLMiTU8lRnaIxB9dUvj9/+tNMsGT+0WUSlcW4tqecX2s0sLUYmSutLyhJCfZsK7O5
        sZnTTYZOtC6waxmiDOOf03npCn+efOYyGmUU1e3wYigK0InpfMtCUr3ofdNL/EXCHnlK1DJCrBHE7
        fK4NdnhK1VXHjIAAoKrpCjo1I57z/1W1EljR0FeMea/l68q2v2HOthmr+Pm4cbfQgvQ+juuXSs5sd
        fu+VzhGw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4CY7-0005vO-Ol; Tue, 18 Feb 2020 23:45:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-scsi@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] ufshcd: use an enum for quirks
Date:   Tue, 18 Feb 2020 15:44:50 -0800
Message-Id: <20200218234450.69412-3-hch@lst.de>
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

Use an enum to specify the various quirks instead of #defines inside
the structure definition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ufs/ufshcd.h | 82 ++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9c2b80f87b9f..f68b3cd2e465 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -469,6 +469,48 @@ struct ufs_stats {
 	struct ufs_err_reg_hist task_abort;
 };
 
+enum ufshcd_quirks {
+	/* Interrupt aggregation support is broken */
+	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
+
+	/*
+	 * delay before each dme command is required as the unipro
+	 * layer has shown instabilities
+	 */
+	UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		= 1 << 1,
+
+	/*
+	 * If UFS host controller is having issue in processing LCC (Line
+	 * Control Command) coming from device then enable this quirk.
+	 * When this quirk is enabled, host controller driver should disable
+	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
+	 * attribute of device to 0).
+	 */
+	UFSHCD_QUIRK_BROKEN_LCC				= 1 << 2,
+
+	/*
+	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
+	 * inbound Link supports unterminated line in HS mode. Setting this
+	 * attribute to 1 fixes moving to HS gear.
+	 */
+	UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		= 1 << 3,
+
+	/*
+	 * This quirk needs to be enabled if the host contoller only allows
+	 * accessing the peer dme attributes in AUTO mode (FAST AUTO or
+	 * SLOW AUTO).
+	 */
+	UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		= 1 << 4,
+
+	/*
+	 * This quirk needs to be enabled if the host contoller doesn't
+	 * advertise the correct version in UFS_VER register. If this quirk
+	 * is enabled, standard UFS host driver will call the vendor specific
+	 * ops (get_ufs_hci_version) to get the correct version.
+	 */
+	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
+};
+
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
@@ -572,46 +614,6 @@ struct ufs_hba {
 	bool is_irq_enabled;
 	enum ufs_ref_clk_freq dev_ref_clk_freq;
 
-	/* Interrupt aggregation support is broken */
-	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
-
-	/*
-	 * delay before each dme command is required as the unipro
-	 * layer has shown instabilities
-	 */
-	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		0x2
-
-	/*
-	 * If UFS host controller is having issue in processing LCC (Line
-	 * Control Command) coming from device then enable this quirk.
-	 * When this quirk is enabled, host controller driver should disable
-	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
-	 * attribute of device to 0).
-	 */
-	#define UFSHCD_QUIRK_BROKEN_LCC				0x4
-
-	/*
-	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
-	 * inbound Link supports unterminated line in HS mode. Setting this
-	 * attribute to 1 fixes moving to HS gear.
-	 */
-	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		0x8
-
-	/*
-	 * This quirk needs to be enabled if the host contoller only allows
-	 * accessing the peer dme attributes in AUTO mode (FAST AUTO or
-	 * SLOW AUTO).
-	 */
-	#define UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		0x10
-
-	/*
-	 * This quirk needs to be enabled if the host contoller doesn't
-	 * advertise the correct version in UFS_VER register. If this quirk
-	 * is enabled, standard UFS host driver will call the vendor specific
-	 * ops (get_ufs_hci_version) to get the correct version.
-	 */
-	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		0x20
-
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.24.1


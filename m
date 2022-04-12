Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAEEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiDLXgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiDLXcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:54 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE79E7C16D
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bg9so240768pgb.9
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ktf2Ixfl4Rko+xBPpF90tScNTI6jjGh7xMf78/bKXXY=;
        b=FyKvkWkQjXfnCb1qSwoW+5Qdo88tkeyQYuZo9V9s4TCqxyxpCEQSr0jV+475lRsslm
         byd17BAkDHD17LvMvWyzzr3pBrO9LtRMd3U7pUpwBxJjvjgYKE1V0378apZjlalrUhHe
         F6dmZU3ExkSP6aE7oZthm7QHcQNbjcZWBCvXuSpbxn9GtQpJZ4rZ7RPVdHm2bbZx29to
         D0fAVWlMQMFSIWMbo2gaPPR3q2lFuMhxie+3m0nop/OQ6EmvI2GwTQPPYOvb2pZtcDuZ
         FSXU2ZoSoNYiRoG31UKskxWlY7qWvtB65eei5bhFQU/ghaJjnfxO5+QaOWLiEGyNdMPN
         UFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ktf2Ixfl4Rko+xBPpF90tScNTI6jjGh7xMf78/bKXXY=;
        b=19NDpUKY5l47u/mwA4FoPRh3dMCjFfZm5qG/VryWDRSYkPoXGpOydVX4Zb0ND/v0JW
         WAIsffpJYDpMMsQhYr+d+IgKUpcCMabT0G3/+sd4OhgcuiLMpigMi6al4YG3oML+PziV
         l6b7RGM7+BuxsxjSRmjHCqgVvTqqxTuvEzP6ltVcX3w1A18VzQQ/ON6mn6Qn8kE3uZ2w
         dViM0oQ7FLbPyfU8Un67uSjyK/7/YbiXzx3bcFHQtmmGtpB/tsg7U43LLubQjsMnc0Hz
         k9lNc65zUUQ6DYNKEp1akffoeZRv5+eG5CPn1oochaHkzYT05X9Djytt06YLTlrbIeRf
         BYqg==
X-Gm-Message-State: AOAM5324/viFTosYZWei2PjtPV10Lw55AFAsqFEUAMPi5dE9ynpHfoR4
        u/3ZcISQ6Qrdb9trc+sEleb9moM2ePI=
X-Google-Smtp-Source: ABdhPJwXgysXsdJ9MbvFX1eMEd1QOKYha2DYv7HSEYAI4m7W0CcMvT3Bs55RcmzhA8cw/myorIzc1g==
X-Received: by 2002:a63:cf09:0:b0:372:d564:8024 with SMTP id j9-20020a63cf09000000b00372d5648024mr32221686pgg.251.1649802033256;
        Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 23/26] lpfc: Update stat accounting for READ_STATUS mbox command
Date:   Tue, 12 Apr 2022 15:20:05 -0700
Message-Id: <20220412222008.126521-24-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

READ_STATUS tx/rx byte count fields are now expanded to 64 bit wide
counters.  This patch updates logic for the READ_STATUS mbox command when
displaying tx_word and rx_word statistics in sysfs.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 35 ++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_hw.h   | 37 ++++++++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 0d19e469386b..c8fa579168c6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6885,17 +6885,34 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	memset(hs, 0, sizeof (struct fc_host_statistics));
 
 	hs->tx_frames = pmb->un.varRdStatus.xmitFrameCnt;
+	hs->rx_frames = pmb->un.varRdStatus.rcvFrameCnt;
+
 	/*
-	 * The MBX_READ_STATUS returns tx_k_bytes which has to
-	 * converted to words
+	 * The MBX_READ_STATUS returns tx_k_bytes which has to be
+	 * converted to words.
+	 *
+	 * Check if extended byte flag is set, to know when to collect upper
+	 * bits of 64 bit wide statistics counter.
 	 */
-	hs->tx_words = (uint64_t)
-			((uint64_t)pmb->un.varRdStatus.xmitByteCnt
-			* (uint64_t)256);
-	hs->rx_frames = pmb->un.varRdStatus.rcvFrameCnt;
-	hs->rx_words = (uint64_t)
-			((uint64_t)pmb->un.varRdStatus.rcvByteCnt
-			 * (uint64_t)256);
+	if (pmb->un.varRdStatus.xkb & RD_ST_XKB) {
+		hs->tx_words = (u64)
+			       ((((u64)(pmb->un.varRdStatus.xmit_xkb &
+					RD_ST_XMIT_XKB_MASK) << 32) |
+				(u64)pmb->un.varRdStatus.xmitByteCnt) *
+				(u64)256);
+		hs->rx_words = (u64)
+			       ((((u64)(pmb->un.varRdStatus.rcv_xkb &
+					RD_ST_RCV_XKB_MASK) << 32) |
+				(u64)pmb->un.varRdStatus.rcvByteCnt) *
+				(u64)256);
+	} else {
+		hs->tx_words = (uint64_t)
+				((uint64_t)pmb->un.varRdStatus.xmitByteCnt
+				* (uint64_t)256);
+		hs->rx_words = (uint64_t)
+				((uint64_t)pmb->un.varRdStatus.rcvByteCnt
+				 * (uint64_t)256);
+	}
 
 	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 	pmb->mbxCommand = MBX_READ_LNK_STAT;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 70c3dd7b7105..748c53219986 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -2648,19 +2648,26 @@ typedef struct {
 } READ_SPARM_VAR;
 
 /* Structure for MB Command READ_STATUS (14) */
+enum read_status_word1 {
+	RD_ST_CC	= 0x01,
+	RD_ST_XKB	= 0x80,
+};
+
+enum read_status_word17 {
+	RD_ST_XMIT_XKB_MASK = 0x3fffff,
+};
+
+enum read_status_word18 {
+	RD_ST_RCV_XKB_MASK = 0x3fffff,
+};
 
 typedef struct {
-#ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd1:31;
-	uint32_t clrCounters:1;
-	uint16_t activeXriCnt;
-	uint16_t activeRpiCnt;
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint32_t clrCounters:1;
-	uint32_t rsvd1:31;
-	uint16_t activeRpiCnt;
-	uint16_t activeXriCnt;
-#endif
+	u8 clear_counters; /* rsvd 7:1, cc 0 */
+	u8 rsvd5;
+	u8 rsvd6;
+	u8 xkb; /* xkb 7, rsvd 6:0 */
+
+	u32 rsvd8;
 
 	uint32_t xmitByteCnt;
 	uint32_t rcvByteCnt;
@@ -2672,6 +2679,14 @@ typedef struct {
 	uint32_t totalRespExchanges;
 	uint32_t rcvPbsyCnt;
 	uint32_t rcvFbsyCnt;
+
+	u32 drop_frame_no_rq;
+	u32 empty_rq;
+	u32 drop_frame_no_xri;
+	u32 empty_xri;
+
+	u32 xmit_xkb; /* rsvd 31:22, xmit_xkb 21:0 */
+	u32 rcv_xkb; /* rsvd 31:22, rcv_xkb 21:0 */
 } READ_STATUS_VAR;
 
 /* Structure for MB Command READ_RPI (15) */
-- 
2.26.2


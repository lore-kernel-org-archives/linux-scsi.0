Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A0AC47082
	for <linux-scsi@archiver.kernel.org>; Sat, 29 May 2021 23:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A366108D
	for <linux-scsi@archiver.kernel.org>; Sat, 29 May 2021 23:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhE2Xuj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 May 2021 19:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhE2Xuj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 May 2021 19:50:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B030C061574
        for <linux-scsi@vger.kernel.org>; Sat, 29 May 2021 16:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=b6jRAqcck9zu7xXrrOW4rNulzJBM7xMgxV9cSmz/aSQ=; b=WgUPLXr6kcz+COK+GzZm5R4n/6
        CkY7MvsqDLQUPxEo53MDaGWdD/TTXytlfkqzW6P/ZsKieY51aIbo5OSvvtL5vCwLiqnYSbwv9RN31
        qxRunbxBEot6975at7Dg3CMTmFzs+uNf90ffX1/uP3FR52RHxcxJAI5Bg/b8WU/nmCMZFcz8SYieF
        XmWZIBbD8zLlUm4ZdrfcAtW9icpj0v8a1WsjaXmPD66U+ako8d0YUW+wPuY23pQKRWRlpIsut9faU
        TJsRMDIdtaTljMm4bE+1maPdVQogv36Zl6Rpoomm7D80fLRJBUMLuhGtDiND3pNYZPLnQEPqa0Bh4
        nlisndJA==;
Received: from [2601:1c0:6280:3f0::ce7d] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ln8hO-008c7j-LJ; Sat, 29 May 2021 23:48:58 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-scsi@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Khalid Aziz <khalid@gonehiking.org>
Subject: [PATCH] SCSI: FlashPoint: rename si_flags field
Date:   Sat, 29 May 2021 16:48:57 -0700
Message-Id: <20210529234857.6870-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The BusLogic driver has build errors on ia64 due to a name collision
(in the #included FlashPoint.c file).
Rename the struct field in struct sccb_mgr_info from si_flags to
si_mflags (manager flags) to mend the build.

This is the first problem. There are 50+ others after this one:

In file included from ../include/uapi/linux/signal.h:6,
                 from ../include/linux/signal_types.h:10,
                 from ../include/linux/sched.h:29,
                 from ../include/linux/hardirq.h:9,
                 from ../include/linux/interrupt.h:11,
                 from ../drivers/scsi/BusLogic.c:27:
../arch/ia64/include/uapi/asm/siginfo.h:15:27: error: expected ':', ',', ';', '}' or '__attribute__' before '.' token
   15 | #define si_flags _sifields._sigfault._flags
      |                           ^
../drivers/scsi/FlashPoint.c:43:6: note: in expansion of macro 'si_flags'
   43 |  u16 si_flags;
      |      ^~~~~~~~
In file included from ../drivers/scsi/BusLogic.c:51:
../drivers/scsi/FlashPoint.c: In function 'FlashPoint_ProbeHostAdapter':
../drivers/scsi/FlashPoint.c:1076:11: error: 'struct sccb_mgr_info' has no member named '_sifields'
 1076 |  pCardInfo->si_flags = 0x0000;
      |           ^~
../drivers/scsi/FlashPoint.c:1079:12: error: 'struct sccb_mgr_info' has no member named '_sifields'

Fixes: 391e2f25601e ("[SCSI] BusLogic: Port driver to 64-bit.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Khalid Aziz <khalid@gonehiking.org>
---
 drivers/scsi/FlashPoint.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- linux-next-20210528.orig/drivers/scsi/FlashPoint.c
+++ linux-next-20210528/drivers/scsi/FlashPoint.c
@@ -40,7 +40,7 @@ struct sccb_mgr_info {
 	u16 si_per_targ_ultra_nego;
 	u16 si_per_targ_no_disc;
 	u16 si_per_targ_wide_nego;
-	u16 si_flags;
+	u16 si_mflags;
 	unsigned char si_card_family;
 	unsigned char si_bustype;
 	unsigned char si_card_model[3];
@@ -1073,22 +1073,22 @@ static int FlashPoint_ProbeHostAdapter(s
 		ScamFlg =
 		    (unsigned char)FPT_utilEERead(ioport, SCAM_CONFIG / 2);
 
-	pCardInfo->si_flags = 0x0000;
+	pCardInfo->si_mflags = 0x0000;
 
 	if (i & 0x01)
-		pCardInfo->si_flags |= SCSI_PARITY_ENA;
+		pCardInfo->si_mflags |= SCSI_PARITY_ENA;
 
 	if (!(i & 0x02))
-		pCardInfo->si_flags |= SOFT_RESET;
+		pCardInfo->si_mflags |= SOFT_RESET;
 
 	if (i & 0x10)
-		pCardInfo->si_flags |= EXTENDED_TRANSLATION;
+		pCardInfo->si_mflags |= EXTENDED_TRANSLATION;
 
 	if (ScamFlg & SCAM_ENABLED)
-		pCardInfo->si_flags |= FLAG_SCAM_ENABLED;
+		pCardInfo->si_mflags |= FLAG_SCAM_ENABLED;
 
 	if (ScamFlg & SCAM_LEVEL2)
-		pCardInfo->si_flags |= FLAG_SCAM_LEVEL2;
+		pCardInfo->si_mflags |= FLAG_SCAM_LEVEL2;
 
 	j = (RD_HARPOON(ioport + hp_bm_ctrl) & ~SCSI_TERM_ENA_L);
 	if (i & 0x04) {
@@ -1104,7 +1104,7 @@ static int FlashPoint_ProbeHostAdapter(s
 
 	if (!(RD_HARPOON(ioport + hp_page_ctrl) & NARROW_SCSI_CARD))
 
-		pCardInfo->si_flags |= SUPPORT_16TAR_32LUN;
+		pCardInfo->si_mflags |= SUPPORT_16TAR_32LUN;
 
 	pCardInfo->si_card_family = HARPOON_FAMILY;
 	pCardInfo->si_bustype = BUSTYPE_PCI;
@@ -1140,15 +1140,15 @@ static int FlashPoint_ProbeHostAdapter(s
 
 	if (pCardInfo->si_card_model[1] == '3') {
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 	} else if (pCardInfo->si_card_model[2] == '0') {
 		temp = RD_HARPOON(ioport + hp_xfer_pad);
 		WR_HARPOON(ioport + hp_xfer_pad, (temp & ~BIT(4)));
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 		WR_HARPOON(ioport + hp_xfer_pad, (temp | BIT(4)));
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= HIGH_BYTE_TERM;
+			pCardInfo->si_mflags |= HIGH_BYTE_TERM;
 		WR_HARPOON(ioport + hp_xfer_pad, temp);
 	} else {
 		temp = RD_HARPOON(ioport + hp_ee_ctrl);
@@ -1166,9 +1166,9 @@ static int FlashPoint_ProbeHostAdapter(s
 		WR_HARPOON(ioport + hp_ee_ctrl, temp);
 		WR_HARPOON(ioport + hp_xfer_pad, temp2);
 		if (!(temp3 & BIT(7)))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 		if (!(temp3 & BIT(6)))
-			pCardInfo->si_flags |= HIGH_BYTE_TERM;
+			pCardInfo->si_mflags |= HIGH_BYTE_TERM;
 	}
 
 	ARAM_ACCESS(ioport);
@@ -1275,7 +1275,7 @@ static void *FlashPoint_HardwareResetHos
 	WR_HARPOON(ioport + hp_arb_id, pCardInfo->si_id);
 	CurrCard->ourId = pCardInfo->si_id;
 
-	i = (unsigned char)pCardInfo->si_flags;
+	i = (unsigned char)pCardInfo->si_mflags;
 	if (i & SCSI_PARITY_ENA)
 		WR_HARPOON(ioport + hp_portctrl_1, (HOST_MODE8 | CHK_SCSI_P));
 
@@ -1289,14 +1289,14 @@ static void *FlashPoint_HardwareResetHos
 		j |= SCSI_TERM_ENA_H;
 	WR_HARPOON(ioport + hp_ee_ctrl, j);
 
-	if (!(pCardInfo->si_flags & SOFT_RESET)) {
+	if (!(pCardInfo->si_mflags & SOFT_RESET)) {
 
 		FPT_sresb(ioport, thisCard);
 
 		FPT_scini(thisCard, pCardInfo->si_id, 0);
 	}
 
-	if (pCardInfo->si_flags & POST_ALL_UNDERRRUNS)
+	if (pCardInfo->si_mflags & POST_ALL_UNDERRRUNS)
 		CurrCard->globalFlags |= F_NO_FILTER;
 
 	if (pCurrNvRam) {

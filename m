Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D649C2BB55
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 02:14:08 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 188EF206C3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 02:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 188EF206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-scsi-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgDMCOG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 22:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgDMCOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 22:14:06 -0400
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856ABC0A3BE0
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 19:14:06 -0700 (PDT)
Received: by mail-pl1-f194.google.com with SMTP id k18so2889960pll.6
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 19:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nXcmLboU7EK8w6P4mXnOerfhO+s8zbKSwpn6FsP5uFs=;
        b=sVcj6WigtRft/y2zpcFB//Hdr78SN6D+TWXqrwWb2YVLQfAKpwNVkRW7ql2c2lysDh
         jVz0YRIDsIDPPxxB3OAi+e8jLoS5TdoohSq0itINfrcCGkiMc1ZInq4NBbd2QSTgn6LL
         g5bZFS8pQMLdb4kDLzzzClxHT9FLhr48H76YAcBG9Cq9kEWuPjKK/pfbPkcoFMeLJ1Hu
         EwPNYpd4e73ZXT6zyib4B0XdL6p4XuBYOADFGqFtyX3YPRsZzkb7ZWaW6FoinRFw72Fo
         EWG6p2RTVcYiPrQewlNF3F5VINM5wsZyusJGr8Raz5CkkVhNP9oECY9kzzj58A4pQpJ5
         zppg==
X-Gm-Message-State: AGi0Puadipil471V7q7QhNjIBp7lz3AmdWyx6hKF8+BMJf3K3LLOht8A
        XVQMSJw88W6NXNzKncsikkI=
X-Google-Smtp-Source: APiQypIApTkSBwcHiMmpCnfVlCWcmP6TMmuFTfBUvBoqOGMa9nvJObNldbewpjSG6GehKonfgl3BhQ==
X-Received: by 2002:a17:902:8bc1:: with SMTP id r1mr14926371plo.48.1586744045728;
        Sun, 12 Apr 2020 19:14:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:85b4:9:8368:1313])
        by smtp.gmail.com with ESMTPSA id r13sm6874971pgj.9.2020.04.12.19.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 19:14:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Use ARRAY_SIZE() instead of open-coding it
Date:   Sun, 12 Apr 2020 19:13:59 -0700
Message-Id: <20200413021359.21725-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f301a8048b2f..8b7d0e476773 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -778,16 +778,16 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = &reg->flash_address;
-		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->pbiu_reg); cnt++, dmp_reg++)
 			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
 		dmp_reg = &reg->u.isp2300.req_q_in;
-		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2;
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_host_reg);
 		    cnt++, dmp_reg++)
 			fw->risc_host_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
 		dmp_reg = &reg->u.isp2300.mailbox0;
-		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2;
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg);
 		    cnt++, dmp_reg++)
 			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
@@ -799,7 +799,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
 		dmp_reg = &reg->risc_hw;
-		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2;
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_hdw_reg);
 		    cnt++, dmp_reg++)
 			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
@@ -860,12 +860,12 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	/* Get RISC SRAM. */
 	if (rval == QLA_SUCCESS)
 		rval = qla2xxx_dump_ram(ha, 0x800, fw->risc_ram,
-		    sizeof(fw->risc_ram) / 2, &nxt);
+					ARRAY_SIZE(fw->risc_ram), &nxt);
 
 	/* Get stack SRAM. */
 	if (rval == QLA_SUCCESS)
 		rval = qla2xxx_dump_ram(ha, 0x10000, fw->stack_ram,
-		    sizeof(fw->stack_ram) / 2, &nxt);
+					ARRAY_SIZE(fw->stack_ram), &nxt);
 
 	/* Get data SRAM. */
 	if (rval == QLA_SUCCESS)
@@ -944,7 +944,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = &reg->flash_address;
-		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->pbiu_reg); cnt++, dmp_reg++)
 			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
 		dmp_reg = &reg->u.isp2100.mailbox0;
@@ -956,12 +956,12 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		}
 
 		dmp_reg = &reg->u.isp2100.unused_2[0];
-		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++, dmp_reg++)
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->dma_reg); cnt++, dmp_reg++)
 			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
 		dmp_reg = &reg->risc_hw;
-		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++, dmp_reg++)
+		for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_hdw_reg); cnt++, dmp_reg++)
 			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
 
 		WRT_REG_WORD(&reg->pcr, 0x2000);
@@ -1041,7 +1041,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
  		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_WORD);
 		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 	}
-	for (cnt = 0; cnt < sizeof(fw->risc_ram) / 2 && rval == QLA_SUCCESS;
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_ram) && rval == QLA_SUCCESS;
 	    cnt++, risc_address++) {
  		WRT_MAILBOX_REG(ha, reg, 1, risc_address);
 		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
@@ -1145,7 +1145,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
-	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
 		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
 
 	/* Disable interrupts. */
@@ -1178,7 +1178,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
@@ -1421,7 +1421,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
-	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
 		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
 
 	/* Disable interrupts. */
@@ -1470,7 +1470,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
@@ -1745,7 +1745,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
-	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
 		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
 
 	/* Disable interrupts. */
@@ -1794,7 +1794,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
@@ -2093,7 +2093,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
-	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
 		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
 
 	/* Disable interrupts. */
@@ -2142,7 +2142,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
+	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */

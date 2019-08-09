Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0820AC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6A83216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405256AbfHIDDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38133 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id z14so7869305pga.5
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIS58umSWYfftSOFmNrMQGOHBSjXJEfDkrdKA4XWmsQ=;
        b=bjV16OYRHhEsd2T3SLmrYtyyURgNGSkxpCknNyv/NKi9PACqEAtOj7c94+/7mbrpvl
         A4HgbeOXdET2034j4MwNRb339rPpSHZq/A5Yqqup4LjUypCvDNv7kleOEWnHnLt2xVBr
         zqRiCbBZMekVNJxZ3msWumGO95oqZ/SOI2H75yzX1a8xEnLmpYjZ05uWJ4HwJkrgjzu0
         IlB4GK6TKKuLeEXUjXfzjJHQrLgYEkD2u9zAJeGOJ+fn1b76+kd9yF+ycL3tgluuKNWR
         vtXNstm7TlZb+spD2Nz8QBlLE0rv2jtfhNHuLWZSswN0lpeVL/y/HiHzNYBf1q1b7eQn
         +wmA==
X-Gm-Message-State: APjAAAVQA+O9Q5gOmLDkW0Ut7+5k0KFj8yXcj2BLibZ+0Pb0iJWOghS7
        mgGnfyn34klHLJLYQrnyicI=
X-Google-Smtp-Source: APXvYqyLLb8X6KuZuBPmEoDhzCqOGE4RSIeCM8O+t2yxtthJ3oLslNWtBVUJWHjv806A/vW0M0Nx0w==
X-Received: by 2002:a62:770e:: with SMTP id s14mr18329395pfc.150.1565319809557;
        Thu, 08 Aug 2019 20:03:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 40/58] qla2xxx: Make it explicit that ELS pass-through IOCBs use little endian
Date:   Thu,  8 Aug 2019 20:02:01 -0700
Message-Id: <20190809030219.11296-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the firmware documentation the firmware expects all ELS
pass-through IOCB parameters in little endian format. Make this explicit.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_fw.h   | 8 ++++----
 drivers/scsi/qla2xxx/qla_iocb.c | 7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index df079a8c2b33..732bb871c433 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -761,13 +761,13 @@ struct els_entry_24xx {
 #define ECF_CLR_PASSTHRU_PEND	BIT_12
 #define ECF_INCL_FRAME_HDR	BIT_11
 
-	uint32_t rx_byte_count;
-	uint32_t tx_byte_count;
+	__le32	 rx_byte_count;
+	__le32	 tx_byte_count;
 
 	__le64	 tx_address __packed;	/* Data segment 0 address. */
-	uint32_t tx_len;		/* Data segment 0 length. */
+	__le32	 tx_len;		/* Data segment 0 length. */
 	__le64	 rx_address __packed;	/* Data segment 1 address. */
-	uint32_t rx_len;		/* Data segment 1 length. */
+	__le32	 rx_len;		/* Data segment 1 length. */
 };
 
 struct els_sts_entry_24xx {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6b120254f414..c7b91827c1e7 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2704,12 +2704,12 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 
 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
 		els_iocb->tx_byte_count = els_iocb->tx_len =
-			sizeof(struct els_plogi_payload);
+			cpu_to_le32(sizeof(struct els_plogi_payload));
 		put_unaligned_le64(elsio->u.els_plogi.els_plogi_pyld_dma,
 				   &els_iocb->tx_address);
 		els_iocb->rx_dsd_count = 1;
 		els_iocb->rx_byte_count = els_iocb->rx_len =
-			sizeof(struct els_plogi_payload);
+			cpu_to_le32(sizeof(struct els_plogi_payload));
 		put_unaligned_le64(elsio->u.els_plogi.els_resp_pyld_dma,
 				   &els_iocb->rx_address);
 
@@ -2718,7 +2718,8 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		ql_dump_buffer(ql_log_info, vha, 0x0109,
 		    (uint8_t *)els_iocb, 0x70);
 	} else {
-		els_iocb->tx_byte_count = sizeof(struct els_logo_payload);
+		els_iocb->tx_byte_count =
+			cpu_to_le32(sizeof(struct els_logo_payload));
 		put_unaligned_le64(elsio->u.els_logo.els_logo_pyld_dma,
 				   &els_iocb->tx_address);
 		els_iocb->tx_len = cpu_to_le32(sizeof(struct els_logo_payload));
-- 
2.22.0


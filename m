Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C33CC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB8B5216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405244AbfHIDD2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38493 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so45238514pfn.5
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+nGbjIYrM0zzNxH5kDvLyluvwD/wAhPF8op+/QRychU=;
        b=Dw686fWQDwTienKshoe9kvlvcxVB1DKC0mA93WmpFZ1ncHlwfp/RU2O+Gm1LtHhuuD
         aSH/ONlN7XVwCM2m3Tlq5aMh9SL3pd1efNw8iBvGr6pRLXnNZpS3YbeAfTzFXwRYmYVs
         XmvXi+4O1r2tpRdDMJ1k1BkjzOSHjt79vllkD9arSEJrexdoUG8u+n3cbdtcJiHuqw6p
         IFbA0kQL4ni2Db8TAmxl3wAsHR8p8SYmJF4r8MNgv57zibpPmNAqN6F3MqEkB8Nc/SwO
         qEEXGZE5qCtRslQrka9mRjvZqf0yGVVUI4jqW5FaL3wSRedXlCiQCl5OkCxl+CdU13jS
         A/5A==
X-Gm-Message-State: APjAAAXRUoqSSG7sDBKPEaMXbwZ5dSE2Q9JDz298ZAIfQJL8j3M2Luq7
        ZOnu4mITTNFhduvkecHdw9g=
X-Google-Smtp-Source: APXvYqzEP2a4rQTLuspaA9KBx7CA6NMLtnex6x/9MlzX942kO43K5FuCwFBT1YOMLVrZUIN+eGCzwA==
X-Received: by 2002:a17:90a:6546:: with SMTP id f6mr7134172pjs.11.1565319807178;
        Thu, 08 Aug 2019 20:03:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 38/58] qla2xxx: Change the return type of qla24xx_read_flash_data()
Date:   Thu,  8 Aug 2019 20:01:59 -0700
Message-Id: <20190809030219.11296-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This change makes it easier to detect qla24xx_read_flash_data() failures
and also to handle such failures. This change does not modify the behavior
of the driver since all callers ignore the qla24xx_read_flash_data()
return value.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 2 +-
 drivers/scsi/qla2xxx/qla_sup.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2d9664086f15..aac664da419b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -554,7 +554,7 @@ fc_port_t *qla2x00_find_fcport_by_nportid(scsi_qla_host_t *, port_id_t *, u8);
  * Global Function Prototypes in qla_sup.c source file.
  */
 extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
-extern uint32_t *qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
+extern int qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
     uint32_t, uint32_t);
 extern uint8_t *qla2x00_read_nvram_data(scsi_qla_host_t *, void *, uint32_t,
     uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 1eb82384d933..764e1bb0f695 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -473,22 +473,24 @@ qla24xx_read_flash_dword(struct qla_hw_data *ha, uint32_t addr, uint32_t *data)
 	return QLA_FUNCTION_TIMEOUT;
 }
 
-uint32_t *
+int
 qla24xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	ulong i;
+	int ret = QLA_SUCCESS;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Dword reads to flash. */
 	faddr =  flash_data_addr(ha, faddr);
 	for (i = 0; i < dwords; i++, faddr++, dwptr++) {
-		if (qla24xx_read_flash_dword(ha, faddr, dwptr))
+		ret = qla24xx_read_flash_dword(ha, faddr, dwptr);
+		if (ret != QLA_SUCCESS)
 			break;
 		cpu_to_le32s(dwptr);
 	}
 
-	return dwptr;
+	return ret;
 }
 
 static int
-- 
2.22.0


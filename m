Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62FEC2D0D2
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6AA21582
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDNFYNp7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLRX6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37227 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLRX6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so3796721wmf.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j3AYhR6iXywWYQ/K9jqjM0MdVWjyW/M1px4KFelLlME=;
        b=rDNFYNp7ctg5oSsCtX/MMucIw9vv+INwBg23zEaV0G1+w8BxgASsuvh7pvFX8w+ZOB
         gzEaVJQpGFHEQF7ZE+qLo0mk6aHvo/YJe4wT9Jvv1eV/IUWW2p5Fr5Vxn9uuU8OLZGH8
         5qlmdOnFLSdNinLxG4m04/Tosx1rt0ZIV/olViFvHpnC0u1jfLUEFPbsdt2WcdeurB/r
         7oH0fwFRfvg7YjR0Eey2C0NHsddWhJMIPDx7oMHAeOnDDdr/h7wdpb2ijLKJ/lAmn90U
         N2TustW8TsqcA2hz0E4iDjFIbECjivOFkVwnTH6d1WFs2xgV/jB2KywiYDpOLEWK1bB+
         WkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j3AYhR6iXywWYQ/K9jqjM0MdVWjyW/M1px4KFelLlME=;
        b=RPJ0V0IoBjIvLfnjhAr373c0xrTZYHUTlYTwD21KpBs7vbKXFnetQEC2ry0r/aE4/D
         RgSU9TNiomokYu1DMX9AfYVspNVY9WpORTqh7UEBl8x4goa5n5wwbOiMvW7mfh7IBBMh
         9VxXjUI2Xk4ji5KKtpOZgc7R8W3qdyqfFue8CGwtegyUxSti8owctJbmgJU6WibjqhNp
         acwDEQ7vA8wvo7oSFxoBLc4iDQNVtAxUWYIDitzYE+8w2rs5T7gKcKhIuvDhAZTpdFQD
         G1YJ3dawvmB3EZPhaYpNbxDPBF0soaM1q5CiEFrRqykUIwt94OElFrfj2S3AOBio+xI3
         SYxQ==
X-Gm-Message-State: APjAAAX0kDRutSbZkPFMVrcl99XywCTKgfYYgoz3iVt1EUy5y/DSUY5m
        eLBOYtxk2yiqW3xT2v0dtQC8b8/i
X-Google-Smtp-Source: APXvYqzDQn8crWdCY5gWx0hwd0WIbUNRV/Qju1rTXAKqQaDc/MBNH6xi79GEwhZyTRZTp6kwVey6dg==
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr6268921wmb.174.1576713503054;
        Wed, 18 Dec 2019 15:58:23 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:22 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/10] lpfc: Fix missing check for CSF in Write Object Mbox Rsp
Date:   Wed, 18 Dec 2019 15:58:01 -0800
Message-Id: <20191218235808.31922-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the WriteObject mailbox response has change_status set to is 0x2
(Firmware Reset) or 0x04 (Port Migration Reset), the CSF field should
also be checked to see if a fw reset is sufficient to enable all new
features in the updated firmware image. If not, a fw reset would start
the new firmware, but with a feature level equal to existing firmware.
To enable the new features, a chip reset/pci slot reset would be
required.

Check the CSF bit when change_status is 0x2 or 0x4 to know whether to
perform a pci bus reset or fw reset.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h |  3 +++
 drivers/scsi/lpfc/lpfc_sli.c | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 25cdcbc2b02f..9a064b96e570 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3925,6 +3925,9 @@ struct lpfc_mbx_wr_object {
 #define LPFC_CHANGE_STATUS_FW_RESET		0x02
 #define LPFC_CHANGE_STATUS_PORT_MIGRATION	0x04
 #define LPFC_CHANGE_STATUS_PCI_RESET		0x05
+#define lpfc_wr_object_csf_SHIFT		8
+#define lpfc_wr_object_csf_MASK			0x00000001
+#define lpfc_wr_object_csf_WORD			word5
 		} response;
 	} u;
 };
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c82b5792da98..12319f63cb45 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19449,7 +19449,7 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	struct lpfc_mbx_wr_object *wr_object;
 	LPFC_MBOXQ_t *mbox;
 	int rc = 0, i = 0;
-	uint32_t shdr_status, shdr_add_status, shdr_change_status;
+	uint32_t shdr_status, shdr_add_status, shdr_change_status, shdr_csf;
 	uint32_t mbox_tmo;
 	struct lpfc_dmabuf *dmabuf;
 	uint32_t written = 0;
@@ -19506,6 +19506,16 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	if (check_change_status) {
 		shdr_change_status = bf_get(lpfc_wr_object_change_status,
 					    &wr_object->u.response);
+
+		if (shdr_change_status == LPFC_CHANGE_STATUS_FW_RESET ||
+		    shdr_change_status == LPFC_CHANGE_STATUS_PORT_MIGRATION) {
+			shdr_csf = bf_get(lpfc_wr_object_csf,
+					  &wr_object->u.response);
+			if (shdr_csf)
+				shdr_change_status =
+						   LPFC_CHANGE_STATUS_PCI_RESET;
+		}
+
 		switch (shdr_change_status) {
 		case (LPFC_CHANGE_STATUS_PHYS_DEV_RESET):
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-- 
2.13.7


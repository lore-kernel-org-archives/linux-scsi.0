Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8C0CA9ED5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7D0E20717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o82h/gHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbfKEA5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:32931 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387409AbfKEA5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id 6so15296433wmf.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CR4DD00Zy5I+37E27tWrA1Fc7gmP+BVjOjh8LXyf3UI=;
        b=o82h/gHSzjj8gFeKJAOAm1IyTL1CmBrqtSQ3TyY83QPheGeKJRL4qkNWb7w8Xjce6f
         YFX3Dtyi3BMJZ/NhNgpocXqyAIG8cTqm8o0jistj7fC7zgeX4e60lZI7+yVbgpI6BZQE
         ZaYmSwR7nXQ/oEyWF4DcpHkNapdyYTjHoXhvozunAl7I20zD01syKrnq/Xgu3EFVK8L1
         OERnf+9hF6dI8hhRpFiP/FhwEvQBh5t2ZR6tWbEj9gs6fOa9cQ5kWGz2LxBbIjMvqDkw
         V2/FkSxEzA04epphSs+D/sJZQjvUTM2HWGMbhJfLZDYqR0np26NUHuIR7Z3toHQMklCJ
         GiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CR4DD00Zy5I+37E27tWrA1Fc7gmP+BVjOjh8LXyf3UI=;
        b=RYiW5ykyLODxyAFSjeQGbnTSHckgF4BL4NHnLcLIax3YdR62tjFkExDjJqsucSKtCt
         uNpjEz9HJC9BvZ1n0XARbOu0WRuKC6CMwx082nKD2YwyvfxDpOWgLTmF9RVIFle2XyK8
         QUCWv/2iXGJJZV7MgWR8xGXGouLjCAyGeqNdzGNF7bUNLeyrkVhii1Szlkpr21CgekoS
         TnodCRas91D4xqx9CdoC5YH4erjqLNafivNIiULVbeipBS99+jy+7xEn/4IamABtXT/u
         J/6RhVDsy42qObAkAKiIHhAsFy7277LkH4Db76jxX+hE4ErVDTPa6eGH5TRJOVDQXaWE
         DQwg==
X-Gm-Message-State: APjAAAWqmjRtkkDmD2ZESN9cOwt7ol7U256rOSbLtwa/2XKJzVS5X1hr
        seIbq2WoS3gpyhfTq5eUjATnja8UY7U=
X-Google-Smtp-Source: APXvYqw4kZZZ+ARxhMr6BGsuS41jtTnucqq1Ta8Z05x78XHMKWBXA/ReH2xWwVju1Zi11374z09cfg==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr1714807wmc.150.1572915457521;
        Mon, 04 Nov 2019 16:57:37 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:37 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/11] lpfc: Add enablement of multiple adapter dumps
Date:   Mon,  4 Nov 2019 16:57:07 -0800
Message-Id: <20191105005708.7399-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some adapters support the ability to hold multiple adapter dumps
on the adapter flash. Some adapters default to enabling this
feature while others default to single-dump.

Make support uniform by enabling dual dump by default.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 10 ++++++++++
 drivers/scsi/lpfc/lpfc_sli.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 9daa2b494b5c..25cdcbc2b02f 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3530,6 +3530,7 @@ struct lpfc_sli4_parameters {
 
 #define LPFC_SET_UE_RECOVERY		0x10
 #define LPFC_SET_MDS_DIAGS		0x11
+#define LPFC_SET_DUAL_DUMP		0x1e
 struct lpfc_mbx_set_feature {
 	struct mbox_header header;
 	uint32_t feature;
@@ -3544,6 +3545,15 @@ struct lpfc_mbx_set_feature {
 #define lpfc_mbx_set_feature_mds_deep_loopbk_SHIFT  1
 #define lpfc_mbx_set_feature_mds_deep_loopbk_MASK   0x00000001
 #define lpfc_mbx_set_feature_mds_deep_loopbk_WORD   word6
+#define lpfc_mbx_set_feature_dd_SHIFT		0
+#define lpfc_mbx_set_feature_dd_MASK		0x00000001
+#define lpfc_mbx_set_feature_dd_WORD		word6
+#define lpfc_mbx_set_feature_ddquery_SHIFT	1
+#define lpfc_mbx_set_feature_ddquery_MASK	0x00000001
+#define lpfc_mbx_set_feature_ddquery_WORD	word6
+#define LPFC_DISABLE_DUAL_DUMP		0
+#define LPFC_ENABLE_DUAL_DUMP		1
+#define LPFC_QUERY_OP_DUAL_DUMP		2
 	uint32_t word7;
 #define lpfc_mbx_set_feature_UERP_SHIFT 0
 #define lpfc_mbx_set_feature_UERP_MASK  0x0000ffff
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5f097328d236..b59bb75fbc78 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6203,6 +6203,14 @@ lpfc_set_features(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
 		mbox->u.mqe.un.set_feature.feature = LPFC_SET_MDS_DIAGS;
 		mbox->u.mqe.un.set_feature.param_len = 8;
 		break;
+	case LPFC_SET_DUAL_DUMP:
+		bf_set(lpfc_mbx_set_feature_dd,
+		       &mbox->u.mqe.un.set_feature, LPFC_ENABLE_DUAL_DUMP);
+		bf_set(lpfc_mbx_set_feature_ddquery,
+		       &mbox->u.mqe.un.set_feature, 0);
+		mbox->u.mqe.un.set_feature.feature = LPFC_SET_DUAL_DUMP;
+		mbox->u.mqe.un.set_feature.param_len = 4;
+		break;
 	}
 
 	return;
@@ -7200,7 +7208,7 @@ lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 int
 lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 {
-	int rc, i, cnt, len;
+	int rc, i, cnt, len, dd;
 	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_mqe *mqe;
 	uint8_t *vpd;
@@ -7451,6 +7459,23 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	phba->sli3_options |= (LPFC_SLI3_NPIV_ENABLED | LPFC_SLI3_HBQ_ENABLED);
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Always try to enable dual dump feature if we can */
+	lpfc_set_features(phba, mboxq, LPFC_SET_DUAL_DUMP);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	dd = bf_get(lpfc_mbx_set_feature_dd, &mboxq->u.mqe.un.set_feature);
+	if ((rc == MBX_SUCCESS) && (dd == LPFC_ENABLE_DUAL_DUMP))
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_INIT,
+				"6448 Dual Dump is enabled\n");
+	else
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI | LOG_INIT,
+				"6447 Dual Dump Mailbox x%x (x%x/x%x) failed, "
+				"rc:x%x dd:x%x\n",
+				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+				lpfc_sli_config_mbox_subsys_get(
+					phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(
+					phba, mboxq),
+				rc, dd);
 	/*
 	 * Allocate all resources (xri,rpi,vpi,vfi) now.  Subsequent
 	 * calls depends on these resources to complete port setup.
-- 
2.13.7


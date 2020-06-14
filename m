Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306D8C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB3B206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgFNWjo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38319 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgFNWjm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:42 -0400
Received: by mail-pg1-f196.google.com with SMTP id u5so6787673pgn.5
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cGqE+/d5g0Cp8SKreLu732BH9Bu7otgJLMwt69QnKY=;
        b=pZcn1eyo2mA8dcukul/B2cXFmGv0VwW3PwI9BtBkYrM01CPBwH4An03ZPEeR8aT5Dg
         /5NctTVdMg9dHzRxV0OhNshR7uU3cVllZN0Tbnf/py4GoiiOAZ7Xz7Ft0V8fC5q0M8nx
         e+4gQU3e1vCDQpaxENYIKte/8Gs7G3hxVtArH/DuB9mpUoZe/o3kWYOieYL3Hd4hhy4d
         oaMx3Zj6YRR2zzEpWitmz+wZjS2QqPSRL5ZZmPcCK0DKfW/C488v/BSBvFhy9QD5VCA2
         K4cgLdWBikd5e/HhwQN/FO79Xtf7IW1TbCpOLbjaXqeL0E5RNuM096ZVRBrLUDtsom6/
         zf0g==
X-Gm-Message-State: AOAM531K0j7msanfxdlR/3I0DyaVEnkqN4/nRZ3OHgO1xsWgObCxchx8
        H6cgCqd3r1xw8Ql8KPKBjAk=
X-Google-Smtp-Source: ABdhPJwH/PVQb+xI3aZ9YAEq1ctsSKCiXjIeZae3cYuHATxPJ+z2mHamgzZcSqqlULlLmGDeisQivQ==
X-Received: by 2002:a63:7a56:: with SMTP id j22mr13198669pgn.194.1592174381157;
        Sun, 14 Jun 2020 15:39:41 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 9/9] qla2xxx: Introduce a function for computing the debug message prefix
Date:   Sun, 14 Jun 2020 15:39:21 -0700
Message-Id: <20200614223921.5851-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of repeating the code for generating a debug message prefix
six times, introduce a function for computing the debug message prefix.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 95 ++++++++++++----------------------
 1 file changed, 32 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 5e873b70e843..44f4d3f23a8e 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2448,6 +2448,23 @@ qla83xx_fw_dump(scsi_qla_host_t *vha)
 /*                         Driver Debug Functions.                          */
 /****************************************************************************/
 
+/* Write the debug message prefix into @pbuf. */
+static void ql_dbg_prefix(char *pbuf, int pbuf_size,
+			  const scsi_qla_host_t *vha, uint msg_id)
+{
+	if (vha) {
+		const struct pci_dev *pdev = vha->hw->pdev;
+
+		/* <module-name> [<dev-name>]-<msg-id>:<host>: */
+		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%ld: ", QL_MSGHDR,
+			 dev_name(&(pdev->dev)), msg_id, vha->host_no);
+	} else {
+		/* <module-name> [<dev-name>]-<msg-id>: : */
+		snprintf(pbuf, pbuf_size, "%s [%s]-%04x: : ", QL_MSGHDR,
+			 "0000:00:00.0", msg_id);
+	}
+}
+
 /*
  * This function is for formatting and logging debug information.
  * It is to be used when vha is available. It formats the message
@@ -2473,33 +2490,12 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	if (!ql_mask_match(level)) {
-		if (vha != NULL) {
-			const struct pci_dev *pdev = vha->hw->pdev;
-			/* <module-name> <msg-id>:<host> Message */
-			snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x:%ld: ",
-			    QL_MSGHDR, dev_name(&(pdev->dev)), id,
-			    vha->host_no);
-		} else {
-			snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
-			    QL_MSGHDR, "0000:00:00.0", id);
-		}
-		pbuf[sizeof(pbuf) - 1] = 0;
-		trace_ql_dbg_log(pbuf, &vaf);
-		va_end(va);
-		return;
-	}
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
 
-	if (vha != NULL) {
-		const struct pci_dev *pdev = vha->hw->pdev;
-		/* <module-name> <pci-name> <msg-id>:<host> Message */
-		pr_warn("%s [%s]-%04x:%ld: %pV",
-			QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset,
-			vha->host_no, &vaf);
-	} else {
-		pr_warn("%s [%s]-%04x: : %pV",
-			QL_MSGHDR, "0000:00:00.0", id + ql_dbg_offset, &vaf);
-	}
+	if (!ql_mask_match(level))
+		trace_ql_dbg_log(pbuf, &vaf);
+	else
+		pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
 
@@ -2524,6 +2520,7 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 {
 	va_list va;
 	struct va_format vaf;
+	char pbuf[128];
 
 	if (pdev == NULL)
 		return;
@@ -2535,9 +2532,8 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	/* <module-name> <dev-name>:<msg-id> Message */
-	pr_warn("%s [%s]-%04x: : %pV",
-		QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset, &vaf);
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id + ql_dbg_offset);
+	pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
 }
@@ -2565,16 +2561,7 @@ ql_log(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
-	if (vha != NULL) {
-		const struct pci_dev *pdev = vha->hw->pdev;
-		/* <module-name> <msg-id>:<host> Message */
-		snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x:%ld: ",
-			QL_MSGHDR, dev_name(&(pdev->dev)), id, vha->host_no);
-	} else {
-		snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
-			QL_MSGHDR, "0000:00:00.0", id);
-	}
-	pbuf[sizeof(pbuf) - 1] = 0;
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
 
 	va_start(va, fmt);
 
@@ -2625,10 +2612,7 @@ ql_log_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
-	/* <module-name> <dev-name>:<msg-id> Message */
-	snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
-		 QL_MSGHDR, dev_name(&(pdev->dev)), id);
-	pbuf[sizeof(pbuf) - 1] = 0;
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id);
 
 	va_start(va, fmt);
 
@@ -2724,16 +2708,7 @@ ql_log_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 	if (level > ql_errlev)
 		return;
 
-	if (qpair != NULL) {
-		const struct pci_dev *pdev = qpair->pdev;
-		/* <module-name> <msg-id>:<host> Message */
-		snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: ",
-			QL_MSGHDR, dev_name(&(pdev->dev)), id);
-	} else {
-		snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
-			QL_MSGHDR, "0000:00:00.0", id);
-	}
-	pbuf[sizeof(pbuf) - 1] = 0;
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), qpair ? qpair->vha : NULL, id);
 
 	va_start(va, fmt);
 
@@ -2777,6 +2752,7 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 {
 	va_list va;
 	struct va_format vaf;
+	char pbuf[128];
 
 	if (!ql_mask_match(level))
 		return;
@@ -2786,16 +2762,9 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	if (qpair != NULL) {
-		const struct pci_dev *pdev = qpair->pdev;
-		/* <module-name> <pci-name> <msg-id>:<host> Message */
-		pr_warn("%s [%s]-%04x: %pV",
-		    QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset,
-		    &vaf);
-	} else {
-		pr_warn("%s [%s]-%04x: : %pV",
-			QL_MSGHDR, "0000:00:00.0", id + ql_dbg_offset, &vaf);
-	}
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), qpair ? qpair->vha : NULL,
+		      id + ql_dbg_offset);
+	pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
 

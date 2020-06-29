Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108C8C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C1F2063A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgF2WzU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44605 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgF2WzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id j19so2132927pgm.11
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sXoyxTA9nquAbHQWx0ETGGYQKA6A8CSQCoKl/HAnywk=;
        b=m4R4uttvm0sGG1N6kX908vRGH3JHgV4oqYCPk6vNtI7EfLs5Ayyi5AewQw5LCi2Nlu
         JgzSKc3sTNGZAavSPnaHT+zyR4jxnCNUB7Osvfhk85ia7me8Txsk6CXssX+jBLIir/S+
         tlgHbqcwe4KhB4RNBzNb4oGyvUR3ZEy7k+PlzbSYML5vDU5QZNigxw8qJv7yevGAqWWF
         JQDG+2OhUlp0BYNm9p2db/N0jJcFnpo0+G1vvXH0DJUY5Fh5ZKgtIbUF+tQECvbwoPwm
         /8SbENFDe9Nr3JWFdjCnF+0dg+WwzAFvnoIUcEVE8avRAcxbdIouBGNWnGsvYprPElDS
         TXtA==
X-Gm-Message-State: AOAM531Cz0GvWz3/Of58V3kzgYyJLtWWiGsOTChcLRQFWba8ml9NTyOQ
        mqDJAczFdZjUUZCXlxZ+ZWg=
X-Google-Smtp-Source: ABdhPJzADcnlSqb2xN2XfLnqnNlGfkPPccToj/tAxEABpJfb7IVKSbsYoK0ksHubcf7jWgmF1pMNyg==
X-Received: by 2002:a05:6a00:15ca:: with SMTP id o10mr16531571pfu.169.1593471318930;
        Mon, 29 Jun 2020 15:55:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 9/9] qla2xxx: Introduce a function for computing the debug message prefix
Date:   Mon, 29 Jun 2020 15:54:54 -0700
Message-Id: <20200629225454.22863-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of repeating the code for generating a debug message prefix
six times, introduce a function for computing the debug message prefix.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 96 ++++++++++++----------------------
 1 file changed, 32 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 41493bd53fc0..911c7852e660 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2447,6 +2447,23 @@ qla83xx_fw_dump(scsi_qla_host_t *vha)
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
@@ -2465,41 +2482,19 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 {
 	va_list va;
 	struct va_format vaf;
+	char pbuf[64];
 
 	va_start(va, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	if (!ql_mask_match(level)) {
-		char pbuf[64];
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
 
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
+	if (!ql_mask_match(level))
 		trace_ql_dbg_log(pbuf, &vaf);
-		va_end(va);
-		return;
-	}
-
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
+	else
+		pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
 
@@ -2524,6 +2519,7 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 {
 	va_list va;
 	struct va_format vaf;
+	char pbuf[128];
 
 	if (pdev == NULL)
 		return;
@@ -2535,9 +2531,8 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
-	/* <module-name> <dev-name>:<msg-id> Message */
-	pr_warn("%s [%s]-%04x: : %pV",
-		QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset, &vaf);
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id + ql_dbg_offset);
+	pr_warn("%s%pV", pbuf, &vaf);
 
 	va_end(va);
 }
@@ -2565,16 +2560,7 @@ ql_log(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
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
 
@@ -2625,10 +2611,7 @@ ql_log_pci(uint level, struct pci_dev *pdev, uint id, const char *fmt, ...)
 	if (level > ql_errlev)
 		return;
 
-	/* <module-name> <dev-name>:<msg-id> Message */
-	snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
-		 QL_MSGHDR, dev_name(&(pdev->dev)), id);
-	pbuf[sizeof(pbuf) - 1] = 0;
+	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id);
 
 	va_start(va, fmt);
 
@@ -2724,16 +2707,7 @@ ql_log_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
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
 
@@ -2777,6 +2751,7 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
 {
 	va_list va;
 	struct va_format vaf;
+	char pbuf[128];
 
 	if (!ql_mask_match(level))
 		return;
@@ -2786,16 +2761,9 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
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
 

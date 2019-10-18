Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C52CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8112089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8u8n3N8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503029AbfJRVTS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:18 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44471 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so4008277pgd.11
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2AJsPSv2I/Bb3v25TKcsPOzTXhz7Iswz1+RAkmnmvuU=;
        b=k8u8n3N8gYyqkRqfk/am+0m34awJ4Dgp6PqK9X5EdDjY7sTU+4ABxJDAHfPQOQKurP
         49v+GTiupb3tAAX94Rvtw8f5pe8AWXZcmmHj3f4/Utwli1lLJk7WfkhmgPd39B1QRWxj
         ZQgXede1edHSWflgwbx94PC9I8ghnJnwdkdK+Na2ZFfXzaGoXL3fepBpUqDLiO+xk/md
         kl/fxSKZLsGP/EWSpM7kNN16+yVLXkuVg7LWEZXThA6hk/fgFZp14EbN1JLHULSjT2+o
         aSJAq6T95jq16S0pe/roG4ggdNvdqMOSnQrrfATHC/sEO68ENIwV1YrmqY6W8sFIE+Mm
         bu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2AJsPSv2I/Bb3v25TKcsPOzTXhz7Iswz1+RAkmnmvuU=;
        b=CK2RIIue74lQB+qzYFU3K0zbmD4H27YAqLuD1r9hiHSiieweNn1ECasJTfykGW5eNy
         lc9onVwkDU4oLjzr7iRB10Vo0+v5/7ohHX0jD72mY3dlZnXpVPtGankhxXaUJOOWr9XA
         lC5JDSOwE46MZ3tGFVXeoScifnfzTny9HVzYUvH56pQy+reCrC7ZSSU/222ChsVaqXa9
         zGzMjhjP+CBRsbz3pivm5VjBkI8Lq8SrZYYQa9yt+Qlnsi9gCGT2Dep7u1DP5OGxzQIT
         CFE0tAgNLBxVruyLZqSEfnqjPt6QD9RuDhigK2P562dlDyKerlFXSW7192NA3IiCSDbF
         cs/A==
X-Gm-Message-State: APjAAAUeXVeL3+Izroyosi34v79DOOJXF195YKgPbDFacIs2+7XQYmqa
        lgNYgVBBmZX428Hbe3DhTXMyyu08
X-Google-Smtp-Source: APXvYqzPdm1cw92bLPU+xeHkeMTQA8Z38rZBRtmq1Fg8RBw4nTTL8q9FyoX4W1hnyowuwVRuyD3uEw==
X-Received: by 2002:aa7:8ece:: with SMTP id b14mr9318036pfr.205.1571433555526;
        Fri, 18 Oct 2019 14:19:15 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/16] lpfc: Add log macros to allow print by serverity or verbocity setting
Date:   Fri, 18 Oct 2019 14:18:28 -0700
Message-Id: <20191018211832.7917-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add two new macros to aid in message logging:

Both macros print a message if the corresponding lpfc verbosity
setting is set or the kernel log level is WARNING or more critical.

One macro is for use with a phba structure, the other with a vport
structure.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_logmsg.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index ea10f03437f5..148d02a27b58 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -46,6 +46,23 @@
 #define LOG_NVME_IOERR  0x00800000      /* NVME IO Error events. */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
+/* generate message by verbose log setting or severity */
+#define lpfc_vlog_msg(vport, level, mask, fmt, arg...) \
+{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '4')) \
+	dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
+		   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); }
+
+#define lpfc_log_msg(phba, level, mask, fmt, arg...) \
+do { \
+	{ uint32_t log_verbose = (phba)->pport ? \
+				 (phba)->pport->cfg_log_verbose : \
+				 (phba)->cfg_log_verbose; \
+	if (((mask) & log_verbose) || (level[1] <= '4')) \
+		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
+			   fmt, phba->brd_no, ##arg); \
+	} \
+} while (0)
+
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
 do { \
 	{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) \
-- 
2.13.7


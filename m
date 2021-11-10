Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C0AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2DB61186
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhKJAsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:45 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:39846 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhKJAso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:44 -0500
Received: by mail-pg1-f177.google.com with SMTP id g184so635840pgc.6
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DXgDe1+Dztca8AnvzuiNKtcmsU9O3EaaKYEgt6dr/+c=;
        b=PMMor+AedtF7rI58ujm3mg/SmZgyBqiDw2/wJWytuPiWebu1SNabk8rqoGVIig8SnJ
         c/UtspkrDuR+CM8omo9UQ9GpELcumXe9PaN5/B/Hv46pGiKG+0HPmMva+sXmlWfnrlqt
         IWQAz4XGoxgN+RQ2uFUwdU06FuxDOPOCQ5GcRVFf366jvxR9YZi/c4hEMumjc/9JeVs7
         9gXb2UlY4+ZpDXZ+qqFSj4HjncUOSVmwMkkhen+f99xxxRs5sOsgbJaisZVPeJhj8EU1
         QI4sEwCXHGhO7R4ci6S6EzGfYvu4QA7b9Td3SKNqoH08tlEqoQY7ic3IlVUVQ8PodKi+
         MARw==
X-Gm-Message-State: AOAM530+b7Hk6mKQWZrmP2TpcE8sQ9ouA0oiCLqrEq605ABvvsl90iUq
        +TcEgVsxuKtP9ZHGr5N7RpA=
X-Google-Smtp-Source: ABdhPJyu5jkWq5iVhRipJo4YYw8hDv6DrxXDVvzXNo2p2uGES7wY5AHhr9W3z2hd+G9ybL4pGLkVAA==
X-Received: by 2002:a62:31c5:0:b0:447:cd37:61f8 with SMTP id x188-20020a6231c5000000b00447cd3761f8mr95464562pfx.29.1636505157524;
        Tue, 09 Nov 2021 16:45:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 11/11] scsi: ufs: Implement polling support
Date:   Tue,  9 Nov 2021 16:44:40 -0800
Message-Id: <20211110004440.3389311-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The time spent in io_schedule() is significant when submitting direct
I/O to a UFS device. Hence this patch that implements polling support.
User space software can enable polling by passing the RWF_HIPRI flag to
the preadv2() system call or the IORING_SETUP_IOPOLL flag to the
io_uring interface.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 45 +++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 36df89e8a575..70f128f12445 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5250,6 +5250,31 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	}
 }
 
+/*
+ * Returns > 0 if one or more commands have been completed or 0 if no
+ * requests have been completed.
+ */
+static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	struct ufs_hba *hba = shost_priv(shost);
+	unsigned long completed_reqs, flags;
+	u32 tr_doorbell;
+
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
+	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
+		  hba->outstanding_reqs);
+	hba->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (completed_reqs)
+		__ufshcd_transfer_req_compl(hba, completed_reqs);
+
+	return completed_reqs;
+}
+
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
@@ -5260,9 +5285,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs, flags;
-	u32 tr_doorbell;
-
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
 	 * In order to prevent other interrupts starvation the DB is read once
@@ -5277,21 +5299,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	if (ufs_fail_completion())
 		return IRQ_HANDLED;
 
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
-	hba->outstanding_reqs &= ~completed_reqs;
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
-		return IRQ_HANDLED;
-	} else {
-		return IRQ_NONE;
-	}
+	return ufshcd_poll(hba->host, 0) ? IRQ_HANDLED : IRQ_NONE;
 }
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
@@ -8112,6 +8120,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
+	.mq_poll		= ufshcd_poll,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,

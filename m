Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315F4C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 133CD61179
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242674AbhIRAHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:46 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:46049 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbhIRAHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:42 -0400
Received: by mail-pl1-f173.google.com with SMTP id n2so4623455plk.12
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q2o/qCP+ag+0iC0yoeHP6317MUAx976w1oda90cAhHw=;
        b=hersbHMeG7zcYuImFna6hKe/c1MLbMvPP6zmgq03jAQLXl/YMWvFv03FWrKhILM0TL
         Xw8PnCmGirI/5MHIaI9Adkt1sG5HSh1z666vwgY5KTH2RZ7zvOQQUH1NlxS7272Yu8Ka
         cLo78BuTHq8ktxa4yT+FDjKslNZ7SW1KinpiuZspws07A8z/nQEMiaT35BW4IvfYk56T
         gwJAifbTYhHu1rSi1rhpEU6C2/hkEUUJyjVoiIcxcM+mfeHrHG1b2/rLYb0UMDr2fJ5w
         6p6glMlme+iTjmEg3U6oib4lMfpissiZfWcuUaz6R/lrbO9HFsWVqAYr9yCw9pYRyUA0
         4ftA==
X-Gm-Message-State: AOAM530mv8B+peZwWq2D9aC9dQbJwZkg0uSxq9fj1vvrlom/EU0b1xhm
        Xj4FMldETJTwFmoRjvVYPwM=
X-Google-Smtp-Source: ABdhPJxKHSEiU3xGR6s2Teh+SY5TzWhLU3ll5Em7cfXpXOCua21KIccNGP464uEWWWcO13hy8EKWgw==
X-Received: by 2002:a17:90a:e547:: with SMTP id ei7mr15801351pjb.177.1631923579977;
        Fri, 17 Sep 2021 17:06:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 04/84] ata: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:47 -0700
Message-Id: <20210918000607.450448-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-sata.c |  2 +-
 drivers/ata/libata-scsi.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 8f3ff830ab0c..60418d872c12 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1258,7 +1258,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
 		rc = __ata_scsi_queuecmd(cmd, ap->link.device);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 	return rc;
 }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1fb4611f7eeb..4afe1abc4709 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -634,7 +634,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
 	if (qc) {
 		qc->scsicmd = cmd;
-		qc->scsidone = cmd->scsi_done;
+		qc->scsidone = scsi_done;
 
 		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
@@ -643,7 +643,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 			qc->flags |= ATA_QCFLAG_QUIET;
 	} else {
 		cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 
 	return qc;
@@ -1738,14 +1738,14 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 early_finish:
 	ata_qc_free(qc);
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
 	ata_qc_free(qc);
 	cmd->result = (DID_ERROR << 16);
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;
@@ -4018,7 +4018,7 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
 		scmd->cmd_len, scsi_op, dev->cdb_len);
 	scmd->result = DID_ERROR << 16;
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	return 0;
 }
 
@@ -4060,7 +4060,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 		rc = __ata_scsi_queuecmd(cmd, dev);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 
 	spin_unlock_irqrestore(ap->lock, irq_flags);
@@ -4188,7 +4188,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		break;
 	}
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)

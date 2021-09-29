Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D364FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B290961406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347062AbhI2WIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:10 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39677 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347039AbhI2WIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:02 -0400
Received: by mail-pf1-f178.google.com with SMTP id g2so3157501pfc.6
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/aF95kyFcWyDHFTMxu1rhd5OKQLF6U8jq19CxAPG1I=;
        b=Fja09FjbUc9Iz4gK4q2JICgTk7hg4f2G0+Ad7IAgWuba4bABotJIv0LG4ta3m7syjN
         bjpJDhjTirVQiOIu9mwPJc60++Xy8AX3gQfrkrnGdRBw6qgB3+I7svG1XTG5tbqhGWv2
         J/zHUPnapTapAFdWtYhn6QdjeIbRkKHp+84YdeqSBwzFFVmEPnls+ibG0tM5/Jc9vQDo
         2gq13dNmLsKyzQopbvtNs3dIqWGGMJPT6o85onKlKyVZSCV3TScZkFlWTIYERPRztw+M
         RuNVRLnDW64D9V22JXaVI79t/NBmIhlwrGd6cWBfvZds7ZrWzNykELqMPFNS2v+hOtw3
         +Ysg==
X-Gm-Message-State: AOAM532Kl21e9d5ufzTFiDp6ZZUX5MU6i9L0V1X9EFUrEqCP9WnqOHXB
        kgC4BXPyYjpqyXax+/hIzqI=
X-Google-Smtp-Source: ABdhPJw1vc0X7UN25Wm6AFuMvQTYYTc7hmiwEJZ8oHiY7IZ3QIGpTVxlicWfKcE/mAZ43Ll2HVF2og==
X-Received: by 2002:a62:4d42:0:b0:44b:3078:7387 with SMTP id a63-20020a624d42000000b0044b30787387mr956936pfb.27.1632953180785;
        Wed, 29 Sep 2021 15:06:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v2 03/84] ata: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:39 -0700
Message-Id: <20210929220600.3509089-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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

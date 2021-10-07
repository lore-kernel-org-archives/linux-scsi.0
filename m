Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0734C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9E361130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhJGUbe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:34 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:46716 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhJGUbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:33 -0400
Received: by mail-pl1-f170.google.com with SMTP id w11so4633851plz.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/aF95kyFcWyDHFTMxu1rhd5OKQLF6U8jq19CxAPG1I=;
        b=4NKlDMNjxy2+JGUlqc5beBgO2nEtg8aYh20LoESyfioQy38NSNp1zc4iVwnfcUp0kh
         r6NBb0Sc/lXsobX+I+VN+g562KJCic5tJoj1Uv6xf6aqKgs/5b0vxDEesJa4bW7ME4xz
         5+dIH1CbSwOZGbkR3AfgOwJThMZi6JkljOnT0dAJi0EcGCt6Zz8mxz9ksraKhEnZE3Dn
         79fEKqgTn6djwkaTtMmQSOeokMTst+NfSmOdlJ0MwzNXGXRUqG0/gsNBn6cx0SLMpPmi
         TCpJWk2jNdq9EcFjcIMTPkNZLoaelGHH6oX4RrdBAgkiU3D0Xgm8vTt6IstDJFN1hRuA
         qDMQ==
X-Gm-Message-State: AOAM530vEwpllQlhZCpwtrpJyEBhfj3IWulN6eUfUSLZXVToWm2MlDqc
        Dlw9HMP7mzpwp2Tuza7wbTaj257LmP0=
X-Google-Smtp-Source: ABdhPJwLjGm1BVEBa4ZEd7dQYDu8HTKDkta4ckMxxNFL3EL68k1s/DvhwmMT9Xxg8RGLtvabNq613w==
X-Received: by 2002:a17:90a:6c97:: with SMTP id y23mr7119558pjj.117.1633638579219;
        Thu, 07 Oct 2021 13:29:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v3 03/88] ata: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:27:58 -0700
Message-Id: <20211007202923.2174984-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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

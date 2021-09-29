Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E6AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ECF260FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347149AbhI2WJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:14 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:45570 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347151AbhI2WJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:08 -0400
Received: by mail-pj1-f53.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so3130708pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p2HaRX5pPHaZGfEsseY/SfrdWg8TP+livibGzd6jccs=;
        b=hMKvk+DlMjJQogZmZWfl+9IREFopjeYjXxQ59NCZ8YMdgQ+6nkvMwtABRIl3k9Oo85
         UynNmszrNmsyi6zf7Sapw9PklexlExgheOHeyyfpF8HEiuKSw7CApheanT0YfIzw+lAt
         wloRm45t8SFihBp9uG1wqQI5l4hkZFD6yt/idNcVcu5LLlgQB5Aca6TpsJmeeZaHK5Id
         Ll96E9Ue+LRAHm3Kq2PfSInsbtvGEmRdYR0INur+6Dag48/q2k8IqwvG1Gtfy37X+DKw
         GJb58JV/Lb3MSkiuGZxC/jarz8FbEy18SY94kyMLsGIZAtApZE8bPa991aR9ewGdZPdL
         u6vA==
X-Gm-Message-State: AOAM530RG2PAN/s6C4Xj+J2OoZRWmcNIYBNWOFUeQ6S0o2VWJ0KdvA0c
        X+w3DrxsE0Mv8YScAjwUW/A=
X-Google-Smtp-Source: ABdhPJyPnGnDB2SVRAUbUP8AI6v3FTMoyg/dbeTtnA7GUVQ3WhXE76g24ZtVZRA6e5nENNfczKxBUQ==
X-Received: by 2002:a17:90a:ba12:: with SMTP id s18mr8951264pjr.60.1632953244123;
        Wed, 29 Sep 2021 15:07:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 43/84] libfc: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:19 -0700
Message-Id: <20210929220600.3509089-44-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libfc/fc_fcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 509eacd7893d..871b11edb586 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1870,7 +1870,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -1880,7 +1880,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		 * online
 		 */
 		sc_cmd->result = DID_IMM_RETRY << 16;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		goto out;
 	}
 
@@ -2087,7 +2087,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 	list_del(&fsp->list);
 	sc_cmd->SCp.ptr = NULL;
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 
 	/* release ref from initial allocation in queue command */
 	fc_fcp_pkt_release(fsp);

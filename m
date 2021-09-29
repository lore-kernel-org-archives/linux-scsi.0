Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7180C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C005060FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347117AbhI2WIe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:34 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:45875 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347079AbhI2WI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:27 -0400
Received: by mail-pg1-f170.google.com with SMTP id n18so4110651pgm.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6NUsYAaALq9TsTWyA1j2V3MIAW6p3hWUP9skEIvRvs=;
        b=PbA/csTZ7cgbZEGn7C7ZMoZpVyf9pFtnhHkpm25LIqsHMQu+U5lI058q8nM4ZXEw5v
         N6u/fMaUPxpAYQQDvlNl7HXvTiDu/t5JrENb+KHtharPh7cUop9IW1nI+PNLQhfKxdMn
         5k/YeJxAnggtECXwSjiwlH6qGBZEzujvbT4jlhuYSbLju8YW6Ak8Tl6EL41Z8t6WTKfv
         2Q6EHdc4MDWKJrFBvZchis6y5DXsT733q4sodFHCVOTKu/lbbwZzjlxF7UKLl2uMyg3J
         h61+LLOqwiGf8TuZlsRtLYeqWACWBmybv0OhxnladBz2vGprNs7TsksxJ4ZmscI/ow7M
         blBQ==
X-Gm-Message-State: AOAM530hl/03T8Jj9PfGWHKc7ikZv6tDZ3JBjEjWtJVgEqXbLXP5mhXB
        kqhRyesNmW59KHHOnGrwX8w=
X-Google-Smtp-Source: ABdhPJzSA+CfJsg3CqO2cFqGfs/+p+bl1E8drcL4czzDqlJ4sP57qriTkyjYptOdx/8Z3o6zgcEkxw==
X-Received: by 2002:a63:5608:: with SMTP id k8mr1882326pgb.287.1632953206040;
        Wed, 29 Sep 2021 15:06:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 21/84] aic7xxx: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:57 -0700
Message-Id: <20210929220600.3509089-22-bvanassche@acm.org>
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
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 92ea24a075b8..af49c32cfaf7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -581,7 +581,6 @@ ahd_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	cmd->scsi_done = scsi_done;
 	cmd->result = CAM_REQ_INPROG << 16;
 	rtn = ahd_linux_run_command(ahd, dev, cmd);
 
@@ -2111,7 +2110,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 
 	ahd_cmd_set_transaction_status(cmd, new_status);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static void
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 8b3d472aa3cc..f2daca41f3f2 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -530,7 +530,6 @@ ahc_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd
 
 	ahc_lock(ahc, &flags);
 	if (ahc->platform_data->qfrozen == 0) {
-		cmd->scsi_done = scsi_done;
 		cmd->result = CAM_REQ_INPROG << 16;
 		rtn = ahc_linux_run_command(ahc, dev, cmd);
 	}
@@ -1986,7 +1985,7 @@ ahc_linux_queue_cmd_complete(struct ahc_softc *ahc, struct scsi_cmnd *cmd)
 		ahc_cmd_set_transaction_status(cmd, new_status);
 	}
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static void

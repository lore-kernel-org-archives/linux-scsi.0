Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB60BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E1360E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242250AbhJGUcA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:00 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:39769 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241841AbhJGUb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:58 -0400
Received: by mail-pg1-f180.google.com with SMTP id g184so912489pgc.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6NUsYAaALq9TsTWyA1j2V3MIAW6p3hWUP9skEIvRvs=;
        b=6Psq59n+YbUW2Rg4gbDUOyw+ZNR6hQFIgJE0YbZkH5WNN3BZriDJNj+ByxziJUuB6p
         TXqU0fG9jRcISQ2ZZ7PeH626Jht6qFjy+MJ/3ecJufqskB85Xpzp+YV9xy8krFX2ohWR
         YNsSuXV++noN2JVnLEShpdYIqSK7eI2c0VZHCaT7eqWbqdw1e2pVLyd39EQM5KW8wLbc
         ASbWCqXzWYxtQO9WF259GPD6tV6iOrVr0AOzKKYhRIbPwkFZPTluinvg7Y6ZoeueXt5n
         MWLno8rvVHEBYO1YRMA5iagSmGjRvLmtWTV3GF7Mlx1IxuxZdBuP66Zm9rUCspwGcckP
         szQA==
X-Gm-Message-State: AOAM531MHXDVUYQqTThG1c20LHmNXkm5cNgB5yb4MzOXA6D8vAhdAJX7
        A3Lu6e2jnJCGsqQPuZvlt3Q=
X-Google-Smtp-Source: ABdhPJzHz2IlxBTLCJxJUo95NhFKTaICabDz+HTO7BDf2Uglbv4pyD1Z2JgJCM2YjeMFzG3V2WPUSQ==
X-Received: by 2002:a63:4d20:: with SMTP id a32mr1350428pgb.247.1633638604055;
        Thu, 07 Oct 2021 13:30:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 21/88] aic7xxx: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:16 -0700
Message-Id: <20211007202923.2174984-22-bvanassche@acm.org>
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

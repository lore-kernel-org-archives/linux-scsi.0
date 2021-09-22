Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6D6C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CFD660F9D
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhIVQ1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:27:50 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:39742 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbhIVQ1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:27:50 -0400
Received: by mail-pf1-f182.google.com with SMTP id e16so3178236pfc.6
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:26:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yOUtkVE8E9bWE+12UwZCS9uclaO/RQ1oZVDSnS5TBJ0=;
        b=6PCtR7PY54De8BYWqW3He6L2GioKKlMKq/S6lKoGYw9IqJsxBoYiVEsCF1dm+7gDgg
         gmPczCYtTaxNyfwoGVwFktGSzkLjqapMLFcL8JrQxsWddJrhPo3/DO8WSoOBOoYHHzin
         5otpJlqMfEr1Cfi3WAuJv5cuol0YKnSmXy7TY4lEwPCdhMi0DW9tNeFQMOIZj7d8h5+d
         EJQWYK0G6m9xsB4fP73w5GQABN03x5x1MBLJLfrZdN1OitLPkZHqZwhsOZ/qKh5plxgv
         F4W49mWY8S8BEJAZwA4/BupNSbKwoC7tbwmw6QF/6WJGV4chh//DEzdKwJI+V6fodaSv
         ri2g==
X-Gm-Message-State: AOAM530TOclBe2zhN0cFuT5G0/Lzm5u87Ghz9TV1GBhPjZ/JKU3QYF6Q
        qGdTeFn/5QUqqfcjR/li7N8xG8Jke1c=
X-Google-Smtp-Source: ABdhPJzr/xbn1HkD7SeNqt6yKalUWiGDSm5I6W5UozyyC8sw/unfXgrA63XI3ZEfDOEW8wSNghmnug==
X-Received: by 2002:a63:555c:: with SMTP id f28mr478713pgm.316.1632327979585;
        Wed, 22 Sep 2021 09:26:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id p26sm2311697pfw.137.2021.09.22.09.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:26:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 81/84] staging: unisys: visorhba: Call scsi_done() directly
Date:   Wed, 22 Sep 2021 09:25:59 -0700
Message-Id: <20210922162603.476745-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210922162603.476745-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210922162603.476745-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/unisys/visorhba/visorhba_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 41f8a72a2a95..6a8fa0587280 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -327,7 +327,7 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
 	rtn = forward_taskmgmt_command(TASK_MGMT_ABORT_TASK, scsidev);
 	if (rtn == SUCCESS) {
 		scsicmd->result = DID_ABORT << 16;
-		scsicmd->scsi_done(scsicmd);
+		scsi_done(scsicmd);
 	}
 	return rtn;
 }
@@ -354,7 +354,7 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
 	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
 	if (rtn == SUCCESS) {
 		scsicmd->result = DID_RESET << 16;
-		scsicmd->scsi_done(scsicmd);
+		scsi_done(scsicmd);
 	}
 	return rtn;
 }
@@ -383,7 +383,7 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
 	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
 	if (rtn == SUCCESS) {
 		scsicmd->result = DID_RESET << 16;
-		scsicmd->scsi_done(scsicmd);
+		scsi_done(scsicmd);
 	}
 	return rtn;
 }
@@ -476,8 +476,7 @@ static int visorhba_queue_command_lck(struct scsi_cmnd *scsicmd,
 	 */
 	cmdrsp->scsi.handle = insert_location;
 
-	/* save done function that we have call when cmd is complete */
-	scsicmd->scsi_done = visorhba_cmnd_done;
+	WARN_ON_ONCE(visorhba_cmnd_done != scsi_done);
 	/* save destination */
 	cmdrsp->scsi.vdest.channel = scsidev->channel;
 	cmdrsp->scsi.vdest.id = scsidev->id;
@@ -686,8 +685,7 @@ static void visorhba_serverdown_complete(struct visorhba_devdata *devdata)
 		case CMD_SCSI_TYPE:
 			scsicmd = pendingdel->sent;
 			scsicmd->result = DID_RESET << 16;
-			if (scsicmd->scsi_done)
-				scsicmd->scsi_done(scsicmd);
+			scsi_done(scsicmd);
 			break;
 		case CMD_SCSITASKMGMT_TYPE:
 			cmdrsp = pendingdel->sent;
@@ -853,7 +851,7 @@ static void complete_scsi_command(struct uiscmdrsp *cmdrsp,
 	else
 		do_scsi_nolinuxstat(cmdrsp, scsicmd);
 
-	scsicmd->scsi_done(scsicmd);
+	scsi_done(scsicmd);
 }
 
 /*

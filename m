Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C38BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ABD760FBF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347053AbhI2WNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:13:33 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:33382 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344944AbhI2WNc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:13:32 -0400
Received: by mail-pl1-f175.google.com with SMTP id t4so2564545plo.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yOUtkVE8E9bWE+12UwZCS9uclaO/RQ1oZVDSnS5TBJ0=;
        b=R+4H9vQLaWbxDZO9/ut/FIGpEf1dPN7DVOdIPxSzoFmlUTIeFTaOK181APlZ+YHCyg
         XAzcO2/Rw8caHweJ9Yxn2XMAS/nx/NYZxwS+8OO4vYOubMLyJhiQrvnCIx8dykRHS1LZ
         XFwNY0xg17hvFFiWStSStXZmma9MY9+rzKgosc9h0bVY5MTDNVE/2m489KeE1AJaiUTP
         OIwDP1+bnPLeaimVPAYwapVGAi5zeozOvX4IA15eihh9o4Lv7cw4yuHaQ6bQXlde5EM6
         FoFROyhd7hkiYtFp/nAL6b79vhxtf1sreUwq+8gjnt4hkNR6u/osATER3dwSc77Y4yGg
         UnkQ==
X-Gm-Message-State: AOAM533mFMgkhRkC8Nlo0QVcvi9bfJvhtQcbOlSLL5scAPbQA3JcEnJi
        YpUF6k74OebZnVmcJrhqLog=
X-Google-Smtp-Source: ABdhPJzn6vz1bf0BW7waCjzA1NzalgXibDccPCJYks1EYCpUxaUYTFHBwbTsIICG080/KGqnUBuhEA==
X-Received: by 2002:a17:90b:804:: with SMTP id bk4mr9136039pjb.107.1632953510408;
        Wed, 29 Sep 2021 15:11:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id 139sm706461pfz.35.2021.09.29.15.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:11:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Kershner <david.kershner@unisys.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: [PATCH v2 81/84] staging: unisys: visorhba: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:11:32 -0700
Message-Id: <20210929221138.3511208-2-bvanassche@acm.org>
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

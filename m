Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CCDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8063E61184
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhIURgi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:36:38 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:35457 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhIURgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 13:36:35 -0400
Received: by mail-pf1-f173.google.com with SMTP id w14so196072pfu.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 10:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=yOUtkVE8E9bWE+12UwZCS9uclaO/RQ1oZVDSnS5TBJ0=;
        b=doGKSy5d+j9HriPwDS+1Qq3vCbdwuBb6Qd6sM7rRNa5n9VQQMoLa7LVd+9J6Z5ulPo
         6q3EbrnoiqJaxOJCCSr7WjciNddCOZQS/ZQb+aC9l3bKRAEwpIf+HLnReUqWN9yst/Gs
         AJ75b2m1ldKcTReFKqtJzbahCNGwlqFcJTbsoXDLvpaCGSp4VTbXl5b9yvfj+m2uXdUF
         IL9ENGaHLSFcJAx+COGxyq/qytfC1jx4Sse0upyO/rhsmGZyuUrp7G5Yb5zgB0BlJFyv
         jzdi38P5vUuiMJ1XSrG2u+HgsJrfSuvxe1uA5Oi6fxldbi5lWXLoMJ8Wi65d1b+cdvI5
         3h8w==
X-Gm-Message-State: AOAM531dDdx/rUUeTpUVjzmCmn4prQmQM41dVIlZxtWCEoI6fjJ79DMQ
        W4n7idLM1IA5x4SSlhFJzLo=
X-Google-Smtp-Source: ABdhPJxngGU60xfNLseudRPjhxmPtI3hiiCo/EQn9sCcojo+FCGkVZXppEHsqLi34M3CQN942Qa2Og==
X-Received: by 2002:a62:1683:0:b0:3f3:814f:4367 with SMTP id 125-20020a621683000000b003f3814f4367mr32051290pfw.68.1632245706527;
        Tue, 21 Sep 2021 10:35:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f15:8d17:800:eea3])
        by smtp.gmail.com with ESMTPSA id w22sm14561603pgc.56.2021.09.21.10.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:35:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>
Subject: [PATCH 81/84] staging: unisys: visorhba: Call scsi_done() directly
Date:   Tue, 21 Sep 2021 10:34:33 -0700
Message-Id: <20210921173436.3533078-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921173436.3533078-1-bvanassche@acm.org>
References: <20210921173436.3533078-1-bvanassche@acm.org>
Reply-To: 20210918000607.450448-1-bvanassche@acm.org
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

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5F6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F5B603E5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241631AbhJGUso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:44 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:43813 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbhJGUso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:44 -0400
Received: by mail-pl1-f182.google.com with SMTP id y1so4668204plk.10
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjug1GLmW/1ZK9+42yO9dldTJjiCOheMITcS+wFWDeE=;
        b=6L8fNQJSBnO1QpCAyQuO/ImIS3eWztUAyi2nm1/g45EtLZRriBAPVohYdK35j9G/Fv
         TvgjpIDY3iavU6Q14X1SYINLhPktWkcO1J1Gxe56S06Gw1v0o/UUnHE9y4x21mBrn1D/
         R4uzfVrcnH89g2l8a3ahJEHYC917aFRoyZZlXkxAx0HZw8TMBnVnmAMHzMqId1sRxjF7
         33s34K+vaQpnFRm1sCHfcixY02opbjk6mpy7OfzdF/uc0vwqMxZZbgF8r06+m+/MihiV
         G1u68fJTj6ampvPxNoLJCY8V0WMKyEIXIVx7sa82AcO/76kmxw2vYNlgNhcYpDMu5YL5
         O07g==
X-Gm-Message-State: AOAM532enc2jB8WAQWloM7rytZ5xkp74KupeB8ce2D00vxVHdXxAP5jt
        6FCH+Yv6AdQZjal7TIOM6oU=
X-Google-Smtp-Source: ABdhPJyp+48CxlAaEK7uDWoAKB1SkCHSaBAkTYDNRiHUR8fPewmNXct2lN3FDPR8Wg7otXJDOsQD1g==
X-Received: by 2002:a17:902:a385:b0:13e:99e9:17f3 with SMTP id x5-20020a170902a38500b0013e99e917f3mr5838415pla.65.1633639609971;
        Thu, 07 Oct 2021 13:46:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Kershner <david.kershner@unisys.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>
Subject: [PATCH v3 82/88] staging: unisys: visorhba: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:08 -0700
Message-Id: <20211007204618.2196847-8-bvanassche@acm.org>
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

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

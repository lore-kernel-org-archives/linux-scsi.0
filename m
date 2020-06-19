Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06517C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 15:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D845A20809
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 15:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZyWYcff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404848AbgFSPly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 11:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394020AbgFSPlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 11:41:37 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB43C06174E;
        Fri, 19 Jun 2020 08:41:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so10654524ejc.8;
        Fri, 19 Jun 2020 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DponZSTc3PXadFZ/Va5z+HlpHIhGzNlZ4rlMGnjJEz8=;
        b=QZyWYcffTCxTAou4/XDL0wFs/ac5lDwo/8AznACPc3AmiBImc+1vq2iwTECxAuhJex
         ILxAYIS7Ex3EoQiZMwOB3xhsl8aswr8UHePRXi+Nl/oqfinyXTGKJtrS8TKVKwBgxoWl
         jPWPS/8nw6i3tmrT2b5pJ5lcNKgUus2kUTV6ZZNzx3vMudu8g04fHJBBLuafGVuq3ZV9
         VPLQlbfV7P1HxJiwfRIT6gZzsnO2t6M5XfElFaZ+PedcGHKmknXmXZdFae8ceJOZU8n5
         4BofWIMkQsw8X44nTMSHEJhL3nW2HqE7taPGMVvXjEPxPryPqSBPGZ+XccR8/gEbZacw
         tI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DponZSTc3PXadFZ/Va5z+HlpHIhGzNlZ4rlMGnjJEz8=;
        b=B+4cZGJTpuGxlzS+htlFz/yA3x0+YYSMk5LMAHxpL4Yxzl+js1YNeNWJ/7hO0QoiBn
         9yFTk6ifl4Ty0Gr8towPk0q6g7+ENiYt5CUCktSRc+wVtkBsCmJTyVOp0wHnGr+8y4W9
         /SJgVlxJQPi3D/OLEBOJoPvPH1mSFddUnvnziDiI1pRlFHknC6d3nXVRuQGjKjlz/RJf
         BT2syRBcIafT1moiESCrHUPpkiGEHiIHEVlm5gDdw+F1M7+gSevsbcDgOhM0OkYRnUIL
         1EIl3zCZyQdFVjvuqJUGV5UiJ8y1+Xc8wmTqkfjMY8xHpO8HjEDIRSbFJQXjt5V9svWY
         K1jQ==
X-Gm-Message-State: AOAM530YIEz1lRzUgR1aXJBY3kDPqbbavwtpHjUQ3d55bnML8HzJyueo
        kaZH8v0EP0u/+uyjnaxm0lA=
X-Google-Smtp-Source: ABdhPJwc5KBg86fF95A4Q+GvR1ansr7SgCbM42vcDpjhFxtXdUQn7fnpXSNMr7CNxA3gP5x3Tao2WQ==
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr4397827ejj.155.1592581295536;
        Fri, 19 Jun 2020 08:41:35 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id ew9sm4986163ejb.121.2020.06.19.08.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 08:41:35 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Cc:     beanhuo@micron.com
Subject: [PATCH v2 2/2] scsi: fix coding style errors in scsi_lib.c
Date:   Fri, 19 Jun 2020 17:41:17 +0200
Message-Id: <20200619154117.10262-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619154117.10262-1-huobean@gmail.com>
References: <20200619154117.10262-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete trailing whitespace, multiple blank lines, and make
switch/case be at the same indent.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/scsi_lib.c | 43 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c47650f7f0d3..be8f5050f837 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -389,7 +389,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
+
 		scsi_device_put(sdev);
 	}
  out:
@@ -1455,18 +1455,18 @@ static void scsi_softirq_done(struct request *rq)
 	scsi_log_completion(cmd, disposition);
 
 	switch (disposition) {
-		case SUCCESS:
-			scsi_finish_command(cmd);
-			break;
-		case NEEDS_RETRY:
-			scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
-			break;
-		case ADD_TO_MLQUEUE:
-			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
-			break;
-		default:
-			scsi_eh_scmd_add(cmd);
-			break;
+	case SUCCESS:
+		scsi_finish_command(cmd);
+		break;
+	case NEEDS_RETRY:
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
+		break;
+	case ADD_TO_MLQUEUE:
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		break;
+	default:
+		scsi_eh_scmd_add(cmd);
+		break;
 	}
 }
 
@@ -2024,7 +2024,6 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[1] = data->medium_type;
 		real_buffer[2] = data->device_specific;
 		real_buffer[3] = data->block_descriptor_length;
-		
 
 		cmd[0] = MODE_SELECT;
 		cmd[4] = len;
@@ -2110,7 +2109,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
-				/* 
+				/*
 				 * Invalid command operation code
 				 */
 				sdev->use_10_for_ms = 0;
@@ -2119,7 +2118,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		}
 	}
 
-	if(scsi_status_is_good(result)) {
+	if (scsi_status_is_good(result)) {
 		if (unlikely(buffer[0] == 0x86 && buffer[1] == 0x0b &&
 			     (modepage == 6 || modepage == 8))) {
 			/* Initio breakage? */
@@ -2129,7 +2128,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			data->device_specific = 0;
 			data->longlba = 0;
 			data->block_descriptor_length = 0;
-		} else if(use_10_for_ms) {
+		} else if (use_10_for_ms) {
 			data->length = buffer[0]*256 + buffer[1] + 2;
 			data->medium_type = buffer[2];
 			data->device_specific = buffer[3];
@@ -2212,7 +2211,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 			goto illegal;
 		}
 		break;
-			
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -2497,7 +2496,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
  *	(which must be a legal transition).  When the device is in this
  *	state, only special requests will be accepted, all others will
  *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be 
+ *	a successful return doesn't guarantee the device will be
  *	totally quiescent.
  *
  *	Must be called with user context, may sleep.
@@ -2623,10 +2622,10 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 			return err;
 	}
 
-	/* 
+	/*
 	 * The device has transitioned to SDEV_BLOCK.  Stop the
 	 * block layer from calling the midlayer with this device's
-	 * request queue. 
+	 * request queue.
 	 */
 	blk_mq_quiesce_queue_nowait(q);
 	return 0;
@@ -2661,7 +2660,7 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 
 	return err;
 }
- 
+
 void scsi_start_queue(struct scsi_device *sdev)
 {
 	struct request_queue *q = sdev->request_queue;
-- 
2.17.1


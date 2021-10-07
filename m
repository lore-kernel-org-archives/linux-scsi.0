Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2653C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4A761074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhJGUbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:44 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:50727 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhJGUbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:41 -0400
Received: by mail-pj1-f42.google.com with SMTP id k23so5837849pji.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3g9GybVmhn5NcVSEf+e0j0/kR3Jt4ybQmvybi1gAxcA=;
        b=cGwTpIC46zY8lBYA1MiZ7NZ6yugq+6c3rCRL6EdmqCLlyULf5qn7Vx4FsOYUV/cuRN
         OVXMJABTcTfxQtjDly6tB6JE+V104RvEAQj+acsMWE7blPxZ63jIt4Ou65LcrnXs9Hv7
         LiyojISEOkeBrs5CqHnJ7vAoVRnaaC19TjLaXAxGn5XtEu/ViHuNZjrf6mWGpzVOvCXP
         j44fUhCKP4Xa+v/sAz/f5s18XGshRgcsz1ts78J2QAMqaxSL6uv/Ku3txO4SHkfpoZj1
         zutsq+pYO4khZCuxLjO3+TclzYKQH1MP8nS7fuIL/51TFubNxK1YJfyiwb5ROIN/Ohnp
         wC8w==
X-Gm-Message-State: AOAM531vvEjdLgDFy2RedAGurEJDLwszTZOn5TBY2h/uh4cc/ldPGZhd
        ey/5rS4ekPbu8MqG0cT4DL0=
X-Google-Smtp-Source: ABdhPJwORm7TxASsGv3ITRvB+L4WUZLunUgk3d6jpw+5N4jkml2f5U74laUO4Jvr+RkDnHNG1Z3UfQ==
X-Received: by 2002:a17:90b:11cd:: with SMTP id gv13mr7876915pjb.210.1633638587687;
        Thu, 07 Oct 2021 13:29:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 09/88] 3w-sas: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:04 -0700
Message-Id: <20211007202923.2174984-10-bvanassche@acm.org>
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
 drivers/scsi/3w-sas.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 4fde39da54e4..e6f51904f5b1 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1216,7 +1216,7 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 
 			/* Now complete the io */
 			scsi_dma_unmap(cmd);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			twl_free_request_id(tw_dev, request_id);
 			tw_dev->posted_request_count--;
@@ -1369,7 +1369,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 			if (cmd) {
 				cmd->result = (DID_RESET << 16);
 				scsi_dma_unmap(cmd);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 			}
 		}
 	}
@@ -1461,9 +1461,6 @@ static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		goto out;
 	}
 
-	/* Save done function into scsi_cmnd struct */
-	SCpnt->scsi_done = done;
-
 	/* Get a free request id */
 	twl_get_request_id(tw_dev, &request_id);
 

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27037C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A31A60FBF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347206AbhI2WNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:13:38 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:46781 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347100AbhI2WNi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:13:38 -0400
Received: by mail-pf1-f173.google.com with SMTP id u7so3129075pfg.13
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eyhlcCOvwT4kTceXvmzNtXnFzDU2u/+/8T4S4M+aWMc=;
        b=CSnzXIhC/ZAi+DVOFeEMYlmktMesXScIdMTPLIk2UDKftKYkMLdpgYFjghGN51/bhq
         09Geuqvh8j0hqPVBLPn7PLEydTvWEZBzIYymDRcQWw3sXbwpFrUW0Od0yoBqHZNQD7PR
         MBJkQcqi8uAgkvKzn+Op8z+KgsAn4GjBLLd8jMtc8sg4Qii8L8Xj0DN6sod+fmD1GSw1
         jWQ1IDwulvOhapLn18XkdKdYNHqddyVd5kJTGcOUtBUEKHJhFfFlNzmgajXNO6wep4hh
         uLXJRhaR2fpECYTDJQQ3PqX/tRONwFwF4cOJ0N/7iTTmwyoJjxlri8ubXBQSrC2XkbyL
         yR+Q==
X-Gm-Message-State: AOAM533s4nhF5/DWx/QjzZDTk+DCZAkCcOg7Wpi3CGjzN47KLye/oisk
        6MBU9ruckYKlMnZIYg/8JlM=
X-Google-Smtp-Source: ABdhPJyY5Qzq4D9jN05ZcG0BFiRbMhlZ4vHb19p9KjT3iEuW8ytThtV5Q0iXDeCkVVH9BpzD7ZGt+g==
X-Received: by 2002:a62:4d42:0:b0:44b:3078:7387 with SMTP id a63-20020a624d42000000b0044b30787387mr977797pfb.27.1632953516522;
        Wed, 29 Sep 2021 15:11:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id 139sm706461pfz.35.2021.09.29.15.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:11:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v2 83/84] usb: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:11:34 -0700
Message-Id: <20210929221138.3511208-4-bvanassche@acm.org>
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
 drivers/usb/storage/scsiglue.c |  1 -
 drivers/usb/storage/uas.c      | 10 ++++------
 drivers/usb/storage/usb.c      |  4 ++--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5a971b83e3f..9dfea19e5a91 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -393,7 +393,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	}
 
 	/* enqueue the command and wake up the control thread */
-	srb->scsi_done = done;
 	us->srb = srb;
 	complete(&us->cmnd_ready);
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bef89c6bd1d7..774d18907f47 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -256,7 +256,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 		return -EBUSY;
 	devinfo->cmnd[cmdinfo->uas_tag - 1] = NULL;
 	uas_free_unsubmitted_urbs(cmnd);
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
@@ -653,7 +653,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		memcpy(cmnd->sense_buffer, usb_stor_sense_invalidCDB,
 		       sizeof(usb_stor_sense_invalidCDB));
 		cmnd->result = SAM_STAT_CHECK_CONDITION;
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		return 0;
 	}
 
@@ -661,7 +661,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	if (devinfo->resetting) {
 		set_host_byte(cmnd, DID_ERROR);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		goto zombie;
 	}
 
@@ -675,8 +675,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
-	cmnd->scsi_done = done;
-
 	memset(cmdinfo, 0, sizeof(*cmdinfo));
 	cmdinfo->uas_tag = idx + 1; /* uas-tag == usb-stream-id, so 1 based */
 	cmdinfo->state = SUBMIT_STATUS_URB | ALLOC_CMD_URB | SUBMIT_CMD_URB;
@@ -706,7 +704,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	 */
 	if (err == -ENODEV) {
 		set_host_byte(cmnd, DID_ERROR);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		goto zombie;
 	}
 	if (err) {
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 90aa9c12ffac..8b543f2c9857 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -388,7 +388,7 @@ static int usb_stor_control_thread(void * __us)
 		if (srb->result == DID_ABORT << 16) {
 SkipForAbort:
 			usb_stor_dbg(us, "scsi command aborted\n");
-			srb = NULL;	/* Don't call srb->scsi_done() */
+			srb = NULL;	/* Don't call scsi_done() */
 		}
 
 		/*
@@ -417,7 +417,7 @@ static int usb_stor_control_thread(void * __us)
 		if (srb) {
 			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
 					srb->result);
-			srb->scsi_done(srb);
+			scsi_done(srb);
 		}
 	} /* for (;;) */
 

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2848C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973F6611C5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhIURgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:36:44 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:38509 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhIURgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 13:36:42 -0400
Received: by mail-pf1-f176.google.com with SMTP id y4so178258pfe.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 10:35:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=eyhlcCOvwT4kTceXvmzNtXnFzDU2u/+/8T4S4M+aWMc=;
        b=cLiB5dsaxw80BX63mJVUdDMRNfO/IYaItX0D1sZGqUWbAIWnp0EgXW0leOQsmHAnXe
         HEPaSZyrv9zBzyu091jHdvmPX4q0DVtsmJeI7a2dyQwAMZLpIo7yx2x2ZlBPHUIKeZ2h
         D9J2ZfqgzFmbH9koDEc+50yRKk7wXN3Ym+aGe8z1XUSPfMcKNSZtJZUBRUQcWQbI4cvP
         +qOVbYbCEaxYGXnFhjxS4BWjeOi0STy8YRLHHoIqOFjZLYEC1A76LlKmM7guCaYfwWvC
         HtvfyjbLLU96BcaNdcwQS/y+csp95grAuEJGdrpcxRGIdvHd4oTNyPZN8encmreUWmuS
         3rpA==
X-Gm-Message-State: AOAM530mxaBsH/qPqzrRrcTECiBSvmpj3cBMMHA3RESQAeKTqkVDEhUK
        tXNBKlFyFnFWbtey7oDaf3c=
X-Google-Smtp-Source: ABdhPJwfgMFwLavN8cajXFxH/bMbZuQVEwNQQXsB8VT5Ee8rG96xH08zaOgdYiZ1xUikFqRbYglerw==
X-Received: by 2002:a62:384d:0:b0:447:e970:3d3f with SMTP id f74-20020a62384d000000b00447e9703d3fmr4744216pfa.23.1632245713239;
        Tue, 21 Sep 2021 10:35:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f15:8d17:800:eea3])
        by smtp.gmail.com with ESMTPSA id w22sm14561603pgc.56.2021.09.21.10.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:35:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 83/84] usb: Call scsi_done() directly
Date:   Tue, 21 Sep 2021 10:34:35 -0700
Message-Id: <20210921173436.3533078-5-bvanassche@acm.org>
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
 

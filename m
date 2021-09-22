Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19D9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B73611CA
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhIVQ15 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:27:57 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:45924 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbhIVQ14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:27:56 -0400
Received: by mail-pf1-f179.google.com with SMTP id w19so3126539pfn.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eyhlcCOvwT4kTceXvmzNtXnFzDU2u/+/8T4S4M+aWMc=;
        b=o4sFlkSuCRIPZ72hulAUzw9IKy8FDDzkwdAnAaiN39DjN3UfaYdjpmMM6qVLvDqqp2
         pbjER5PCl85JBnGgH3aE7Fp42EmXW0rqiyerrt5N+LS0d4+jAAXk96/7cvQmGyoPZQWo
         Ath3xy3onYw3nMKSZa65cwIBmDtqanyM7du749w36LPlOaN5p4B7VjcuJvU6TAxihrHw
         Rv25H93lmnAyMJ3cPtDMZ1Vf3qA6ObqwwOTxos3f1YgTkzWv9jUlilV6xjB0t5pvXvAA
         2tNl6XP4uR4ECWANcor3uRIWUrYZn6mrtQA1VDEvamURlxilXxeBETjavOWV3lRK8Ka7
         XxqQ==
X-Gm-Message-State: AOAM530kIkOV1+xYTm0GXhT7lEFA5XueloAQ8igX51osqdHQ/Zs8auzX
        6Hf1SpNJdFn+n+nvQyDYbY+XrROFVO8=
X-Google-Smtp-Source: ABdhPJzr43gOk7mDfF+ZD4ztbDZaTGKCdGeb8ZcUmg+yOsV8iLnVW1mSw548xgJxWrRmfgtoY+z9ow==
X-Received: by 2002:a63:8c42:: with SMTP id q2mr450994pgn.325.1632327986363;
        Wed, 22 Sep 2021 09:26:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id p26sm2311697pfw.137.2021.09.22.09.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:26:25 -0700 (PDT)
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
Date:   Wed, 22 Sep 2021 09:26:01 -0700
Message-Id: <20210922162603.476745-5-bvanassche@acm.org>
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
 

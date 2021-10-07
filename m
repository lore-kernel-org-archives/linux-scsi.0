Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19447C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05248603E5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhJGUsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:54 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:42835 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhJGUsx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:53 -0400
Received: by mail-pl1-f173.google.com with SMTP id l6so4676537plh.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eyhlcCOvwT4kTceXvmzNtXnFzDU2u/+/8T4S4M+aWMc=;
        b=Ssv7zBUdpsmwekcCf6/v65OQsv1m9Sbph+d+Hy+1WATtU2bnLmcUU7poCm9Ynr0QzH
         8zd+rTAVSNzJ96BfGYh/8RyEr1T5UsqjAc8uMFwbykZN+Chg1p+QP5wie/Qe3ewL3Uwd
         zup0FWE8eJm0aMR9MG3orT+CanRE4lpY3md9a0MYCfm8gU+stS35lrC3rgYO/tjeXBFp
         XDu12+FFUpICJbfX9kFDJFZt7oqxBV0+GWk1uxQGbwDcDVY/onsqcu/dDavpqtByDPEG
         8IhljXGrvgu3l0nRoacaExZEPi5b952PfEluzV2g4WOGtqwDAiVt+bJl1Kfhp6G7JCpu
         1I/Q==
X-Gm-Message-State: AOAM532Gz7JWX+okEoxUH7m3pZY3WcWKYZ6aWyUanK1UPOTAL42XU+DJ
        tQhYlakDs+exBfvm3SUBqeg=
X-Google-Smtp-Source: ABdhPJzlIeElVeniBoDBJEzzlKSxg+NoH84RUoZbSvJOswElPvIkStf7FmINfSdDixh+rbJEx3wdnA==
X-Received: by 2002:a17:90a:ea94:: with SMTP id h20mr5850500pjz.58.1633639619445;
        Thu, 07 Oct 2021 13:46:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:58 -0700 (PDT)
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
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v3 84/88] usb: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:10 -0700
Message-Id: <20211007204618.2196847-10-bvanassche@acm.org>
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
 

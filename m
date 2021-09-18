Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B701C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48A6660F46
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344439AbhIRAIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:39 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:33467 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344304AbhIRAIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:36 -0400
Received: by mail-pf1-f182.google.com with SMTP id s16so2406418pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjvgxivave2j5ZL8bX3+wFTPDeSH2Nh05FzrEkym00w=;
        b=Sy5if9p93q7yvI81soGlWghW5xP2HAAJSUDRzFImK2osTJqoPvVA9Iy3G1Q6Izhwid
         rbOmWDksaJ/5FqpgQuuIiAd643me7r6kPzApWODLgA2kWlVmdbh0EPAWE6Gf8c7yap1V
         MHU4N6mJNQz9lOddcjZFIe20ZW158NxujbMqX8jIk9euA3XLdd5VtNXaNreAc0rdQ9J6
         zb2OnMIOGCEfJK0m20FIUSbr/X+PuiKrGh1VMHZss6ZV9Sxe5gtzlyc+DNA+945BIOBQ
         whhkXUqTqEiA0lVbrIBGuk0/XzdIC9yEg+S19GGi1QCpwnWPJdC0ncQ0nJC/Pu40aQUH
         uFnA==
X-Gm-Message-State: AOAM531IW+sCBNLFX66bmFye8OQddPZQeIxUy8OHLxNbjuObFphNq5TZ
        Nhf3Jz0FS1uKkYxb7ASnYO2N7iCGG94=
X-Google-Smtp-Source: ABdhPJwsG7OIcCX5sHoZbqe+T8KiUzmvvjpxeWLPLjzZTH3NMkDArNuTamQdR/VCO1VH+26vTVcVtw==
X-Received: by 2002:a63:391:: with SMTP id 139mr12241002pgd.410.1631923633765;
        Fri, 17 Sep 2021 17:07:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 35/84] fnic: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:18 -0700
Message-Id: <20210918000607.450448-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 119 +++++++++++++++-------------------
 1 file changed, 54 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index f8afbfb468dc..1d6ad312c47b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -560,7 +560,6 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
 	CMD_SP(sc) = (char *)io_req;
 	CMD_FLAGS(sc) |= FNIC_IO_INITIALIZED;
-	sc->scsi_done = done;
 
 	/* create copy wq desc and enqueue it */
 	wq = &fnic->wq_copy[0];
@@ -1051,8 +1050,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	}
 
 	/* Call SCSI completion function to complete the IO */
-	if (sc->scsi_done)
-		sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 /* fnic_fcpio_itmf_cmpl_handler
@@ -1193,28 +1191,25 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 
 			fnic_release_ioreq_buf(fnic, io_req, sc);
 			mempool_free(io_req, fnic->io_req_pool);
-			if (sc->scsi_done) {
-				FNIC_TRACE(fnic_fcpio_itmf_cmpl_handler,
-					sc->device->host->host_no, id,
-					sc,
-					jiffies_to_msecs(jiffies - start_time),
-					desc,
-					(((u64)hdr_status << 40) |
-					(u64)sc->cmnd[0] << 32 |
-					(u64)sc->cmnd[2] << 24 |
-					(u64)sc->cmnd[3] << 16 |
-					(u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-					(((u64)CMD_FLAGS(sc) << 32) |
-					CMD_STATE(sc)));
-				sc->scsi_done(sc);
-				atomic64_dec(&fnic_stats->io_stats.active_ios);
-				if (atomic64_read(&fnic->io_cmpl_skip))
-					atomic64_dec(&fnic->io_cmpl_skip);
-				else
-					atomic64_inc(&fnic_stats->io_stats.io_completions);
-			}
+			FNIC_TRACE(fnic_fcpio_itmf_cmpl_handler,
+				   sc->device->host->host_no, id,
+				   sc,
+				   jiffies_to_msecs(jiffies - start_time),
+				   desc,
+				   (((u64)hdr_status << 40) |
+				    (u64)sc->cmnd[0] << 32 |
+				    (u64)sc->cmnd[2] << 24 |
+				    (u64)sc->cmnd[3] << 16 |
+				    (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
+				   (((u64)CMD_FLAGS(sc) << 32) |
+				    CMD_STATE(sc)));
+			scsi_done(sc);
+			atomic64_dec(&fnic_stats->io_stats.active_ios);
+			if (atomic64_read(&fnic->io_cmpl_skip))
+				atomic64_dec(&fnic->io_cmpl_skip);
+			else
+				atomic64_inc(&fnic_stats->io_stats.io_completions);
 		}
-
 	} else if (id & FNIC_TAG_DEV_RST) {
 		/* Completion of device reset */
 		CMD_LR_STATUS(sc) = hdr_status;
@@ -1421,23 +1416,22 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 	/* Complete the command to SCSI */
-	if (sc->scsi_done) {
-		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
-				     tag, sc);
-
-		FNIC_TRACE(fnic_cleanup_io,
-			   sc->device->host->host_no, tag, sc,
-			   jiffies_to_msecs(jiffies - start_time),
-			   0, ((u64)sc->cmnd[0] << 32 |
-			       (u64)sc->cmnd[2] << 24 |
-			       (u64)sc->cmnd[3] << 16 |
-			       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-			   (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
-
-		sc->scsi_done(sc);
-	}
+	if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
+			     tag, sc);
+
+	FNIC_TRACE(fnic_cleanup_io,
+		   sc->device->host->host_no, tag, sc,
+		   jiffies_to_msecs(jiffies - start_time),
+		   0, ((u64)sc->cmnd[0] << 32 |
+		       (u64)sc->cmnd[2] << 24 |
+		       (u64)sc->cmnd[3] << 16 |
+		       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
+		   (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
+
+	scsi_done(sc);
+
 	return true;
 }
 
@@ -1495,17 +1489,15 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
 		      " DID_NO_CONNECT\n");
 
-	if (sc->scsi_done) {
-		FNIC_TRACE(fnic_wq_copy_cleanup_handler,
-			  sc->device->host->host_no, id, sc,
-			  jiffies_to_msecs(jiffies - start_time),
-			  0, ((u64)sc->cmnd[0] << 32 |
-			  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
-			  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-			  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
+	FNIC_TRACE(fnic_wq_copy_cleanup_handler,
+		   sc->device->host->host_no, id, sc,
+		   jiffies_to_msecs(jiffies - start_time),
+		   0, ((u64)sc->cmnd[0] << 32 |
+		       (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
+		       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
+		   (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-		sc->scsi_done(sc);
-	}
+	scsi_done(sc);
 }
 
 static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
@@ -1931,16 +1923,14 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 	mempool_free(io_req, fnic->io_req_pool);
 
-	if (sc->scsi_done) {
 	/* Call SCSI completion function to complete the IO */
-		sc->result = (DID_ABORT << 16);
-		sc->scsi_done(sc);
-		atomic64_dec(&fnic_stats->io_stats.active_ios);
-		if (atomic64_read(&fnic->io_cmpl_skip))
-			atomic64_dec(&fnic->io_cmpl_skip);
-		else
-			atomic64_inc(&fnic_stats->io_stats.io_completions);
-	}
+	sc->result = (DID_ABORT << 16);
+	scsi_done(sc);
+	atomic64_dec(&fnic_stats->io_stats.active_ios);
+	if (atomic64_read(&fnic->io_cmpl_skip))
+		atomic64_dec(&fnic->io_cmpl_skip);
+	else
+		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 fnic_abort_cmd_end:
 	FNIC_TRACE(fnic_abort_cmd, sc->device->host->host_no, tag, sc,
@@ -2153,11 +2143,10 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 	 * Any IO is returned during reset, it needs to call scsi_done
 	 * to return the scsi_cmnd to upper layer.
 	 */
-	if (sc->scsi_done) {
-		/* Set result to let upper SCSI layer retry */
-		sc->result = DID_RESET << 16;
-		sc->scsi_done(sc);
-	}
+	/* Set result to let upper SCSI layer retry */
+	sc->result = DID_RESET << 16;
+	scsi_done(sc);
+
 	return true;
 }
 

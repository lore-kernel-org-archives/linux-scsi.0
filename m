Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFFBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 16:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbiFOQmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jun 2022 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbiFOQmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2022 12:42:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92444C41C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 09:42:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A928921C42;
        Wed, 15 Jun 2022 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655311329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JtVso2c2YfrsPnpkaBKgLB81I55VTuSJFvCfPnC3iq4=;
        b=e3k2WTMBIKBZSKNSgXyIf4uoxR0sJEynNisf+erU0zFrppxs3gIPKQclpWJeKaou8t0ecl
        19FS8R58yzLAmmKnyxNKkQLB+QgcpMkKxZFofMnBUbSApx8FjRU0dCGihE1Ks9opzs6svE
        Hm9AWdAWidcoEAqlJZTE5qcubpLd+3M=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C9AA139F3;
        Wed, 15 Jun 2022 16:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OIbdGOELqmKIcwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 15 Jun 2022 16:42:09 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: [PATCH 1/2] scsi: add BLIST_RETRY_SCAN to ignore errors during scanning
Date:   Wed, 15 Jun 2022 18:41:48 +0200
Message-Id: <20220615164149.3092-2-mwilck@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615164149.3092-1-mwilck@suse.com>
References: <20220615164149.3092-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

On flaky connections the INQUIRY command might run into a timeout,
but as we already have performed a REPORT LUNS command we know that
a LUN should be present. So ignore errors for the INQUIRY commands,
and retry until we exhaust the number of retries.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c    | 12 +++++++++---
 include/scsi/scsi_devinfo.h |  4 +++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a6682..b9b851ce1b72 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -649,8 +649,6 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int pass, count, result;
 	struct scsi_sense_hdr sshdr;
 
-	*bflags = 0;
-
 	/* Perform up to 3 passes.  The first pass uses a conservative
 	 * transfer length of 36 unless sdev->inquiry_len specifies a
 	 * different value. */
@@ -697,6 +695,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				    (sshdr.ascq == 0))
 					continue;
 			}
+			if (*bflags & BLIST_RETRY_SCAN) {
+				SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+						"scsi scan: retry inquiry after REPORT LUNs\n"));
+				continue;
+			}
 		} else if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
@@ -709,6 +712,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		break;
 	}
 
+	*bflags = 0;
+
 	if (result == 0) {
 		scsi_sanitize_inquiry_string(&inq_result[8], 8);
 		scsi_sanitize_inquiry_string(&inq_result[16], 16);
@@ -1531,9 +1536,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				    " allowed by the host adapter\n", lun);
 		} else {
 			int res;
+			blist_flags_t bflags = BLIST_RETRY_SCAN;
 
 			res = scsi_probe_and_add_lun(starget,
-				lun, NULL, NULL, rescan, NULL);
+				lun, &bflags, NULL, rescan, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 5d14adae21c7..e74a228d73d1 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -68,8 +68,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Retry errors during scanning */
+#define BLIST_RETRY_SCAN	((__force blist_flags_t)(1ULL << 34))
 
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_RETRY_SCAN
 
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
-- 
2.36.1


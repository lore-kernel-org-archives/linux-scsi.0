Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B711EC54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 01:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997D72080C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 01:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgD0Bsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 21:48:53 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37542 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgD0Bsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 21:48:52 -0400
Received: by mail-pj1-f66.google.com with SMTP id a7so6764196pju.2
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 18:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZYoppyqa3a1qqvomYxzLuR4sE0PGXggE4GaZWOB6nQ=;
        b=tk0xxd1RQli0mt1H0HXEdLeUjqygI6qMDCHd5NIvWLeMb/VpoA7oOx+TJEMGcoXnYg
         JzT+suRMwBw7bgdHqtjOshq4/LBmsZHdImaoHM0sxVmYrUGNxlYWtgOG0JTc4Vr1WHQZ
         qX3+DpoorN0m/6Fek/3YoQYJglB0PUoIFON/4bN9fA1+JHcEBHIOYGIL+qfQ6V5SfCBR
         IqVBENWrphifsk/BUWvMbFgOYvRxHIXjfcPFF+eR1Jxlmy9VxDFkFXBuq+CRRhwyoQXF
         NLv3ViQmM93o8YfvQauQn4NJdKPxwACtZSWCAeH4CuLrNcZ96AAcSFZktnPGlLpJkoBJ
         g1mg==
X-Gm-Message-State: AGi0PuYbbOurHX87xViwPjfZ+bM5koatk8NajvOs/oyA08kpk2mWz0yo
        5F3bYUiwLsxTcGi7ZZ4kaHo=
X-Google-Smtp-Source: APiQypIMtPGGlycn93wdB5R6V4xJwvdq1IXtElTitn/1JRCVQ6r5WDwuNl5kq4syY9Lqdxxi0JM7WA==
X-Received: by 2002:a17:902:8d8d:: with SMTP id v13mr20851746plo.67.1587952131938;
        Sun, 26 Apr 2020 18:48:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id a19sm11274707pfd.91.2020.04.26.18.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 18:48:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Merlijn Wajer <merlijn@archive.org>
Subject: [PATCH] sr: Use {get,put}_unaligned_be*() instead of open-coding these functions
Date:   Sun, 26 Apr 2020 18:48:44 -0700
Message-Id: <20200427014844.12109-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes the sr code slightly easier to read.

Cc: Merlijn Wajer <merlijn@archive.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d2fe3fa470f9..7727893238c7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -51,6 +51,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/uaccess.h>
 
+#include <asm/unaligned.h>
+
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
@@ -344,10 +346,8 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 		case ILLEGAL_REQUEST:
 			if (!(SCpnt->sense_buffer[0] & 0x90))
 				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-				(SCpnt->sense_buffer[4] << 16) |
-				(SCpnt->sense_buffer[5] << 8) |
-				SCpnt->sense_buffer[6];
+			error_sector =
+				get_unaligned_be32(&SCpnt->sense_buffer[3]);
 			if (SCpnt->request->bio != NULL)
 				block_sectors =
 					bio_sectors(SCpnt->request->bio);
@@ -495,13 +495,9 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 		SCpnt->sdb.length = this_count * s_size;
 	}
 
-	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
-	SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
-	SCpnt->cmnd[5] = (unsigned char) block & 0xff;
+	put_unaligned_be32(block, &SCpnt->cmnd[2]);
 	SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
-	SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
-	SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
+	put_unaligned_be16(this_count, &SCpnt->cmnd[7]);
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -854,8 +850,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 	} else {
 		long last_written;
 
-		cd->capacity = 1 + ((buffer[0] << 24) | (buffer[1] << 16) |
-				    (buffer[2] << 8) | buffer[3]);
+		cd->capacity = 1 + get_unaligned_be32(&buffer[0]);
 		/*
 		 * READ_CAPACITY doesn't return the correct size on
 		 * certain UDF media.  If last_written is larger, use
@@ -866,8 +861,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 		if (!cdrom_get_last_written(&cd->cdi, &last_written))
 			cd->capacity = max_t(long, cd->capacity, last_written);
 
-		sector_size = (buffer[4] << 24) |
-		    (buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
+		sector_size = get_unaligned_be32(&buffer[4]);
 		switch (sector_size) {
 			/*
 			 * HP 4020i CD-Recorder reports 2340 byte sectors
@@ -955,13 +949,13 @@ static void get_capabilities(struct scsi_cd *cd)
 	}
 
 	n = data.header_length + data.block_descriptor_length;
-	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
+	cd->cdi.speed = get_unaligned_be16(&buffer[n + 8]) / 176;
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
 	/* print some capability bits */
 	sr_printk(KERN_INFO, cd,
 		  "scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n",
-		  ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
+		  get_unaligned_be16(&buffer[n + 14]) / 176,
 		  cd->cdi.speed,
 		  buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
 		  buffer[n + 3] & 0x20 ? "dvd-ram " : "",

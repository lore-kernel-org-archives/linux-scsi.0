Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D75C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 19:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0152065F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 19:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgGWTsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 15:48:24 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52944 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgGWTsY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jul 2020 15:48:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 537B920418F;
        Thu, 23 Jul 2020 21:48:22 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id noWfMkg0ODmR; Thu, 23 Jul 2020 21:48:22 +0200 (CEST)
Received: from xtwo70.bingwo.ca (vpn.infotech.no [82.134.31.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 63AE6204164;
        Thu, 23 Jul 2020 21:48:21 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH] scsi_debug: fix request sense
Date:   Thu, 23 Jul 2020 15:48:19 -0400
Message-Id: <20200723194819.545573-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI REQUEST SENSE command emulation was found to be broken.
It is a quite complex command so try and make it do a subset of
what it should do. Remove the attempt to mimic SCSI-1 REQUEST
SENSE (i.e. return the sense data for the previous failed
command). Add some reporting of "pollable" sense data [see
spc6r02: 5.12.2]. Keep the IEC mode page MRIE=6 TEST=1
predictive failure reporting.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 64 ++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 50b29b898db8..074d58dc8b5c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1713,68 +1713,62 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return ret;
 }
 
+/* See resp_iec_m_pg() for how this data is manipulated */
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
 				   0, 0, 0x0, 0x0};
 
 static int resp_requests(struct scsi_cmnd *scp,
 			 struct sdebug_dev_info *devip)
 {
-	unsigned char *sbuff;
 	unsigned char *cmd = scp->cmnd;
-	unsigned char arr[SCSI_SENSE_BUFFERSIZE];
-	bool dsense;
+	unsigned char arr[SCSI_SENSE_BUFFERSIZE];	/* assume >= 18 bytes */
+	bool dsense = !!(cmd[1] & 1);
+	int alloc_len = cmd[4];
 	int len = 18;
+	int stopped_state = atomic_read(&devip->stopped);
 
 	memset(arr, 0, sizeof(arr));
-	dsense = !!(cmd[1] & 1);
-	sbuff = scp->sense_buffer;
-	if ((iec_m_pg[2] & 0x4) && (6 == (iec_m_pg[3] & 0xf))) {
+	if (stopped_state > 0) {	/* some "pollable" data [spc6r02: 5.12.2] */
+		if (dsense) {
+			arr[0] = 0x72;
+			arr[1] = NOT_READY;
+			arr[2] = LOGICAL_UNIT_NOT_READY;
+			arr[3] = (stopped_state == 2) ? 0x1 : 0x2;
+			len = 8;
+		} else {
+			arr[0] = 0x70;
+			arr[2] = NOT_READY;		/* NO_SENSE in sense_key */
+			arr[7] = 0xa;			/* 18 byte sense buffer */
+			arr[12] = LOGICAL_UNIT_NOT_READY;
+			arr[13] = (stopped_state == 2) ? 0x1 : 0x2;
+		}
+	} else if ((iec_m_pg[2] & 0x4) && (6 == (iec_m_pg[3] & 0xf))) {
+		/* Information exceptions control mode page: TEST=1, MRIE=6 */
 		if (dsense) {
 			arr[0] = 0x72;
 			arr[1] = 0x0;		/* NO_SENSE in sense_key */
 			arr[2] = THRESHOLD_EXCEEDED;
-			arr[3] = 0xff;		/* TEST set and MRIE==6 */
+			arr[3] = 0xff;		/* Failure prediction(false) */
 			len = 8;
 		} else {
 			arr[0] = 0x70;
 			arr[2] = 0x0;		/* NO_SENSE in sense_key */
 			arr[7] = 0xa;   	/* 18 byte sense buffer */
 			arr[12] = THRESHOLD_EXCEEDED;
-			arr[13] = 0xff;		/* TEST set and MRIE==6 */
+			arr[13] = 0xff;		/* Failure prediction(false) */
 		}
-	} else {
-		memcpy(arr, sbuff, SCSI_SENSE_BUFFERSIZE);
-		if (arr[0] >= 0x70 && dsense == sdebug_dsense)
-			;	/* have sense and formats match */
-		else if (arr[0] <= 0x70) {
-			if (dsense) {
-				memset(arr, 0, 8);
-				arr[0] = 0x72;
-				len = 8;
-			} else {
-				memset(arr, 0, 18);
-				arr[0] = 0x70;
-				arr[7] = 0xa;
-			}
-		} else if (dsense) {
-			memset(arr, 0, 8);
-			arr[0] = 0x72;
-			arr[1] = sbuff[2];     /* sense key */
-			arr[2] = sbuff[12];    /* asc */
-			arr[3] = sbuff[13];    /* ascq */
+	} else {	/* nothing to report */
+		if (dsense) {
 			len = 8;
+			memset(arr, 0, len);
+			arr[0] = 0x72;
 		} else {
-			memset(arr, 0, 18);
+			memset(arr, 0, len);
 			arr[0] = 0x70;
-			arr[2] = sbuff[1];
 			arr[7] = 0xa;
-			arr[12] = sbuff[1];
-			arr[13] = sbuff[3];
 		}
-
 	}
-	mk_sense_buffer(scp, 0, NO_ADDITIONAL_SENSE, 0);
-	return fill_from_dev_buffer(scp, arr, len);
+	return fill_from_dev_buffer(scp, arr, min_t(int, len, alloc_len));
 }
 
 static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
-- 
2.25.1


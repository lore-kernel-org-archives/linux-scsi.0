Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E227ECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 09:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA23222BD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 09:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392688AbfJRJyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 05:54:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36070 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389081AbfJRJyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 05:54:51 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3CB61583F1D06A7CB9FE;
        Fri, 18 Oct 2019 17:54:48 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 17:54:39 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <yanaijie@huawei.com>
Subject: [PATCH] scsi: sd: fix uninit access of sshdr
Date:   Fri, 18 Oct 2019 18:01:50 +0800
Message-ID: <1571392910-137272-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Like sd_pr_command, before use sshdr, we need to check the result of
scsi_execute and whether sshdr is valid.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/sd.c | 57 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 32d9517..2041755 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -166,7 +166,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
-	int len;
+	int len, the_result;

 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
@@ -213,9 +213,12 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	 */
 	data.device_specific = 0;

-	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
-			     SD_MAX_RETRIES, &data, &sshdr)) {
-		if (scsi_sense_valid(&sshdr))
+	the_result = scsi_mode_select(sdp, 1, sp, 8, buffer_data, len,
+				      SD_TIMEOUT, SD_MAX_RETRIES, &data,
+				      &sshdr);
+	if (the_result) {
+		if (driver_byte(the_result) == DRIVER_SENSE &&
+		    scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
@@ -1648,16 +1651,20 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);

-		if (driver_byte(res) == DRIVER_SENSE)
+		/* we need to evaluate the error return  */
+		if (driver_byte(res) == DRIVER_SENSE &&
+		    scsi_sense_valid(sshdr)) {
 			sd_print_sense_hdr(sdkp, sshdr);

-		/* we need to evaluate the error return  */
-		if (scsi_sense_valid(sshdr) &&
-			(sshdr->asc == 0x3a ||	/* medium not present */
-			 sshdr->asc == 0x20 ||	/* invalid command */
-			 (sshdr->asc == 0x74 && sshdr->ascq == 0x71)))	/* drive is password locked */
+			/* medium not present */
+			if (sshdr->asc == 0x3a ||
+			    /* invalid command */
+			    sshdr->asc == 0x20 ||
+			    /* drive is password locked */
+			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))
 				/* this is no error here */
 				return 0;
+		}

 		switch (host_byte(res)) {
 		/* ignore errors due to racing a disconnection */
@@ -2100,10 +2107,11 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * doesn't have any media in it, don't bother
 			 * with any more polling.
 			 */
-			if (media_not_present(sdkp, &sshdr))
+			if (driver_byte(the_result) == DRIVER_SENSE &&
+			    media_not_present(sdkp, &sshdr))
 				return;

-			if (the_result)
+			if (driver_byte(the_result) == DRIVER_SENSE)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
 		} while (retries < 3 &&
@@ -2177,7 +2185,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * probably pointless to loop */
 			if(!spintime) {
 				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
-				sd_print_sense_hdr(sdkp, &sshdr);
+				if (sense_valid)
+					sd_print_sense_hdr(sdkp, &sshdr);
 			}
 			break;
 		}
@@ -2237,7 +2246,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
 {
-	if (driver_byte(the_result) == DRIVER_SENSE)
+	if (driver_byte(the_result) == DRIVER_SENSE && sense_valid)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
 		sd_printk(KERN_NOTICE, sdkp, "Sense not available.\n");
@@ -2291,10 +2300,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 					buffer, RC16_LEN, &sshdr,
 					SD_TIMEOUT, SD_MAX_RETRIES, NULL);

-		if (media_not_present(sdkp, &sshdr))
+		if (driver_byte(the_result) == DRIVER_SENSE &&
+		    media_not_present(sdkp, &sshdr))
 			return -ENODEV;

-		if (the_result) {
+		if (driver_byte(the_result) == DRIVER_SENSE) {
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
@@ -2376,10 +2386,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 					buffer, 8, &sshdr,
 					SD_TIMEOUT, SD_MAX_RETRIES, NULL);

-		if (media_not_present(sdkp, &sshdr))
+		if (driver_byte(the_result) == DRIVER_SENSE
+		    && media_not_present(sdkp, &sshdr))
 			return -ENODEV;

-		if (the_result) {
+		if (driver_byte(the_result) == DRIVER_SENSE) {
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == UNIT_ATTENTION &&
@@ -3504,12 +3515,14 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			SD_TIMEOUT, SD_MAX_RETRIES, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (driver_byte(res) == DRIVER_SENSE)
+		if (driver_byte(res) == DRIVER_SENSE &&
+		    scsi_sense_valid(&sshdr)) {
 			sd_print_sense_hdr(sdkp, &sshdr);
-		if (scsi_sense_valid(&sshdr) &&
+
 			/* 0x3a is medium not present */
-			sshdr.asc == 0x3a)
-			res = 0;
+			if (sshdr.asc == 0x3a)
+				res = 0;
+		}
 	}

 	/* SCSI error codes must not go to the generic layer */
--
2.7.4


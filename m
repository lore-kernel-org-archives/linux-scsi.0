Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBAAC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B5A46100B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhD0Ibx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:31:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:49170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235088AbhD0Ibt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:31:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1622BB011;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/40] scsi: reshuffle response handling in scsi_mode_sense()
Date:   Tue, 27 Apr 2021 10:30:10 +0200
Message-Id: <20210427083046.31620-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reshuffle response handling in scsi_mode_sense() to make the code
easier to follow.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 75 ++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ca9dbfa42cb7..ba54b1ba5edb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2190,54 +2190,53 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	 * byte as the problem.  MODE_SENSE commands can return
 	 * ILLEGAL REQUEST if the code page isn't supported */
 
-	if (use_10_for_ms && !scsi_status_is_good(result) &&
-	    driver_byte(result) == DRIVER_SENSE) {
-		if (scsi_sense_valid(sshdr)) {
+	if (!scsi_status_is_good(result)) {
+		if (driver_byte(result) == DRIVER_SENSE &&
+		    scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
 				/*
 				 * Invalid command operation code
 				 */
-				sdev->use_10_for_ms = 0;
+				if (use_10_for_ms) {
+					sdev->use_10_for_ms = 0;
+					goto retry;
+				}
+			}
+			if ((status_byte(result) == CHECK_CONDITION) &&
+			    sshdr->sense_key == UNIT_ATTENTION &&
+			    retry_count) {
+				retry_count--;
 				goto retry;
 			}
 		}
+		return -EIO;
+	}
+	if (unlikely(buffer[0] == 0x86 && buffer[1] == 0x0b &&
+		     (modepage == 6 || modepage == 8))) {
+		/* Initio breakage? */
+		header_length = 0;
+		data->length = 13;
+		data->medium_type = 0;
+		data->device_specific = 0;
+		data->longlba = 0;
+		data->block_descriptor_length = 0;
+	} else if (use_10_for_ms) {
+		data->length = buffer[0]*256 + buffer[1] + 2;
+		data->medium_type = buffer[2];
+		data->device_specific = buffer[3];
+		data->longlba = buffer[4] & 0x01;
+		data->block_descriptor_length = buffer[6]*256
+			+ buffer[7];
+	} else {
+		data->length = buffer[0] + 1;
+		data->medium_type = buffer[1];
+		data->device_specific = buffer[2];
+		data->block_descriptor_length = buffer[3];
 	}
+	data->header_length = header_length;
 
-	if (scsi_status_is_good(result)) {
-		if (unlikely(buffer[0] == 0x86 && buffer[1] == 0x0b &&
-			     (modepage == 6 || modepage == 8))) {
-			/* Initio breakage? */
-			header_length = 0;
-			data->length = 13;
-			data->medium_type = 0;
-			data->device_specific = 0;
-			data->longlba = 0;
-			data->block_descriptor_length = 0;
-		} else if (use_10_for_ms) {
-			data->length = buffer[0]*256 + buffer[1] + 2;
-			data->medium_type = buffer[2];
-			data->device_specific = buffer[3];
-			data->longlba = buffer[4] & 0x01;
-			data->block_descriptor_length = buffer[6]*256
-				+ buffer[7];
-		} else {
-			data->length = buffer[0] + 1;
-			data->medium_type = buffer[1];
-			data->device_specific = buffer[2];
-			data->block_descriptor_length = buffer[3];
-		}
-		data->header_length = header_length;
-		result = 0;
-	} else if ((status_byte(result) == CHECK_CONDITION) &&
-		   scsi_sense_valid(sshdr) &&
-		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
-		retry_count--;
-		goto retry;
-	}
-	if (result > 0)
-		result = -EIO;
-	return result;
+	return 0;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
 
-- 
2.29.2


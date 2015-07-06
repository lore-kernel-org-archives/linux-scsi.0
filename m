From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] sd: retry READ CAPACITY for ALUA state transition
Date: Mon,  6 Jul 2015 13:12:10 +0200
Message-ID: <1436181130-82905-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbbGFLMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 07:12:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

During ALUA state transitions the device might return
a sense code 02/04/0a (Logical unit not accessible, asymmetric
access state transition). As this is a transient error
we should just retry the READ CAPACITY call after 1 second
until the state transition finishes and the correct
capacity can be returned.
At the same time we should break out of the loop after
2 minutes to avoid unbounded retries.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4..f45b8fe 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1934,6 +1934,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 #endif
 
 #define READ_CAPACITY_RETRIES_ON_RESET	10
+#define READ_CAPACITY_RETRIES_ON_TRANSITION 120
 
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
@@ -1943,6 +1944,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
+	int transition_retries = READ_CAPACITY_RETRIES_ON_TRANSITION;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
@@ -1981,6 +1983,15 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A) {
+				/* ALUA state transition; retry after delay */
+				if (--transition_retries > 0) {
+					msleep(1000);
+					continue;
+				}
+			}
 		}
 		retries--;
 
@@ -2039,6 +2050,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
+	int transition_retries = READ_CAPACITY_RETRIES_ON_TRANSITION;
 	sector_t lba;
 	unsigned sector_size;
 
@@ -2063,6 +2075,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A) {
+				/* ALUA state transition; retry after delay */
+				if (--transition_retries > 0) {
+					msleep(1000);
+					continue;
+				}
+			}
 		}
 		retries--;
 
-- 
1.8.5.2


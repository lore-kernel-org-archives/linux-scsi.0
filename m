From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: always retry READ CAPACITY for ALUA state transition
Date: Tue, 17 Oct 2017 09:11:16 +0200
Message-ID: <1508224276-130348-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932521AbdJQHLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 03:11:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

During ALUA state transitions the device might return
a sense code 02/04/0a (Logical unit not accessible, asymmetric
access state transition). As this is a transient error
we should just retry the READ CAPACITY call until
the state transition finishes and the correct
capacity can be returned.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37daf9a..b4647f5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2333,6 +2333,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A)
+				/* ALUA state transition; always retry */
+				continue;
 		}
 		retries--;
 
@@ -2418,6 +2423,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A)
+				/* ALUA state transition; always retry */
+				continue;
 		}
 		retries--;
 
-- 
1.8.5.6

From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: always retry READ CAPACITY for ALUA state transition
Date: Mon, 27 Apr 2015 11:35:09 +0200
Message-ID: <1430127309-90412-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbbD0JfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2015 05:35:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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
index 79beebf..7178b05 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1987,6 +1987,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
 
@@ -2069,6 +2074,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
1.8.5.2


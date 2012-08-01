From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 3/3] sd: error handling synchronizing caches
Date: Wed,  1 Aug 2012 16:44:10 +0200
Message-ID: <1343832250-24228-4-git-send-email-oliver@neukum.org>
References: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:50451 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2HAPAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 11:00:02 -0400
In-Reply-To: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oneukum@suse.de>

sd_sync_cache() can fail in several manners.
As the error return is passed to the generic layer,
it must be correctly processed.

Failures due to unplugged devices or removed media
should be ignored. In the other cases retryable and
fatal errors must be differentiated.

This fixes a problem with unplugging eSATA devices
before suspending the system.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a344220..49b0c52 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1278,8 +1278,32 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 	if (res) {
 		sd_print_result(sdkp, res);
+
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
+			/* we need to evaluate the error return  */
+			if ((scsi_sense_valid(&sshdr) &&
+				/* 0x3a is medium not present */
+				sshdr.asc == 0x3a))
+					/* this is no error here */
+					return 0;
+
+			switch (host_byte(res)) {
+			/* ignore errors due to racing a disconnection */
+			case DID_BAD_TARGET:
+			case DID_NO_CONNECT:
+				return 0;
+			/* signal the upper layer it might try again */
+			case DID_BUS_BUSY:
+			case DID_IMM_RETRY:
+			case DID_REQUEUE:
+			case DID_SOFT_ERROR:
+				return -EBUSY;
+			default:
+				return -EIO;
+		}
+	} else {
+		return 0;
 	}
 
 	if (res)
-- 
1.7.7


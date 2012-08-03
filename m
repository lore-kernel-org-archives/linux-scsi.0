From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 4/5] scsi: translate errors for power management
Date: Fri,  3 Aug 2012 14:27:40 +0200
Message-ID: <1343996861-20857-5-git-send-email-oliver@neukum.org>
References: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:53943 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2HCM2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 08:28:52 -0400
In-Reply-To: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oneukum@suse.de>

Synchronizing caches may fail. The reason for these
failures need to be translated to the generic layer
so that it nows whether to ignore a failure, retry later
or give up, aborting sleep.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_error.c |   32 ++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c         |    3 +--
 include/scsi/scsi_eh.h    |    1 +
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4a6381c..195cc75 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2217,3 +2217,35 @@ void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
 	}
 }
 EXPORT_SYMBOL(scsi_build_sense_buffer);
+
+/**
+ * scsi_translate_errors_to_power_management - errors in a form driver core understands
+ * @res:	Result of scsi command
+ *
+ * Return value:
+ * 	error code driver core understands
+ **/
+int scsi_translate_errors_to_power_management(int res)
+{
+	switch (host_byte(res)) {
+	/* ignore errors due to racing a disconnection */
+	case DID_BAD_TARGET:
+	case DID_NO_CONNECT:
+		return 0;
+	/* signal the upper layer it might try again */
+	case DID_BUS_BUSY:
+	case DID_IMM_RETRY:
+	case DID_REQUEUE:
+	case DID_SOFT_ERROR:
+	case DID_TIME_OUT:
+	case DID_ABORT:
+	case DID_RESET:
+	case DID_TRANSPORT_DISRUPTED:
+		return -EBUSY;
+	case DID_OK:
+		return 0;
+	default:
+		return -EIO;
+	}
+}
+EXPORT_SYMBOL(scsi_translate_errors_to_power_management);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c39a97e..8597294 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1288,10 +1288,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 */
 		if ((scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a))
 			return 0;
+		return scsi_translate_errors_to_power_management(res);
 	}
 
-	if (res)
-		return -EIO;
 	return 0;
 }
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..bdf6d6c 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -59,6 +59,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 				   u64 * info_out);
 
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
+extern int scsi_translate_errors_to_power_management(int res);
 
 /*
  * Reset request from external source
-- 
1.7.7


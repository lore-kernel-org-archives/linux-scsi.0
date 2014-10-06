From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/26] scsi: use 'bool' as return value for scsi_normalize_sense()
Date: Mon,  6 Oct 2014 11:01:12 +0200
Message-ID: <1412586086-129821-13-git-send-email-hare@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaJFJBc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 05:01:32 -0400
In-Reply-To: <1412586086-129821-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Convert scsi_normalize_sense() and frieds to return 'bool'
instead of an integer.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 16 ++++++++--------
 drivers/scsi/scsi_lib.c   |  2 +-
 include/scsi/scsi_eh.h    | 14 +++++++-------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6c99624..a113e99 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2408,20 +2408,20 @@ EXPORT_SYMBOL(scsi_reset_provider);
  *	responded to a SCSI command with the CHECK_CONDITION status.
  *
  * Return value:
- *	1 if valid sense data information found, else 0;
+ *	true if valid sense data information found, else false;
  */
-int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
-                         struct scsi_sense_hdr *sshdr)
+bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+			  struct scsi_sense_hdr *sshdr)
 {
 	if (!sense_buffer || !sb_len)
-		return 0;
+		return false;
 
 	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
 
 	sshdr->response_code = (sense_buffer[0] & 0x7f);
 
 	if (!scsi_sense_valid(sshdr))
-		return 0;
+		return false;
 
 	if (sshdr->response_code >= 0x72) {
 		/*
@@ -2451,12 +2451,12 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		}
 	}
 
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(scsi_normalize_sense);
 
-int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
-				 struct scsi_sense_hdr *sshdr)
+bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
+				  struct scsi_sense_hdr *sshdr)
 {
 	return scsi_normalize_sense(cmd->sense_buffer,
 			SCSI_SENSE_BUFFERSIZE, sshdr);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c3220b7..b853659 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -830,7 +830,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	struct request *req = cmd->request;
 	int error = 0;
 	struct scsi_sense_hdr sshdr;
-	int sense_valid = 0;
+	bool sense_valid = false;
 	int sense_deferred = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 3d720ca..1d3c254 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -27,10 +27,10 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 additional_length;	/* always 0 for fixed sense format */
 };
 
-static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
+static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
 {
 	if (!sshdr)
-		return 0;
+		return false;
 
 	return (sshdr->response_code & 0x70) == 0x70;
 }
@@ -42,12 +42,12 @@ extern void scsi_eh_flush_done_q(struct list_head *done_q);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
-extern int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
-		struct scsi_sense_hdr *sshdr);
-extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
-		struct scsi_sense_hdr *sshdr);
+extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+				 struct scsi_sense_hdr *sshdr);
+extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
+					 struct scsi_sense_hdr *sshdr);
 
-static inline int scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
+static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
 	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
 }
-- 
1.8.5.2


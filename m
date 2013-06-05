From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi: Document enhanced error codes
Date: Wed,  5 Jun 2013 09:10:59 +0200
Message-ID: <1370416261-57005-2-git-send-email-hare@suse.de>
References: <1370416261-57005-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3FEHLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jun 2013 03:11:05 -0400
In-Reply-To: <1370416261-57005-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Document the various error codes returned on I/O failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c |  7 +++++--
 drivers/scsi/scsi_lib.c   | 11 +++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f43de1e..443b0e3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -229,8 +229,11 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
  *
- * Return value:
- *	SUCCESS or FAILED or NEEDS_RETRY or TARGET_ERROR
+ * Possible return values:
+ *	SUCCESS
+ *	FAILED
+ *	NEEDS_RETRY
+ *	TARGET_ERROR
  *
  * Notes:
  *	When a deferred error is detected the current command has
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 86d5220..12bfa73 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -700,6 +700,17 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
+/**
+ * __scsi_error_from_host_byte - translate SCSI error code into errno
+ * @cmd:	SCSI command (unused)
+ * @result:	scsi error code
+ *
+ * Translate SCSI error code into standard UNIX errno.
+ * Return values:
+ * -ENOLINK	temporary transport failure
+ * -EREMOTEIO	permanent target failure, do not retry
+ * -EBADE	permanent nexus failure, retry on other path
+ */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 {
 	int error = 0;
-- 
1.7.12.4


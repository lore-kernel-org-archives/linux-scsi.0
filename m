From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi: Document enhanced error codes
Date: Mon,  1 Jul 2013 15:16:23 +0200
Message-ID: <1372684586-41829-2-git-send-email-hare@suse.de>
References: <1372684586-41829-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1372684586-41829-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Document the various error codes returned on I/O failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 86d5220..d3fc50f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -700,6 +700,18 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
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
+ * -EIO		unspecified I/O error
+ */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 {
 	int error = 0;
-- 
1.7.12.4


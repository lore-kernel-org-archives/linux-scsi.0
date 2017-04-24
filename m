From: damien.lemoal@wdc.com
Subject: [PATCH v2 4/7] scsi: Improve scsi_get_sense_info_fld
Date: Mon, 24 Apr 2017 16:51:12 +0900
Message-ID: <20170424075115.30337-5-damien.lemoal@wdc.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8132 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166215AbdDXHvj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 03:51:39 -0400
In-Reply-To: <20170424075115.30337-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

Use get_unaligned_be32 and get_unaligned_be64 to obtain values from
the sense buffer instead of open coding the operations.
Also change the function return value to a bool and fix the function
signature declaration to remove spaces triggering checkpatch warnings.

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 drivers/scsi/scsi_error.c | 38 +++++++++++++++-----------------------
 include/scsi/scsi_eh.h    |  4 ++--
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 53e3343..d70c67c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -46,6 +46,8 @@
 
 #include <trace/events/scsi.h>
 
+#include <asm/unaligned.h>
+
 static void scsi_eh_done(struct scsi_cmnd *scmd);
 
 /*
@@ -2361,44 +2363,34 @@ EXPORT_SYMBOL(scsi_command_normalize_sense);
  *			field will be placed if found.
  *
  * Return value:
- *	1 if information field found, 0 if not found.
+ *	true if information field found, false if not found.
  */
-int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
-			    u64 * info_out)
+bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
+			     u64 *info_out)
 {
-	int j;
 	const u8 * ucp;
-	u64 ull;
 
 	if (sb_len < 7)
-		return 0;
+		return false;
 	switch (sense_buffer[0] & 0x7f) {
 	case 0x70:
 	case 0x71:
 		if (sense_buffer[0] & 0x80) {
-			*info_out = (sense_buffer[3] << 24) +
-				    (sense_buffer[4] << 16) +
-				    (sense_buffer[5] << 8) + sense_buffer[6];
-			return 1;
-		} else
-			return 0;
+			*info_out = get_unaligned_be32(&sense_buffer[3]);
+			return true;
+		}
+		return false;
 	case 0x72:
 	case 0x73:
 		ucp = scsi_sense_desc_find(sense_buffer, sb_len,
 					   0 /* info desc */);
 		if (ucp && (0xa == ucp[1])) {
-			ull = 0;
-			for (j = 0; j < 8; ++j) {
-				if (j > 0)
-					ull <<= 8;
-				ull |= ucp[4 + j];
-			}
-			*info_out = ull;
-			return 1;
-		} else
-			return 0;
+			*info_out = get_unaligned_be64(&ucp[4]);
+			return true;
+		}
+		return false;
 	default:
-		return 0;
+		return false;
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index a25b328..64d30d8 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -23,8 +23,8 @@ static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
 }
 
-extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
-				   u64 * info_out);
+extern bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
+				    u64 *info_out);
 
 extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
-- 
2.9.3

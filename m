From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 12 of 16] SCSI host driver DIF helpers
Date: Fri, 25 Apr 2008 19:12:14 -0400
Message-ID: <5262eba570f472b4d517.1209165134@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44319 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbYDYXR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:29 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1 file changed, 23 insertions(+)
include/scsi/sd.h |   23 +++++++++++++++++++++++


HBA drivers need to poke in the CDB to prepare DIF commands.  Provide
helpers for extracting {RD,WR}PROTECT and start LBA.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r b512cd02f8b0 -r 5262eba570f4 include/scsi/sd.h
--- a/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
@@ -1,5 +1,7 @@
 #ifndef _SCSI_DISK_H
 #define _SCSI_DISK_H
+
+#include <scsi/scsi_cmnd.h>
 
 /*
  * More than enough for everybody ;)  The huge number of majors
@@ -61,4 +63,25 @@
 		    (sdsk)->disk->disk_name, ##a) :			\
 	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
 
+static inline unsigned int sd_protect_field(struct scsi_cmnd *scmd)
+{
+	switch(scmd->cmnd[0]) {
+	case READ_10:
+	case READ_12:
+	case READ_16:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+		return (scmd->cmnd[1] & 0xe0) >> 5;
+
+	default:
+		return -1;
+	}
+}
+
+static inline sector_t sd_start_lba(struct scsi_cmnd *scmd)
+{
+	return scmd->request->sector;
+}
+
 #endif /* _SCSI_DISK_H */



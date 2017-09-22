From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 3/5] scsi_devinfo: Reformat blacklist flags
Date: Fri, 22 Sep 2017 08:04:45 +0200
Message-ID: <1506060287-87031-4-git-send-email-hare@suse.de>
References: <1506060287-87031-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42565 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751798AbdIVGFB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Sep 2017 02:05:01 -0400
In-Reply-To: <1506060287-87031-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Reformat blacklist flags to make the values easier to read and
to enhance error checking.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart van Assche <bart.vanassche@wdc.com>
---
 include/scsi/scsi_devinfo.h | 76 +++++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 26 deletions(-)

diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 9592570e092a..7a2329c026a4 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -3,31 +3,55 @@
 /*
  * Flags for SCSI devices that need special treatment
  */
-#define BLIST_NOLUN     	0x001	/* Only scan LUN 0 */
-#define BLIST_FORCELUN  	0x002	/* Known to have LUNs, force scanning,
-					   deprecated: Use max_luns=N */
-#define BLIST_BORKEN    	0x004	/* Flag for broken handshaking */
-#define BLIST_KEY       	0x008	/* unlock by special command */
-#define BLIST_SINGLELUN 	0x010	/* Do not use LUNs in parallel */
-#define BLIST_NOTQ		0x020	/* Buggy Tagged Command Queuing */
-#define BLIST_SPARSELUN 	0x040	/* Non consecutive LUN numbering */
-#define BLIST_MAX5LUN		0x080	/* Avoid LUNS >= 5 */
-#define BLIST_ISROM     	0x100	/* Treat as (removable) CD-ROM */
-#define BLIST_LARGELUN		0x200	/* LUNs past 7 on a SCSI-2 device */
-#define BLIST_INQUIRY_36	0x400	/* override additional length field */
-#define BLIST_NOSTARTONADD	0x1000	/* do not do automatic start on add */
-#define BLIST_REPORTLUN2	0x20000	/* try REPORT_LUNS even for SCSI-2 devs
- 					   (if HBA supports more than 8 LUNs) */
-#define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
-#define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
-#define BLIST_NO_ULD_ATTACH	0x100000 /* device is actually for RAID config */
-#define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
-#define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
-#define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
-#define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
-#define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
-#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
-#define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
-#define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
+
+/* Only scan LUN 0 */
+#define BLIST_NOLUN		((__force __u32 __bitwise)(1 << 0))
+/* Known to have LUNs, force scanning.
+ * DEPRECATED: Use max_luns=N */
+#define BLIST_FORCELUN		((__force __u32 __bitwise)(1 << 1))
+/* Flag for broken handshaking */
+#define BLIST_BORKEN		((__force __u32 __bitwise)(1 << 2))
+/* unlock by special command */
+#define BLIST_KEY		((__force __u32 __bitwise)(1 << 3))
+/* Do not use LUNs in parallel */
+#define BLIST_SINGLELUN		((__force __u32 __bitwise)(1 << 4))
+/* Buggy Tagged Command Queuing */
+#define BLIST_NOTQ		((__force __u32 __bitwise)(1 << 5))
+/* Non consecutive LUN numbering */
+#define BLIST_SPARSELUN		((__force __u32 __bitwise)(1 << 6))
+/* Avoid LUNS >= 5 */
+#define BLIST_MAX5LUN		((__force __u32 __bitwise)(1 << 7))
+/* Treat as (removable) CD-ROM */
+#define BLIST_ISROM		((__force __u32 __bitwise)(1 << 8))
+/* LUNs past 7 on a SCSI-2 device */
+#define BLIST_LARGELUN		((__force __u32 __bitwise)(1 << 9))
+/* override additional length field */
+#define BLIST_INQUIRY_36	((__force __u32 __bitwise)(1 << 10))
+/* do not do automatic start on add */
+#define BLIST_NOSTARTONADD	((__force __u32 __bitwise)(1 << 12))
+/* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
+#define BLIST_REPORTLUN2	((__force __u32 __bitwise)(1 << 17))
+/* don't try REPORT_LUNS scan (SCSI-3 devs) */
+#define BLIST_NOREPORTLUN	((__force __u32 __bitwise)(1 << 18))
+/* don't use PREVENT-ALLOW commands */
+#define BLIST_NOT_LOCKABLE	((__force __u32 __bitwise)(1 << 19))
+/* device is actually for RAID config */
+#define BLIST_NO_ULD_ATTACH	((__force __u32 __bitwise)(1 << 20))
+/* select without ATN */
+#define BLIST_SELECT_NO_ATN	((__force __u32 __bitwise)(1 << 21))
+/* retry HARDWARE_ERROR */
+#define BLIST_RETRY_HWERROR	((__force __u32 __bitwise)(1 << 22))
+/* maximum 512 sector cdb length */
+#define BLIST_MAX_512		((__force __u32 __bitwise)(1 << 23))
+/* Disable T10 PI (DIF) */
+#define BLIST_NO_DIF		((__force __u32 __bitwise)(1 << 25))
+/* Ignore SBC-3 VPD pages */
+#define BLIST_SKIP_VPD_PAGES	((__force __u32 __bitwise)(1 << 26))
+/* Attempt to read VPD pages */
+#define BLIST_TRY_VPD_PAGES	((__force __u32 __bitwise)(1 << 28))
+/* don't try to issue RSOC */
+#define BLIST_NO_RSOC		((__force __u32 __bitwise)(1 << 29))
+/* maximum 1024 sector cdb length */
+#define BLIST_MAX_1024		((__force __u32 __bitwise)(1 << 30))
 
 #endif
-- 
2.12.3

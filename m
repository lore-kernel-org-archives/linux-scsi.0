From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 3/5] scsi_devinfo: Reformat blacklist flags
Date: Fri, 11 Aug 2017 16:23:19 +0200
Message-ID: <1502461401-94630-4-git-send-email-hare@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34115 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753268AbdHKOXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 10:23:25 -0400
In-Reply-To: <1502461401-94630-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Reformat blacklist flags to make the values easier to read and
to enhance error checking.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/scsi/scsi_devinfo.h | 77 ++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 9592570..25b9603 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -3,31 +3,56 @@
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
+typedef __u32 __bitwise sdev_bflags_t;
+
+/* Only scan LUN 0 */
+#define BLIST_NOLUN		((__force sdev_bflags_t)(1 << 0))
+/* Known to have LUNs, force scanning.
+ * DEPRECATED: Use max_luns=N */
+#define BLIST_FORCELUN		((__force sdev_bflags_t)(1 << 1))
+/* Flag for broken handshaking */
+#define BLIST_BORKEN		((__force sdev_bflags_t)(1 << 2))
+/* unlock by special command */
+#define BLIST_KEY		((__force sdev_bflags_t)(1 << 3))
+/* Do not use LUNs in parallel */
+#define BLIST_SINGLELUN		((__force sdev_bflags_t)(1 << 4))
+/* Buggy Tagged Command Queuing */
+#define BLIST_NOTQ		((__force sdev_bflags_t)(1 << 5))
+/* Non consecutive LUN numbering */
+#define BLIST_SPARSELUN		((__force sdev_bflags_t)(1 << 6))
+/* Avoid LUNS >= 5 */
+#define BLIST_MAX5LUN		((__force sdev_bflags_t)(1 << 7))
+/* Treat as (removable) CD-ROM */
+#define BLIST_ISROM		((__force sdev_bflags_t)(1 << 8))
+/* LUNs past 7 on a SCSI-2 device */
+#define BLIST_LARGELUN		((__force sdev_bflags_t)(1 << 9))
+/* override additional length field */
+#define BLIST_INQUIRY_36	((__force sdev_bflags_t)(1 << 10))
+/* do not do automatic start on add */
+#define BLIST_NOSTARTONADD	((__force sdev_bflags_t)(1 << 12))
+/* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
+#define BLIST_REPORTLUN2	((__force sdev_bflags_t)(1 << 17))
+/* don't try REPORT_LUNS scan (SCSI-3 devs) */
+#define BLIST_NOREPORTLUN	((__force sdev_bflags_t)(1 << 18))
+/* don't use PREVENT-ALLOW commands */
+#define BLIST_NOT_LOCKABLE	((__force sdev_bflags_t)(1 << 19))
+/* device is actually for RAID config */
+#define BLIST_NO_ULD_ATTACH	((__force sdev_bflags_t)(1 << 20))
+/* select without ATN */
+#define BLIST_SELECT_NO_ATN	((__force sdev_bflags_t)(1 << 21))
+/* retry HARDWARE_ERROR */
+#define BLIST_RETRY_HWERROR	((__force sdev_bflags_t)(1 << 22))
+/* maximum 512 sector cdb length */
+#define BLIST_MAX_512		((__force sdev_bflags_t)(1 << 23))
+/* Disable T10 PI (DIF) */
+#define BLIST_NO_DIF		((__force sdev_bflags_t)(1 << 25))
+/* Ignore SBC-3 VPD pages */
+#define BLIST_SKIP_VPD_PAGES	((__force sdev_bflags_t)(1 << 26))
+/* Attempt to read VPD pages */
+#define BLIST_TRY_VPD_PAGES	((__force sdev_bflags_t)(1 << 28))
+/* don't try to issue RSOC */
+#define BLIST_NO_RSOC		((__force sdev_bflags_t)(1 << 29))
+/* maximum 1024 sector cdb length */
+#define BLIST_MAX_1024		((__force sdev_bflags_t)(1 << 30))
 
 #endif
-- 
1.8.5.6

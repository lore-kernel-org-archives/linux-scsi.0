From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 5/6] scsi: devinfo: add BLIST_RETRY_ITF for EMC Symmetrix
Date: Wed, 18 Apr 2018 01:35:10 +0200
Message-ID: <20180417233511.6573-6-mwilck@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Janusz Dziemidowicz <rraptorr@nails.eu.org>, James Bottomley <JBottomley@Odin.com>, Kurt Garloff <garloff@suse.de>
List-Id: linux-scsi@vger.kernel.org

EMC Symmetrix returns 'internal target error' for a variety
of conditions, most of which will be transient.
So we should always retry it, even with failfast set.
Otherwise we'd get spurious path flaps with multipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 3 ++-
 drivers/scsi/scsi_error.c   | 4 ++++
 include/scsi/scsi_devinfo.h | 4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c05843a..f7b94c1 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -161,7 +161,8 @@ static struct {
 	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, storage on LUN 0 */
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, no storage on LUN 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_REPORTLUN2},
+	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
+	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ac3b1c3..1dee91f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -38,6 +38,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/sg.h>
 
 #include "scsi_priv.h"
@@ -524,6 +525,9 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SUCCESS;
 
+		if (sshdr.asc == 0x44 && sdev->sdev_bflags & BLIST_RETRY_ITF)
+			return ADD_TO_MLQUEUE;
+
 		return NEEDS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 3434e14..91a327e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -63,8 +63,10 @@
 #define BLIST_MAX_1024		((__force blist_flags_t)(1ULL << 30))
 /* Use UNMAP limit for WRITE SAME */
 #define BLIST_UNMAP_LIMIT_WS	((__force blist_flags_t)(1ULL << 31))
+/* Always retry ABORTED_COMMAND with Internal Target Failure */
+#define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 
-#define __BLIST_LAST_USED BLIST_UNMAP_LIMIT_WS
+#define __BLIST_LAST_USED BLIST_RETRY_ITF
 
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
-- 
2.16.1

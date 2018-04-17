From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 6/6] scsi: devinfo: BLIST_RETRY_ASC_C1 for Fujitsu ETERNUS
Date: Wed, 18 Apr 2018 01:35:11 +0200
Message-ID: <20180417233511.6573-7-mwilck@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Janusz Dziemidowicz <rraptorr@nails.eu.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fujitsu ETERNUS systems, sense code ABORTED COMMAND with ASC/Q C1/01 is
used to indicate temporary condition where the storage-internal path to a
target is switched from one controller to another. SCSI commands that
return with this error code must be retried unconditionally (i.e. without
the "maybe_retry" logic in scsi_decide_disposition); otherwise dm-multipath
might initiate a failover from a healthy path e.g. for REQ_FAILFAST_DEV
commands.

Introduce a new blist flag for this case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_error.c   | 3 +++
 include/scsi/scsi_devinfo.h | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f7b94c1..e75a50f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -168,6 +168,7 @@ static struct {
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"FUJITSU", "ETERNUS_DXM", "*", BLIST_RETRY_ASC_C1},
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1dee91f..896b991 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -527,6 +527,9 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 
 		if (sshdr.asc == 0x44 && sdev->sdev_bflags & BLIST_RETRY_ITF)
 			return ADD_TO_MLQUEUE;
+		if (sshdr.asc == 0xc1 && sshdr.ascq == 0x01 &&
+		    sdev->sdev_bflags & BLIST_RETRY_ASC_C1)
+			return ADD_TO_MLQUEUE;
 
 		return NEEDS_RETRY;
 	case NOT_READY:
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 91a327e..3fdb322 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -65,8 +65,10 @@
 #define BLIST_UNMAP_LIMIT_WS	((__force blist_flags_t)(1ULL << 31))
 /* Always retry ABORTED_COMMAND with Internal Target Failure */
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
+/* Always retry ABORTED_COMMAND with ASC 0xc1 */
+#define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
 
-#define __BLIST_LAST_USED BLIST_RETRY_ITF
+#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
 
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
-- 
2.16.1

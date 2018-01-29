From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: handle special return codes for ABORTED COMMAND
Date: Tue, 30 Jan 2018 00:30:13 +0100
Message-ID: <20180129233013.23474-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46991 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeA2Xac (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 29 Jan 2018 18:30:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>, linux-scsi@vger.kernel.org

(Resending, because I forgot to cc linux-scsi. BIG SORRY!)

Introduce a new blist flag that indicates the device may return certain
sense code/ASC/ASCQ combinations that indicate different treatment than
normal. In particular, some devices need unconditional retry (aka
ADD_TO_MLQUEUE) under certain conditions; otherwise path failures may be
falsely detected.

Because different devices use different sense codes to indicate this
condition, a single bit is not enough. But we also can't use a bit for
every possible status code. Therefore the new flag BLIST_ABORTED_CMD_QUIRK
just indicates that this is a device for which the return code should be
checked. An extra "blacklist" in scsi_aborted_cmd_quirk() then checks for
known ASC/ASCQ combinations, and handles them.

When such a combination is encountered for the first time, a message is
printed. In systems that have several different peripherals using this
flag, that might lead to a wrong match without a warning. This small risk
is a compromise between exactness and the excessive resources that would be
required to check for matching device vendor and model name every time.

I chose to recycle devinfo flag (1<<11) (former BLIST_INQUIRY_58, free
since 496c91bbc910) for this purpose rather than extending blist_flags_t to
64 bit. This could be easily changed of course.

This patch replaces the previously submitted patches
 "scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS" and
 "scsi: Always retry internal target error" (Hannes Reinecke)

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_devinfo.c |  4 ++-
 drivers/scsi/scsi_error.c   | 82 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_devinfo.h |  6 ++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index dfb8da83fa50..39455734d934 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -161,12 +161,14 @@ static struct {
 	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_REPORTLUN2},
+	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN
+	 | BLIST_REPORTLUN2 | BLIST_ABORTED_CMD_QUIRK},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"FUJITSU", "ETERNUS_DXM", "*", BLIST_ABORTED_CMD_QUIRK},
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 62b56de38ae8..91f5cdc85dfa 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -39,6 +39,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/sg.h>
+#include <scsi/scsi_devinfo.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -432,6 +433,84 @@ static void scsi_report_sense(struct scsi_device *sdev,
 	}
 }
 
+struct aborted_cmd_blist {
+	u8 asc;
+	u8 ascq;
+	int retval;
+	const char *vendor;
+	const char *model;
+	bool warned;
+};
+
+/**
+ * scsi_aborted_cmd_quirk - Handle special return codes for ABORTED COMMAND
+ * @sdev:	SCSI device that returned ABORTED COMMAND.
+ * @sshdr:	Sense data
+ *
+ * Return value:
+ *	SUCCESS or FAILED or NEEDS_RETRY or ADD_TO_MLQUEUE
+ *
+ * Notes:
+ *	This is only called for devices that have the blist flag
+ *      BLIST_ABORTED_CMD_QUIRK set.
+ */
+static int scsi_aborted_cmd_quirk(const struct scsi_device *sdev,
+				  const struct scsi_sense_hdr *sshdr)
+{
+	static struct aborted_cmd_blist blist[] = {
+		/*
+		 * 44/00: SYMMETRIX uses this code for a variety of internal
+		 * issues, all of which can be recovered by retry
+		 */
+		{ 0x44, 0x00, ADD_TO_MLQUEUE, "EMC", "SYMMETRIX", false },
+		/*
+		 * c1/01: This is used by ETERNUS to indicate the
+		 * command should be retried unconditionally
+		 */
+		{ 0xc1, 0x01, ADD_TO_MLQUEUE, "FUJITSU", "ETERNUS_DXM", false }
+	};
+	struct aborted_cmd_blist *found = NULL;
+	int ret = NEEDS_RETRY, i;
+
+	for (i = 0; i < sizeof(blist)/sizeof(struct aborted_cmd_blist); i++) {
+		if (sshdr->asc == blist[i].asc &&
+		    sshdr->ascq == blist[i].ascq) {
+			found = &blist[i];
+			ret = found->retval;
+			break;
+		}
+	}
+
+	if (found == NULL || found->warned)
+		return ret;
+
+	found->warned = true;
+
+	/*
+	 * When we encounter a known ASC/ASCQ combination, it may or may not
+	 * match the device for which this combination is known.
+	 * Warn only once for each known ASC/ASCQ combination.
+	 * We can't afford making a string comparison every time in the
+	 * SCSI command return path, and a wrong match here is expected to be
+	 * non-fatal.
+	 */
+	if (!strcmp(sdev->vendor, found->vendor) &&
+	    !strcmp(sdev->model, found->model)) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			sdev_printk(KERN_INFO, sdev,
+				    "special retcode %d for ABORTED COMMAND %02x/%02x on %s:%s (expected)",
+				    ret, sshdr->asc, sshdr->ascq,
+				    sdev->vendor, sdev->model));
+	} else {
+		SCSI_LOG_ERROR_RECOVERY(1,
+			sdev_printk(KERN_WARNING, sdev,
+				    "special retcode %d for ABORTED COMMAND %02x/%02x on %s:%s (UNEXPECTED, please inform linux-scsi@vger.kernel.org)",
+				    ret, sshdr->asc, sshdr->ascq,
+				    sdev->vendor, sdev->model));
+	}
+	return ret;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -503,6 +582,9 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SUCCESS;
 
+		if (sdev->sdev_bflags & BLIST_ABORTED_CMD_QUIRK)
+			return scsi_aborted_cmd_quirk(sdev, &sshdr);
+
 		return NEEDS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index ea67c32e870e..1f5ed53040ab 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -28,6 +28,12 @@
 #define BLIST_LARGELUN		((__force blist_flags_t)(1 << 9))
 /* override additional length field */
 #define BLIST_INQUIRY_36	((__force blist_flags_t)(1 << 10))
+/*
+ * Device uses special return codes for ABORTED COMMAND
+ * This flag must go together with matching status handling code in
+ * scsi_aborted_cmd_quirk()
+ */
+#define BLIST_ABORTED_CMD_QUIRK	((__force blist_flags_t)(1 << 11))
 /* do not do automatic start on add */
 #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1 << 12))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
-- 
2.16.1

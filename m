From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1 of 1] cciss: add procfs interface to rescan logical volumes
Date: Tue, 7 Oct 2008 11:24:54 -0500
Message-ID: <20081007162454.GA12104@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:18331 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYJGQY7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 12:24:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 1 of 1

This patch adds a procfs interface so users can force a rescan of the
logical volumes attached to the controller. A new product uses Target Based
Management (TBM) out-of-band for configuration purposes. With this method
the driver has no way of knowing that something has changed, i.e., new
logical volume(s) added or existing volumes deleted.
This interface allows the user to echo "rescan volumes" >
/proc/driver/cciss/ccissN to force the driver to rebuild our table of
logical volumes. 
Please consider this patch for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/Documentation/cciss.txt b/Documentation/cciss.txt
index 8244c64..afda23d 100644
--- a/Documentation/cciss.txt
+++ b/Documentation/cciss.txt
@@ -166,3 +166,17 @@ is issued which positions the tape to a known position.  Typically you
 must rewind the tape (by issuing "mt -f /dev/st0 rewind" for example)
 before i/o can proceed again to a tape drive which was reset.
 
+Rescanning for changes in configuration
+---------------------------------------
+
+Some new products use Target Based Management (TBM) for configuration
+purposes. These products cannot inform the driver that a new logical volume
+has been added, an existing volume deleted, or of change in the size of a
+logical volume. 
+A procfs interface has been added to facilitate a rescan of the devices
+attached to the controller. If a change is made the user may then issue:
+
+	# echo "rescan volumes" > /proc/driver/cciss/ccissN
+
+where N is the controller number. This will force the driver to update the
+configuration.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b73116e..76b5b33 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -249,6 +249,7 @@ static inline CommandList_struct *removeQ(CommandList_struct **Qptr,
 #define ENG_GIG 1000000000
 #define ENG_GIG_FACTOR (ENG_GIG/512)
 #define ENGAGE_SCSI	"engage scsi"
+#define RESCAN_VOLUMES	"rescan volumes"
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
@@ -379,7 +380,9 @@ static ssize_t
 cciss_proc_write(struct file *file, const char __user *buf,
 		 size_t length, loff_t *ppos)
 {
-	int err;
+	struct seq_file *seq = file->private_data;
+	ctlr_info_t *h = seq->private;
+	int err, rc;
 	char *buffer;
 
 #ifndef CONFIG_CISS_SCSI_TAPE
@@ -398,12 +401,26 @@ cciss_proc_write(struct file *file, const char __user *buf,
 		goto out;
 	buffer[length] = '\0';
 
+	/* For the MSA2000 the firmware cannot tell the driver to
+	 * rescan when new logical volumes are created. We provide
+	 * this interface so users can `echo "rescan volumes" >
+	 * /proc/driver/cciss/ccissN` to accomplish that task. It's not
+	 * the best solution because it must be done on every server
+	 * that connected to the storage.
+	 */
+
+	if (strncmp(RESCAN_VOLUMES, buffer, sizeof RESCAN_VOLUMES - 1) == 0) {
+		/* rebuild_lun_table returns -1 on success to tell ACU
+		* to quit calling it. In this case we just ignore any
+		* return code.
+		*/
+		(void) rebuild_lun_table(h, NULL);
+		err = length;
+		goto out;
+	}
+
 #ifdef CONFIG_CISS_SCSI_TAPE
 	if (strncmp(ENGAGE_SCSI, buffer, sizeof ENGAGE_SCSI - 1) == 0) {
-		struct seq_file *seq = file->private_data;
-		ctlr_info_t *h = seq->private;
-		int rc;
-
 		rc = cciss_engage_scsi(h->ctlr);
 		if (rc != 0)
 			err = -rc;

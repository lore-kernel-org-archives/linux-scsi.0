From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: Fix bug in the SCSI power management handler
Date: Fri, 17 Feb 2012 16:25:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202171622160.1194-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53658 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752633Ab2BQVZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2012 16:25:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1520) fixes a bug in the SCSI layer's power management
implementation.

LUN scanning can be carried out asynchronously in do_scan_async(), and
sd uses an asynchronous thread for the time-consuming parts of disk
probing in sd_probe_async().  Currently nothing coordinates these
async threads with system sleep transitions; they can and do attempt
to continue scanning/probing SCSI devices even after the host adapter
has been suspended.  As one might expect, the outcome is not ideal.

This is what the "prepare" stage of system suspend was created for.
After the prepare callback has been called for a host, target, or
device, drivers are not allowed to register any children underneath
them.  Currently the SCSI prepare callback is not implemented; this
patch rectifies that omission.

For SCSI hosts, the prepare routine calls scsi_complete_async_scans()
to wait until async scanning is finished.  It might be slightly more
efficient to wait only until the host in question has been scanned,
but there's currently no way to do that.  Besides, during a sleep
transition we will ultimately have to wait until all the host scanning
has finished anyway.

For SCSI devices, the prepare routine calls async_synchronize_full()
to wait until sd probing is finished.  The routine does nothing for
SCSI targets, because asynchronous target scanning is done only as
part of host scanning.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@kernel.org>

---

 drivers/scsi/scsi_pm.c   |   16 ++++++++++++++++
 drivers/scsi/scsi_priv.h |    1 +
 2 files changed, 17 insertions(+)

Index: usb-3.3/drivers/scsi/scsi_pm.c
===================================================================
--- usb-3.3.orig/drivers/scsi/scsi_pm.c
+++ usb-3.3/drivers/scsi/scsi_pm.c
@@ -7,6 +7,7 @@
 
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
+#include <linux/async.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -92,6 +93,19 @@ static int scsi_bus_resume_common(struct
 	return err;
 }
 
+static int scsi_bus_prepare(struct device *dev)
+{
+	if (scsi_is_sdev_device(dev)) {
+		/* sd probing uses async_schedule.  Wait until it finishes. */
+		async_synchronize_full();
+
+	} else if (scsi_is_host_device(dev)) {
+		/* Wait until async scanning is finished */
+		scsi_complete_async_scans();
+	}
+	return 0;
+}
+
 static int scsi_bus_suspend(struct device *dev)
 {
 	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
@@ -110,6 +124,7 @@ static int scsi_bus_poweroff(struct devi
 #else /* CONFIG_PM_SLEEP */
 
 #define scsi_bus_resume_common		NULL
+#define scsi_bus_prepare		NULL
 #define scsi_bus_suspend		NULL
 #define scsi_bus_freeze			NULL
 #define scsi_bus_poweroff		NULL
@@ -218,6 +233,7 @@ void scsi_autopm_put_host(struct Scsi_Ho
 #endif /* CONFIG_PM_RUNTIME */
 
 const struct dev_pm_ops scsi_bus_pm_ops = {
+	.prepare =		scsi_bus_prepare,
 	.suspend =		scsi_bus_suspend,
 	.resume =		scsi_bus_resume_common,
 	.freeze =		scsi_bus_freeze,
Index: usb-3.3/drivers/scsi/scsi_priv.h
===================================================================
--- usb-3.3.orig/drivers/scsi/scsi_priv.h
+++ usb-3.3/drivers/scsi/scsi_priv.h
@@ -109,6 +109,7 @@ extern void scsi_exit_procfs(void);
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
+extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);


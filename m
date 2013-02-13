From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH] mpt2sas/mpt3sas: set async scan finished on adapter
 removal
Date: Wed, 13 Feb 2013 16:52:58 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302131634210.11804@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:59248 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760376Ab3BMV5f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 16:57:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Joe Lawrence <joe.lawrence@stratus.com>

I stumbled across this while testing surprise device removal, particularly 
during device initialization.

The test added an LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT 
SAS-2 with a few disks attached.  During an async SCSI scan, the device is 
removed via PCI hotplug.  Cleanup of the scsi host took a long time 
(roughly five minutes) which I traced back to the timeout value in the 
mpt2sas _scsih_scan_finished() function.

Since the driver has already set the adapter's "remove_host" value in its 
.remove callback, it seems like the driver should use that information to 
give up on the scan and cleanup a bit faster.

I don't have mpt3sas HW, so that part of the patch is untested (though the 
code looks 99% the same here.)

Regards,

-- Joe

>From 9900a0a30464ef1fff67f28780ec036d3d7d0cbe Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Wed, 13 Feb 2013 16:30:31 -0500
Subject: [PATCH] mpt2sas/mpt3sas: set async scan finished on adapter removal

If a scsi host is removed during an asynchronous SCSI scan, the driver's
.scan_finished callback function may take up to 5 minutes to timeout and
notify the SCSI layer that the operation has failed.  Once the driver
determines that an adapter is gone, stop waiting for the scan to complete.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 10 ++++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c6bdc92..d1e24e7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7951,14 +7951,20 @@ _scsih_scan_start(struct Scsi_Host *shost)
  * @time: elapsed time of the scan in jiffies
  *
  * This function will be called periodically until it returns 1 with the
- * scsi_host and the elapsed time of the scan in jiffies. In our implemention,
- * we wait for firmware discovery to complete, then return 1.
+ * scsi_host and the elapsed time of the scan in jiffies. In our
+ * implementation, we wait for firmware discovery to complete, then return 1.
  */
 static int
 _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 
+	if (ioc->remove_host) {
+		printk(MPT2SAS_INFO_FMT "port enable: FAILED host removed\n",
+		    ioc->name);
+		return 1;
+	}
+
 	if (disable_discovery > 0) {
 		ioc->is_driver_loading = 0;
 		ioc->wait_for_discovery_to_complete = 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6421a06..170f485 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7665,15 +7665,21 @@ _scsih_scan_start(struct Scsi_Host *shost)
  * @shost: SCSI host pointer
  * @time: elapsed time of the scan in jiffies
  *
- * This function will be called periodicallyn until it returns 1 with the
- * scsi_host and the elapsed time of the scan in jiffies. In our implemention,
- * we wait for firmware discovery to complete, then return 1.
+ * This function will be called periodically until it returns 1 with the
+ * scsi_host and the elapsed time of the scan in jiffies. In our
+ * implementation, we wait for firmware discovery to complete, then return 1.
  */
 static int
 _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
+	if (ioc->remove_host) {
+		pr_info(MPT3SAS_FMT "port enable: FAILED host removed\n",
+			ioc->name);
+		return 1;
+	}
+
 	if (disable_discovery > 0) {
 		ioc->is_driver_loading = 0;
 		ioc->wait_for_discovery_to_complete = 0;
-- 
1.8.1.2


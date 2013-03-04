From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH 2/2] mpt2sas, mpt3sas: set async scan finished on adapter
 removal
Date: Mon, 4 Mar 2013 10:57:12 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1303041056030.1736@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:53829 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab3CDQA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 11:00:56 -0500
In-Reply-To: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com, support@lsi.com, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

If a scsi host is removed during an asynchronous SCSI scan, the mpt2sas
and mpt3sas .scan_finished callback function may take up to 5 minutes to
timeout and notify the SCSI layer that the operation has failed.  Once the
driver determines that an adapter is gone, stop waiting for the scan to
complete.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
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


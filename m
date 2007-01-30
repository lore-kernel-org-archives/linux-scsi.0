From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/4] libsas: Add an LU reset mechanism to the error handler
Date: Mon, 29 Jan 2007 23:48:19 -0800
Message-ID: <20070130074819.7612.42318.stgit@elm3a70.beaverton.ibm.com>
References: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52276 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965429AbXA3Hps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 02:45:48 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U7jkHN029283
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:46 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U7jk0x300318
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:46 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U7jkur014643
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:46 -0500
In-Reply-To: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


After discussion with andmike and dougg, it seems that the purpose of
eh_device_reset_handler is to issue LU resets, and that
eh_bus_reset_handler would be a more appropriate place for a phy reset.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   40 ++++++++++++++++++++++++++++++++---
 include/scsi/libsas.h               |    1 +
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 04eace9..261b85a 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -421,16 +421,37 @@ struct sas_phy *find_local_sas_phy(struc
 	return exphy->phy;
 }
 
-/* Attempt to send a target reset message to a device */
+/* Attempt to send a LUN reset message to a device */
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct sas_internal *i =
+		to_sas_internal(dev->port->ha->core.shost->transportt);
+	struct scsi_lun lun;
+	int res;
+
+	int_to_scsilun(cmd->device->lun, &lun);
+
+	if (!i->dft->lldd_lu_reset)
+		return FAILED;
+
+	res = i->dft->lldd_lu_reset(dev, lun.scsi_lun);
+	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
+		return SUCCESS;
+
+	return FAILED;
+}
+
+/* Attempt to send a phy (bus) reset */
+int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
+{
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_phy *phy = find_local_sas_phy(dev);
 	int res;
 
 	res = sas_phy_reset(phy, 1);
 	if (res)
-		SAS_DPRINTK("Device reset of %s failed 0x%x\n",
+		SAS_DPRINTK("Bus reset of %s failed 0x%x\n",
 			    phy->dev.kobj.k_name,
 			    res);
 	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
@@ -443,10 +464,20 @@ int sas_eh_device_reset_handler(struct s
 static int try_to_reset_cmd_device(struct Scsi_Host *shost,
 				   struct scsi_cmnd *cmd)
 {
+	int res;
+
 	if (!shost->hostt->eh_device_reset_handler)
-		return FAILED;
+		goto try_bus_reset;
+
+	res = shost->hostt->eh_device_reset_handler(cmd);
+	if (res == SUCCESS)
+		return res;
 
-	return shost->hostt->eh_device_reset_handler(cmd);
+try_bus_reset:
+	if (shost->hostt->eh_bus_reset_handler)
+		return shost->hostt->eh_bus_reset_handler(cmd);
+
+	return FAILED;
 }
 
 static int sas_eh_handle_sas_errors(struct Scsi_Host *shost,
@@ -976,3 +1007,4 @@ EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 EXPORT_SYMBOL_GPL(sas_phy_enable);
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
+EXPORT_SYMBOL_GPL(sas_eh_bus_reset_handler);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index b200233..8516ba6 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -661,5 +661,6 @@ void sas_init_dev(struct domain_device *
 void sas_task_abort(struct sas_task *);
 int __sas_task_abort(struct sas_task *);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
 
 #endif /* _SASLIB_H_ */

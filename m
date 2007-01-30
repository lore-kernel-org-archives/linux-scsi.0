From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 12/12] sas_ata: Make this a module separate from libsas
Date: Tue, 30 Jan 2007 01:19:04 -0800
Message-ID: <20070130091903.31530.90178.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39651 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965464AbXA3JRr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:17:47 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9IPER019402
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:18:25 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GUDC234362
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:30 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GUhs011099
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:30 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Break out sas_ata as a free-standing module that provides a SATA
Translation Layer (SATL) for libsas.  This patch requires the libsas
SATL registration patch; the changes to sas_ata itself are rather
minor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/Makefile  |    5 +++--
 drivers/scsi/libsas/sas_ata.c |   37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 6383eb5..5e95902 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -33,5 +33,6 @@ libsas-y +=  sas_init.o     \
 		sas_dump.o     \
 		sas_discover.o \
 		sas_expander.o \
-		sas_scsi_host.o \
-		sas_ata.o
+		sas_scsi_host.o
+
+obj-$(CONFIG_SCSI_SAS_SATL) += sas_ata.o
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 1b7221c..f75fa59 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -404,8 +404,8 @@ static struct ata_port_info sata_port_in
 	.port_ops = &sas_sata_ops
 };
 
-int sas_ata_init_host_and_port(struct domain_device *found_dev,
-			       struct scsi_target *starget)
+static int sas_ata_init_host_and_port(struct domain_device *found_dev,
+				      struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
@@ -431,7 +431,7 @@ int sas_ata_init_host_and_port(struct do
 	return 0;
 }
 
-void sas_ata_task_abort(struct sas_task *task)
+static void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
 	struct completion *waiting;
@@ -450,3 +450,34 @@ void sas_ata_task_abort(struct sas_task 
 	waiting = qc->private_data;
 	complete(waiting);
 }
+
+/* Module initialization */
+static struct satl_operations sas_ata_ops = {
+	.owner			= THIS_MODULE,
+	.init_target		= sas_ata_init_host_and_port,
+	.queuecommand		= ata_sas_queuecmd,
+	.ioctl			= ata_scsi_ioctl,
+	.configure_port		= ata_sas_slave_configure,
+	.deactivate_port	= ata_port_disable,
+	.destroy_port		= ata_sas_port_destroy,
+	.init_port		= ata_sas_port_init,
+	.task_abort		= sas_ata_task_abort
+};
+
+static int __init sas_ata_init(void)
+{
+	return sas_register_satl(&sas_ata_ops);
+}
+
+static void __exit sas_ata_exit(void)
+{
+	sas_unregister_satl(&sas_ata_ops);
+}
+
+module_init(sas_ata_init);
+module_exit(sas_ata_exit);
+
+MODULE_AUTHOR("Darrick Wong <djwong@us.ibm.com>");
+MODULE_DESCRIPTION("libata SATL for SAS");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("1.0");

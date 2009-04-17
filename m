From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 15/15] zfcp: Fix oops when port disappears
Date: Fri, 17 Apr 2009 15:08:15 +0200
Message-ID: <20090417131123.790167000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:39170 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbZDQNLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:37 -0400
Content-Disposition: inline; filename=s390-sles11-12-05-zfcp_fcp_port_handling.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The zfcp_port might have been removed, while the FC fast_io_fail timer
is still running and could trigger the terminate_rport_io callback.
Set the pointer to the zfcp_port to NULL and check accordingly
before using it.

Reviewed-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    3 +--
 drivers/s390/scsi/zfcp_fsf.c  |    4 ++++
 drivers/s390/scsi/zfcp_scsi.c |   25 +++++++++++++++++++------
 3 files changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-04-17 15:03:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-04-17 15:04:00.000000000 +0200
@@ -671,8 +671,7 @@ void zfcp_port_dequeue(struct zfcp_port 
 	list_del(&port->list);
 	write_unlock_irq(&zfcp_data.config_lock);
 	if (port->rport)
-		fc_remote_port_delete(port->rport);
-	port->rport = NULL;
+		port->rport->dd_data = NULL;
 	zfcp_adapter_put(port->adapter);
 	sysfs_remove_group(&port->sysfs_device.kobj, &zfcp_sysfs_port_attrs);
 	device_unregister(&port->sysfs_device);
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-04-17 15:03:49.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-04-17 15:04:00.000000000 +0200
@@ -486,10 +486,12 @@ static void zfcp_set_rport_dev_loss_tmo(
  */
 static void zfcp_scsi_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
-	struct zfcp_port *port = rport->dd_data;
+	struct zfcp_port *port;
 
 	write_lock_irq(&zfcp_data.config_lock);
-	port->rport = NULL;
+	port = rport->dd_data;
+	if (port)
+		port->rport = NULL;
 	write_unlock_irq(&zfcp_data.config_lock);
 }
 
@@ -503,9 +505,18 @@ static void zfcp_scsi_dev_loss_tmo_callb
  */
 static void zfcp_scsi_terminate_rport_io(struct fc_rport *rport)
 {
-	struct zfcp_port *port = rport->dd_data;
+	struct zfcp_port *port;
+
+	write_lock_irq(&zfcp_data.config_lock);
+	port = rport->dd_data;
+	if (port)
+		zfcp_port_get(port);
+	write_unlock_irq(&zfcp_data.config_lock);
 
-	zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
+	if (port) {
+		zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
+		zfcp_port_put(port);
+	}
 }
 
 static void zfcp_scsi_rport_register(struct zfcp_port *port)
@@ -534,8 +545,10 @@ static void zfcp_scsi_rport_register(str
 
 static void zfcp_scsi_rport_block(struct zfcp_port *port)
 {
-	if (port->rport)
-		fc_remote_port_delete(port->rport);
+	struct fc_rport *rport = port->rport;
+
+	if (rport)
+		fc_remote_port_delete(rport);
 }
 
 void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:04:00.000000000 +0200
@@ -172,12 +172,16 @@ static void zfcp_fsf_link_down_info_eval
 					 struct fsf_link_down_info *link_down)
 {
 	struct zfcp_adapter *adapter = req->adapter;
+	unsigned long flags;
 
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED)
 		return;
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
+
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_scsi_schedule_rports_block(adapter);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	if (!link_down)
 		goto out;


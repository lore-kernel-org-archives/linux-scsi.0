From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 19/27] zfcp: resolve false usage of dd_data in fc_rport
Date: Tue, 18 Aug 2009 15:43:24 +0200
Message-ID: <20090818135031.284201000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56272 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988AbZHRNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:35 -0400
Content-Disposition: inline; filename=720-zfcp-dd_data-usage.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The fc_rport structure reserves a reference where a LLD can put
information required in a situation where the fc transport class is
triggering LLD callbacks. The zfcp driver was using this variable
directly which is discouraged. This patch solves this issue by making
this reference unnecessary.  In addition the dev_loss_tmo callback is
removed, it is not required: zfcp does not access the fc_rport after
calling fc_remote_port_delete.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |    4 ----
 drivers/s390/scsi/zfcp_fc.c   |    2 +-
 drivers/s390/scsi/zfcp_scsi.c |   22 ++++------------------
 3 files changed, 5 insertions(+), 23 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 13:28:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 13:28:26.000000000 +0200
@@ -709,10 +709,6 @@ void zfcp_port_dequeue(struct zfcp_port 
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&port->list);
 	write_unlock_irq(&zfcp_data.config_lock);
-	if (port->rport) {
-		port->rport->dd_data = NULL;
-		port->rport = NULL;
-	}
 	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
 	cancel_work_sync(&port->rport_work); /* usually not necessary */
 	zfcp_adapter_put(port->adapter);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 13:28:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 13:28:26.000000000 +0200
@@ -752,7 +752,7 @@ int zfcp_fc_execute_els_fc_job(struct fc
 	els_fc_job->els.adapter = adapter;
 	if (rport) {
 		read_lock_irq(&zfcp_data.config_lock);
-		port = rport->dd_data;
+		port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
 		if (port)
 			els_fc_job->els.d_id = port->d_id;
 		read_unlock_irq(&zfcp_data.config_lock);
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 13:26:55.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 13:34:37.000000000 +0200
@@ -491,21 +491,6 @@ static void zfcp_set_rport_dev_loss_tmo(
 }
 
 /**
- * zfcp_scsi_dev_loss_tmo_callbk - Free any reference to rport
- * @rport: The rport that is about to be deleted.
- */
-static void zfcp_scsi_dev_loss_tmo_callbk(struct fc_rport *rport)
-{
-	struct zfcp_port *port;
-
-	write_lock_irq(&zfcp_data.config_lock);
-	port = rport->dd_data;
-	if (port)
-		port->rport = NULL;
-	write_unlock_irq(&zfcp_data.config_lock);
-}
-
-/**
  * zfcp_scsi_terminate_rport_io - Terminate all I/O on a rport
  * @rport: The FC rport where to teminate I/O
  *
@@ -516,9 +501,12 @@ static void zfcp_scsi_dev_loss_tmo_callb
 static void zfcp_scsi_terminate_rport_io(struct fc_rport *rport)
 {
 	struct zfcp_port *port;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *)shost->hostdata[0];
 
 	write_lock_irq(&zfcp_data.config_lock);
-	port = rport->dd_data;
+	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
 	if (port)
 		zfcp_port_get(port);
 	write_unlock_irq(&zfcp_data.config_lock);
@@ -550,7 +538,6 @@ static void zfcp_scsi_rport_register(str
 		return;
 	}
 
-	rport->dd_data = port;
 	rport->maxframe_size = port->maxframe_size;
 	rport->supported_classes = port->supported_classes;
 	port->rport = rport;
@@ -663,7 +650,6 @@ struct fc_function_template zfcp_transpo
 	.reset_fc_host_stats = zfcp_reset_fc_host_stats,
 	.set_rport_dev_loss_tmo = zfcp_set_rport_dev_loss_tmo,
 	.get_host_port_state = zfcp_get_host_port_state,
-	.dev_loss_tmo_callbk = zfcp_scsi_dev_loss_tmo_callbk,
 	.terminate_rport_io = zfcp_scsi_terminate_rport_io,
 	.show_host_port_state = 1,
 	.bsg_request = zfcp_execute_fc_job,


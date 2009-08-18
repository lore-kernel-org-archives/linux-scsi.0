From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/27] zfcp: invalid usage after free of port resources
Date: Tue, 18 Aug 2009 15:43:06 +0200
Message-ID: <20090818135028.887008000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38046 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=700-zfcp-use-after-free.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

In certain error scenarios ports, rports are getting attached, 
validated and removed from the systems environment. Depending on the
layer this occurs asynchronously. This patch fixes the few races
which existed and ensures all references and cross references are 
cleared at the time they're invalid. In addition fc transports
actions are only scheduled when required.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com> 
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |    7 +++++--
 drivers/s390/scsi/zfcp_scsi.c |    6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:28:56.000000000 +0200
@@ -672,12 +672,15 @@ err_out:
  */
 void zfcp_port_dequeue(struct zfcp_port *port)
 {
-	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&port->list);
 	write_unlock_irq(&zfcp_data.config_lock);
-	if (port->rport)
+	if (port->rport) {
 		port->rport->dd_data = NULL;
+		port->rport = NULL;
+	}
+	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
+	cancel_work_sync(&port->rport_work); /* usually not necessary */
 	zfcp_adapter_put(port->adapter);
 	sysfs_remove_group(&port->sysfs_device.kobj, &zfcp_sysfs_port_attrs);
 	device_unregister(&port->sysfs_device);
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 11:28:56.000000000 +0200
@@ -582,8 +582,10 @@ void zfcp_scsi_schedule_rport_block(stru
 	zfcp_port_get(port);
 	port->rport_task = RPORT_DEL;
 
-	if (!queue_work(zfcp_data.work_queue, &port->rport_work))
-		zfcp_port_put(port);
+	if (port->rport && queue_work(zfcp_data.work_queue, &port->rport_work))
+		return;
+
+	zfcp_port_put(port);
 }
 
 void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *adapter)


From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/10] zfcp: Remove SCSI device when removing unit
Date: Fri, 16 Jul 2010 15:37:35 +0200
Message-ID: <20100716134300.006377000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:42877 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965486Ab0GPNnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:02 -0400
Content-Disposition: inline; filename=705-zfcp-unit-removal.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Configuring a LUN in zfcp, also creates a SCSI device. For
consistency, it makes sense to remove the SCSI device when the LUN is
deconfigured. Replace the flush_work with the call to
scsi_remove_device: scsi_remove_device also takes the scan_mutex that
synchronizes itself with any long running device discovery.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h   |    1 +
 drivers/s390/scsi/zfcp_scsi.c  |    1 +
 drivers/s390/scsi/zfcp_sysfs.c |   10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -212,6 +212,7 @@ struct zfcp_port {
 	struct work_struct     test_link_work;
 	struct work_struct     rport_work;
 	enum { RPORT_NONE, RPORT_ADD, RPORT_DEL }  rport_task;
+	unsigned int		starget_id;
 };
 
 struct zfcp_unit {
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -564,6 +564,7 @@ static void zfcp_scsi_rport_register(str
 	rport->maxframe_size = port->maxframe_size;
 	rport->supported_classes = port->supported_classes;
 	port->rport = rport;
+	port->starget_id = rport->scsi_target_id;
 
 	zfcp_scsi_queue_unit_register(port);
 }
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -290,6 +290,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = -EINVAL;
+	struct scsi_device *sdev;
 
 	if (!(port && get_device(&port->dev)))
 		return -EBUSY;
@@ -303,8 +304,13 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	else
 		retval = 0;
 
-	/* wait for possible timeout during SCSI probe */
-	flush_work(&unit->scsi_work);
+	sdev = scsi_device_lookup(port->adapter->scsi_host, 0,
+				  port->starget_id,
+				  scsilun_to_int((struct scsi_lun *)&fcp_lun));
+	if (sdev) {
+		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
+	}
 
 	write_lock_irq(&port->unit_list_lock);
 	list_del(&unit->list);


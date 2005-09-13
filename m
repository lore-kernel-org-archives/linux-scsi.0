From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 4/6] zfcp: shorten eh_bus_reset and eh_host_reset handlers
Date: Tue, 13 Sep 2005 21:49:52 +0200
Message-ID: <20050913194952.GA7685@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:56570 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S932419AbVIMTw3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 15:52:29 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j8DJqSd7170100
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 19:52:28 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8DJqS7u140312
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:52:28 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j8DJqSRL024971
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:52:28 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: shorten eh_bus_reset and eh_host_reset handlers

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_scsi.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_scsi.c	2005-09-13 20:39:47.678906409 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_scsi.c	2005-09-13 20:40:10.708906409 +0200
@@ -587,50 +587,38 @@ zfcp_task_management_function(struct zfc
 	return retval;
 }
 
-/*
- * function:	zfcp_scsi_eh_bus_reset_handler
- *
- * purpose:
- *
- * returns:
+/**
+ * zfcp_scsi_eh_bus_reset_handler - reset bus (reopen adapter)
  */
 int
 zfcp_scsi_eh_bus_reset_handler(struct scsi_cmnd *scpnt)
 {
-	int retval = 0;
-	struct zfcp_unit *unit;
+	struct zfcp_unit *unit = (struct zfcp_unit*) scpnt->device->hostdata;
+	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 	ZFCP_LOG_NORMAL("bus reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
-	zfcp_erp_adapter_reopen(unit->port->adapter, 0);
-	zfcp_erp_wait(unit->port->adapter);
-	retval = SUCCESS;
+	zfcp_erp_adapter_reopen(adapter, 0);
+	zfcp_erp_wait(adapter);
 
-	return retval;
+	return SUCCESS;
 }
 
-/*
- * function:	zfcp_scsi_eh_host_reset_handler
- *
- * purpose:
- *
- * returns:
+/**
+ * zfcp_scsi_eh_host_reset_handler - reset host (reopen adapter)
  */
 int
 zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	int retval = 0;
-	struct zfcp_unit *unit;
+	struct zfcp_unit *unit = (struct zfcp_unit*) scpnt->device->hostdata;
+	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 	ZFCP_LOG_NORMAL("host reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
-	zfcp_erp_adapter_reopen(unit->port->adapter, 0);
-	zfcp_erp_wait(unit->port->adapter);
-	retval = SUCCESS;
+	zfcp_erp_adapter_reopen(adapter, 0);
+	zfcp_erp_wait(adapter);
 
-	return retval;
+	return SUCCESS;
 }
 
 /*

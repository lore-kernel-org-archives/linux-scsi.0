From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 5/7] zfcp: shorten eh_bus_reset and eh_host_reset handlers
Date: Sat, 3 Sep 2005 14:34:02 +0200
Message-ID: <20050903123402.GA7930@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:56525 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751406AbVICMgS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:36:18 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83CaGd7172386
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 12:36:16 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83CaGih181256
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:36:16 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83CaGa2015291
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:36:16 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: shorten eh_bus_reset and eh_host_reset handlers

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c	2005-09-03 12:21:58.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c	2005-09-03 12:22:13.000000000 +0200
@@ -643,50 +643,38 @@ zfcp_task_management_function(struct zfc
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

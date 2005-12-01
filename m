From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [patch 1/4] zfcp: fix spinlock initialization
Date: Thu, 1 Dec 2005 02:46:32 +0100
Message-ID: <20051201014632.GA13063@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7322 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751618AbVLABrp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 20:47:45 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id jB11lnLs057048
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 01:47:49 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jB11li9Z231416
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:47:44 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id jB11li6i006701
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:47:44 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[patch 1/4] zfcp: fix spinlock initialization

Move initialization of locks and lists to adapter allocation function.
Otherwise we might end up with some uninitialized locks, like e.g. the
erp locks which only will be inititialized if an error recovery thread
for an adapter will be started.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_aux.c linux-2.6.x/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_aux.c	2005-12-01 00:10:35.000000000 +0100
+++ linux-2.6.x/drivers/s390/scsi/zfcp_aux.c	2005-12-01 01:14:36.000000000 +0100
@@ -996,6 +996,20 @@ zfcp_adapter_enqueue(struct ccw_device *
 	spin_lock_init(&adapter->fsf_req_list_lock);
 	INIT_LIST_HEAD(&adapter->fsf_req_list_head);
 
+	/* initialize debug locks */
+
+	spin_lock_init(&adapter->erp_dbf_lock);
+	spin_lock_init(&adapter->hba_dbf_lock);
+	spin_lock_init(&adapter->san_dbf_lock);
+	spin_lock_init(&adapter->scsi_dbf_lock);
+
+	/* initialize error recovery stuff */
+
+	rwlock_init(&adapter->erp_lock);
+	sema_init(&adapter->erp_ready_sem, 0);
+	INIT_LIST_HEAD(&adapter->erp_ready_head);
+	INIT_LIST_HEAD(&adapter->erp_running_head);
+
 	/* initialize abort lock */
 	rwlock_init(&adapter->abort_lock);
 
diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_dbf.c linux-2.6.x/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_dbf.c	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi/zfcp_dbf.c	2005-12-01 01:14:36.000000000 +0100
@@ -926,7 +926,6 @@ int zfcp_adapter_debug_register(struct z
 	char dbf_name[DEBUG_MAX_NAME_LEN];
 
 	/* debug feature area which records recovery activity */
-	spin_lock_init(&adapter->erp_dbf_lock);
 	sprintf(dbf_name, "zfcp_%s_erp", zfcp_get_busid_by_adapter(adapter));
 	adapter->erp_dbf = debug_register(dbf_name, dbfsize, 2,
 					  sizeof(struct zfcp_erp_dbf_record));
@@ -936,7 +935,6 @@ int zfcp_adapter_debug_register(struct z
 	debug_set_level(adapter->erp_dbf, 3);
 
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
-	spin_lock_init(&adapter->hba_dbf_lock);
 	sprintf(dbf_name, "zfcp_%s_hba", zfcp_get_busid_by_adapter(adapter));
 	adapter->hba_dbf = debug_register(dbf_name, dbfsize, 1,
 					  sizeof(struct zfcp_hba_dbf_record));
@@ -947,7 +945,6 @@ int zfcp_adapter_debug_register(struct z
 	debug_set_level(adapter->hba_dbf, 3);
 
 	/* debug feature area which records SAN command failures and recovery */
-	spin_lock_init(&adapter->san_dbf_lock);
 	sprintf(dbf_name, "zfcp_%s_san", zfcp_get_busid_by_adapter(adapter));
 	adapter->san_dbf = debug_register(dbf_name, dbfsize, 1,
 					  sizeof(struct zfcp_san_dbf_record));
@@ -958,7 +955,6 @@ int zfcp_adapter_debug_register(struct z
 	debug_set_level(adapter->san_dbf, 6);
 
 	/* debug feature area which records SCSI command failures and recovery */
-	spin_lock_init(&adapter->scsi_dbf_lock);
 	sprintf(dbf_name, "zfcp_%s_scsi", zfcp_get_busid_by_adapter(adapter));
 	adapter->scsi_dbf = debug_register(dbf_name, dbfsize, 1,
 					   sizeof(struct zfcp_scsi_dbf_record));
diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_erp.c linux-2.6.x/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_erp.c	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi/zfcp_erp.c	2005-12-01 01:14:36.000000000 +0100
@@ -1071,11 +1071,6 @@ zfcp_erp_thread_setup(struct zfcp_adapte
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
 
-	rwlock_init(&adapter->erp_lock);
-	INIT_LIST_HEAD(&adapter->erp_ready_head);
-	INIT_LIST_HEAD(&adapter->erp_running_head);
-	sema_init(&adapter->erp_ready_sem, 0);
-
 	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
 	if (retval < 0) {
 		ZFCP_LOG_NORMAL("error: creation of erp thread failed for "

From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 5/6] zfcp: fix: avoid removal of fsf reqs before qdio queues are down
Date: Mon, 18 Sep 2006 22:30:36 +0200
Message-ID: <20060918203036.GA10510@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:42040 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S964935AbWIRUfW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 16:35:22 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id k8IKZKZe104704
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 20:35:20 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8IKe5ip2588926
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:40:05 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8IKZKoJ015029
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:35:20 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: fix: avoid removal of fsf requests before qdio queues are shut down

Fix the fix ... One of my previous fixes introduced removal of all fsf
requests in zfcp's eh_host_reset_handler. But this must not happen
before qdio queues are shut down. So, I revert the changes of
zfcp_scsi_eh_host_reset_handler.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c  |    3 ++-
 drivers/s390/scsi/zfcp_ext.h  |    1 -
 drivers/s390/scsi/zfcp_scsi.c |   19 ++-----------------
 3 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index af42a0e..862a411 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -91,6 +91,7 @@ static int zfcp_erp_unit_strategy_clears
 static int zfcp_erp_unit_strategy_close(struct zfcp_erp_action *);
 static int zfcp_erp_unit_strategy_open(struct zfcp_erp_action *);
 
+static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *);
 static void zfcp_erp_action_dismiss_port(struct zfcp_port *);
 static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *);
 static void zfcp_erp_action_dismiss(struct zfcp_erp_action *);
@@ -3157,7 +3158,7 @@ zfcp_erp_action_cleanup(int action, stru
 }
 
 
-void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
+static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
 {
 	struct zfcp_port *port;
 
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 3125a42..b8794d7 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -134,7 +134,6 @@ extern void zfcp_erp_modify_adapter_stat
 extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int);
 extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int);
 extern void zfcp_erp_adapter_failed(struct zfcp_adapter *);
-extern void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *);
 
 extern void zfcp_erp_modify_port_status(struct zfcp_port *, u32, int);
 extern int  zfcp_erp_port_reopen(struct zfcp_port *, int);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 753bb9b..7cafa34 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -544,7 +544,6 @@ int zfcp_scsi_eh_host_reset_handler(stru
 {
 	struct zfcp_unit *unit;
 	struct zfcp_adapter *adapter;
-	unsigned long flags;
 
 	unit = (struct zfcp_unit*) scpnt->device->hostdata;
 	adapter = unit->port->adapter;
@@ -552,22 +551,8 @@ int zfcp_scsi_eh_host_reset_handler(stru
 	ZFCP_LOG_NORMAL("host/bus reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
 
-	write_lock_irqsave(&adapter->erp_lock, flags);
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
-			     &adapter->status)) {
-		zfcp_erp_modify_adapter_status(adapter,
-		       ZFCP_STATUS_COMMON_UNBLOCKED|ZFCP_STATUS_COMMON_OPEN,
-		       ZFCP_CLEAR);
-		zfcp_erp_action_dismiss_adapter(adapter);
-		write_unlock_irqrestore(&adapter->erp_lock, flags);
-		zfcp_fsf_req_dismiss_all(adapter);
-		adapter->fsf_req_seq_no = 0;
-		zfcp_erp_adapter_reopen(adapter, 0);
-	} else {
-		write_unlock_irqrestore(&adapter->erp_lock, flags);
-		zfcp_erp_adapter_reopen(adapter, 0);
-		zfcp_erp_wait(adapter);
-	}
+	zfcp_erp_adapter_reopen(adapter, 0);
+	zfcp_erp_wait(adapter);
 
 	return SUCCESS;
 }
-- 
1.4.2.1.g80823


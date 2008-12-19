From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/11] zfcp: Remove adapter list
Date: Fri, 19 Dec 2008 16:56:55 +0100
Message-ID: <20081219155752.629082000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:60954 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYLSP5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:55 -0500
Content-Disposition: inline; filename=remove-adapter-list.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

After the latest changes, the list of FCP devices is only used to
lookup the adapter for requests from the actcli tool. Change this to
use the lookup function in the cio layer. Now we can remove the
adapter list and have one place less to use the global config_lock.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |   12 ------------
 drivers/s390/scsi/zfcp_cfdc.c |   17 +++--------------
 drivers/s390/scsi/zfcp_def.h  |    2 --
 3 files changed, 3 insertions(+), 28 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-12-19 14:38:26.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-12-19 14:38:30.000000000 +0100
@@ -175,7 +175,6 @@ static int __init zfcp_module_init(void)
 
 	zfcp_data.work_queue = create_singlethread_workqueue("zfcp_wq");
 
-	INIT_LIST_HEAD(&zfcp_data.adapter_list_head);
 	sema_init(&zfcp_data.config_sema, 1);
 	rwlock_init(&zfcp_data.config_lock);
 
@@ -509,11 +508,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 			       &zfcp_sysfs_adapter_attrs))
 		goto sysfs_failed;
 
-	write_lock_irq(&zfcp_data.config_lock);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-	list_add_tail(&adapter->list, &zfcp_data.adapter_list_head);
-	write_unlock_irq(&zfcp_data.config_lock);
-
 	zfcp_fc_nameserver_init(adapter);
 
 	if (!zfcp_adapter_scsi_register(adapter))
@@ -556,14 +551,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 		return;
 
 	zfcp_adapter_debug_unregister(adapter);
-
-	/* remove specified adapter data structure from list */
-	write_lock_irq(&zfcp_data.config_lock);
-	list_del(&adapter->list);
-	write_unlock_irq(&zfcp_data.config_lock);
-
 	zfcp_qdio_free(adapter);
-
 	zfcp_free_low_mem_buffers(adapter);
 	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
--- a/drivers/s390/scsi/zfcp_cfdc.c	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_cfdc.c	2008-12-19 14:38:30.000000000 +0100
@@ -82,20 +82,9 @@ static int zfcp_cfdc_copy_to_user(void _
 
 static struct zfcp_adapter *zfcp_cfdc_get_adapter(u32 devno)
 {
-	struct zfcp_adapter *adapter = NULL, *cur_adapter;
-	struct ccw_dev_id dev_id;
-
-	read_lock_irq(&zfcp_data.config_lock);
-	list_for_each_entry(cur_adapter, &zfcp_data.adapter_list_head, list) {
-		ccw_device_get_id(cur_adapter->ccw_device, &dev_id);
-		if (dev_id.devno == devno) {
-			adapter = cur_adapter;
-			zfcp_adapter_get(adapter);
-			break;
-		}
-	}
-	read_unlock_irq(&zfcp_data.config_lock);
-	return adapter;
+	char busid[9];
+	snprintf(busid, sizeof(busid), "0.0.%04x", devno);
+	return zfcp_get_adapter_by_busid(busid);
 }
 
 static int zfcp_cfdc_set_fsf(struct zfcp_fsf_cfdc *fsf_cfdc, int command)
--- a/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:30.000000000 +0100
@@ -450,7 +450,6 @@ struct zfcp_latencies {
 };
 
 struct zfcp_adapter {
-	struct list_head	list;              /* list of adapters */
 	atomic_t                refcount;          /* reference count */
 	wait_queue_head_t	remove_wq;         /* can be used to wait for
 						      refcount drop to zero */
@@ -591,7 +590,6 @@ struct zfcp_fsf_req {
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
 	struct scsi_transport_template *scsi_transport_template;
-	struct list_head	adapter_list_head;  /* head of adapter list */
 	rwlock_t                config_lock;        /* serialises changes
 						       to adapter/port/unit
 						       lists */

-- 

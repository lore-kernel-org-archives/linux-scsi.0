From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 3/6] Fix unsafe sas_device_list usage
Date: Mon, 8 Jun 2015 20:50:53 -0700
Message-ID: <1433821856-2815280-4-git-send-email-calvinowens@fb.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55363 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932383AbbFIDvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 23:51:44 -0400
In-Reply-To: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com

We cannot iterate over the list without holding a lock for the entire
duration, or we risk corrupting random memory if items are added or
deleted as we iterate.

This refactors code such that it always holds the lock when iterating
on or accessing the sas_device_list.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 83 +++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index ad6ceb7e..9645055 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7104,6 +7104,7 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 	struct _raid_device *raid_device, *raid_device_next;
 	struct list_head tmp_list;
 	unsigned long flags;
+	LIST_HEAD(head);
 
 	printk(MPT2SAS_INFO_FMT "removing unresponding devices: start\n",
 	    ioc->name);
@@ -7111,14 +7112,29 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 	/* removing unresponding end devices */
 	printk(MPT2SAS_INFO_FMT "removing unresponding devices: end-devices\n",
 	    ioc->name);
+
+	/*
+	 * Iterate, pulling off devices marked as non-responding. We become the
+	 * owner for the reference the list had on any object we prune.
+	 */
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_for_each_entry_safe(sas_device, sas_device_next,
-	    &ioc->sas_device_list, list) {
+			&ioc->sas_device_list, list) {
 		if (!sas_device->responding)
-			mpt2sas_device_remove_by_sas_address(ioc,
-				sas_device->sas_address);
+			list_move_tail(&sas_device->list, &head);
 		else
 			sas_device->responding = 0;
 	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	/*
+	 * Now, uninitialize and remove the unresponding devices we pruned.
+	 */
+	list_for_each_entry_safe(sas_device, sas_device_next, &head, list) {
+		_scsih_remove_device(ioc, sas_device);
+		list_del_init(&sas_device->list);
+		sas_device_put(sas_device);
+	}
 
 	/* removing unresponding volumes */
 	if (ioc->ir_firmware) {
@@ -8055,6 +8071,37 @@ _scsih_probe_raid(struct MPT2SAS_ADAPTER *ioc)
 	}
 }
 
+static struct _sas_device *dequeue_next_sas_device(struct MPT2SAS_ADAPTER *ioc)
+{
+	struct _sas_device *sas_device = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	if (!list_empty(&ioc->sas_device_init_list)) {
+		sas_device = list_first_entry(&ioc->sas_device_init_list,
+				struct _sas_device, list);
+		list_del_init(&sas_device->list);
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	/*
+	 * If an item was dequeued, the caller now owns the reference that was
+	 * previously owned by the list
+	 */
+	return sas_device;
+}
+
+static void sas_device_make_active(struct MPT2SAS_ADAPTER *ioc,
+		struct _sas_device *sas_device)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device_get(sas_device);
+	list_add_tail(&sas_device->list, &ioc->sas_device_list);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+}
+
 /**
  * _scsih_probe_sas - reporting sas devices to sas transport
  * @ioc: per adapter object
@@ -8064,34 +8111,28 @@ _scsih_probe_raid(struct MPT2SAS_ADAPTER *ioc)
 static void
 _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
 {
-	struct _sas_device *sas_device, *next;
-	unsigned long flags;
-
-	/* SAS Device List */
-	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
-	    list) {
+	struct _sas_device *sas_device;
 
-		if (ioc->hide_drives)
-			continue;
+	if (ioc->hide_drives)
+		return;
 
+	while ((sas_device = dequeue_next_sas_device(ioc))) {
 		if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
-		    sas_device->sas_address_parent)) {
-			list_del(&sas_device->list);
-			kfree(sas_device);
+				sas_device->sas_address_parent)) {
+			sas_device_put(sas_device);
 			continue;
 		} else if (!sas_device->starget) {
 			if (!ioc->is_driver_loading) {
 				mpt2sas_transport_port_remove(ioc,
-					sas_device->sas_address,
-					sas_device->sas_address_parent);
-				list_del(&sas_device->list);
-				kfree(sas_device);
+						sas_device->sas_address,
+						sas_device->sas_address_parent);
+				sas_device_put(sas_device);
 				continue;
 			}
 		}
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		list_move_tail(&sas_device->list, &ioc->sas_device_list);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+		sas_device_make_active(ioc, sas_device);
+		sas_device_put(sas_device);
 	}
 }
 
-- 
1.8.1


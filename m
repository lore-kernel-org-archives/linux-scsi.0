From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 5/6] Refactor code to use new fw_event refcount
Date: Thu, 14 May 2015 20:42:01 -0700
Message-ID: <1431661322-3097935-6-git-send-email-calvinowens@fb.com>
References: <20150506184852.GA1007288@mail.thefacebook.com>
 <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8095 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933862AbbEODmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2015 23:42:45 -0400
In-Reply-To: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com

This refactors the fw_event code to use the new refcount.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 611b34d..8d8c814 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2863,6 +2863,7 @@ _scsih_fw_event_add(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		return;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	fw_event_work_get(fw_event);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
 	INIT_DELAYED_WORK(&fw_event->delayed_work, _firmware_event_work);
 	queue_delayed_work(ioc->firmware_event_thread,
@@ -2887,12 +2888,13 @@ _scsih_fw_event_free(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-	list_del(&fw_event->list);
-	kfree(fw_event);
+	if (!list_empty(&fw_event->list))
+		list_del_init(&fw_event->list);
+
+	fw_event_work_put(fw_event);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
-
 /**
  * _scsih_error_recovery_delete_devices - remove devices not responding
  * @ioc: per adapter object
@@ -2907,13 +2909,14 @@ _scsih_error_recovery_delete_devices(struct MPT2SAS_ADAPTER *ioc)
 	if (ioc->is_driver_loading)
 		return;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 
 	fw_event->event = MPT2SAS_REMOVE_UNRESPONDING_DEVICES;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -2927,12 +2930,13 @@ mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT2SAS_PORT_ENABLE_COMPLETE;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -4439,13 +4443,14 @@ _scsih_send_event_to_turn_on_pfa_led(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	struct fw_event_work *fw_event;
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(0);
 	if (!fw_event)
 		return;
 	fw_event->event = MPT2SAS_TURN_ON_PFA_LED;
 	fw_event->device_handle = handle;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 }
 
 /**
@@ -7740,7 +7745,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	}
 
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event = kzalloc(sizeof(*fw_event) + sz, GFP_ATOMIC);
+	fw_event = alloc_fw_event_work(sz);
 	if (!fw_event) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7753,6 +7758,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	fw_event->VP_ID = mpi_reply->VP_ID;
 	fw_event->event = event;
 	_scsih_fw_event_add(ioc, fw_event);
+	fw_event_work_put(fw_event);
 	return;
 }
 
-- 
1.8.1


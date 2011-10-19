From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] mpt2sas: Fix for system hang when discovery in progress
Date: Wed, 19 Oct 2011 10:21:05 +0530
Message-ID: <201110191057.p9JAv2w7027023@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38415 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab1JSK5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 06:57:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for issue : While discovery is in progress, hot unplug and hot plug of 
enclosure connected to the controller card is causing system to hang.

When a device is in the process of being detected at driver load time then 
if it is removed, the device that is no longer present will not be added 
to the list. So the code in _scsih_probe_sas() is rearranged as such so 
the devices that failed to be detected are not added to the list.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index bd9df3a..849fa84 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7657,22 +7657,27 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
 	/* SAS Device List */
 	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
 	    list) {
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		list_move_tail(&sas_device->list, &ioc->sas_device_list);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 		if (ioc->hide_drives)
 			continue;
 
 		if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
 		    sas_device->sas_address_parent)) {
-			_scsih_sas_device_remove(ioc, sas_device);
+			list_del(&sas_device->list);
+			kfree(sas_device);
+			continue;
 		} else if (!sas_device->starget) {
 			mpt2sas_transport_port_remove(ioc,
 			    sas_device->sas_address,
 			    sas_device->sas_address_parent);
-			_scsih_sas_device_remove(ioc, sas_device);
+			list_del(&sas_device->list);
+			kfree(sas_device);
+			continue;
+
 		}
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		list_move_tail(&sas_device->list, &ioc->sas_device_list);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
 }
 

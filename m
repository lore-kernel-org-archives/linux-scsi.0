From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 05/07] [SCSI] mpt2sas : Do not set sas_device->starget to
 NULL from the slave_destroy callback when all the LUNS have been deleted
Date: Thu, 1 Dec 2011 07:43:50 +0530
Message-ID: <201112010920.pB19KIsU018388@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57592 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab1LAJUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:20:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Do not set sas_device->starget to NULL from the slave_destroy callback
when all the LUNS have been deleted.

If the sas_device->starget to NULL from slave_destroy callback for LUN=1
even though LUN=0 exist, results in entire target getting deleted.  
To resolve the issue, the driver should only set sas_device->starget to 
NULL when all the LUNS have been deleted from the slave_destroy.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 1ef05ee..0a1522b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -613,13 +613,17 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 	if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
 	     sas_device->sas_address_parent)) {
 		_scsih_sas_device_remove(ioc, sas_device);
-		} else if (!sas_device->starget) {
-			if (!ioc->is_driver_loading)
-				mpt2sas_transport_port_remove(ioc,
-				sas_device->sas_address,
-			    sas_device->sas_address_parent);
-			_scsih_sas_device_remove(ioc, sas_device);
-		}
+	} else if (!sas_device->starget) {
+		/* When asyn scanning is enabled, its not possible to remove
+		 * devices while scanning is turned on due to an oops in
+		 * scsi_sysfs_add_sdev()->add_device()->sysfs_addrm_start()
+		 */
+		if (!ioc->is_driver_loading)
+			mpt2sas_transport_port_remove(ioc,
+			sas_device->sas_address,
+			sas_device->sas_address_parent);
+		_scsih_sas_device_remove(ioc, sas_device);
+	}
 }
 
 /**
@@ -1450,7 +1454,7 @@ _scsih_slave_destroy(struct scsi_device *sdev)
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
 		   sas_target_priv_data->sas_address);
-		if (sas_device)
+		if (sas_device && !sas_target_priv_data->num_luns)
 			sas_device->starget = NULL;
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}

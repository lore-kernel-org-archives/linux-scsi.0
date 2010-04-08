From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/03] mpt2sas: Before removing sas_device search device in list for _scsih_sas_device_remove
Date: Thu, 8 Apr 2010 17:55:22 +0530
Message-ID: <20100408122510.GC17543@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58380 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758678Ab0DHNBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 09:01:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Fix a oops in _scsih_sas_device_remove.  The driver was attempting to
delete a object from the sas_device link list when the object was not
present.

Added sanity check for sas_device NULL dereference.
before deleting sas_device now driver will search device in list then
only it will follow device removal.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 8f594b7..47b5381 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -536,10 +536,15 @@ _scsih_sas_device_remove(struct MPT2SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
+	if (!sas_device)
+		return;
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	list_del(&sas_device->list);
-	memset(sas_device, 0, sizeof(struct _sas_device));
-	kfree(sas_device);
+	if (mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_device->sas_address)) {
+		list_del(&sas_device->list);
+		kfree(sas_device);
+	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 }
 

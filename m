From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : Do not reset handle before calling _scsih_remove_device in RESCAN task after HBA RESET
Date: Wed, 17 Mar 2010 15:20:37 +0530
Message-ID: <20100317094954.GB21081@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:43598 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab0CQKVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 06:21:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


This patch needs to be apply on top of 04.100.01.02 version of mpt2sas driver.

Setting handle to zero is not required before _scsih_remove_device.
Driver uses sas_device->handle reference in _scsih_remove_device.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b2d6d75..c62adda 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5635,8 +5635,6 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 			    (unsigned long long)
 			    sas_device->enclosure_logical_id,
 			    sas_device->slot);
-		/* invalidate the device handle */
-		sas_device->handle = 0;
 		_scsih_remove_device(ioc, sas_device);
 	}
 

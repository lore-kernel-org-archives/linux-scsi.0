From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 6/8][SCSI] mpt2sas: when Async scanning is enabled then while
 scanning, devices are removed but their transport layer entries are not
 removed
Date: Thu, 25 Jul 2013 11:31:12 +0530
Message-ID: <20130725060112.GA29907@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:11026
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab3GYGAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 02:00:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com

When Async scanning mode is enabled and device scanning is in progress then
devices should not be removed. But in actuality, devices are removed but
their transport layer entries are not removed. This causes error to add
the same device to the transport layer after host reset or diagnostic
reset.

So, in this patch, modified the code in such a way that device is not removed
when Async scanning mode is enabled and device scanning is in progress.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b7f8229..5bd5d05 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -628,11 +628,12 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 		 * devices while scanning is turned on due to an oops in
 		 * scsi_sysfs_add_sdev()->add_device()->sysfs_addrm_start()
 		 */
-		if (!ioc->is_driver_loading)
+		if (!ioc->is_driver_loading) {
 			mpt2sas_transport_port_remove(ioc,
 			sas_device->sas_address,
 			sas_device->sas_address_parent);
-		_scsih_sas_device_remove(ioc, sas_device);
+			_scsih_sas_device_remove(ioc, sas_device);
+		}
 	}
 }
 
@@ -7916,10 +7917,12 @@ _scsih_probe_boot_devices(struct MPT2SAS_ADAPTER *ioc)
 		    sas_device->sas_address_parent)) {
 			_scsih_sas_device_remove(ioc, sas_device);
 		} else if (!sas_device->starget) {
-			if (!ioc->is_driver_loading)
-				mpt2sas_transport_port_remove(ioc, sas_address,
+			if (!ioc->is_driver_loading) {
+				mpt2sas_transport_port_remove(ioc,
+					sas_address,
 					sas_address_parent);
-			_scsih_sas_device_remove(ioc, sas_device);
+				_scsih_sas_device_remove(ioc, sas_device);
+			}
 		}
 	}
 }
@@ -7972,14 +7975,14 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
 			kfree(sas_device);
 			continue;
 		} else if (!sas_device->starget) {
-			if (!ioc->is_driver_loading)
+			if (!ioc->is_driver_loading) {
 				mpt2sas_transport_port_remove(ioc,
 					sas_device->sas_address,
 					sas_device->sas_address_parent);
-			list_del(&sas_device->list);
-			kfree(sas_device);
-			continue;
-
+				list_del(&sas_device->list);
+				kfree(sas_device);
+				continue;
+			}
 		}
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
-- 
1.7.3



From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 6/7][SCSI] mpt3sas: when async scanning is enabled then while
 scanning, devices are removed but their transport layer entries are not
 removed
Date: Sat, 29 Jun 2013 03:54:51 +0530
Message-ID: <20130628222451.GA5066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:19545
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab3F1L34 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 07:29:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com


When Async scanning mode is enabled and device scanning is in progress, 
devices should not be removed. But in actuality, devices are removed but
their transport layer entries are not removed. This causes error to add
the same device to the transport layer after host reset or diagnostic
reset.

So, in this patch, modified the code in such a way that device is not removed
when Async scanning mode is enabled and device scanning is in progress.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 632eba7..8cbe8fd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -675,11 +675,12 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 		 * devices while scanning is turned on due to an oops in
 		 * scsi_sysfs_add_sdev()->add_device()->sysfs_addrm_start()
 		 */
-		if (!ioc->is_driver_loading)
+		if (!ioc->is_driver_loading) {
 			mpt3sas_transport_port_remove(ioc,
 			    sas_device->sas_address,
 			    sas_device->sas_address_parent);
-		_scsih_sas_device_remove(ioc, sas_device);
+			_scsih_sas_device_remove(ioc, sas_device);
+		}
 	}
 }
 
@@ -7531,10 +7532,12 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 		    sas_address_parent)) {
 			_scsih_sas_device_remove(ioc, sas_device);
 		} else if (!sas_device->starget) {
-			if (!ioc->is_driver_loading)
-				mpt3sas_transport_port_remove(ioc, sas_address,
+			if (!ioc->is_driver_loading) {
+				mpt3sas_transport_port_remove(ioc,
+				    sas_address,
 				    sas_address_parent);
-			_scsih_sas_device_remove(ioc, sas_device);
+				_scsih_sas_device_remove(ioc, sas_device);
+			}
 		}
 	}
 }
@@ -7590,13 +7593,14 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 			 * oops in scsi_sysfs_add_sdev()->add_device()->
 			 * sysfs_addrm_start()
 			 */
-			if (!ioc->is_driver_loading)
+			if (!ioc->is_driver_loading) {
 				mpt3sas_transport_port_remove(ioc,
 				    sas_device->sas_address,
 				    sas_device->sas_address_parent);
-			list_del(&sas_device->list);
-			kfree(sas_device);
-			continue;
+				list_del(&sas_device->list);
+				kfree(sas_device);
+				continue;
+			}
 		}
 
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-- 
1.7.3



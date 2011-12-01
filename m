From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 05/08] [SCSI]  mpt2sas : Release spinlock for the raid
 device list before blocking it
Date: Thu, 1 Dec 2011 07:52:56 +0530
Message-ID: <201112010929.pB19TPpn021211@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39641 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab1LAJ33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:29:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Release spinlock for the raid device list before blocking it.

Added code to release the spinlock that is used to protect the
raid device list before calling a function that can block. The
blocking was causing a reschedule, and subsequently it is tried
to acquire the same lock, resulting in a panic (NMI Watchdog 
detecting a CPU lockup).

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: stable@kernel.org
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 97f0997..6b7b927 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6745,6 +6745,7 @@ _scsih_mark_responding_raid_device(struct MPT2SAS_ADAPTER *ioc, u64 wwid,
 			} else
 				sas_target_priv_data = NULL;
 			raid_device->responding = 1;
+			spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 			starget_printk(KERN_INFO, raid_device->starget,
 			    "handle(0x%04x), wwid(0x%016llx)\n", handle,
 			    (unsigned long long)raid_device->wwid);
@@ -6755,16 +6756,16 @@ _scsih_mark_responding_raid_device(struct MPT2SAS_ADAPTER *ioc, u64 wwid,
 			 */
 			_scsih_init_warpdrive_properties(ioc, raid_device);
 			if (raid_device->handle == handle)
-				goto out;
+				return;
 			printk(KERN_INFO "\thandle changed from(0x%04x)!!!\n",
 			    raid_device->handle);
 			raid_device->handle = handle;
 			if (sas_target_priv_data)
 				sas_target_priv_data->handle = handle;
-			goto out;
+			return;
 		}
 	}
- out:
+
 	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 }
 

From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] mpt2sas: Fix for dead lock occurring between host_lock
 and sas_device_lock
Date: Wed, 19 Oct 2011 10:22:53 +0530
Message-ID: <201110191058.p9JAwndd027325@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:35139 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab1JSK6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 06:58:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for dead lock occurring between host_lock and sas_device_lock.

The deadlock is between two spin locks, between the shost->host_lock 
and driver ioc->sas_device_lock.

The fix is to rearrange the code in the  FW/Driver device removal 
handshake so the ioc->sas_device_lock is not occurring when the  
shost->host_lock is taken.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index a84bde8..ea5e151 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3017,7 +3017,8 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	u16 smid;
 	struct _sas_device *sas_device;
-	struct MPT2SAS_TARGET *sas_target_priv_data;
+	struct MPT2SAS_TARGET *sas_target_priv_data = NULL;
+	u64 sas_address;
 	unsigned long flags;
 	struct _tr_list *delayed_tr;
 	u32 ioc_state;
@@ -3050,13 +3051,17 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	     sas_device->starget->hostdata) {
 		sas_target_priv_data = sas_device->starget->hostdata;
 		sas_target_priv_data->deleted = 1;
-		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
-		    "setting delete flag: handle(0x%04x), "
-		    "sas_addr(0x%016llx)\n", ioc->name, handle,
-		    (unsigned long long) sas_device->sas_address));
+		sas_address = sas_device->sas_address;
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
+	if (sas_target_priv_data) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "setting delete flag: "
+		"handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, handle,
+			(unsigned long long)sas_address));
+		_scsih_ublock_io_device(ioc, handle);
+	}
+
 	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_tr_cb_idx);
 	if (!smid) {
 		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);

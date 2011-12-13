From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] [SCSI] mpt2sas: Removed redundant calling of
 _scsih_probe_devices() from _scsih_probe
Date: Tue, 13 Dec 2011 09:29:15 +0530
Message-ID: <201112131105.pBDB5Ste026393@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36654 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab1LMLFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2011 06:05:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Removed redundant calling of _scsih_probe_devices() from _scsih_probe as 
it is getting called from _scsih_scan_finished.

Also moved the function scsi_scan_host(shost) to get called after the
volumes on warp drive are reported to the OS. Otherwise by the time 
the (ioc->hide_drives) flags is set, the volumes on warp drive 
are reported to the OS already.

Also modified the initialization of reply queues only in case of driver load 
time in the function _base_make_ioc_operational().

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index fceba1b..dca5a83 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c

@@ -8035,7 +8035,6 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_attach_fail;
 	}
 
-	scsi_scan_host(shost);
 	if (ioc->is_warpdrive) {
 		if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS)
 			ioc->hide_drives = 0;
@@ -8049,8 +8048,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	} else
 		ioc->hide_drives = 0;
+	scsi_scan_host(shost);
 
-	_scsih_probe_devices(ioc);
 	return 0;
 
  out_attach_fail:
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a691767..b1688c2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4113,7 +4113,8 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		ioc->reply_free[i] = cpu_to_le32(reply_address);
 
 	/* initialize reply queues */
-	_base_assign_reply_queues(ioc);
+	if (ioc->is_driver_loading)
+		_base_assign_reply_queues(ioc);
 
 	/* initialize Reply Post Free Queue */
 	reply_post_free = (long)ioc->reply_post_free;
@@ -4161,24 +4162,17 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 
 	if (ioc->is_driver_loading) {
-
-
-
-		ioc->wait_for_discovery_to_complete =
-		    _base_determine_wait_on_discovery(ioc);
-		return r; /* scan_start and scan_finished support */
-	}
-
-
-	if (ioc->wait_for_discovery_to_complete && ioc->is_warpdrive) {
-		if (ioc->manu_pg10.OEMIdentifier  == 0x80) {
+		if (ioc->is_warpdrive && ioc->manu_pg10.OEMIdentifier
+		    == 0x80) {
 			hide_flag = (u8) (ioc->manu_pg10.OEMSpecificFlags0 &
 			    MFG_PAGE10_HIDE_SSDS_MASK);
 			if (hide_flag != MFG_PAGE10_HIDE_SSDS_MASK)
 				ioc->mfg_pg10_hide_flag = hide_flag;
 		}
+		ioc->wait_for_discovery_to_complete =
+		    _base_determine_wait_on_discovery(ioc);
+		return r; /* scan_start and scan_finished support */
 	}
-
 	r = _base_send_port_enable(ioc, sleep_flag);
 	if (r)
 		return r;

From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 07/12] [SCSI] mpt2sas : Fix linux driver sparse errors
Date: Tue, 20 Mar 2012 12:07:48 +0530
Message-ID: <201203200637.q2K6bGjU032552@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:53128 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab2CTGhU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:37:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Fix  several endian issues found by runing sparse.


Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f9c885e..b43025d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4170,7 +4170,8 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	if (ioc->is_driver_loading) {
 		if (ioc->is_warpdrive && ioc->manu_pg10.OEMIdentifier
 		    == 0x80) {
-			hide_flag = (u8) (ioc->manu_pg10.OEMSpecificFlags0 &
+			hide_flag = (u8) (
+			    le32_to_cpu(ioc->manu_pg10.OEMSpecificFlags0) &
 			    MFG_PAGE10_HIDE_SSDS_MASK);
 			if (hide_flag != MFG_PAGE10_HIDE_SSDS_MASK)
 				ioc->mfg_pg10_hide_flag = hide_flag;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c37bfcf..0612ccb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1855,7 +1855,8 @@ _scsih_init_warpdrive_properties(struct MPT2SAS_ADAPTER *ioc,
 		if (mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
 		    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM,
 		    vol_pg0->PhysDisk[count].PhysDiskNum) ||
-		    pd_pg0.DevHandle == MPT2SAS_INVALID_DEVICE_HANDLE) {
+		     le16_to_cpu(pd_pg0.DevHandle) ==
+		    MPT2SAS_INVALID_DEVICE_HANDLE) {
 			printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is "
 			    "disabled for the drive with handle(0x%04x) member"
 			    "handle retrieval failed for member number=%d\n",
@@ -7435,14 +7436,14 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	case MPI2_EVENT_LOG_ENTRY_ADDED:
 	{
 		Mpi2EventDataLogEntryAdded_t *log_entry;
-		u32 *log_code;
+		__le32 *log_code;
 
 		if (!ioc->is_warpdrive)
 			break;
 
 		log_entry = (Mpi2EventDataLogEntryAdded_t *)
 		    mpi_reply->EventData;
-		log_code = (u32 *)log_entry->LogData;
+		log_code = (__le32 *)log_entry->LogData;
 
 		if (le16_to_cpu(log_entry->LogEntryQualifier)
 		    != MPT2_WARPDRIVE_LOGENTRY)

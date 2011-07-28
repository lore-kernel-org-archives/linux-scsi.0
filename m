From: David Miller <davem@davemloft.net>
Subject: [PATCH 2/2] mpt2sas: Fix various endianness errors.
Date: Wed, 27 Jul 2011 23:20:49 -0700 (PDT)
Message-ID: <20110727.232049.2024679456518886642.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50244 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1G1GUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 02:20:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kashyap.Desai@lsi.com, eric.moore@lsi.com


1) Manufacturing page 10's OEMSpecificFlags0 is 32-bit little endian, access
   with le32_to_cpu().

2) PD Page 0's DevHandle is 16-bit little endian, access with le16_to_cpu().

3) PrimaryReferenceTag is little, not big endian, 32-bit.

4) SAS IO-Unit Page 1 timeouts are 8-bit, so do not run them through
   le16_to_cpu().

5) In _scsih_add_device() and _scsih_search_responding_sas_devices(), the
   local variable "sas_address" holds cpu-endian values, so use "u64"
   to declare it instead of __le64.

6) In mpt2sas_scsih_event_callback, case MPI2_EVENT_LOG_ENTRY_ADDED, the
   log_code area holds 32-bit little-endian values and is accessed as
   such, therefore declare log_code as __le32 instead of u32.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   18 ++++++++----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 543cd07..830e357 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3781,7 +3781,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	if (ioc->wait_for_port_enable_to_complete && ioc->is_warpdrive) {
 		if (ioc->manu_pg10.OEMIdentifier  == 0x80) {
-			hide_flag = (u8) (ioc->manu_pg10.OEMSpecificFlags0 &
+			hide_flag = (u8) (le32_to_cpu(ioc->manu_pg10.OEMSpecificFlags0) &
 			    MFG_PAGE10_HIDE_SSDS_MASK);
 			if (hide_flag != MFG_PAGE10_HIDE_SSDS_MASK)
 				ioc->mfg_pg10_hide_flag = hide_flag;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 939f283..26a7156 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1784,7 +1784,7 @@ _scsih_init_warpdrive_properties(struct MPT2SAS_ADAPTER *ioc,
 		if (mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
 		    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM,
 		    vol_pg0->PhysDisk[count].PhysDiskNum) ||
-		    pd_pg0.DevHandle == MPT2SAS_INVALID_DEVICE_HANDLE) {
+		    le16_to_cpu(pd_pg0.DevHandle) == MPT2SAS_INVALID_DEVICE_HANDLE) {
 			printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is "
 			    "disabled for the drive with handle(0x%04x) member"
 			    "handle retrieval failed for member number=%d\n",
@@ -3577,7 +3577,7 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(scsi_get_lba(scmd));
+		    cpu_to_le32(scsi_get_lba(scmd));
 		break;
 
 	case SCSI_PROT_DIF_TYPE3:
@@ -4573,10 +4573,8 @@ _scsih_sas_host_add(struct MPT2SAS_ADAPTER *ioc)
 		goto out;
 	}
 
-	ioc->io_missing_delay =
-	    le16_to_cpu(sas_iounit_pg1->IODeviceMissingDelay);
-	device_missing_delay =
-	    le16_to_cpu(sas_iounit_pg1->ReportDeviceMissingDelay);
+	ioc->io_missing_delay = sas_iounit_pg1->IODeviceMissingDelay;
+	device_missing_delay = sas_iounit_pg1->ReportDeviceMissingDelay;
 	if (device_missing_delay & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
 		ioc->device_missing_delay = (device_missing_delay &
 		    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
@@ -5010,7 +5008,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 	Mpi2SasEnclosurePage0_t enclosure_pg0;
 	struct _sas_device *sas_device;
 	u32 ioc_status;
-	__le64 sas_address;
+	u64 sas_address;
 	u32 device_info;
 	unsigned long flags;
 
@@ -6501,7 +6499,7 @@ _scsih_search_responding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	Mpi2ConfigReply_t mpi_reply;
 	u16 ioc_status;
-	__le64 sas_address;
+	u64 sas_address;
 	u16 handle;
 	u32 device_info;
 	u16 slot;
@@ -7026,14 +7024,14 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
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
+		log_code = (__le32 __force *)log_entry->LogData;
 
 		if (le16_to_cpu(log_entry->LogEntryQualifier)
 		    != MPT2_WARPDRIVE_LOGENTRY)
-- 
1.7.6


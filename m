From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 5/8][SCSI] mpt2sas: Infinite loop can occur if
 MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Thu, 25 Jul 2013 11:29:45 +0530
Message-ID: <20130725055945.GA29898@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com
List-Id: linux-scsi@vger.kernel.org

Infinite loop can occur if IOCStatus is not equal to
MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value in the while loops in functions
_scsih_search_responding_sas_devices,
_scsih_search_responding_raid_devices and
_scsih_search_responding_expanders

So, Instead of checking for MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value,
in this patch code is modified to check for IOCStatus not equals to
MPI2_IOCSTATUS_SUCCESS to break the while loop.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6c86355..b7f8229 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6753,7 +6753,7 @@ _scsih_search_responding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
@@ -6862,7 +6862,7 @@ _scsih_search_responding_raid_devices(struct MPT2SAS_ADAPTER *ioc)
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 
@@ -6887,7 +6887,7 @@ _scsih_search_responding_raid_devices(struct MPT2SAS_ADAPTER *ioc)
 		    phys_disk_num))) {
 			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 			    MPI2_IOCSTATUS_MASK;
-			if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 				break;
 			phys_disk_num = pd_pg0.PhysDiskNum;
 			handle = le16_to_cpu(pd_pg0.DevHandle);
@@ -6967,7 +6967,7 @@ _scsih_search_responding_expanders(struct MPT2SAS_ADAPTER *ioc)
 
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 
 		handle = le16_to_cpu(expander_pg0.DevHandle);
@@ -7109,8 +7109,6 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 	    MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			printk(MPT2SAS_INFO_FMT "\tbreak from expander scan: "
 				"ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -7153,8 +7151,6 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 	    phys_disk_num))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan:"
 				"ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -7219,8 +7215,6 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: "
 				"ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -7278,8 +7272,6 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			printk(MPT2SAS_INFO_FMT "\tbreak from end device scan:"
 				" ioc_status(0x%04x), loginfo(0x%08x)\n",
-- 
1.7.3

From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 4/7][SCSI] mpt3sas: Infinite loops can occur if
 MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Sat, 29 Jun 2013 03:53:02 +0530
Message-ID: <20130628222302.GA5055@lsi.com>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 9ebc9dc..632eba7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6406,7 +6406,7 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
@@ -6508,7 +6508,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 
@@ -6532,7 +6532,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 		    phys_disk_num))) {
 			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 			    MPI2_IOCSTATUS_MASK;
-			if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 				break;
 			phys_disk_num = pd_pg0.PhysDiskNum;
 			handle = le16_to_cpu(pd_pg0.DevHandle);
@@ -6611,7 +6611,7 @@ _scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
 
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 
 		handle = le16_to_cpu(expander_pg0.DevHandle);
@@ -6756,8 +6756,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from expander scan: " \
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6801,8 +6799,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    phys_disk_num))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan: "\
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6868,8 +6864,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6928,8 +6922,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from end device scan:"\
 			    " ioc_status(0x%04x), loginfo(0x%08x)\n",
-- 
1.7.3

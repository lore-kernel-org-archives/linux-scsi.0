From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 11/13] mpt3sas: Fix nvme drives checking for tlr.
Date: Thu, 29 Jun 2017 19:49:12 +0530
Message-ID: <1498745954-7907-12-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Check for NVMe drives before enabling or checking tlr.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b96da33..4d71ef7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2013,6 +2013,14 @@ scsih_is_raid(struct device *dev)
 	return (sdev->channel == RAID_CHANNEL) ? 1 : 0;
 }
 
+static int
+scsih_is_nvme(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return (sdev->channel == PCIE_CHANNEL) ? 1 : 0;
+}
+
 /**
  * scsih_get_resync - get raid volume resync percent complete
  * @dev the device struct object
@@ -4810,8 +4818,9 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	/* Make sure Device is not raid volume.
 	 * We do not expose raid functionality to upper layer for warpdrive.
 	 */
-	if (!ioc->is_warpdrive && !scsih_is_raid(&scmd->device->sdev_gendev)
-	    && sas_is_tlr_enabled(scmd->device) && scmd->cmd_len != 32)
+	if (((!ioc->is_warpdrive && !scsih_is_raid(&scmd->device->sdev_gendev))
+		&& !scsih_is_nvme(&scmd->device->sdev_gendev))
+		&& sas_is_tlr_enabled(scmd->device) && scmd->cmd_len != 32)
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
 	smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
@@ -4856,8 +4865,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
-		    smid);
+		mpt3sas_setup_direct_io(ioc, scmd,
+			raid_device, mpi_request, smid);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -5405,9 +5414,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
 	if (!sas_device_priv_data->tlr_snoop_check) {
 		sas_device_priv_data->tlr_snoop_check++;
-		if (!ioc->is_warpdrive &&
+		if ((!ioc->is_warpdrive &&
 		    !scsih_is_raid(&scmd->device->sdev_gendev) &&
-		    sas_is_tlr_enabled(scmd->device) &&
+		    !scsih_is_nvme(&scmd->device->sdev_gendev))
+		    && sas_is_tlr_enabled(scmd->device) &&
 		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME) {
 			sas_disable_tlr(scmd->device);
 			sdev_printk(KERN_INFO, scmd->device, "TLR disabled\n");
-- 
1.7.1

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v5 12/14] mpt3sas: Fix nvme drives checking for tlr.
Date: Wed, 30 Aug 2017 19:38:36 +0530
Message-ID: <1504102118-7152-13-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Check for NVMe drives before enabling or checking tlr.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8754ade..aece862 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2014,6 +2014,14 @@ scsih_is_raid(struct device *dev)
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
@@ -4821,8 +4829,9 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
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
@@ -4867,8 +4876,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
-		    smid);
+		mpt3sas_setup_direct_io(ioc, scmd,
+			raid_device, mpi_request, smid);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -5416,9 +5425,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
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
2.5.5

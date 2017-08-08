From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 12/13] mpt3sas: Fix nvme drives checking for tlr.
Date: Tue,  8 Aug 2017 14:33:54 +0530
Message-ID: <1502183035-7441-13-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36570 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752594AbdHHJFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 05:05:46 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so1774314wmt.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2017 02:05:45 -0700 (PDT)
In-Reply-To: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org

Check for NVMe drives before enabling or checking tlr.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ff77850..49e1943 100644
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
@@ -4818,8 +4826,9 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
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
@@ -4864,8 +4873,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
-		    smid);
+		mpt3sas_setup_direct_io(ioc, scmd,
+			raid_device, mpi_request, smid);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -5413,9 +5422,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
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

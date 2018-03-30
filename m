From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 11/15] mpt3sas: Report Firmware Package Version from HBA  Driver.
Date: Fri, 30 Mar 2018 15:07:20 +0530
Message-ID: <1522402644-3016-12-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Added function _base_display_fwpkg_version, which sends FWUpload
request to pull FW package version from FW Image Header.
Now driver prints FW package version in addition to FW
version if the PackageVersion is valid.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 115 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h |   1 +
 2 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index dca0782..94c69aa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3825,6 +3825,111 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * _base_display_fwpkg_version - sends FWUpload request to pull FWPkg
+ *				version from FW Image Header.
+ * @ioc: per adapter object
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+	static int
+_base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2FWImageHeader_t *FWImgHdr;
+	Mpi25FWUploadRequest_t *mpi_request;
+	Mpi2FWUploadReply_t mpi_reply;
+	int r = 0;
+	void *fwpkg_data = NULL;
+	dma_addr_t fwpkg_data_dma;
+	u16 smid, ioc_status;
+	size_t data_length;
+
+	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				__func__));
+
+	if (ioc->base_cmds.status & MPT3_CMD_PENDING) {
+		pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
+				ioc->name, __func__);
+		return -EAGAIN;
+	}
+
+	data_length = sizeof(Mpi2FWImageHeader_t);
+	fwpkg_data = pci_alloc_consistent(ioc->pdev, data_length,
+			&fwpkg_data_dma);
+	if (!fwpkg_data) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+				ioc->name, __FILE__, __LINE__, __func__);
+		return -ENOMEM;
+	}
+
+	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+				ioc->name, __func__);
+		r = -EAGAIN;
+		goto out;
+	}
+
+	ioc->base_cmds.status = MPT3_CMD_PENDING;
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	ioc->base_cmds.smid = smid;
+	memset(mpi_request, 0, sizeof(Mpi25FWUploadRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_FW_UPLOAD;
+	mpi_request->ImageType = MPI2_FW_UPLOAD_ITYPE_FW_FLASH;
+	mpi_request->ImageSize = data_length;
+	ioc->build_sg(ioc, &mpi_request->SGL, 0, 0, fwpkg_data_dma,
+			data_length);
+	init_completion(&ioc->base_cmds.done);
+	mpt3sas_base_put_smid_default(ioc, smid);
+	/* Wait for 15 seconds */
+	wait_for_completion_timeout(&ioc->base_cmds.done,
+			FW_IMG_HDR_READ_TIMEOUT*HZ);
+	pr_info(MPT3SAS_FMT "%s: complete\n",
+			ioc->name, __func__);
+	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
+		pr_err(MPT3SAS_FMT "%s: timeout\n",
+				ioc->name, __func__);
+		_debug_dump_mf(mpi_request,
+				sizeof(Mpi25FWUploadRequest_t)/4);
+		r = -ETIME;
+	} else {
+		memset(&mpi_reply, 0, sizeof(Mpi2FWUploadReply_t));
+		if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID) {
+			memcpy(&mpi_reply, ioc->base_cmds.reply,
+					sizeof(Mpi2FWUploadReply_t));
+			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+						MPI2_IOCSTATUS_MASK;
+			if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
+				FWImgHdr = (Mpi2FWImageHeader_t *)fwpkg_data;
+				FWImgHdr->PackageVersion.Word =
+				    le32_to_cpu(FWImgHdr->PackageVersion.Word);
+				if (FWImgHdr->PackageVersion.Word) {
+					pr_info(MPT3SAS_FMT "FW Package Version"
+					"(%02d.%02d.%02d.%02d)\n",
+					ioc->name,
+					((FWImgHdr->PackageVersion.Word)
+							& 0xFF000000) >> 24,
+					((FWImgHdr->PackageVersion.Word)
+							& 0x00FF0000) >> 16,
+					((FWImgHdr->PackageVersion.Word)
+							& 0x0000FF00) >> 8,
+					(FWImgHdr->PackageVersion.Word)
+							& 0x000000FF);
+				}
+			} else {
+				_debug_dump_mf(&mpi_reply,
+						sizeof(Mpi2FWUploadReply_t)/4);
+			}
+		}
+	}
+	ioc->base_cmds.status = MPT3_CMD_NOT_USED;
+out:
+	if (fwpkg_data)
+		pci_free_consistent(ioc->pdev, data_length, fwpkg_data,
+				fwpkg_data_dma);
+	return r;
+}
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -6359,12 +6464,18 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
  skip_init_reply_post_host_index:
 
 	_base_unmask_interrupts(ioc);
+
+	if (ioc->hba_mpi_version_belonged != MPI2_VERSION) {
+		r = _base_display_fwpkg_version(ioc);
+		if (r)
+			return r;
+	}
+
+	_base_static_config_pages(ioc);
 	r = _base_event_notification(ioc);
 	if (r)
 		return r;
 
-	_base_static_config_pages(ioc);
-
 	if (ioc->is_driver_loading) {
 
 		if (ioc->is_warpdrive && ioc->manu_pg10.OEMIdentifier
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6f3329e..20fe90d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -138,6 +138,7 @@
 #define MAX_CHAIN_ELEMT_SZ		16
 #define DEFAULT_NUM_FWCHAIN_ELEMTS	8
 
+#define FW_IMG_HDR_READ_TIMEOUT	15
 /*
  * NVMe defines
  */
-- 
1.8.3.1

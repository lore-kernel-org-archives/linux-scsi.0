From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery issue with saturn adapter.")
Date: Tue, 28 Apr 2015 18:26:22 +1000
Message-ID: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, James Smart <james.smart@emulex.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This reverts 4fbdf9cb is breaks LPFC on POWER7 machine, big endian kernel.

This is the hardware used for verification:
0005:01:00.0 Fibre Channel [0c04]: Emulex Corporation Saturn-X: LightPulse Fibre Channel Host Adapter [10df:f100] (rev 03)
0005:01:00.1 Fibre Channel [0c04]: Emulex Corporation Saturn-X: LightPulse Fibre Channel Host Adapter [10df:f100] (rev 03)

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cb73cf9..c140f99 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1130,25 +1130,6 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 }
 
 /**
- * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
- * @data: A pointer to the immediate command data portion of the IOCB.
- * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
- *
- * The routine copies the entire FCP command from @fcp_cmnd to @data while
- * byte swapping the data to big endian format for transmission on the wire.
- **/
-static void
-lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
-{
-	int i, j;
-
-	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
-	     i += sizeof(uint32_t), j++) {
-		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
-	}
-}
-
-/**
  * lpfc_scsi_prep_dma_buf_s3 - DMA mapping for scsi buffer to SLI3 IF spec
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
@@ -1283,7 +1264,6 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	 * we need to set word 4 of IOCB here
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
-	lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	return 0;
 }
 
@@ -4147,6 +4127,24 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 }
 
 /**
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
+ * @data: A pointer to the immediate command data portion of the IOCB.
+ * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
+ *
+ * The routine copies the entire FCP command from @fcp_cmnd to @data while
+ * byte swapping the data to big endian format for transmission on the wire.
+ **/
+static void
+lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
+{
+	int i, j;
+	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
+	     i += sizeof(uint32_t), j++) {
+		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
+	}
+}
+
+/**
  * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
@@ -4225,6 +4223,9 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		fcp_cmnd->fcpCntl3 = 0;
 		phba->fc4ControlRequests++;
 	}
+	if (phba->sli_rev == 3 &&
+	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
+		lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	/*
 	 * Finish initializing those IOCB fields that are independent
 	 * of the scsi_cmnd request_buffer
-- 
2.0.0

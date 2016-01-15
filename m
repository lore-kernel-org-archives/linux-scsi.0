From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] be2iscsi: add checks for dma mapping errors
Date: Sat, 16 Jan 2016 00:45:34 +0300
Message-ID: <1452894334-8984-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

hwi_write_buffer() does not check if mapping dma memory succeed.
The patch adds the check and failure handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/be2iscsi/be_main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fe0c5143f8e6..1da9e31ea958 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2504,7 +2504,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
  * @pwrb: ptr to the WRB entry
  * @task: iscsi task which is to be executed
  **/
-static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
+static int hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 {
 	struct iscsi_sge *psgl;
 	struct beiscsi_io_task *io_task = task->dd_data;
@@ -2536,6 +2536,9 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 							     task->data,
 							     task->data_count,
 							     PCI_DMA_TODEVICE);
+			if (pci_dma_mapping_error(phba->pcidev,
+						  io_task->mtask_addr))
+				return -ENOMEM;
 			io_task->mtask_data_count = task->data_count;
 		} else
 			io_task->mtask_addr = 0;
@@ -2580,6 +2583,7 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, 0x106);
 	}
 	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
+	return 0;
 }
 
 /**
@@ -5025,6 +5029,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	unsigned int doorbell = 0;
 	unsigned int cid;
 	unsigned int pwrb_typeoffset = 0;
+	int ret = 0;
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
@@ -5073,7 +5078,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	case ISCSI_OP_LOGIN:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
 		ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
-		hwi_write_buffer(pwrb, task);
+		ret = hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_NOOP_OUT:
 		if (task->hdr->ttt != ISCSI_RESERVED_TAG) {
@@ -5093,19 +5098,19 @@ static int beiscsi_mtask(struct iscsi_task *task)
 				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
 					      dmsg, pwrb, 0);
 		}
-		hwi_write_buffer(pwrb, task);
+		ret = hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
 		ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
-		hwi_write_buffer(pwrb, task);
+		ret = hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
 		ADAPTER_SET_WRB_TYPE(pwrb, INI_TMF_CMD, pwrb_typeoffset);
-		hwi_write_buffer(pwrb, task);
+		ret = hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_LOGOUT:
 		ADAPTER_SET_WRB_TYPE(pwrb, HWH_TYPE_LOGOUT, pwrb_typeoffset);
-		hwi_write_buffer(pwrb, task);
+		ret = hwi_write_buffer(pwrb, task);
 		break;
 
 	default:
@@ -5116,6 +5121,9 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		return -EINVAL;
 	}
 
+	if (ret)
+		return ret;
+
 	/* Set the task type */
 	io_task->wrb_type = (is_chip_be2_be3r(phba)) ?
 		AMAP_GET_BITS(struct amap_iscsi_wrb, type, pwrb) :
-- 
1.9.1

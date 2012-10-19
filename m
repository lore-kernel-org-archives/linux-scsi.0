From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 03/19] be2iscsi: Fix memory leak in control path of driver
Date: Sat, 20 Oct 2012 04:42:00 +0530
Message-ID: <40a3d987-f9b3-4f05-935a-3b5446688499@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38739 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2JSXNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:13:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 In contorl path of the driver the task was mapped using
 pci_map_single which was not unmapped when the completion
 for the task had come.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   39 +++++++++++++++++++++++++++++----------
 drivers/scsi/be2iscsi/be_main.h |    2 ++
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b52c5c0..db3ea14 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2242,10 +2242,14 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
 }
 
+/**
+ * hwi_write_buffer()- Populate the WRB with task info
+ * @pwrb: ptr to the WRB entry
+ * @task: iscsi task which is to be executed
+ **/
 static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 {
 	struct iscsi_sge *psgl;
-	unsigned long long addr;
 	struct beiscsi_io_task *io_task = task->dd_data;
 	struct beiscsi_conn *beiscsi_conn = io_task->conn;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
@@ -2259,24 +2263,27 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 	if (task->data) {
 		if (task->data_count) {
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
-			addr = (u64) pci_map_single(phba->pcidev,
-						    task->data,
-						    task->data_count, 1);
+			io_task->mtask_addr = pci_map_single(phba->pcidev,
+							     task->data,
+							     task->data_count,
+							     PCI_DMA_TODEVICE);
+
+			io_task->mtask_data_count = task->data_count;
 		} else {
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
-			addr = 0;
+			io_task->mtask_addr = 0;
 		}
 		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_lo, pwrb,
-						((u32)(addr & 0xFFFFFFFF)));
+			      lower_32_bits(io_task->mtask_addr));
 		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_hi, pwrb,
-						((u32)(addr >> 32)));
+			      upper_32_bits(io_task->mtask_addr));
 		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_len, pwrb,
 						task->data_count);
 
 		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb, 1);
 	} else {
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
-		addr = 0;
+		io_task->mtask_addr = 0;
 	}
 
 	psgl = (struct iscsi_sge *)io_task->psgl_handle->pfrag;
@@ -2299,9 +2306,9 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 		psgl++;
 		if (task->data) {
 			AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
-						((u32)(addr & 0xFFFFFFFF)));
+				      lower_32_bits(io_task->mtask_addr));
 			AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
-						((u32)(addr >> 32)));
+				      upper_32_bits(io_task->mtask_addr));
 		}
 		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, 0x106);
 	}
@@ -3893,6 +3900,11 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 	kfree(phba->ep_array);
 }
 
+/**
+ * beiscsi_cleanup_task()- Free driver resources of the task
+ * @task: ptr to the iscsi task
+ *
+ **/
 static void beiscsi_cleanup_task(struct iscsi_task *task)
 {
 	struct beiscsi_io_task *io_task = task->dd_data;
@@ -3940,6 +3952,13 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 				spin_unlock(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = NULL;
 			}
+			if (io_task->mtask_addr) {
+				pci_unmap_single(phba->pcidev,
+						 io_task->mtask_addr,
+						 io_task->mtask_data_count,
+						 PCI_DMA_TODEVICE);
+				io_task->mtask_addr = 0;
+			}
 		}
 	}
 }
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b891226..f4e8d19 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -410,6 +410,8 @@ struct beiscsi_io_task {
 	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
 	unsigned short bhs_len;
+	dma_addr_t mtask_addr;
+	uint32_t mtask_data_count;
 };
 
 struct be_nonio_bhs {
-- 
1.7.2


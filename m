From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 4/7] be2iscsi : Fix memory check before unmapping.
Date: Fri, 17 Apr 2015 15:02:21 +0530
Message-ID: <60475e93-f33c-40e3-9461-7ed18d91a873@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:58883 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbDPRRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 13:17:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Check DMA memory before it is unmapped.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dca3a55..1fbbece 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1368,8 +1368,10 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 	if (io_task->cmd_bhs->iscsi_hdr.flags & ISCSI_FLAG_CMD_READ)
 		conn->rxdata_octets += resid;
 unmap:
-	scsi_dma_unmap(io_task->scsi_cmnd);
-	io_task->scsi_cmnd = NULL;
+	if (io_task->scsi_cmnd) {
+		scsi_dma_unmap(io_task->scsi_cmnd);
+		io_task->scsi_cmnd = NULL;
+	}
 	iscsi_complete_scsi_task(task, exp_cmdsn, max_cmdsn);
 }
 
@@ -4609,11 +4611,13 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 		spin_unlock_bh(&phba->mgmt_sgl_lock);
 	}
 
-	if (io_task->mtask_addr)
+	if (io_task->mtask_addr) {
 		pci_unmap_single(phba->pcidev,
 				 io_task->mtask_addr,
 				 io_task->mtask_data_count,
 				 PCI_DMA_TODEVICE);
+		io_task->mtask_addr = 0;
+	}
 }
 
 /**
-- 
1.7.1


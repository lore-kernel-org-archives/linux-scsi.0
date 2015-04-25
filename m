From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH V2 4/7] be2iscsi : Fix memory check before unmapping.
Date: Sat, 25 Apr 2015 08:17:45 +0530
Message-ID: <9d34f267-7ea4-4844-a844-165f05f3338c@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:16283 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbDXKWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 06:22:16 -0400
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


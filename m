From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] qla4xxx: Fix a sleep-in-atomic bug in qla4_82xx_crb_win_lock
Date: Mon, 19 Jun 2017 10:43:27 +0800
Message-ID: <1497840207-4757-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:32964 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753227AbdFSCkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jun 2017 22:40:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qlogic-storage-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>

The driver may sleep under a write spin lock, the function call path is:
qla4_82xx_wr_32 (acquire the lock)
  qla4_82xx_crb_win_lock
      schedule or cpu_relax

To fix it, the lock is released before "schedule" and "cpu_relax",
and the lock is acquired again after "schedule" and "cpu_relax".

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c   |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index bce96a5..b723bef 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -115,7 +115,7 @@ uint8_t qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 void qla4_82xx_queue_iocb(struct scsi_qla_host *ha);
 void qla4_82xx_complete_iocb(struct scsi_qla_host *ha);
 
-int qla4_82xx_crb_win_lock(struct scsi_qla_host *);
+int qla4_82xx_crb_win_lock(struct scsi_qla_host *, unsigned long *);
 void qla4_82xx_crb_win_unlock(struct scsi_qla_host *);
 int qla4_82xx_pci_get_crb_addr_2M(struct scsi_qla_host *, ulong *);
 void qla4_82xx_wr_32(struct scsi_qla_host *, ulong, u32);
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index e91abb3..1cf5f4a 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -386,7 +386,7 @@
 
 	if (rv == 1) {
 		write_lock_irqsave(&ha->hw_lock, flags);
-		qla4_82xx_crb_win_lock(ha);
+		qla4_82xx_crb_win_lock(ha, &flags);
 		qla4_82xx_pci_set_crbwindow_2M(ha, &off);
 	}
 
@@ -410,7 +410,7 @@ uint32_t qla4_82xx_rd_32(struct scsi_qla_host *ha, ulong off)
 
 	if (rv == 1) {
 		write_lock_irqsave(&ha->hw_lock, flags);
-		qla4_82xx_crb_win_lock(ha);
+		qla4_82xx_crb_win_lock(ha, &flags);
 		qla4_82xx_pci_set_crbwindow_2M(ha, &off);
 	}
 	data = readl((void __iomem *)off);
@@ -476,7 +476,7 @@ int qla4_82xx_md_wr_32(struct scsi_qla_host *ha, uint32_t off, uint32_t data)
 
 #define CRB_WIN_LOCK_TIMEOUT 100000000
 
-int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha)
+int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha, unsigned long *flags)
 {
 	int i;
 	int done = 0, timeout = 0;
@@ -491,6 +491,7 @@ int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha)
 
 		timeout++;
 
+		write_unlock_irqrestore(&ha->hw_lock, *flags);
 		/* Yield CPU */
 		if (!in_interrupt())
 			schedule();
@@ -498,6 +499,7 @@ int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha)
 			for (i = 0; i < 20; i++)
 				cpu_relax();    /*This a nop instr on i386*/
 		}
+		write_lock_irqsave(&ha->hw_lock, *flags);
 	}
 	qla4_82xx_wr_32(ha, QLA82XX_CRB_WIN_LOCK_ID, ha->func_num);
 	return 0;
-- 
1.7.9.5

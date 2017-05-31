From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] [PATCH] qla4xxx: Fix a sleep-in-atomic bug
Date: Wed, 31 May 2017 09:19:31 +0800
Message-ID: <1496193571-31682-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep under a write spin lock, the function call path is:
qla4_82xx_wr_32 (acquire the lock)
  qla4_82xx_crb_win_lock
      schedule or cpu_relax

To fixed it, the lock is released before "schedule" and "cpu_relax", 
and the lock is acquired again after "schedule" and "cpu_relax".

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index e91abb3..1cf5f4a 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -386,7 +386,7 @@
 
 	if (rv == 1) {
 		write_lock_irqsave(&ha->hw_lock, flags);
-		qla4_82xx_crb_win_lock(ha);
+		qla4_82xx_crb_win_lock(ha, flags);
 		qla4_82xx_pci_set_crbwindow_2M(ha, &off);
 	}
 
@@ -410,7 +410,7 @@ uint32_t qla4_82xx_rd_32(struct scsi_qla_host *ha, ulong off)
 
 	if (rv == 1) {
 		write_lock_irqsave(&ha->hw_lock, flags);
-		qla4_82xx_crb_win_lock(ha);
+		qla4_82xx_crb_win_lock(ha, flags);
 		qla4_82xx_pci_set_crbwindow_2M(ha, &off);
 	}
 	data = readl((void __iomem *)off);
@@ -476,7 +476,7 @@ int qla4_82xx_md_wr_32(struct scsi_qla_host *ha, uint32_t off, uint32_t data)
 
 #define CRB_WIN_LOCK_TIMEOUT 100000000
 
-int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha)
+int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha, unsigned long flags)
 {
 	int i;
 	int done = 0, timeout = 0;
@@ -491,6 +491,7 @@ int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha)
 
 		timeout++;
 
+		write_unlock_irqrestore(&ha->hw_lock, flags);
 		/* Yield CPU */
 		if (!in_interrupt())
 			schedule();
@@ -498,6 +499,7 @@ int qla4_82xx_crb_win_lock(struct scsi_qla_host *ha)
 			for (i = 0; i < 20; i++)
 				cpu_relax();    /*This a nop instr on i386*/
 		}
+		write_lock_irqsave(&ha->hw_lock, flags);
 	}
 	qla4_82xx_wr_32(ha, QLA82XX_CRB_WIN_LOCK_ID, ha->func_num);
 	return 0;
-- 
1.7.9.5

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/13] irq_poll: don't disable new irq_poll instances
Date: Mon,  7 Dec 2015 12:51:41 -0800
Message-ID: <1449521512-22921-3-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is no good reason to start out disabled - drivers can control if
the poll instance can be scheduled by simply not scheduling it yet.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/be2iscsi/be_main.c | 2 --
 drivers/scsi/ipr.c              | 2 --
 lib/irq_poll.c                  | 4 +---
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1d879ef..471e2b9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5581,7 +5581,6 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 		pbe_eq = &phwi_context->be_eq[i];
 		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget,
 				be_iopoll);
-		irq_poll_enable(&pbe_eq->iopoll);
 	}
 
 	i = (phba->msix_enabled) ? i : 0;
@@ -5754,7 +5753,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		pbe_eq = &phwi_context->be_eq[i];
 		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget,
 				be_iopoll);
-		irq_poll_enable(&pbe_eq->iopoll);
 	}
 
 	i = (phba->msix_enabled) ? i : 0;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 6b9c738..402e4ca 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3708,7 +3708,6 @@ static ssize_t ipr_store_iopoll_weight(struct device *dev,
 		for (i = 1; i < ioa_cfg->hrrq_num; i++) {
 			irq_poll_init(&ioa_cfg->hrrq[i].iopoll,
 					ioa_cfg->iopoll_weight, ipr_iopoll);
-			irq_poll_enable(&ioa_cfg->hrrq[i].iopoll);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
@@ -10407,7 +10406,6 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		for (i = 1; i < ioa_cfg->hrrq_num; i++) {
 			irq_poll_init(&ioa_cfg->hrrq[i].iopoll,
 					ioa_cfg->iopoll_weight, ipr_iopoll);
-			irq_poll_enable(&ioa_cfg->hrrq[i].iopoll);
 		}
 	}
 
diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index e6fd1dc..88af879 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -170,8 +170,7 @@ EXPORT_SYMBOL(irq_poll_enable);
  * @poll_fn:  The handler to invoke
  *
  * Description:
- *     Initialize this irq_poll structure. Before being actively used, the
- *     driver must call irq_poll_enable().
+ *     Initialize and enable this irq_poll structure.
  **/
 void irq_poll_init(struct irq_poll *iop, int weight, irq_poll_fn *poll_fn)
 {
@@ -179,7 +178,6 @@ void irq_poll_init(struct irq_poll *iop, int weight, irq_poll_fn *poll_fn)
 	INIT_LIST_HEAD(&iop->list);
 	iop->weight = weight;
 	iop->poll = poll_fn;
-	set_bit(IRQ_POLL_F_SCHED, &iop->state);
 }
 EXPORT_SYMBOL(irq_poll_init);
 
-- 
1.9.1

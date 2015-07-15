From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] csiostor: Use list_for_each_safe instead of re-implementing it
Date: Wed, 15 Jul 2015 22:53:26 +0200
Message-ID: <69b8506362a7564f7ec5cf8acb40197b634239e9.1436993298.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Use 'list_for_each_safe' instead of 'list_for_each' + own logic to keep
safe when a list entry is deleted.
Delete the now useless 'csio_list_prev' macro.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/csiostor/csio_defs.h |  1 -
 drivers/scsi/csiostor/csio_hw.c   | 10 ++++------
 drivers/scsi/csiostor/csio_scsi.c | 10 ++++------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_defs.h b/drivers/scsi/csiostor/csio_defs.h
index c38017b..4b3557c 100644
--- a/drivers/scsi/csiostor/csio_defs.h
+++ b/drivers/scsi/csiostor/csio_defs.h
@@ -70,7 +70,6 @@ csio_list_deleted(struct list_head *list)
 }
 
 #define csio_list_next(elem)	(((struct list_head *)(elem))->next)
-#define csio_list_prev(elem)	(((struct list_head *)(elem))->prev)
 
 /* State machine */
 typedef void (*csio_sm_state_t)(void *, uint32_t);
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdab..61ee6cb 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -3643,20 +3643,19 @@ static void
 csio_mgmt_tmo_handler(uintptr_t data)
 {
 	struct csio_mgmtm *mgmtm = (struct csio_mgmtm *) data;
-	struct list_head *tmp;
+	struct list_head *tmp, *next;
 	struct csio_ioreq *io_req;
 
 	csio_dbg(mgmtm->hw, "Mgmt timer invoked!\n");
 
 	spin_lock_irq(&mgmtm->hw->lock);
 
-	list_for_each(tmp, &mgmtm->active_q) {
+	list_for_each_safe(tmp, next, &mgmtm->active_q) {
 		io_req = (struct csio_ioreq *) tmp;
 		io_req->tmo -= min_t(uint32_t, io_req->tmo, ECM_MIN_TMO);
 
 		if (!io_req->tmo) {
 			/* Dequeue the request from retry Q. */
-			tmp = csio_list_prev(tmp);
 			list_del_init(&io_req->sm.sm_list);
 			if (io_req->io_cbfn) {
 				/* io_req will be freed by completion handler */
@@ -3680,7 +3679,7 @@ csio_mgmtm_cleanup(struct csio_mgmtm *mgmtm)
 {
 	struct csio_hw *hw = mgmtm->hw;
 	struct csio_ioreq *io_req;
-	struct list_head *tmp;
+	struct list_head *tmp, *next;
 	uint32_t count;
 
 	count = 30;
@@ -3692,9 +3691,8 @@ csio_mgmtm_cleanup(struct csio_mgmtm *mgmtm)
 	}
 
 	/* release outstanding req from ACTIVEQ */
-	list_for_each(tmp, &mgmtm->active_q) {
+	list_for_each_safe(tmp, next, &mgmtm->active_q) {
 		io_req = (struct csio_ioreq *) tmp;
-		tmp = csio_list_prev(tmp);
 		list_del_init(&io_req->sm.sm_list);
 		mgmtm->stats.n_active--;
 		if (io_req->io_cbfn) {
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 2c4562d..2bfb401 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2322,7 +2322,7 @@ csio_scsi_alloc_ddp_bufs(struct csio_scsim *scm, struct csio_hw *hw,
 			 int buf_size, int num_buf)
 {
 	int n = 0;
-	struct list_head *tmp;
+	struct list_head *tmp, *next;
 	struct csio_dma_buf *ddp_desc = NULL;
 	uint32_t unit_size = 0;
 
@@ -2370,9 +2370,8 @@ csio_scsi_alloc_ddp_bufs(struct csio_scsim *scm, struct csio_hw *hw,
 	return 0;
 no_mem:
 	/* release dma descs back to freelist and free dma memory */
-	list_for_each(tmp, &scm->ddp_freelist) {
+	list_for_each_safe(tmp, next, &scm->ddp_freelist) {
 		ddp_desc = (struct csio_dma_buf *) tmp;
-		tmp = csio_list_prev(tmp);
 		pci_free_consistent(hw->pdev, ddp_desc->len, ddp_desc->vaddr,
 				    ddp_desc->paddr);
 		list_del_init(&ddp_desc->list);
@@ -2393,13 +2392,12 @@ no_mem:
 static void
 csio_scsi_free_ddp_bufs(struct csio_scsim *scm, struct csio_hw *hw)
 {
-	struct list_head *tmp;
+	struct list_head *tmp, *next;
 	struct csio_dma_buf *ddp_desc;
 
 	/* release dma descs back to freelist and free dma memory */
-	list_for_each(tmp, &scm->ddp_freelist) {
+	list_for_each_safe(tmp, next, &scm->ddp_freelist) {
 		ddp_desc = (struct csio_dma_buf *) tmp;
-		tmp = csio_list_prev(tmp);
 		pci_free_consistent(hw->pdev, ddp_desc->len, ddp_desc->vaddr,
 				    ddp_desc->paddr);
 		list_del_init(&ddp_desc->list);
-- 
2.1.4

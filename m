From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH] drivers, scsi: convert fc_fcp_pkt.ref_cnt from atomic_t to refcount_t
Date: Thu,  9 Mar 2017 09:44:02 +0200
Message-ID: <1489045442-18738-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jth@kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, linux-kernel@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_fcp.c | 6 +++---
 include/scsi/libfc.h        | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 0e67621..a808e8e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -154,7 +154,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 		memset(fsp, 0, sizeof(*fsp));
 		fsp->lp = lport;
 		fsp->xfer_ddp = FC_XID_UNKNOWN;
-		atomic_set(&fsp->ref_cnt, 1);
+		refcount_set(&fsp->ref_cnt, 1);
 		init_timer(&fsp->timer);
 		fsp->timer.data = (unsigned long)fsp;
 		INIT_LIST_HEAD(&fsp->list);
@@ -175,7 +175,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
  */
 static void fc_fcp_pkt_release(struct fc_fcp_pkt *fsp)
 {
-	if (atomic_dec_and_test(&fsp->ref_cnt)) {
+	if (refcount_dec_and_test(&fsp->ref_cnt)) {
 		struct fc_fcp_internal *si = fc_get_scsi_internal(fsp->lp);
 
 		mempool_free(fsp, si->scsi_pkt_pool);
@@ -188,7 +188,7 @@ static void fc_fcp_pkt_release(struct fc_fcp_pkt *fsp)
  */
 static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
 {
-	atomic_inc(&fsp->ref_cnt);
+	refcount_inc(&fsp->ref_cnt);
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index da5033d..2109844 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -23,6 +23,7 @@
 #include <linux/timer.h>
 #include <linux/if.h>
 #include <linux/percpu.h>
+#include <linux/refcount.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
@@ -321,7 +322,7 @@ struct fc_seq_els_data {
  */
 struct fc_fcp_pkt {
 	spinlock_t	  scsi_pkt_lock;
-	atomic_t	  ref_cnt;
+	refcount_t	  ref_cnt;
 
 	/* SCSI command and data transfer information */
 	u32		  data_len;
-- 
2.7.4

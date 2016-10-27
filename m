From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc2
Date: Thu, 27 Oct 2016 07:58:54 -0700
Message-ID: <1477580334.3431.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two small fixes: one is a fatal section mismatch (reference to init
after it's discarded) and the other two are iscsi locking fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: NCR5380: no longer mark irq probing as __init

Jitendra Bhivare (2):
      scsi: be2iscsi: Replace _bh with _irqsave/irqrestore
      scsi: libiscsi: Fix locking in __iscsi_conn_send_pdu

And the diffstat:

 drivers/scsi/NCR5380.c          |  6 +++---
 drivers/scsi/be2iscsi/be_main.c | 37 +++++++++++++++++++++++--------------
 drivers/scsi/libiscsi.c         |  4 ++--
 3 files changed, 28 insertions(+), 19 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index db27390..790babc 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -353,7 +353,7 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
 #endif
 
 
-static int probe_irq __initdata;
+static int probe_irq;
 
 /**
  * probe_intr	-	helper for IRQ autoprobe
@@ -365,7 +365,7 @@ static int probe_irq __initdata;
  * used by the IRQ probe code.
  */
 
-static irqreturn_t __init probe_intr(int irq, void *dev_id)
+static irqreturn_t probe_intr(int irq, void *dev_id)
 {
 	probe_irq = irq;
 	return IRQ_HANDLED;
@@ -380,7 +380,7 @@ static irqreturn_t __init probe_intr(int irq, void *dev_id)
  * and then looking to see what interrupt actually turned up.
  */
 
-static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
+static int __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 						int possible)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 68138a6..d9239c2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -900,8 +900,9 @@ void hwi_ring_cq_db(struct beiscsi_hba *phba,
 static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&phba->io_sgl_lock);
+	spin_lock_irqsave(&phba->io_sgl_lock, flags);
 	if (phba->io_sgl_hndl_avbl) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 			    "BM_%d : In alloc_io_sgl_handle,"
@@ -919,14 +920,16 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 			phba->io_sgl_alloc_index++;
 	} else
 		psgl_handle = NULL;
-	spin_unlock_bh(&phba->io_sgl_lock);
+	spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 	return psgl_handle;
 }
 
 static void
 free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
-	spin_lock_bh(&phba->io_sgl_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&phba->io_sgl_lock, flags);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 		    "BM_%d : In free_,io_sgl_free_index=%d\n",
 		    phba->io_sgl_free_index);
@@ -941,7 +944,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			     "value there=%p\n", phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
-		 spin_unlock_bh(&phba->io_sgl_lock);
+		 spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 		return;
 	}
 	phba->io_sgl_hndl_base[phba->io_sgl_free_index] = psgl_handle;
@@ -950,7 +953,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->io_sgl_free_index = 0;
 	else
 		phba->io_sgl_free_index++;
-	spin_unlock_bh(&phba->io_sgl_lock);
+	spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 }
 
 static inline struct wrb_handle *
@@ -958,15 +961,16 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
 		       unsigned int wrbs_per_cxn)
 {
 	struct wrb_handle *pwrb_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&pwrb_context->wrb_lock);
+	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
 	pwrb_handle = pwrb_context->pwrb_handle_base[pwrb_context->alloc_index];
 	pwrb_context->wrb_handles_available--;
 	if (pwrb_context->alloc_index == (wrbs_per_cxn - 1))
 		pwrb_context->alloc_index = 0;
 	else
 		pwrb_context->alloc_index++;
-	spin_unlock_bh(&pwrb_context->wrb_lock);
+	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
 
 	if (pwrb_handle)
 		memset(pwrb_handle->pwrb, 0, sizeof(*pwrb_handle->pwrb));
@@ -1001,14 +1005,16 @@ beiscsi_put_wrb_handle(struct hwi_wrb_context *pwrb_context,
 		       struct wrb_handle *pwrb_handle,
 		       unsigned int wrbs_per_cxn)
 {
-	spin_lock_bh(&pwrb_context->wrb_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
 	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
 	pwrb_context->wrb_handles_available++;
 	if (pwrb_context->free_index == (wrbs_per_cxn - 1))
 		pwrb_context->free_index = 0;
 	else
 		pwrb_context->free_index++;
-	spin_unlock_bh(&pwrb_context->wrb_lock);
+	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
 }
 
 /**
@@ -1037,8 +1043,9 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&phba->mgmt_sgl_lock);
+	spin_lock_irqsave(&phba->mgmt_sgl_lock, flags);
 	if (phba->eh_sgl_hndl_avbl) {
 		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
 		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
@@ -1056,14 +1063,16 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 			phba->eh_sgl_alloc_index++;
 	} else
 		psgl_handle = NULL;
-	spin_unlock_bh(&phba->mgmt_sgl_lock);
+	spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 	return psgl_handle;
 }
 
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
-	spin_lock_bh(&phba->mgmt_sgl_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&phba->mgmt_sgl_lock, flags);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 		    "BM_%d : In  free_mgmt_sgl_handle,"
 		    "eh_sgl_free_index=%d\n",
@@ -1078,7 +1087,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			    "BM_%d : Double Free in eh SGL ,"
 			    "eh_sgl_free_index=%d\n",
 			    phba->eh_sgl_free_index);
-		spin_unlock_bh(&phba->mgmt_sgl_lock);
+		spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 		return;
 	}
 	phba->eh_sgl_hndl_base[phba->eh_sgl_free_index] = psgl_handle;
@@ -1088,7 +1097,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->eh_sgl_free_index = 0;
 	else
 		phba->eh_sgl_free_index++;
-	spin_unlock_bh(&phba->mgmt_sgl_lock);
+	spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 }
 
 static void
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c051694..f9b6fba 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -791,9 +791,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 free_task:
 	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
+	spin_lock(&session->back_lock);
 	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock(&session->back_lock);
 	return NULL;
 }
 

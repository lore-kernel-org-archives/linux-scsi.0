From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/20] fnic: Process all cq entries per ISR
Date: Wed, 21 Oct 2009 16:28:14 -0700
Message-ID: <20091021232814.12986.39089.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZJUX2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:28:09 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Herman Lee <hermlee@cisco.com>, Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

Driver was processing a fixed max number of cq descriptors per ISR. For
instance, for the SCSI IO queue, number of IOs processed per ISR were 8.
If hardware writes 9 cq descriptors to the cq and generates an interrupt,
driver would process only 8 descriptors and decrement the outstanding
credit count by 8. Unless another interrupt event happens, the hw does
not generate any additional interrupt. This results in the cq descriptor
sitting in the queue without being procesed and can cause IO timeouts
and aborts.

Modify all ISR functions to process all queued cq descriptors in one shot.
Since bulk of ELS frame processing is done in thread context and bulk
of SCSI IO processing is done in soft ISR deferred context, the cycles
spent in the ISR per cq descriptor is small.

Signed-off-by: Herman Lee <hermlee@cisco.com>
Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic_isr.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 2b30648..5c1f223 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -48,9 +48,9 @@ static irqreturn_t fnic_isr_legacy(int irq, void *data)
 	}
 
 	if (pba & (1 << FNIC_INTX_WQ_RQ_COPYWQ)) {
-		work_done += fnic_wq_copy_cmpl_handler(fnic, 8);
-		work_done += fnic_wq_cmpl_handler(fnic, 4);
-		work_done += fnic_rq_cmpl_handler(fnic, 4);
+		work_done += fnic_wq_copy_cmpl_handler(fnic, -1);
+		work_done += fnic_wq_cmpl_handler(fnic, -1);
+		work_done += fnic_rq_cmpl_handler(fnic, -1);
 
 		vnic_intr_return_credits(&fnic->intr[FNIC_INTX_WQ_RQ_COPYWQ],
 					 work_done,
@@ -66,9 +66,9 @@ static irqreturn_t fnic_isr_msi(int irq, void *data)
 	struct fnic *fnic = data;
 	unsigned long work_done = 0;
 
-	work_done += fnic_wq_copy_cmpl_handler(fnic, 8);
-	work_done += fnic_wq_cmpl_handler(fnic, 4);
-	work_done += fnic_rq_cmpl_handler(fnic, 4);
+	work_done += fnic_wq_copy_cmpl_handler(fnic, -1);
+	work_done += fnic_wq_cmpl_handler(fnic, -1);
+	work_done += fnic_rq_cmpl_handler(fnic, -1);
 
 	vnic_intr_return_credits(&fnic->intr[0],
 				 work_done,
@@ -83,7 +83,7 @@ static irqreturn_t fnic_isr_msix_rq(int irq, void *data)
 	struct fnic *fnic = data;
 	unsigned long rq_work_done = 0;
 
-	rq_work_done = fnic_rq_cmpl_handler(fnic, 4);
+	rq_work_done = fnic_rq_cmpl_handler(fnic, -1);
 	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_RQ],
 				 rq_work_done,
 				 1 /* unmask intr */,
@@ -97,7 +97,7 @@ static irqreturn_t fnic_isr_msix_wq(int irq, void *data)
 	struct fnic *fnic = data;
 	unsigned long wq_work_done = 0;
 
-	wq_work_done = fnic_wq_cmpl_handler(fnic, 4);
+	wq_work_done = fnic_wq_cmpl_handler(fnic, -1);
 	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_WQ],
 				 wq_work_done,
 				 1 /* unmask intr */,
@@ -110,7 +110,7 @@ static irqreturn_t fnic_isr_msix_wq_copy(int irq, void *data)
 	struct fnic *fnic = data;
 	unsigned long wq_copy_work_done = 0;
 
-	wq_copy_work_done = fnic_wq_copy_cmpl_handler(fnic, 8);
+	wq_copy_work_done = fnic_wq_copy_cmpl_handler(fnic, -1);
 	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_WQ_COPY],
 				 wq_copy_work_done,
 				 1 /* unmask intr */,


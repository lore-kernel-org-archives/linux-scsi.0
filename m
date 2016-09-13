From: Daniel Wagner <wagi@monom.org>
Subject: [PATCH 1/3] csiostor: fix completion usage
Date: Tue, 13 Sep 2016 10:58:48 +0200
Message-ID: <1473757130-14751-2-git-send-email-wagi@monom.org>
References: <1473757130-14751-1-git-send-email-wagi@monom.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473757130-14751-1-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
List-Id: linux-scsi@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

The (re)initialzing of the completion object should be done before we
trigger the transfer. Doing this after triggering the hardware opens up
a race window. Without the timeout we would problaly even deadlock. Use
also reinit_completion because we initalize the whole data structure in
csio_scscim_init().

There is only one waiter for the completion, therefore there is no need
to use complete_all(). Let's make that clear by using complete() instead
of complete_all().

The usage pattern of the completion is:

waiter context                          waker context

csio_eh_abort_handler()
  reinit_completion()
  wait_for_completion_timeout()

                                        csio_scsi_err_handler()
                                          complete()

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/scsi/csiostor/csio_scsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index c2a6f9f..89a52b9 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1721,7 +1721,7 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 
 	/* Wake up waiting threads */
 	csio_scsi_cmnd(req) = NULL;
-	complete_all(&req->cmplobj);
+	complete(&req->cmplobj);
 }
 
 /*
@@ -1945,6 +1945,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 	ready = csio_is_lnode_ready(ln);
 	tmo = CSIO_SCSI_ABRT_TMO_MS;
 
+	reinit_completion(&ioreq->cmplobj);
 	spin_lock_irq(&hw->lock);
 	rv = csio_do_abrt_cls(hw, ioreq, (ready ? SCSI_ABORT : SCSI_CLOSE));
 	spin_unlock_irq(&hw->lock);
@@ -1964,8 +1965,6 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		goto inval_scmnd;
 	}
 
-	/* Wait for completion */
-	init_completion(&ioreq->cmplobj);
 	wait_for_completion_timeout(&ioreq->cmplobj, msecs_to_jiffies(tmo));
 
 	/* FW didnt respond to abort within our timeout */
-- 
2.7.4

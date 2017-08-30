From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.13-rc6
Date: Wed, 30 Aug 2017 14:29:37 +0100
Message-ID: <1504099777.2928.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three minor fixes: a NULL deref in qedf, an off by one in sg and a fix
to IPR to prevent an error on initialisation.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (1):
      scsi: ipr: Set no_report_opcodes for RAID arrays

Christophe JAILLET (1):
      scsi: qedf: Fix a potential NULL pointer dereference

Dan Carpenter (1):
      scsi: sg: off by one in sg_ioctl()

And the diffstat:

 drivers/scsi/ipr.c           |  1 +
 drivers/scsi/qedf/qedf_els.c | 14 ++++++++------
 drivers/scsi/sg.c            |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index da5bdbdcce52..f838bd73befa 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4945,6 +4945,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 		}
 		if (ipr_is_vset_device(res)) {
 			sdev->scsi_level = SCSI_SPC_3;
+			sdev->no_report_opcodes = 1;
 			blk_queue_rq_timeout(sdev->request_queue,
 					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index eb07f1de8afa..59c18ca4cda9 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -489,7 +489,7 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 
 	/* If a SRR times out, simply free resources */
 	if (srr_req->event == QEDF_IOREQ_EV_ELS_TMO)
-		goto out_free;
+		goto out_put;
 
 	/* Normalize response data into struct fc_frame */
 	mp_req = &(srr_req->mp_req);
@@ -501,7 +501,7 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 	if (!fp) {
 		QEDF_ERR(&(qedf->dbg_ctx),
 		    "fc_frame_alloc failure.\n");
-		goto out_free;
+		goto out_put;
 	}
 
 	/* Copy frame header from firmware into fp */
@@ -526,9 +526,10 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 	}
 
 	fc_frame_free(fp);
-out_free:
+out_put:
 	/* Put reference for original command since SRR completed */
 	kref_put(&orig_io_req->refcount, qedf_release_cmd);
+out_free:
 	kfree(cb_arg);
 }
 
@@ -780,7 +781,7 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 
 	/* If a REC times out, free resources */
 	if (rec_req->event == QEDF_IOREQ_EV_ELS_TMO)
-		goto out_free;
+		goto out_put;
 
 	/* Normalize response data into struct fc_frame */
 	mp_req = &(rec_req->mp_req);
@@ -792,7 +793,7 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 	if (!fp) {
 		QEDF_ERR(&(qedf->dbg_ctx),
 		    "fc_frame_alloc failure.\n");
-		goto out_free;
+		goto out_put;
 	}
 
 	/* Copy frame header from firmware into fp */
@@ -884,9 +885,10 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 
 out_free_frame:
 	fc_frame_free(fp);
-out_free:
+out_put:
 	/* Put reference for original command since REC completed */
 	kref_put(&orig_io_req->refcount, qedf_release_cmd);
+out_free:
 	kfree(cb_arg);
 }
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d7ff71e0c85c..84e782d8e7c3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1021,7 +1021,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			val = 0;
 			list_for_each_entry(srp, &sfp->rq_list, entry) {
-				if (val > SG_MAX_QUEUE)
+				if (val >= SG_MAX_QUEUE)
 					break;
 				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
 				rinfo[val].req_state = srp->done + 1;

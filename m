From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] scsi: stop setting up request->special
Date: Fri,  1 Feb 2019 08:55:55 +0100
Message-ID: <20190201075557.9249-7-hch@lst.de>
References: <20190201075557.9249-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201075557.9249-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

No more need in a blk-mq world where the scsi command and request
are allocated together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qedf/qedf_io.c | 6 ------
 drivers/scsi/qedi/qedi_fw.c | 7 -------
 drivers/scsi/scsi_lib.c     | 3 ---
 drivers/scsi/sr.c           | 1 -
 4 files changed, 17 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 6bbc38b1b465..6ca583bdde23 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1128,12 +1128,6 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	if (!sc_cmd->request->special) {
-		QEDF_WARN(&(qedf->dbg_ctx), "request->special is NULL so "
-		    "request not valid, sc_cmd=%p.\n", sc_cmd);
-		return;
-	}
-
 	if (!sc_cmd->request->q) {
 		QEDF_WARN(&(qedf->dbg_ctx), "request->q is NULL so request "
 		   "is not valid, sc_cmd=%p.\n", sc_cmd);
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 25d763ae5d5a..e2a995a6e8e7 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -616,13 +616,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->request->special) {
-		QEDI_WARN(&qedi->dbg_ctx,
-			  "request->special is NULL so request not valid, sc_cmd=%p.\n",
-			  sc_cmd);
-		goto error;
-	}
-
 	if (!sc_cmd->request->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6fd1d8d83f07..7e256b384a99 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1568,10 +1568,7 @@ static blk_status_t scsi_mq_prep_fn(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	req->special = cmd;
-
 	cmd->request = req;
-
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 38ddbbfe5f3c..039c27c2d7b3 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -394,7 +394,6 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	ret = scsi_init_io(SCpnt);
 	if (ret != BLK_STS_OK)
 		goto out;
-	WARN_ON_ONCE(SCpnt != rq->special);
 	cd = scsi_cd(rq->rq_disk);
 
 	/* from here on until we're complete, any goto out
-- 
2.20.1

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/3] scsi: qedf: Fix a return value in case of error in 'qedf_alloc_global_queues'
Date: Sun, 11 Jun 2017 08:16:02 +0200
Message-ID: <7674c3a305022d1e30b7e7b744b673713fd50117.1497160148.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

We should return -ENOMEM in case of memory allocation error, as done
elsewhere in this function.

Fixes: 61d8658b4a435 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index aab3e2bd26a0..52a27100ca6d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2673,6 +2673,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 		if (!qedf->global_queues[i]) {
 			QEDF_WARN(&(qedf->dbg_ctx), "Unable to allocation "
 				   "global queue %d.\n", i);
+			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
-- 
2.11.0

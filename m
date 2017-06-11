From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] scsi: qedi: Fix a return value in case of error in 'qedi_alloc_global_queues'
Date: Sun, 11 Jun 2017 08:40:18 +0200
Message-ID: <aafc9e362592524150d11f61dc7ab0b49e75f698.1497162751.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

We should return -ENOMEM in case of memory allocation error, as done
elsewhere in this function.

Fixes: ace7f46ba5fde ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f46880315ba8..c81e494a9067 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1319,6 +1319,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		if (!qedi->global_queues[i]) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to allocation global queue %d.\n", i);
+			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
-- 
2.11.0

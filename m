From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: qla2xxx: remove unnecessary call to memset
Date: Mon, 11 Sep 2017 18:24:22 +0530
Message-ID: <1505134462-789-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: jejb@linux.vnet.ibm.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

call to memset to assign 0 value immediately after allocating
memory with kzalloc is unnecesaary as kzalloc allocates the memory
filled with 0 value.

Semantic patch used to resolve this issue:

@@
expression e,e2; constant c;
statement S;
@@

  e = kzalloc(e2, c);
  if(e == NULL) S
- memset(e, 0, e2);

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b5b48dd..54c1d63 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7917,7 +7917,6 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 			    "Failed to allocate memory for queue pair.\n");
 			return NULL;
 		}
-		memset(qpair, 0, sizeof(struct qla_qpair));
 
 		qpair->hw = vha->hw;
 		qpair->vha = vha;
-- 
2.7.4

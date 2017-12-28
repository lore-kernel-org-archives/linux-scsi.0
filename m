From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 13/37] qla2xxx: Don't call dma_free_coherent with IRQ disabled.
Date: Thu, 28 Dec 2017 12:33:21 -0800
Message-ID: <20171228203345.2702-14-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0056.outbound.protection.outlook.com ([104.47.41.56]:29094
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755090AbdL1UeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:06 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@cavium.com>

The logo ELS command allocates dma coherent memory for the
data payload and serialize the completions. When this command
times out, the timeout routine completes the thread waiting
for completion which in turn cleanup resources allocated for
this ELS command processing. Don't call generic sp->free
routine when this ELS command times out to avoid to double
freeing of the same resources.

Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 56bff7856cf8..4e6d3eb4caa4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -59,7 +59,8 @@ qla2x00_sp_timeout(struct timer_list *t)
 	req->outstanding_cmds[sp->handle] = NULL;
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
-	sp->free(sp);
+	if (sp->type != SRB_ELS_DCMD)
+		sp->free(sp);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 }
 
-- 
2.12.0

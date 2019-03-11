From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 43/52] scsi: qla2xxx: Fix panic from use after free in qla2x00_async_tm_cmd
Date: Mon, 11 Mar 2019 15:55:07 -0400
Message-ID: <20190311195516.137772-43-sashal@kernel.org>
References: <20190311195516.137772-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311195516.137772-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bill Kuzeja <William.Kuzeja@stratus.com>, Bill Kuzeja <william.kuzeja@stratus.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Bill Kuzeja <William.Kuzeja@stratus.com>

[ Upstream commit 388a49959ee4e4e99f160241d9599efa62cd4299 ]

In qla2x00_async_tm_cmd, we reference off sp after it has been freed.  This
caused a panic on a system running a slub debug kernel. Since fcport is
passed in anyways, just use that instead.

Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
Acked-by: Giridhar Malavali <gmalavali@marvell.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index eb59c796a795..1986b3347a01 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1787,13 +1787,13 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 		/* Issue Marker IOCB */
 		qla2x00_marker(vha, vha->hw->req_q_map[0],
-		    vha->hw->rsp_q_map[0], sp->fcport->loop_id, lun,
+		    vha->hw->rsp_q_map[0], fcport->loop_id, lun,
 		    flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
 	}
 
 done_free_sp:
 	sp->free(sp);
-	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
-- 
2.19.1

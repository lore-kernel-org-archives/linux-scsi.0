From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: [PATCH 2/2] scsi: qla2xxx: do not use __constant_cpu_to_leXX
Date: Thu, 14 Mar 2019 15:36:56 +0900
Message-ID: <20190314063656.25561-2-sergey.senozhatsky@gmail.com>
References: <20190314063656.25561-1-sergey.senozhatsky@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314063656.25561-1-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, QLogic-Storage-Upstream@qlogic.com, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
List-Id: linux-scsi@vger.kernel.org

A trivial patch.

cpu_to_le32() and cpu_to_le16() are capable enough to detect
__builtin_constant_p() and to use an appropriate compile time
___constant_swahbXX() functions.

So we can use cpu_to_leXX() instead of __constant_cpu_to_leXX().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 582d1663f971..e839c80fb9a9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3623,12 +3623,12 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
 	if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
 		nack->u.isp24.flags = ntfy->u.isp24.flags &
-			__constant_cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
+			cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
 	}
 
 	/* terminate */
 	nack->u.isp24.flags |=
-		__constant_cpu_to_le16(NOTIFY_ACK_FLAGS_TERMINATE);
+		cpu_to_le16(NOTIFY_ACK_FLAGS_TERMINATE);
 
 	nack->u.isp24.srr_rx_id = ntfy->u.isp24.srr_rx_id;
 	nack->u.isp24.status = ntfy->u.isp24.status;
-- 
2.21.0

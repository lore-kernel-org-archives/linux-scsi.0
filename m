From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 25/43] qla2xxx: Reduce trace noise for Async Events
Date: Tue, 19 Dec 2017 22:56:26 -0800
Message-ID: <20171220065644.21511-26-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0067.outbound.protection.outlook.com ([104.47.40.67]:41459
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932463AbdLTG5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:18 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add NPIV id check to reduce multiple debug messages
of the same RSCN event.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 12a29eca02e1..11a424df5f52 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -265,13 +265,20 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 			case MBA_LIP_RESET:
 			case MBA_POINT_TO_POINT:
 			case MBA_CHG_IN_CONNECTION:
-			case MBA_PORT_UPDATE:
-			case MBA_RSCN_UPDATE:
 				ql_dbg(ql_dbg_async, vha, 0x5024,
 				    "Async_event for VP[%d], mb=0x%x vha=%p.\n",
 				    i, *mb, vha);
 				qla2x00_async_event(vha, rsp, mb);
 				break;
+			case MBA_PORT_UPDATE:
+			case MBA_RSCN_UPDATE:
+				if ((mb[3] & 0xff) == vha->vp_idx) {
+					ql_dbg(ql_dbg_async, vha, 0x5024,
+					    "Async_event for VP[%d], mb=0x%x vha=%p\n",
+					    i, *mb, vha);
+					qla2x00_async_event(vha, rsp, mb);
+				}
+				break;
 			}
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
-- 
2.12.0

From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 21/37] qla2xxx: Reduce trace noise for Async Events
Date: Thu, 28 Dec 2017 12:33:29 -0800
Message-ID: <20171228203345.2702-22-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0079.outbound.protection.outlook.com ([104.47.40.79]:64384
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755090AbdL1UeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:13 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
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
index bf365f8a9d32..e965b16f21e3 100644
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

From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 29/43] qla2xxx: Fix GPNFT/GNNFT error handling
Date: Tue, 19 Dec 2017 22:56:30 -0800
Message-ID: <20171220065644.21511-30-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:33315
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932412AbdLTG5V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:21 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

retry gpnft/gnnft if error is encountered.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 15 +++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c |  8 ++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 0e84381e227e..0fcbdcaba127 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3927,6 +3927,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		ql_dbg(ql_dbg_disc, vha, 0xffff,
 		    "GPNFT failed. FC4type %x. Rescanning.\n",
 		    fc4type);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		goto out;
 	}
@@ -4036,6 +4037,19 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 	    "Async done-%s res %x FC4Type %x\n",
 	    sp->name, res, sp->gen2);
 
+	if (res) {
+		unsigned long flags;
+
+		ql_dbg(ql_dbg_disc, sp->vha, 0xffff,
+		    "Async done-%s timed out.\n",
+		    sp->name);
+		sp->free(sp);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		return;
+	}
+
 	if (!res) {
 		port_id_t id;
 		u64 wwn;
@@ -4097,6 +4111,7 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		    "Async done-%s unable to alloc work element\n",
 		    sp->name);
 		sp->free(sp);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		return;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 152c808b272b..e58faa1e984c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -683,15 +683,15 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 			}
 		}
 
-		id.b.domain = e->port_id[0];
+		id.b.domain = e->port_id[2];
 		id.b.area = e->port_id[1];
-		id.b.al_pa = e->port_id[2];
+		id.b.al_pa = e->port_id[0];
 		id.b.rsvd_1 = 0;
 
 		if (!found && wwn && !IS_SW_RESV_ADDR(id)) {
 			ql_dbg(ql_dbg_disc, vha, 0x2065,
-			    "%s %d %8phC post new sess\n",
-			    __func__, __LINE__, (u8 *)&wwn);
+			    "%s %d %8phC %06x post new sess\n",
+			    __func__, __LINE__, (u8 *)&wwn, id.b24);
 			wwnn = wwn_to_u64(e->node_name);
 			qla24xx_post_newsess_work(vha, &id, (u8 *)&wwn,
 			    (u8 *)&wwnn, NULL, FC4_TYPE_UNKNOWN);
-- 
2.12.0

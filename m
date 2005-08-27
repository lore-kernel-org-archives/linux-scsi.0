From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/16]  qla2xxx: Simplify redundant target/device reset logic.
Date: Fri, 26 Aug 2005 19:08:50 -0700 (PDT)
Message-ID: <20050827020850.27275.68211.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56679 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751615AbVH0CIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:08:51 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Simplify redundant target/device reset logic.

Remove redundant qla2x00_target_reset() function in favour of
the equivalent qla2x00_device_reset().  Update callers of
old function.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_gbl.h |    3 --
 drivers/scsi/qla2xxx/qla_mbx.c |   52 ----------------------------------------
 drivers/scsi/qla2xxx/qla_os.c  |    2 +-
 3 files changed, 1 insertions(+), 56 deletions(-)

3afc7a5ea763a249b0da88944967d4e52868c41c
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -148,9 +148,6 @@ qla2x00_abort_target(fc_port_t *);
 #endif
 
 extern int
-qla2x00_target_reset(scsi_qla_host_t *, struct fc_port *);
-
-extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
     uint8_t *, uint16_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -984,58 +984,6 @@ qla2x00_abort_target(fc_port_t *fcport)
 #endif
 
 /*
- * qla2x00_target_reset
- *	Issue target reset mailbox command.
- *
- * Input:
- *	ha = adapter block pointer.
- *	TARGET_QUEUE_LOCK must be released.
- *	ADAPTER_STATE_LOCK must be released.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_target_reset(scsi_qla_host_t *ha, struct fc_port *fcport)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("qla2x00_target_reset(%ld): entered.\n", ha->host_no);)
-
-	if (atomic_read(&fcport->state) != FCS_ONLINE)
-		return 0;
-
-	mcp->mb[0] = MBC_TARGET_RESET;
-	if (HAS_EXTENDED_IDS(ha))
-		mcp->mb[1] = fcport->loop_id;
-	else
-		mcp->mb[1] = fcport->loop_id << 8;
-	mcp->mb[2] = ha->loop_reset_delay;
-	mcp->out_mb = MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_target_reset(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
-	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_target_reset(%ld): done.\n",
-		    ha->host_no);)
-	}
-
-	return rval;
-}
-
-/*
  * qla2x00_get_adapter_id
  *	Get adapter ID and topology.
  *
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1022,7 +1022,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			status = qla2x00_target_reset(ha, fcport);
+			status = qla2x00_device_reset(ha, fcport);
 			if (status != QLA_SUCCESS)
 				break;
 		}

-- 
Andrew Vasquez

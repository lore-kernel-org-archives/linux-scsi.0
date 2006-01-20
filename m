From: andrew.vasquez@qlogic.com
Subject: [PATCH 3/3] qla2xxx: Drop legacy 'bypass lun scan for tape device' code.
Date: Fri, 20 Jan 2006 14:53:25 -0800
Message-ID: <11377976001141-git-send-email-andrew.vasquez@qlogic.com>
References: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56241 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932267AbWATWxZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 17:53:25 -0500
In-Reply-To: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mdr@sgi.com
Cc: andrew.vasquez@qlogic.com

Internal lun discovery has been removed since fc_transport
integration.  Short-circuiting for tape-devices in
qla2x00_update_fcport() could inadvertently result in a
blocked rport timing-out and its targets being reaped.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_init.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

19f42106b0d65287d0cb4cd35198307595e2b9d1
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 16c8892..e67bb09 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2041,10 +2041,6 @@ qla2x00_probe_for_all_luns(scsi_qla_host
 void
 qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
-	uint16_t	index;
-	unsigned long flags;
-	srb_t *sp;
-
 	fcport->ha = ha;
 	fcport->login_retry = 0;
 	fcport->port_login_retry_count = ha->port_down_retry_count *
@@ -2053,28 +2049,6 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 	    PORT_RETRY_TIME);
 	fcport->flags &= ~FCF_LOGIN_NEEDED;
 
-	/*
-	 * Check for outstanding cmd on tape Bypass LUN discovery if active
-	 * command on tape.
-	 */
-	if (fcport->flags & FCF_TAPE_PRESENT) {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
-			fc_port_t *sfcp;
-
-			if ((sp = ha->outstanding_cmds[index]) != 0) {
-				sfcp = sp->fcport;
-				if (sfcp == fcport) {
-					atomic_set(&fcport->state, FCS_ONLINE);
-					spin_unlock_irqrestore(
-					    &ha->hardware_lock, flags);
-					return;
-				}
-			}
-		}
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	}
-
 	if (fcport->port_type == FCT_INITIATOR ||
 	    fcport->port_type == FCT_BROADCAST)
 		fcport->device_type = TYPE_PROCESSOR;
-- 
1.1.4.ge755



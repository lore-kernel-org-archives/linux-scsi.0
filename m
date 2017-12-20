From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 26/43] qla2xxx: Fix login state machine freeze
Date: Tue, 19 Dec 2017 22:56:27 -0800
Message-ID: <20171220065644.21511-27-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0078.outbound.protection.outlook.com ([104.47.32.78]:54675
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932433AbdLTG5e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:34 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Relogin stop moving forward due to improper check of scan_state flag.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 300cd795dad4..152c808b272b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1270,11 +1270,6 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 {
 	fc_port_t *fcport = ea->fcport;
 
-	if (fcport->scan_state != QLA_FCPORT_FOUND) {
-		fcport->login_retry++;
-		return;
-	}
-
 	ql_dbg(ql_dbg_disc, vha, 0x2102,
 	    "%s %8phC DS %d LS %d P %d del %d cnfl %p rscn %d|%d login %d|%d fl %x\n",
 	    __func__, fcport->port_name, fcport->disc_state,
@@ -1324,7 +1319,6 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	int rc;
 
 	switch (ea->event) {
-	case FCME_RELOGIN:
 	case FCME_RSCN:
 	case FCME_GIDPN_DONE:
 	case FCME_GPSC_DONE:
-- 
2.12.0

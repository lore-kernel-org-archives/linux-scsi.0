From: madhu.iyengar@qlogic.com
Subject: [PATCH 02/18] qla2xxx: Correct calling contexts of qla2x00_mark_device_lost() in async paths.
Date: Wed, 30 Mar 2011 11:46:17 -0700
Message-ID: <1301510793-2492-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45774 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755571Ab1C3SvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:13 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The respective done() functions are called from process context,
so there's no reason to 'defer' the request.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8575808..394d03d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -397,7 +397,7 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 		if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		else
-			qla2x00_mark_device_lost(vha, fcport, 1, 1);
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
 		break;
 	case MBS_PORT_ID_USED:
 		fcport->loop_id = data[1];
@@ -409,7 +409,7 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 		rval = qla2x00_find_new_loop_id(vha, fcport);
 		if (rval != QLA_SUCCESS) {
 			fcport->flags &= ~FCF_ASYNC_SENT;
-			qla2x00_mark_device_lost(vha, fcport, 1, 1);
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
 			break;
 		}
 		qla2x00_post_async_login_work(vha, fcport, NULL);
@@ -441,7 +441,7 @@ qla2x00_async_adisc_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 	else
-		qla2x00_mark_device_lost(vha, fcport, 1, 1);
+		qla2x00_mark_device_lost(vha, fcport, 1, 0);
 
 	return;
 }
-- 
1.6.0.2


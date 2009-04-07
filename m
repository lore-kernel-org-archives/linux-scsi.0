From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/15] qla2xxx: Correct bus-reset behaviour with recent ISPs.
Date: Mon,  6 Apr 2009 22:33:37 -0700
Message-ID: <1239082431-19496-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZDGFdx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:33:53 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

The short-circuit to skip the non-applicable 'full-login-lip'
process on 81xx ISPs was nested too deeply in the 'bus-reset'
routine, as the code in qla2x00_loop_reset() should skip the
whole enable_lip_full_login process.  The original code could
cause device tear-down due to the qla2x00_wait_for_loop_ready()
call taking a large amount of time.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ---
 drivers/scsi/qla2xxx/qla_os.c  |    3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e67c166..1458438 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1864,9 +1864,6 @@ qla2x00_full_login_lip(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (IS_QLA81XX(vha->hw))
-	    return QLA_SUCCESS;
-
 	DEBUG11(printk("qla2x00_full_login_lip(%ld): entered.\n",
 	    vha->host_no));
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index efe2992..f67c842 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1037,7 +1037,8 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (ha->flags.enable_lip_full_login && !vha->vp_idx) {
+	if (ha->flags.enable_lip_full_login && !vha->vp_idx &&
+	    !IS_QLA81XX(ha)) {
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): failed: "
-- 
1.6.2.2.404.ge96f3


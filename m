From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 20/21] qla2xxx: Correct vport configuration-change handling.
Date: Thu,  3 Apr 2008 13:13:31 -0700
Message-ID: <1207253612-15538-20-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbYDCUNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:53 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Upon having configuration changes on vports only, the driver
handles SCR regardless physical port state and, in turn, it
results mailbox error as below:

	Mar 20 11:24:20 dl585 kernel: qla2x00_mailbox_command(9): **** FAILED.  mbx0=4005, mbx1=1, mbx2=8100, cmd=70 ****

With the changes, driver checks physical port loop_state and make
sure the port is ready to take commands.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 9f48cd4..f2b0497 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -254,9 +254,17 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
+	scsi_qla_host_t *ha = vha->parent;
+
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
-		qla24xx_configure_vp(vha);
+		if (atomic_read(&ha->loop_state) == LOOP_READY) {
+			qla24xx_configure_vp(vha);
+		} else {
+			set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
+			set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+		}
+
 		return 0;
 	}
 
-- 
1.5.5.rc2


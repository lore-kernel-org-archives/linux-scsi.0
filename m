From: madhu.iyengar@qlogic.com
Subject: [PATCH 1/3] qla2xxx: Remove check to return DID_NO_CONNECT when FC device is lost.
Date: Fri, 28 Jan 2011 15:17:55 -0800
Message-ID: <1296256677-11572-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59073 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753400Ab1A1XeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 18:34:03 -0500
In-Reply-To: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c194c23..5dc548b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -562,7 +562,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	}
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-			atomic_read(&fcport->state) == FCS_DEVICE_LOST ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
-- 
1.6.0.2


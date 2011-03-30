From: madhu.iyengar@qlogic.com
Subject: [PATCH 04/18] qla2xxx: Remove extraneous setting of FCF_ASYNC_SENT during login-done completion.
Date: Wed, 30 Mar 2011 11:46:19 -0700
Message-ID: <1301510793-2492-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45782 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755579Ab1C3SvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:14 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The bit is already set upon entry.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f98cfac..0f75fab 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -386,7 +386,6 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	switch (data[0]) {
 	case MBS_COMMAND_COMPLETE:
 		if (fcport->flags & FCF_FCP2_DEVICE) {
-			fcport->flags |= FCF_ASYNC_SENT;
 			qla2x00_post_async_adisc_work(vha, fcport, data);
 			break;
 		}
-- 
1.6.0.2


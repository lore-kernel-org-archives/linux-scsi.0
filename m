From: madhu.iyengar@qlogic.com
Subject: [PATCH 3/4] qla2xxx: Fix vport delete hang when logins are outstanding.
Date: Tue, 10 May 2011 11:18:17 -0700
Message-ID: <1305051498-16718-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1305051498-16718-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:38279 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751505Ab1EJSYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:24:35 -0400
In-Reply-To: <1305051498-16718-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>

From: Arun Easi <arun.easi@qlogic.com>

Timer is required to flush out entries that may be present in work queues.

Cc: stable@kernel.org
Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 75faf48..260c030 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1877,14 +1877,15 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	scsi_remove_host(vha->host);
 
+	/* Allow timer to run to drain queued items, when removing vp */
+	qla24xx_deallocate_vp_id(vha);
+
 	if (vha->timer_active) {
 		qla2x00_vp_stop_timer(vha);
 		DEBUG15(printk(KERN_INFO "scsi(%ld): timer for the vport[%d]"
 		" = %p has stopped\n", vha->host_no, vha->vp_idx, vha));
 	}
 
-	qla24xx_deallocate_vp_id(vha);
-
 	/* No pending activities shall be there on the vha now */
 	DEBUG(msleep(random32()%10));  /* Just to see if something falls on
 					* the net we have placed below */
-- 
1.6.0.2


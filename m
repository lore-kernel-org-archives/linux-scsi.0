From: giridhar.malavali@qlogic.com
Subject: [PATCH 01/17] qla2xxx: Don't issue set or get port param MBC if invalid port loop id
Date: Fri, 23 Jul 2010 15:28:22 +0500
Message-ID: <1279880918-62876-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47926 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753435Ab0GWJ67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:58:59 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 3a02483..20eaa1c 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1222,6 +1222,13 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (fcport->loop_id == FC_NO_LOOP_ID) {
+		DEBUG2(printk(KERN_ERR "%s(%ld): Invalid port loop id, "
+			"loop_id = 0x%x\n",
+			__func__, vha->host_no, fcport->loop_id));
+		return -EINVAL;
+	}
+
 	if (port_param->mode)
 		rval = qla2x00_set_idma_speed(vha, fcport->loop_id,
 			port_param->speed, mb);
-- 
1.6.0.2


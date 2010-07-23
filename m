From: giridhar.malavali@qlogic.com
Subject: [PATCH 10/17] qla2xxx: Don't issue set or get port param MBC if remote port is not logged in
Date: Fri, 23 Jul 2010 15:28:31 +0500
Message-ID: <1279880918-62876-11-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47957 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:34 -0400
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
index d551ae1..518fccf 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1259,6 +1259,13 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (fcport->flags & FCF_LOGIN_NEEDED) {
+		DEBUG2(printk(KERN_ERR "%s(%ld): Remote port not logged in, "
+		    "flags = 0x%x\n",
+		    __func__, vha->host_no, fcport->flags));
+		return -EINVAL;
+	}
+
 	if (port_param->mode)
 		rval = qla2x00_set_idma_speed(vha, fcport->loop_id,
 			port_param->speed, mb);
-- 
1.6.0.2


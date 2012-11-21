From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 13/19] qla2xxx: Move marking fcport online ahead of setting iiDMA speed.
Date: Wed, 21 Nov 2012 02:40:38 -0500
Message-ID: <1353483644-17262-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:32601 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753533Ab2KUH64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:56 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7464a47..1b5f40d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3083,10 +3083,10 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fcport->login_retry = 0;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 	qla2x00_iidma_fcport(vha, fcport);
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
 	qla2x00_reg_remote_port(vha, fcport);
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 }
 
 /*
-- 
1.7.7


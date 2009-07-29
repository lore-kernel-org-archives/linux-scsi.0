From: giridhar.malavali@qlogic.com
Subject: [PATCH 13/14] qla2xxx: ISP21xx/22xx do not support FDMI registrations.  (fixed)
Date: Wed, 29 Jul 2009 11:04:02 -0700
Message-ID: <1248890643-761-14-git-send-email-giridhar.malavali@qlogic.com>
References: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35947 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbZG2SEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 14:04:06 -0400
In-Reply-To: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 917534b..4647015 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1674,6 +1674,10 @@ int
 qla2x00_fdmi_register(scsi_qla_host_t *vha)
 {
 	int rval;
+       struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return QLA_FUNCTION_FAILED;
 
 	rval = qla2x00_mgmt_svr_login(vha);
 	if (rval)
-- 
1.6.2.rc1.30.gd43c


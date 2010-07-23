From: giridhar.malavali@qlogic.com
Subject: [PATCH 08/17] qla2xxx: Stop firmware before doing init firmware.
Date: Fri, 23 Jul 2010 15:28:29 +0500
Message-ID: <1279880918-62876-9-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47950 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755702Ab0GWJ7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:25 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

If BIOS is enabled then drivers init firmware fails since
BIOS has done the init once.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 685c350..f6b1052 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1402,9 +1402,10 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 
 	if (IS_QLA82XX(ha)) {
 		rval = ha->isp_ops->load_risc(vha, &srisc_address);
-		if (rval == QLA_SUCCESS)
+		if (rval == QLA_SUCCESS) {
+			qla2x00_stop_firmware(vha);
 			goto enable_82xx_npiv;
-		else
+		} else
 			goto failed;
 	}
 
-- 
1.6.0.2


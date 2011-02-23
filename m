From: madhu.iyengar@qlogic.com
Subject: [PATCH 03/13] qla2xxx: Reinitialize the device initialize timeout value after reset on ISP82xx.
Date: Wed, 23 Feb 2011 15:27:08 -0800
Message-ID: <1298503638-22396-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52609 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755027Ab1BWXa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:29 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b37445d..4ff80ee 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3557,6 +3557,8 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			break;
 		case QLA82XX_DEV_NEED_RESET:
 			qla82xx_need_reset_handler(vha);
+			dev_init_timeout = jiffies +
+				(ha->nx_dev_init_timeout * HZ);
 			break;
 		case QLA82XX_DEV_NEED_QUIESCENT:
 			qla82xx_need_qsnt_handler(vha);
-- 
1.6.0.2


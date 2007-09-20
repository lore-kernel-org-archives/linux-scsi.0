From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/19] qla2xxx: Sparse cleanups in qla_mid.c
Date: Thu, 20 Sep 2007 14:07:47 -0700
Message-ID: <1190322470-15543-16-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXITVH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:57 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Make several needlessly global functions static:
- qla2x00_mark_vp_devices_dead()
- qla24xx_configure_vp()

Remove unused function qla24xx_modify_vport().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 1a2cdcd..821ee74 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -104,7 +104,7 @@ qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
  *
  * Context:
  */
-void
+static void
 qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 {
 	fc_port_t *fcport;
@@ -179,37 +179,7 @@ enable_failed:
 	return 1;
 }
 
-/**
- * qla24xx_modify_vport() -  Modifies the virtual fabric port's configuration
- * @ha: HA context
- * @vp: pointer to buffer of virtual port parameters.
- * @ret_code: return error code:
- *
- * Returns the virtual port id, or MAX_VSAN_ID, if couldn't create.
- */
-uint32_t
-qla24xx_modify_vhba(scsi_qla_host_t *ha, vport_params_t *vp, uint32_t *vp_id)
-{
-	scsi_qla_host_t *vha;
-
-	vha = qla24xx_find_vhost_by_name(ha, vp->port_name);
-	if (!vha) {
-		*vp_id = MAX_NUM_VPORT_LOOP;
-		return VP_RET_CODE_WWPN;
-	}
-
-	if (qla24xx_enable_vp(vha)) {
-		scsi_host_put(vha->host);
-		qla2x00_mem_free(vha);
-		*vp_id = MAX_NUM_VPORT_LOOP;
-		return VP_RET_CODE_RESOURCES;
-	}
-
-	*vp_id = vha->vp_idx;
-	return VP_RET_CODE_OK;
-}
-
-void
+static void
 qla24xx_configure_vp(scsi_qla_host_t *vha)
 {
 	struct fc_vport *fc_vport;
-- 
1.5.3.2.80.g077d6f


From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH] qla2xxx: Correct loop_id_map allocation-size and usage.
Date: Thu, 20 Sep 2012 03:39:34 -0400
Message-ID: <1348126774-3844-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:19711 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752506Ab2ITH5K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 03:57:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code incorrectly assigned LOOPID_MAP_SIZE to be the
allocation size in bytes rather than total bit size.
Additionally corrected code to check for bit-allocation failure
in qla2x00_find_new_loop_id().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3841fb18..a9725bf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -205,7 +205,7 @@
 #define MAX_FIBRE_DEVICES_2400	2048
 #define MAX_FIBRE_DEVICES_LOOP	128
 #define MAX_FIBRE_DEVICES_MAX	MAX_FIBRE_DEVICES_2400
-#define LOOPID_MAP_SIZE		(ha->max_fibre_devices / 8)
+#define LOOPID_MAP_SIZE		(ha->max_fibre_devices)
 #define MAX_FIBRE_LUNS  	0xFFFF
 #define	MAX_HOST_COUNT		16
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3c83934..799a58b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3440,8 +3440,8 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 
 	dev->loop_id = find_first_zero_bit(ha->loop_id_map,
 	    LOOPID_MAP_SIZE);
-
-	if (qla2x00_is_reserved_id(vha, dev->loop_id)) {
+	if (dev->loop_id >= LOOPID_MAP_SIZE ||
+	    qla2x00_is_reserved_id(vha, dev->loop_id)) {
 		dev->loop_id = FC_NO_LOOP_ID;
 		rval = QLA_FUNCTION_FAILED;
 	} else
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 84ddd30..c7dd298 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3220,7 +3220,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	INIT_LIST_HEAD(&ha->vp_list);
 
 	/* Allocate memory for our loop_id bitmap */
-	ha->loop_id_map = kzalloc(LOOPID_MAP_SIZE, GFP_KERNEL);
+	ha->loop_id_map = kzalloc(BITS_TO_LONGS(LOOPID_MAP_SIZE) * sizeof(long),
+	    GFP_KERNEL);
 	if (!ha->loop_id_map)
 		goto fail_async_pd;
 	else {
-- 
1.7.7


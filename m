From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/11] qla2xxx: Access the proper 'physical' port in FC-transport callbacks.
Date: Thu, 31 Jan 2008 12:33:52 -0800
Message-ID: <1201811634-19865-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760587AbYAaUeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:10 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

 For following fc_host specific attributes, vports rely on the pport.
 So, this patch changed way to access the data for those attributes so that
 they can access pport's.
 - get_host_speed (speed)
 - get_host_port_state (port_state)
 - get_host_port_type (port_type)
 - get_fc_host_stats

Also, added PORT_SPEED_8GB case in the speed attribute for 8Gb HBAs.

Signed-Off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |   11 +++++++----
 drivers/scsi/qla2xxx/qla_def.h    |    2 --
 drivers/scsi/qla2xxx/qla_inline.h |    7 +++++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1dd8591..4894dc8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -848,7 +848,7 @@ qla2x00_get_host_port_id(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_speed(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
 	uint32_t speed = 0;
 
 	switch (ha->link_data_rate) {
@@ -861,6 +861,9 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 	case PORT_SPEED_4GB:
 		speed = 4;
 		break;
+	case PORT_SPEED_8GB:
+		speed = 8;
+		break;
 	}
 	fc_host_speed(shost) = speed;
 }
@@ -868,7 +871,7 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_port_type(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
 	uint32_t port_type = FC_PORTTYPE_UNKNOWN;
 
 	switch (ha->current_topology) {
@@ -978,7 +981,7 @@ qla2x00_issue_lip(struct Scsi_Host *shost)
 static struct fc_host_statistics *
 qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
 	int rval;
 	struct link_statistics *stats;
 	dma_addr_t stats_dma;
@@ -1062,7 +1065,7 @@ qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_port_state(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
 
 	if (!ha->flags.online)
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6f129da..42500bc 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2041,8 +2041,6 @@ typedef struct vport_params {
 #define VP_RET_CODE_NO_MEM		5
 #define VP_RET_CODE_NOT_FOUND		6
 
-#define to_qla_parent(x) (((x)->parent) ? (x)->parent : (x))
-
 /*
  * ISP operations
  */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 8e3b044..5d1a3f7 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -119,6 +119,13 @@ static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *ha)
 	qla2x00_get_firmware_state(ha, &fw_state);
 }
 
+static __inline__ scsi_qla_host_t * to_qla_parent(scsi_qla_host_t *);
+static __inline__ scsi_qla_host_t *
+to_qla_parent(scsi_qla_host_t *ha)
+{
+	return ha->parent ? ha->parent : ha;
+}
+
 /**
  * qla2x00_issue_marker() - Issue a Marker IOCB if necessary.
  * @ha: HA context
-- 
1.5.4.rc5.5.gab98


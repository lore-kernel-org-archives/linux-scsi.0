From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 20/23] qla2xxx: Don't process RSCNs for a vport on the same physical adapter.
Date: Fri,  8 Feb 2013 01:58:01 -0500
Message-ID: <1360306684-8286-21-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:46856 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760004Ab3BHHTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:12 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Currently,the driver is processes RSCNs for each new NPIV ports that is created.
Processing the RSCN includes a name server query to see what has changed at the
name server side.  The name server query is performed by the physical port and
each virtual port on the physical adapter (since the RSCN is passed to each
virtual port for processing).  As the number of virtual ports being created
increases, this causes a lot of traffic and busies the firmware.

Processing the RSCN for a virtual port we already have a priori knowledge of is
not necessary so check the 24-bit fabric ID of the RSCN entry and skip
processing it if the RSCN is for a virtual port we already know about.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   21 +++------------------
 drivers/scsi/qla2xxx/qla_isr.c  |   29 +++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 617771b..02f11de 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -446,6 +446,7 @@ extern uint8_t *qla25xx_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
     uint32_t);
 extern int qla25xx_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
     uint32_t);
+extern int qla2x00_is_a_vp_did(scsi_qla_host_t *, uint32_t);
 
 extern int qla2x00_beacon_on(struct scsi_qla_host *);
 extern int qla2x00_beacon_off(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 891b8f1..a1e5848 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3368,8 +3368,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	int		first_dev, last_dev;
 	port_id_t	wrap = {}, nxt_d_id;
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
-	struct scsi_qla_host *tvp;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	rval = QLA_SUCCESS;
 
@@ -3482,22 +3481,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			continue;
 
 		/* Bypass virtual ports of the same host. */
-		found = 0;
-		if (ha->num_vhosts) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&ha->vport_slock, flags);
-			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-				if (new_fcport->d_id.b24 == vp->d_id.b24) {
-					found = 1;
-					break;
-				}
-			}
-			spin_unlock_irqrestore(&ha->vport_slock, flags);
-
-			if (found)
-				continue;
-		}
+		if (qla2x00_is_a_vp_did(vha, new_fcport->d_id.b24))
+			continue;
 
 		/* Bypass if same domain and area of adapter. */
 		if (((new_fcport->d_id.b24 & 0xffff00) ==
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fa738cd..d62fd1a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -495,6 +495,31 @@ qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	}
 }
 
+int
+qla2x00_is_a_vp_did(scsi_qla_host_t *vha, uint32_t rscn_entry)
+{
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vp;
+	uint32_t vp_did;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!ha->num_vhosts)
+		return ret;
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		vp_did = vp->d_id.b24;
+		if (vp_did == rscn_entry) {
+			ret = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+	return ret;
+}
+
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @ha: SCSI driver HA context
@@ -901,6 +926,10 @@ skip_rio:
 		/* Ignore reserved bits from RSCN-payload. */
 		rscn_entry = ((mb[1] & 0x3ff) << 16) | mb[2];
 
+		/* Skip RSCNs for virtual ports on the same physical port */
+		if (qla2x00_is_a_vp_did(vha, rscn_entry))
+			break;
+
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 
-- 
1.7.7


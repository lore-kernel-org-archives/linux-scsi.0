From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/42] qla2xxx: Use bitmap to store loop_id's for fcports.
Date: Wed, 22 Aug 2012 14:21:00 -0400
Message-ID: <1345659696-3670-7-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:53253 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964817Ab2HVSiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:10 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Store used fcport loop_id's in a bitmap so that as opposed to looping through
all fcports to find the next free loop_id, new loop_id lookup can be just be
done via bitops.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    2 +-
 drivers/scsi/qla2xxx/qla_def.h    |    2 +
 drivers/scsi/qla2xxx/qla_init.c   |   79 +++++++++---------------------------
 drivers/scsi/qla2xxx/qla_inline.h |   26 ++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     |   15 +++++++-
 5 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index d651179..0c4fd2c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0122       | 0x4b,0xba,0xfa |
+ * | Module Init and Probe        |       0x0123       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x1140       | 0x111a-0x111b  |
  * |                              |                    | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 39007f5..84db668 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -129,6 +129,7 @@
 #define MAX_FIBRE_DEVICES_2400	2048
 #define MAX_FIBRE_DEVICES_LOOP	128
 #define MAX_FIBRE_DEVICES_MAX	MAX_FIBRE_DEVICES_2400
+#define LOOPID_MAP_SIZE		(ha->max_fibre_devices / 8)
 #define MAX_FIBRE_LUNS  	0xFFFF
 #define	MAX_HOST_COUNT		16
 
@@ -2918,6 +2919,7 @@ struct qla_hw_data {
 	void            *md_dump;
 	uint32_t	md_dump_size;
 
+	void		*loop_id_map;
 	struct qlt_hw_data tgt;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a44653b..ee2ccc3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3285,7 +3285,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			 */
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
 				fcport->d_id.b24 = new_fcport->d_id.b24;
-				fcport->loop_id = FC_NO_LOOP_ID;
+				qla2x00_clear_loop_id(fcport);
 				fcport->flags |= (FCF_FABRIC_DEVICE |
 				    FCF_LOGIN_NEEDED);
 				break;
@@ -3306,7 +3306,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 				ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 				    fcport->d_id.b.domain, fcport->d_id.b.area,
 				    fcport->d_id.b.al_pa);
-				fcport->loop_id = FC_NO_LOOP_ID;
+				qla2x00_clear_loop_id(fcport);
 			}
 
 			break;
@@ -3352,71 +3352,32 @@ int
 qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 {
 	int	rval;
-	int	found;
-	fc_port_t *fcport;
-	uint16_t first_loop_id;
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp;
-	struct scsi_qla_host *tvp;
 	unsigned long flags = 0;
 
 	rval = QLA_SUCCESS;
 
-	/* Save starting loop ID. */
-	first_loop_id = dev->loop_id;
-
-	for (;;) {
-		/* Skip loop ID if already used by adapter. */
-		if (dev->loop_id == vha->loop_id)
-			dev->loop_id++;
-
-		/* Skip reserved loop IDs. */
-		while (qla2x00_is_reserved_id(vha, dev->loop_id))
-			dev->loop_id++;
-
-		/* Reset loop ID if passed the end. */
-		if (dev->loop_id > ha->max_loop_id) {
-			/* first loop ID. */
-			dev->loop_id = ha->min_external_loopid;
-		}
+	spin_lock_irqsave(&ha->vport_slock, flags);
 
-		/* Check for loop ID being already in use. */
-		found = 0;
-		fcport = NULL;
+	dev->loop_id = find_first_zero_bit(ha->loop_id_map,
+	    LOOPID_MAP_SIZE);
 
-		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			list_for_each_entry(fcport, &vp->vp_fcports, list) {
-				if (fcport->loop_id == dev->loop_id &&
-								fcport != dev) {
-					/* ID possibly in use */
-					found++;
-					break;
-				}
-			}
-			if (found)
-				break;
-		}
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
-
-		/* If not in use then it is free to use. */
-		if (!found) {
-			ql_dbg(ql_dbg_disc, dev->vha, 0x2086,
-			    "Assigning new loopid=%x, portid=%x.\n",
-			    dev->loop_id, dev->d_id.b24);
-			break;
-		}
+	if (qla2x00_is_reserved_id(vha, dev->loop_id)) {
+		dev->loop_id = FC_NO_LOOP_ID;
+		rval = QLA_FUNCTION_FAILED;
+	} else
+		set_bit(dev->loop_id, ha->loop_id_map);
 
-		/* ID in use. Try next value. */
-		dev->loop_id++;
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-		/* If wrap around. No free ID to use. */
-		if (dev->loop_id == first_loop_id) {
-			dev->loop_id = FC_NO_LOOP_ID;
-			rval = QLA_FUNCTION_FAILED;
-			break;
-		}
-	}
+	if (rval == QLA_SUCCESS)
+		ql_dbg(ql_dbg_disc, dev->vha, 0x2086,
+		    "Assigning new loopid=%x, portid=%x.\n",
+		    dev->loop_id, dev->d_id.b24);
+	else
+		ql_log(ql_log_warn, dev->vha, 0x2087,
+		    "No loop_id's available, portid=%x.\n",
+		    dev->d_id.b24);
 
 	return (rval);
 }
@@ -3616,7 +3577,7 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
-			fcport->loop_id = FC_NO_LOOP_ID;
+			qla2x00_clear_loop_id(fcport);
 			fcport->login_retry = 0;
 
 			rval = 3;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 6e45764..c12add2 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -57,6 +57,20 @@ host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
        return fcp;
 }
 
+static inline void
+qla2x00_set_reserved_loop_ids(struct qla_hw_data *ha)
+{
+	int i;
+
+	if (IS_FWI2_CAPABLE(ha))
+		return;
+
+	for (i = 0; i < SNS_FIRST_LOOP_ID; i++)
+		set_bit(i, ha->loop_id_map);
+	set_bit(MANAGEMENT_SERVER, ha->loop_id_map);
+	set_bit(BROADCAST, ha->loop_id_map);
+}
+
 static inline int
 qla2x00_is_reserved_id(scsi_qla_host_t *vha, uint16_t loop_id)
 {
@@ -69,6 +83,18 @@ qla2x00_is_reserved_id(scsi_qla_host_t *vha, uint16_t loop_id)
 }
 
 static inline void
+qla2x00_clear_loop_id(fc_port_t *fcport) {
+	struct qla_hw_data *ha = fcport->vha->hw;
+
+	if (fcport->loop_id == FC_NO_LOOP_ID ||
+	    qla2x00_is_reserved_id(fcport->vha, fcport->loop_id))
+		return;
+
+	clear_bit(fcport->loop_id, ha->loop_id_map);
+	fcport->loop_id = FC_NO_LOOP_ID;
+}
+
+static inline void
 qla2x00_clean_dsd_pool(struct qla_hw_data *ha, srb_t *sp)
 {
 	struct dsd_dma *dsd_ptr, *tdsd_ptr;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index caa4ce4..6b87b55 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2872,6 +2872,7 @@ void qla2x00_free_fcports(struct scsi_qla_host *vha)
 
 	list_for_each_entry_safe(fcport, tfcport, &vha->vp_fcports, list) {
 		list_del(&fcport->list);
+		qla2x00_clear_loop_id(fcport);
 		kfree(fcport);
 		fcport = NULL;
 	}
@@ -3169,6 +3170,17 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	}
 
 	INIT_LIST_HEAD(&ha->vp_list);
+
+	/* Allocate memory for our loop_id bitmap */
+	ha->loop_id_map = kzalloc(LOOPID_MAP_SIZE, GFP_KERNEL);
+	if (!ha->loop_id_map)
+		goto fail_async_pd;
+	else {
+		qla2x00_set_reserved_loop_ids(ha);
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0123,
+		    "loop_id_map=%p. \n", ha->loop_id_map);
+	}
+
 	return 1;
 
 fail_async_pd:
@@ -3352,6 +3364,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	kfree(ha->nvram);
 	kfree(ha->npiv_info);
 	kfree(ha->swl);
+	kfree(ha->loop_id_map);
 
 	ha->srb_mempool = NULL;
 	ha->ctx_mempool = NULL;
@@ -3687,7 +3700,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 			}
 
 			if (fcport->login_retry == 0 && status != QLA_SUCCESS)
-				fcport->loop_id = FC_NO_LOOP_ID;
+				qla2x00_clear_loop_id(fcport);
 		}
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			break;
-- 
1.7.7


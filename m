From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] qla2xxx: Configure NPIV fc_vport via tcm_qla2xxx_npiv_make_lport
Date: Wed, 15 Jan 2014 05:42:05 +0000
Message-ID: <1389764525-24453-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40165 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaAOGCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 01:02:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Saurav & Co,

Here is the updated NPIV patch on top of the original here:

  [PATCH] qla2xxx: Enhancements to enable NPIV support for QLOGIC ISPs with TCM/LIO.
  http://marc.info/?l=linux-scsi&m=138930044930212&w=2
   
As previously dicussed, it moves fc_vport creation into tcm_qla2xxx
control plane code thus allowing everything required for NPIV port
creation to be encapsulated within configfs.

There are still some bugs to be resolved.  Namely:

 * Determine how to save 'point-to-point' NVRAM settings across target restart
 * Figure out why the initiator logs in, but doesn't perform LUN scan on
   the first login attempt
 * Determine if it's possible to collapse the name formatting further,
   by generating $NPIV_WWNN internally
 * Determine proper NPIV format for EVPD=0x83 SCSI name string

Aside from these remaining issues, multiple NPIV ports can be configured
on a single physical FC port, and initial I/O appears to be functioning
as expected.

Please review.

Thank you,

--nab

--------------------------------------------------------------------

This patch changes qla2xxx qlt_lport_register() code to accept
target_lport_ptr + npiv_wwpn + npiv_wwnn parameters, and updates
tcm_qla2xxx to use the new tcm_qla2xxx_lport_register_npiv_cb()
callback for invoking fc_vport_create() from configfs context
via tcm_qla2xxx_npiv_make_lport() code.

In order for this to work, the qlt_lport_register() callback is
now called without holding qla_tgt_mutex, as the fc_vport creation
process will call qlt_vport_create() -> qlt_add_target(), which
already expects to acquire it.

It enforces /sys/kernel/config/target/qla2xxx_npiv/$NPIV_WWPN
naming in the following format:

     $PHYSICAL_WWPN@$NPIV_WWPN:$NPIV_WWNN

and assumes the $PHYSICAL_WWPN in question has already had been
configured for target mode in non NPIV mode.

Finally, it updates existing tcm_qla2xxx_lport_register_cb() logic
to setup the non NPIV assignments that have now been moved out of
qlt_lport_register() code.

Cc: Sawan Chandak <sawan.chandak@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c  |   25 ++++-----
 drivers/scsi/qla2xxx/qla_target.h  |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  106 ++++++++++++++++++++++++++----------
 3 files changed, 88 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 34ed246..b596f8b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4235,8 +4235,9 @@ static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
  * @callback:  lport initialization callback for tcm_qla2xxx code
  * @target_lport_ptr: pointer for tcm_qla2xxx specific lport data
  */
-int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
-	int (*callback)(struct scsi_qla_host *), void *target_lport_ptr)
+int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
+		       u64 npiv_wwpn, u64 npiv_wwnn,
+		       int (*callback)(struct scsi_qla_host *, void *, u64, u64))
 {
 	struct qla_tgt *tgt;
 	struct scsi_qla_host *vha;
@@ -4259,7 +4260,7 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
 			continue;
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
-		if (host->active_mode & MODE_TARGET) {
+		if ((!npiv_wwpn || !npiv_wwnn) && host->active_mode & MODE_TARGET) {
 			pr_debug("MODE_TARGET already active on qla2xxx(%d)\n",
 			    host->host_no);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -4273,24 +4274,18 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
 			    " qla2xxx scsi_host\n");
 			continue;
 		}
-		qlt_lport_dump(vha, wwpn, b);
+		qlt_lport_dump(vha, phys_wwpn, b);
 
 		if (memcmp(vha->port_name, b, WWN_SIZE)) {
 			scsi_host_put(host);
 			continue;
 		}
-		/*
-		 * Setup passed parameters ahead of invoking callback
-		 */
-		ha->tgt.tgt_ops = qla_tgt_ops;
-		vha->vha_tgt.target_lport_ptr = target_lport_ptr;
-		rc = (*callback)(vha);
-		if (rc != 0) {
-			ha->tgt.tgt_ops = NULL;
-			vha->vha_tgt.target_lport_ptr = NULL;
-			scsi_host_put(host);
-		}
 		mutex_unlock(&qla_tgt_mutex);
+
+		rc = (*callback)(vha, target_lport_ptr, npiv_wwpn, npiv_wwnn);
+		if (rc != 0)
+			scsi_host_put(host);
+
 		return rc;
 	}
 	mutex_unlock(&qla_tgt_mutex);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index b33e411..1d10eec 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -932,8 +932,8 @@ void qlt_disable_vha(struct scsi_qla_host *);
  */
 extern int qlt_add_target(struct qla_hw_data *, struct scsi_qla_host *);
 extern int qlt_remove_target(struct qla_hw_data *, struct scsi_qla_host *);
-extern int qlt_lport_register(struct qla_tgt_func_tmpl *, u64,
-			int (*callback)(struct scsi_qla_host *), void *);
+extern int qlt_lport_register(void *, u64, u64, u64,
+			int (*callback)(struct scsi_qla_host *, void *, u64, u64));
 extern void qlt_lport_deregister(struct scsi_qla_host *);
 extern void qlt_unreg_sess(struct qla_tgt_sess *);
 extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 113ca95..75a141b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1559,14 +1559,18 @@ static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
 	return 0;
 }
 
-static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha)
+static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha,
+					 void *target_lport_ptr,
+					 u64 npiv_wwpn, u64 npiv_wwnn)
 {
-	struct tcm_qla2xxx_lport *lport;
+	struct qla_hw_data *ha = vha->hw;
+	struct tcm_qla2xxx_lport *lport =
+			(struct tcm_qla2xxx_lport *)target_lport_ptr;
 	/*
-	 * Setup local pointer to vha, NPIV VP pointer (if present) and
-	 * vha->tcm_lport pointer
+	 * Setup tgt_ops, local pointer to vha and target_lport_ptr
 	 */
-	lport = (struct tcm_qla2xxx_lport *)vha->vha_tgt.target_lport_ptr;
+	ha->tgt.tgt_ops = &tcm_qla2xxx_template;
+	vha->vha_tgt.target_lport_ptr = target_lport_ptr;
 	lport->qla_vha = vha;
 
 	return 0;
@@ -1598,8 +1602,8 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 	if (ret != 0)
 		goto out;
 
-	ret = qlt_lport_register(&tcm_qla2xxx_template, wwpn,
-				tcm_qla2xxx_lport_register_cb, lport);
+	ret = qlt_lport_register(lport, wwpn, 0, 0,
+				 tcm_qla2xxx_lport_register_cb);
 	if (ret != 0)
 		goto out_lport;
 
@@ -1637,20 +1641,70 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
 	kfree(lport);
 }
 
+static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base_vha,
+					      void *target_lport_ptr,
+					      u64 npiv_wwpn, u64 npiv_wwnn)
+{
+	struct fc_vport *vport;
+	struct Scsi_Host *sh = base_vha->host;
+	struct scsi_qla_host *npiv_vha;
+	struct tcm_qla2xxx_lport *lport =
+			(struct tcm_qla2xxx_lport *)target_lport_ptr;
+	struct fc_vport_identifiers vport_id;
+
+	if (!qla_tgt_mode_enabled(base_vha)) {
+		pr_err("qla2xxx base_vha not enabled for target mode\n");
+		return -EPERM;
+	}
+
+	memset(&vport_id, 0, sizeof(vport_id));
+	vport_id.port_name = npiv_wwpn;
+	vport_id.node_name = npiv_wwnn;
+	vport_id.roles = FC_PORT_ROLE_FCP_INITIATOR;
+	vport_id.vport_type = FC_PORTTYPE_NPIV;
+	vport_id.disable = false;
+
+	vport = fc_vport_create(sh, 0, &vport_id);
+	if (!vport) {
+		pr_err("fc_vport_create failed for qla2xxx_npiv\n");
+		return -ENODEV;
+	}
+	/*
+	 * Setup local pointer to NPIV vhba + target_lport_ptr
+	 */
+	npiv_vha = (struct scsi_qla_host *)vport->dd_data;
+	npiv_vha->vha_tgt.target_lport_ptr = target_lport_ptr;
+	lport->qla_vha = npiv_vha;
+
+	scsi_host_get(npiv_vha->host);
+	return 0;
+}
+
+
 static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 	struct target_fabric_configfs *tf,
 	struct config_group *group,
 	const char *name)
 {
 	struct tcm_qla2xxx_lport *lport;
-	u64 npiv_wwpn, npiv_wwnn;
+	u64 phys_wwpn, npiv_wwpn, npiv_wwnn;
+	char *p, tmp[128];
 	int ret;
-	struct scsi_qla_host *vha = NULL;
-	struct qla_hw_data *ha = NULL;
-	scsi_qla_host_t *base_vha = NULL;
 
-	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
-				&npiv_wwpn, &npiv_wwnn) < 0)
+	snprintf(tmp, 128, "%s", name);
+
+	p = strchr(tmp, '@');
+	if (!p) {
+		pr_err("Unable to locate NPIV '@' seperator\n");
+		return ERR_PTR(-EINVAL);
+	}
+	*p++ = '\0';
+
+	if (tcm_qla2xxx_parse_wwn(tmp, &phys_wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	if (tcm_qla2xxx_npiv_parse_wwn(p, strlen(p)+1,
+				       &npiv_wwpn, &npiv_wwnn) < 0)
 		return ERR_PTR(-EINVAL);
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
@@ -1668,21 +1722,11 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 	if (ret != 0)
 		goto out;
 
-	ret = qlt_lport_register(&tcm_qla2xxx_template, npiv_wwpn,
-				tcm_qla2xxx_lport_register_cb, lport);
-
+	ret = qlt_lport_register(lport, phys_wwpn, npiv_wwpn, npiv_wwnn,
+				 tcm_qla2xxx_lport_register_npiv_cb);
 	if (ret != 0)
 		goto out_lport;
 
-	vha = lport->qla_vha;
-	ha = vha->hw;
-	base_vha = pci_get_drvdata(ha->pdev);
-
-	if (!qla_tgt_mode_enabled(base_vha)) {
-		ret = -EPERM;
-		goto out_lport;
-	}
-
 	return &lport->lport_wwn;
 out_lport:
 	vfree(lport->lport_loopid_map);
@@ -1696,14 +1740,16 @@ static void tcm_qla2xxx_npiv_drop_lport(struct se_wwn *wwn)
 {
 	struct tcm_qla2xxx_lport *lport = container_of(wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
-	struct scsi_qla_host *vha = lport->qla_vha;
-	struct Scsi_Host *sh = vha->host;
+	struct scsi_qla_host *npiv_vha = lport->qla_vha;
+	struct qla_hw_data *ha = npiv_vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+
+	scsi_host_put(npiv_vha->host);
 	/*
 	 * Notify libfc that we want to release the vha->fc_vport
 	 */
-	fc_vport_terminate(vha->fc_vport);
-
-	scsi_host_put(sh);
+	fc_vport_terminate(npiv_vha->fc_vport);
+	scsi_host_put(base_vha->host);
 	kfree(lport);
 }
 
-- 
1.7.10.4


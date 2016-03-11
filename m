From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 03/14] vhost/scsi: Convert to target_alloc_session usage
Date: Fri, 11 Mar 2016 06:29:59 +0000
Message-ID: <1457677810-2478-4-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34059 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbcCKGed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 01:34:33 -0500
Received: by mail-ob0-f171.google.com with SMTP id ts10so104302696obc.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 22:34:33 -0800 (PST)
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts vhost/scsi pre-allocation of vhost_scsi_cmd
descriptors to use the new alloc_session callback().

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 99 ++++++++++++++++++++++------------------------------
 1 file changed, 41 insertions(+), 58 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 29cfc57..cd5f20f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1664,8 +1664,7 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 	mutex_unlock(&vhost_scsi_mutex);
 }
 
-static void vhost_scsi_free_cmd_map_res(struct vhost_scsi_nexus *nexus,
-				       struct se_session *se_sess)
+static void vhost_scsi_free_cmd_map_res(struct se_session *se_sess)
 {
 	struct vhost_scsi_cmd *tv_cmd;
 	unsigned int i;
@@ -1721,98 +1720,82 @@ static struct configfs_attribute *vhost_scsi_tpg_attrib_attrs[] = {
 	NULL,
 };
 
-static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
-				const char *name)
+static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
+			       struct se_session *se_sess, void *p)
 {
-	struct se_portal_group *se_tpg;
-	struct se_session *se_sess;
-	struct vhost_scsi_nexus *tv_nexus;
 	struct vhost_scsi_cmd *tv_cmd;
 	unsigned int i;
 
-	mutex_lock(&tpg->tv_tpg_mutex);
-	if (tpg->tpg_nexus) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_debug("tpg->tpg_nexus already exists\n");
-		return -EEXIST;
-	}
-	se_tpg = &tpg->se_tpg;
-
-	tv_nexus = kzalloc(sizeof(struct vhost_scsi_nexus), GFP_KERNEL);
-	if (!tv_nexus) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_err("Unable to allocate struct vhost_scsi_nexus\n");
-		return -ENOMEM;
-	}
-	/*
-	 *  Initialize the struct se_session pointer and setup tagpool
-	 *  for struct vhost_scsi_cmd descriptors
-	 */
-	tv_nexus->tvn_se_sess = transport_init_session_tags(
-					VHOST_SCSI_DEFAULT_TAGS,
-					sizeof(struct vhost_scsi_cmd),
-					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS);
-	if (IS_ERR(tv_nexus->tvn_se_sess)) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
-		kfree(tv_nexus);
-		return -ENOMEM;
-	}
-	se_sess = tv_nexus->tvn_se_sess;
 	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
 		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
 
 		tv_cmd->tvc_sgl = kzalloc(sizeof(struct scatterlist) *
 					VHOST_SCSI_PREALLOC_SGLS, GFP_KERNEL);
 		if (!tv_cmd->tvc_sgl) {
-			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
 			goto out;
 		}
 
 		tv_cmd->tvc_upages = kzalloc(sizeof(struct page *) *
-					VHOST_SCSI_PREALLOC_UPAGES, GFP_KERNEL);
+				VHOST_SCSI_PREALLOC_UPAGES, GFP_KERNEL);
 		if (!tv_cmd->tvc_upages) {
-			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
 			goto out;
 		}
 
 		tv_cmd->tvc_prot_sgl = kzalloc(sizeof(struct scatterlist) *
-					VHOST_SCSI_PREALLOC_PROT_SGLS, GFP_KERNEL);
+				VHOST_SCSI_PREALLOC_PROT_SGLS, GFP_KERNEL);
 		if (!tv_cmd->tvc_prot_sgl) {
-			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
 			goto out;
 		}
 	}
+	return 0;
+out:
+	vhost_scsi_free_cmd_map_res(se_sess);
+	return -ENOMEM;
+}
+
+static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
+				const char *name)
+{
+	struct se_portal_group *se_tpg;
+	struct vhost_scsi_nexus *tv_nexus;
+
+	mutex_lock(&tpg->tv_tpg_mutex);
+	if (tpg->tpg_nexus) {
+		mutex_unlock(&tpg->tv_tpg_mutex);
+		pr_debug("tpg->tpg_nexus already exists\n");
+		return -EEXIST;
+	}
+	se_tpg = &tpg->se_tpg;
+
+	tv_nexus = kzalloc(sizeof(struct vhost_scsi_nexus), GFP_KERNEL);
+	if (!tv_nexus) {
+		mutex_unlock(&tpg->tv_tpg_mutex);
+		pr_err("Unable to allocate struct vhost_scsi_nexus\n");
+		return -ENOMEM;
+	}
 	/*
 	 * Since we are running in 'demo mode' this call with generate a
 	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
-	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-				se_tpg, (unsigned char *)name);
-	if (!tv_nexus->tvn_se_sess->se_node_acl) {
+	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg,
+					VHOST_SCSI_DEFAULT_TAGS,
+					sizeof(struct vhost_scsi_cmd),
+					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
+					(unsigned char *)name, tv_nexus,
+					vhost_scsi_nexus_cb);
+	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_debug("core_tpg_check_initiator_node_acl() failed"
-				" for %s\n", name);
-		goto out;
+		kfree(tv_nexus);
+		return -ENOMEM;
 	}
-	/*
-	 * Now register the TCM vhost virtual I_T Nexus as active.
-	 */
-	transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
-			tv_nexus->tvn_se_sess, tv_nexus);
 	tpg->tpg_nexus = tv_nexus;
 
 	mutex_unlock(&tpg->tv_tpg_mutex);
 	return 0;
-
-out:
-	vhost_scsi_free_cmd_map_res(tv_nexus, se_sess);
-	transport_free_session(se_sess);
-	kfree(tv_nexus);
-	return -ENOMEM;
 }
 
 static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
@@ -1853,7 +1836,7 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 		" %s Initiator Port: %s\n", vhost_scsi_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 
-	vhost_scsi_free_cmd_map_res(tv_nexus, se_sess);
+	vhost_scsi_free_cmd_map_res(se_sess);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
-- 
1.9.1


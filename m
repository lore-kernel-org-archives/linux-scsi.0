From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 12/15] vhost/scsi: Add fabric_prot_type attribute support
Date: Mon, 30 Mar 2015 03:28:21 +0000
Message-ID: <1427686104-14231-13-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36829 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbbC3D3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2015 23:29:39 -0400
Received: by oicf142 with SMTP id f142so107798049oic.3
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2015 20:29:38 -0700 (PDT)
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates vhost-scsi to add a new fabric_prot_type TPG
attribute, used for controlling LLD level protection into LIO when
the backend device does not support T10-PI.

This is required for vhost-scsi to enable WRITE_STRIP + READ_INSERT
operations using software emulation + crct10dif instruction offload.

It's disabled by default and controls which se_sesion->sess_prot_type
are set at vhost_scsi_make_nexus() session registration time.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8d4f3f1..27ed964 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -131,6 +131,8 @@ struct vhost_scsi_tpg {
 	int tv_tpg_port_count;
 	/* Used for vhost_scsi device reference to tpg_nexus, protected by tv_tpg_mutex */
 	int tv_tpg_vhost_count;
+	/* Used for enabling T10-PI with legacy devices */
+	int tv_fabric_prot_type;
 	/* list for vhost_scsi_list */
 	struct list_head tv_tpg_list;
 	/* Used to protect access for tpg_nexus */
@@ -431,6 +433,14 @@ vhost_scsi_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
 			port_nexus_ptr);
 }
 
+static int vhost_scsi_check_prot_fabric_only(struct se_portal_group *se_tpg)
+{
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+
+	return tpg->tv_fabric_prot_type;
+}
+
 static struct se_node_acl *
 vhost_scsi_alloc_fabric_acl(struct se_portal_group *se_tpg)
 {
@@ -1878,6 +1888,45 @@ static void vhost_scsi_free_cmd_map_res(struct vhost_scsi_nexus *nexus,
 	}
 }
 
+static ssize_t vhost_scsi_tpg_attrib_store_fabric_prot_type(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	unsigned long val;
+	int ret = kstrtoul(page, 0, &val);
+
+	if (ret) {
+		pr_err("kstrtoul() returned %d for fabric_prot_type\n", ret);
+		return ret;
+	}
+	if (val != 0 && val != 1 && val != 3) {
+		pr_err("Invalid vhost_scsi fabric_prot_type: %lu\n", val);
+		return -EINVAL;
+	}
+	tpg->tv_fabric_prot_type = val;
+
+	return count;
+}
+
+static ssize_t vhost_scsi_tpg_attrib_show_fabric_prot_type(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+
+	return sprintf(page, "%d\n", tpg->tv_fabric_prot_type);
+}
+TF_TPG_ATTRIB_ATTR(vhost_scsi, fabric_prot_type, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *vhost_scsi_tpg_attrib_attrs[] = {
+	&vhost_scsi_tpg_attrib_fabric_prot_type.attr,
+	NULL,
+};
+
 static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 				const char *name)
 {
@@ -2290,6 +2339,7 @@ static struct target_core_fabric_ops vhost_scsi_ops = {
 	.tpg_check_demo_mode_cache	= vhost_scsi_check_true,
 	.tpg_check_demo_mode_write_protect = vhost_scsi_check_false,
 	.tpg_check_prod_mode_write_protect = vhost_scsi_check_false,
+	.tpg_check_prot_fabric_only	= vhost_scsi_check_prot_fabric_only,
 	.tpg_alloc_fabric_acl		= vhost_scsi_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= vhost_scsi_release_fabric_acl,
 	.tpg_get_inst_index		= vhost_scsi_tpg_get_inst_index,
@@ -2348,7 +2398,7 @@ static int vhost_scsi_register_configfs(void)
 	 */
 	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = vhost_scsi_wwn_attrs;
 	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = vhost_scsi_tpg_attrs;
-	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = vhost_scsi_tpg_attrib_attrs;
 	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
 	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
 	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
-- 
1.9.1


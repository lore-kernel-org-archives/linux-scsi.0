From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] target: display 'write_protect' attribute for demo-mode LUNs
Date: Thu, 18 Jun 2015 11:43:42 +0200
Message-ID: <1434620622-65391-9-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbbFRJnv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2015 05:43:51 -0400
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

When LUNs are mapped with a demo-mode initiator we're missing
the 'write_protect' attribute to set a LUN read-only.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_device.c          | 27 ++++++++++++++++++
 drivers/target/target_core_fabric_configfs.c | 42 ++++++++++++++++++++++++++++
 drivers/target/target_core_internal.h        |  1 +
 3 files changed, 70 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 88d6070..3e17070 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -271,6 +271,33 @@ void core_update_device_list_access(
 	mutex_unlock(&nacl->lun_entry_mutex);
 }
 
+void core_update_lun_access(
+	struct se_lun *lun,
+	u32 lun_access)
+{
+	struct se_dev_entry *deve;
+
+	if (lun_access == TRANSPORT_LUNFLAGS_READ_ONLY) {
+		lun->lun_access &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+		lun->lun_access |= TRANSPORT_LUNFLAGS_READ_ONLY;
+	} else {
+		lun->lun_access &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+		lun->lun_access |= TRANSPORT_LUNFLAGS_READ_WRITE;
+	}
+
+	spin_lock_bh(&lun->lun_deve_lock);
+	list_for_each_entry(deve, &lun->lun_deve_list, lun_link) {
+		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+		} else {
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+		}
+	}
+	spin_unlock_bh(&lun->lun_deve_lock);
+}
+
 /*
  * Called with rcu_read_lock or nacl->device_list_lock held.
  */
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 6cfee59..299b4b5 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -726,12 +726,54 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_write_md(
 
 TCM_PORT_ATTR(alua_tg_pt_write_md, S_IRUGO | S_IWUSR);
 
+static ssize_t target_fabric_port_show_attr_write_protect(
+	struct se_lun *lun,
+	char *page)
+{
+	ssize_t len = 0;
+
+	if (!lun || !lun->lun_se_dev)
+		return -ENODEV;
+
+	len = sprintf(page, "%d\n",
+		      (lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ? 1 : 0);
+
+	return len;
+}
+
+static ssize_t target_fabric_port_store_attr_write_protect(
+	struct se_lun *lun,
+	const char *page,
+	size_t count)
+{
+	unsigned long op;
+	int ret;
+
+	if (!lun || !lun->lun_se_dev)
+		return -ENODEV;
+
+	ret = kstrtoul(page, 0, &op);
+	if (ret)
+		return ret;
+
+	if ((op != 1) && (op != 0))
+		return -EINVAL;
+
+	core_update_lun_access(lun, (op) ?
+			       TRANSPORT_LUNFLAGS_READ_ONLY :
+			       TRANSPORT_LUNFLAGS_READ_WRITE);
+
+	return count;
+
+}
+TCM_PORT_ATTR(write_protect, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *target_fabric_port_attrs[] = {
 	&target_fabric_port_alua_tg_pt_gp.attr,
 	&target_fabric_port_alua_tg_pt_offline.attr,
 	&target_fabric_port_alua_tg_pt_status.attr,
 	&target_fabric_port_alua_tg_pt_write_md.attr,
+	&target_fabric_port_write_protect.attr,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 5111789..69a57a4 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -36,6 +36,7 @@ void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
 int	core_dev_add_lun(struct se_portal_group *, struct se_device *,
 		struct se_lun *lun);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
+void	core_update_lun_access(struct se_lun *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_node_acl *, u64, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
-- 
1.8.5.2


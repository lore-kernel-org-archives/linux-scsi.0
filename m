From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 07/11] iscsi-target: Add iser network portal attribute
Date: Fri,  8 Mar 2013 01:45:12 +0000
Message-ID: <1362707116-31406-8-git-send-email-nab@linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39369 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab3CHBz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 20:55:56 -0500
In-Reply-To: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new network portal attribute for iser, that lives
under existing iscsi-target configfs layout at:

   /sys/kernel/config/target/iscsi/$TARGETNAME/$TPGT/np/$PORTAL/iser

When lio_target_np_store_iser() is enabled, iscsit_tpg_add_network_portal()
will attempt to start an rdma_cma network portal for iser-target, only if
the external ib_isert module transport has been loaded.

When disabled, iscsit_tpg_del_network_portal() will cease iser login service
on the network portal, and release any external ib_isert module reference.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |   75 ++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 78d75c8..c4625dd 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -124,8 +124,83 @@ out:
 
 TF_NP_BASE_ATTR(lio_target, sctp, S_IRUGO | S_IWUSR);
 
+static ssize_t lio_target_np_show_iser(
+	struct se_tpg_np *se_tpg_np,
+	char *page)
+{
+	struct iscsi_tpg_np *tpg_np = container_of(se_tpg_np,
+				struct iscsi_tpg_np, se_tpg_np);
+	struct iscsi_tpg_np *tpg_np_iser;
+	ssize_t rb;
+
+	tpg_np_iser = iscsit_tpg_locate_child_np(tpg_np, ISCSI_INFINIBAND);
+	if (tpg_np_iser)
+		rb = sprintf(page, "1\n");
+	else
+		rb = sprintf(page, "0\n");
+
+	return rb;
+}
+
+static ssize_t lio_target_np_store_iser(
+	struct se_tpg_np *se_tpg_np,
+	const char *page,
+	size_t count)
+{
+	struct iscsi_np *np;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np *tpg_np = container_of(se_tpg_np,
+				struct iscsi_tpg_np, se_tpg_np);
+	struct iscsi_tpg_np *tpg_np_iser = NULL;
+	char *endptr;
+	u32 op;
+	int rc;
+
+	op = simple_strtoul(page, &endptr, 0);
+	if ((op != 1) && (op != 0)) {
+		pr_err("Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+	np = tpg_np->tpg_np;
+	if (!np) {
+		pr_err("Unable to locate struct iscsi_np from"
+				" struct iscsi_tpg_np\n");
+		return -EINVAL;
+	}
+
+	tpg = tpg_np->tpg;
+	if (iscsit_get_tpg(tpg) < 0)
+		return -EINVAL;
+
+	if (op) {
+		tpg_np_iser = iscsit_tpg_add_network_portal(tpg, &np->np_sockaddr,
+				np->np_ip, tpg_np, ISCSI_INFINIBAND);
+		if (!tpg_np_iser || IS_ERR(tpg_np_iser))
+			goto out;
+	} else {
+		tpg_np_iser = iscsit_tpg_locate_child_np(tpg_np, ISCSI_INFINIBAND);
+		if (!tpg_np_iser)
+			goto out;
+
+		rc = iscsit_tpg_del_network_portal(tpg, tpg_np_iser);
+		if (rc < 0)
+			goto out;
+	}
+
+	printk("lio_target_np_store_iser() done, op: %d\n", op);
+
+	iscsit_put_tpg(tpg);
+	return count;
+out:
+	iscsit_put_tpg(tpg);
+	return -EINVAL;
+}
+
+TF_NP_BASE_ATTR(lio_target, iser, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *lio_target_portal_attrs[] = {
 	&lio_target_np_sctp.attr,
+	&lio_target_np_iser.attr,
 	NULL,
 };
 
-- 
1.7.2.5


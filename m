From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] tcm_loop: Implement transport offline
Date: Wed, 16 Oct 2013 09:12:53 +0200
Message-ID: <1381907576-81857-3-git-send-email-hare@suse.de>
References: <1381907576-81857-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab3JPHNB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 03:13:01 -0400
In-Reply-To: <1381907576-81857-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add attribute 'transport_status' to simulate link failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 53 +++++++++++++++++++++++++++++++++++++-
 drivers/target/loopback/tcm_loop.h |  4 +++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 57d5a95..f81ebe4 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -178,7 +178,10 @@ static void tcm_loop_submission_work(struct work_struct *work)
 		set_host_byte(sc, DID_NO_CONNECT);
 		goto out_done;
 	}
-
+	if (tl_tpg->tl_transport_status == TCM_TRANSPORT_OFFLINE) {
+		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
+		goto out_done;
+	}
 	tl_nexus = tl_hba->tl_nexus;
 	if (!tl_nexus) {
 		scmd_printk(KERN_ERR, sc, "TCM_Loop I_T Nexus"
@@ -1064,8 +1067,56 @@ check_newline:
 
 TF_TPG_BASE_ATTR(tcm_loop, nexus, S_IRUGO | S_IWUSR);
 
+static ssize_t tcm_loop_tpg_show_transport_status(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
+			struct tcm_loop_tpg, tl_se_tpg);
+	const char *status = NULL;
+	ssize_t ret = -EINVAL;
+
+	switch (tl_tpg->tl_transport_status) {
+	case TCM_TRANSPORT_ONLINE:
+		status = "online";
+		break;
+	case TCM_TRANSPORT_OFFLINE:
+		status = "offline";
+		break;
+	default:
+		break;
+	}
+
+	if (status)
+		ret = snprintf(page, PAGE_SIZE, "%s\n", status);
+
+	return ret;
+}
+
+static ssize_t tcm_loop_tpg_store_transport_status(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
+			struct tcm_loop_tpg, tl_se_tpg);
+
+	if (!strncmp(page, "online", 6)) {
+		tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
+		return count;
+	}
+	if (!strncmp(page, "offline", 7)) {
+		tl_tpg->tl_transport_status = TCM_TRANSPORT_OFFLINE;
+		return count;
+	}
+	return -EINVAL;
+}
+
+TF_TPG_BASE_ATTR(tcm_loop, transport_status, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *tcm_loop_tpg_attrs[] = {
 	&tcm_loop_tpg_nexus.attr,
+	&tcm_loop_tpg_transport_status.attr,
 	NULL,
 };
 
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index dd7a84e..56528f7 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -40,8 +40,12 @@ struct tcm_loop_nacl {
 	struct se_node_acl se_node_acl;
 };
 
+#define TCM_TRANSPORT_ONLINE 0
+#define TCM_TRANSPORT_OFFLINE 1
+
 struct tcm_loop_tpg {
 	unsigned short tl_tpgt;
+	unsigned short tl_transport_status;
 	atomic_t tl_tpg_port_count;
 	struct se_portal_group tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
-- 
1.7.12.4


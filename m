From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/18] target_core_alua: Make supported states configurable
Date: Tue, 19 Nov 2013 09:07:50 +0100
Message-ID: <1384848483-3771-6-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab3KSIIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 03:08:06 -0500
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_configfs.c | 50 +++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3a964fb..1e4ea28 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2131,6 +2131,55 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_type(
 SE_DEV_ALUA_TG_PT_ATTR(alua_access_type, S_IRUGO | S_IWUSR);
 
 /*
+ * alua_supported_states
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_supported_states(
+	struct t10_alua_tg_pt_gp *tg_pt_gp,
+	char *page)
+{
+	return sprintf(page, "%02x\n",
+		tg_pt_gp->tg_pt_gp_alua_supported_states);
+}
+
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_supported_states(
+	struct t10_alua_tg_pt_gp *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int new_states, valid_states, ret;
+
+	if (!tg_pt_gp->tg_pt_gp_valid_id) {
+		pr_err("Unable to do set supported ALUA states on non"
+			" valid tg_pt_gp ID: %hu\n",
+			tg_pt_gp->tg_pt_gp_valid_id);
+		return -EINVAL;
+	}
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		pr_err("Unable to extract new supported ALUA states"
+				" from %s\n", page);
+		return -EINVAL;
+	}
+	new_states = (int)tmp;
+	valid_states = ALUA_T_SUP | ALUA_O_SUP | ALUA_LBD_SUP | \
+	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
+
+
+	if (new_states & ~valid_states) {
+		pr_err("Illegal supported ALUA states: 0x%02x\n",
+				new_states);
+		return -EINVAL;
+	}
+
+	tg_pt_gp->tg_pt_gp_alua_supported_states = new_states;
+	return count;
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(alua_supported_states, S_IRUGO | S_IWUSR);
+
+/*
  * alua_write_metadata
  */
 static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_write_metadata(
@@ -2350,6 +2399,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
 	&target_core_alua_tg_pt_gp_alua_access_status.attr,
 	&target_core_alua_tg_pt_gp_alua_access_type.attr,
+	&target_core_alua_tg_pt_gp_alua_supported_states.attr,
 	&target_core_alua_tg_pt_gp_alua_write_metadata.attr,
 	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
 	&target_core_alua_tg_pt_gp_trans_delay_msecs.attr,
-- 
1.7.12.4


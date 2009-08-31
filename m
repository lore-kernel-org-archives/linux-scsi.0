From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ALUA]: Add ALUA Transition state usage +
	optional delay
Date: Mon, 31 Aug 2009 01:24:37 -0700
Message-ID: <1251707077.4136.35.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:29548 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752441AbZHaI3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2009 04:29:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Alasdair G Kergon <agk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Greeting SCSI and multipath folks,

This patch updates lio-core-2.6.git code to support a optional millisecond delay of
ALUA primary and secondary access state transition via explict (via MO SET_TARGET_PORT_GROUPS)
and implict (via configfs) ALUA operations.

This was something that Hannes had asked me doing about at LSF 09', and is now available
in LIO v3.1, and is intended to be used for debugging scsi_dh_alua and other
ALUA client side code during ALUA_ACCESS_STATE_TRANSITION.

This patch updates core_alua_do_transition_tg_pt() to set the current primary
target port group ALUA access state to ALUA_ACCESS_STATE_TRANSITION for the
passed t10_alua_tg_pt_gp_t, and then optionally wait for tg_pt_gp_trans_delay_msecs
before successfully completing the transition to the new ALUA primary access state.

By default, the transition delay is disabled in the ALUA_DEFAULT_TRANS_DELAY_MSECS
constant, and is intended to add debugging for initiator side ALUA transition
scenarios.

This patch adds a new configfs attribute for this delay in milliseconds located at:

/sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP_NAME/trans_delay_msecs

This patch also updates core_alua_set_tg_pt_secondary_state() to optionally
wait for the same target port group trans_delay_msecs value with the 'Offline'
ALUA secondary access state transition of the fabric dependent SCSI target port.

The userspace commit can be found here:

http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=0b77cc113ef20e26fd58df8d8711a463a0b24070

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c     |   57 +++++++++++++++++++++++++++++++--
 drivers/target/target_core_configfs.c |   21 ++++++++++++
 include/target/target_core_alua.h     |   11 ++++++
 include/target/target_core_base.h     |    1 +
 4 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index b970c50..0845436 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -625,12 +625,21 @@ int core_alua_do_transition_tg_pt(
 	se_port_t *port;
 	t10_alua_tg_pt_gp_member_t *mem;
 	int old_state = 0;
-
+	/*
+	 * Save the old primary ALUA access state, and set the current state
+	 * to ALUA_ACCESS_STATE_TRANSITION.
+	 */
 	old_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
-	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
+	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
+			ALUA_ACCESS_STATE_TRANSITION);
 	tg_pt_gp->tg_pt_gp_alua_access_status = (explict) ?
 				ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
 				ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+	/*
+	 * Check for the optional ALUA primary state transition delay
+	 */
+	if (tg_pt_gp->tg_pt_gp_trans_delay_msecs != 0) 
+		msleep_interruptible(tg_pt_gp->tg_pt_gp_trans_delay_msecs);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(mem, &tg_pt_gp->tg_pt_gp_mem_list,
@@ -674,6 +683,10 @@ int core_alua_do_transition_tg_pt(
 		smp_mb__after_atomic_dec();
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+	/*
+	 * Set the current primary ALUA access state to the requested new state
+	 */
+	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
 
 	printk(KERN_INFO "Successful %s ALUA transition TG PT Group: %s ID: %hu"
 		" from primary access state: %s to %s\n", (explict) ? "explict" :
@@ -806,6 +819,7 @@ int core_alua_set_tg_pt_secondary_state(
 	int offline)
 {
 	struct t10_alua_tg_pt_gp_s *tg_pt_gp;
+	int trans_delay_msecs;
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
@@ -815,6 +829,7 @@ int core_alua_set_tg_pt_secondary_state(
 				" transition\n");
 		return -1;
 	}
+	trans_delay_msecs = tg_pt_gp->tg_pt_gp_trans_delay_msecs;
 	/*
 	 * Set the secondary ALUA target port access state to OFFLINE
 	 * or release the previously secondary state for se_port_t
@@ -827,13 +842,17 @@ int core_alua_set_tg_pt_secondary_state(
 	port->sep_tg_pt_secondary_stat = (explict) ?
 			ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 	printk(KERN_INFO "Successful %s ALUA transition TG PT Group: %s ID: %hu"
 		" to secondary access state: %s\n", (explict) ? "explict" :
 		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
 
+	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
+	if (trans_delay_msecs != 0)
+		msleep_interruptible(trans_delay_msecs);	
+
 	return 0;
 }
 
@@ -1106,6 +1125,7 @@ t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp(
 	 * Set the default Active/NonOptimized Delay in milliseconds
 	 */
 	tg_pt_gp->tg_pt_gp_nonop_delay_msecs = ALUA_DEFAULT_NONOP_DELAY_MSECS;
+	tg_pt_gp->tg_pt_gp_trans_delay_msecs = ALUA_DEFAULT_TRANS_DELAY_MSECS;
 
 	if (def_group) {
 		spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
@@ -1573,6 +1593,37 @@ ssize_t core_alua_store_nonop_delay_msecs(
 	return count;
 }
 
+ssize_t core_alua_show_trans_delay_msecs(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	char *page)
+{
+	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_trans_delay_msecs);
+}
+
+ssize_t core_alua_store_trans_delay_msecs(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract trans_delay_msecs\n");
+		return -EINVAL;
+	}
+	if (tmp > ALUA_MAX_TRANS_DELAY_MSECS) {
+		printk(KERN_ERR "Passed trans_delay_msecs: %lu, exceeds"
+			" ALUA_MAX_TRANS_DELAY_MSECS: %d\n", tmp,
+			ALUA_MAX_TRANS_DELAY_MSECS);
+		return -EINVAL;
+	}
+	tg_pt_gp->tg_pt_gp_trans_delay_msecs = (int)tmp;
+
+	return count;
+}
+
 ssize_t core_alua_show_preferred_bit(
 	t10_alua_tg_pt_gp_t *tg_pt_gp,
 	char *page)
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3fed78c..360fa92 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2266,6 +2266,26 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_nonop_delay_msecs(
 SE_DEV_ALUA_TG_PT_ATTR(nonop_delay_msecs, S_IRUGO | S_IWUSR);
 
 /*
+ * trans_delay_msecs
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_trans_delay_msecs(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return core_alua_show_trans_delay_msecs(tg_pt_gp, page);
+}
+
+static ssize_t target_core_alua_tg_pt_gp_store_attr_trans_delay_msecs(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	return core_alua_store_trans_delay_msecs(tg_pt_gp, page, count);	
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(trans_delay_msecs, S_IRUGO | S_IWUSR);
+
+/*
  * preferred
  */
 
@@ -2387,6 +2407,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_status.attr,
 	&target_core_alua_tg_pt_gp_alua_access_type.attr,
 	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
+	&target_core_alua_tg_pt_gp_trans_delay_msecs.attr,
 	&target_core_alua_tg_pt_gp_preferred.attr,
 	&target_core_alua_tg_pt_gp_tg_pt_gp_id.attr,
 	&target_core_alua_tg_pt_gp_members.attr,
diff --git a/include/target/target_core_alua.h b/include/target/target_core_alua.h
index 825c2a8..0229e18 100644
--- a/include/target/target_core_alua.h
+++ b/include/target/target_core_alua.h
@@ -45,6 +45,13 @@
  */
 #define ALUA_DEFAULT_NONOP_DELAY_MSECS			100
 #define ALUA_MAX_NONOP_DELAY_MSECS			10000 /* 10 seconds */
+/*
+ * Used for implict and explict ALUA transitional delay, that is disabled
+ * by default, and is intended to be used for debugging client side ALUA code.
+ */
+#define ALUA_DEFAULT_TRANS_DELAY_MSECS			0
+#define ALUA_MAX_TRANS_DELAY_MSECS			30000 /* 30 seconds */
+
 
 extern se_global_t *se_global;
 
@@ -104,6 +111,10 @@ extern ssize_t core_alua_show_nonop_delay_msecs(struct t10_alua_tg_pt_gp_s *,
 						char *);
 extern ssize_t core_alua_store_nonop_delay_msecs(struct t10_alua_tg_pt_gp_s *,
 					const char *, size_t);
+extern ssize_t core_alua_show_trans_delay_msecs(struct t10_alua_tg_pt_gp_s *,
+					char *);
+extern ssize_t core_alua_store_trans_delay_msecs(struct t10_alua_tg_pt_gp_s *,
+					const char *, size_t);
 extern ssize_t core_alua_show_preferred_bit(struct t10_alua_tg_pt_gp_s *, char *);
 extern ssize_t core_alua_store_preferred_bit(struct t10_alua_tg_pt_gp_s *,
 				const char *, size_t);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3a97d1e..8bf7877 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -267,6 +267,7 @@ typedef struct t10_alua_tg_pt_gp_s {
 	int	tg_pt_gp_alua_access_status;
 	int	tg_pt_gp_alua_access_type;
 	int	tg_pt_gp_nonop_delay_msecs;
+	int	tg_pt_gp_trans_delay_msecs;
 	int	tg_pt_gp_pref;
 	u32	tg_pt_gp_members;
 	atomic_t tg_pt_gp_alua_access_state;
-- 
1.5.4.1




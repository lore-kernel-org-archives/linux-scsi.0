From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] target: replace strict_strto*() with kstrto*()
Date: Fri, 19 Jul 2013 16:22:19 +0900
Message-ID: <001901ce8450$b4302fb0$1c908f10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49394 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770Ab3GSHWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 03:22:21 -0400
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

The usage of strict_strtoul() and strict_strtoull() is not preferred,
because strict_strtoul() and strict_strtoull() are obsolete. Thus,
kstrtoul() and kstrtoull() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c   |    8 ++---
 drivers/target/iscsi/iscsi_target_login.c      |    2 +-
 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 drivers/target/target_core_alua.c              |   32 +++++++++---------
 drivers/target/target_core_configfs.c          |   42 ++++++++++++------------
 drivers/target/target_core_fabric_configfs.c   |   16 ++++++---
 drivers/target/target_core_file.c              |    4 +--
 drivers/target/target_core_iblock.c            |    4 +--
 drivers/target/tcm_fc/tfc_conf.c               |    6 +++-
 9 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index bbfd288..ddfa32c 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -265,9 +265,9 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		*port_str = '\0'; /* Terminate string for IP */
 		port_str++; /* Skip over ":" */
 
-		ret = strict_strtoul(port_str, 0, &port);
+		ret = kstrtoul(port_str, 0, &port);
 		if (ret < 0) {
-			pr_err("strict_strtoul() failed for port_str: %d\n", ret);
+			pr_err("kstrtoul() failed for port_str: %d\n", ret);
 			return ERR_PTR(ret);
 		}
 		sock_in6 = (struct sockaddr_in6 *)&sockaddr;
@@ -290,9 +290,9 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		*port_str = '\0'; /* Terminate string for IP */
 		port_str++; /* Skip over ":" */
 
-		ret = strict_strtoul(port_str, 0, &port);
+		ret = kstrtoul(port_str, 0, &port);
 		if (ret < 0) {
-			pr_err("strict_strtoul() failed for port_str: %d\n", ret);
+			pr_err("kstrtoul() failed for port_str: %d\n", ret);
 			return ERR_PTR(ret);
 		}
 		sock_in = (struct sockaddr_in *)&sockaddr;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 3402241..76cf1cd 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -428,7 +428,7 @@ static int iscsi_login_zero_tsih_s2(
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 			return -1;
 		}
-		rc = strict_strtoul(param->value, 0, &mrdsl);
+		rc = kstrtoul(param->value, 0, &mrdsl);
 		if (rc < 0) {
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 35fd643..034bd6d 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1182,7 +1182,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 			unsigned long long tmp;
 			int rc;
 
-			rc = strict_strtoull(param->value, 0, &tmp);
+			rc = kstrtoull(param->value, 0, &tmp);
 			if (rc < 0)
 				return -1;
 
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index cbe48ab..5403186 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1756,10 +1756,10 @@ ssize_t core_alua_store_access_type(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract alua_access_type\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
 		pr_err("Illegal value for alua_access_type:"
@@ -1794,10 +1794,10 @@ ssize_t core_alua_store_nonop_delay_msecs(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract nonop_delay_msecs\n");
-		return -EINVAL;
+		return ret;
 	}
 	if (tmp > ALUA_MAX_NONOP_DELAY_MSECS) {
 		pr_err("Passed nonop_delay_msecs: %lu, exceeds"
@@ -1825,10 +1825,10 @@ ssize_t core_alua_store_trans_delay_msecs(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract trans_delay_msecs\n");
-		return -EINVAL;
+		return ret;
 	}
 	if (tmp > ALUA_MAX_TRANS_DELAY_MSECS) {
 		pr_err("Passed trans_delay_msecs: %lu, exceeds"
@@ -1856,10 +1856,10 @@ ssize_t core_alua_store_implict_trans_secs(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract implict_trans_secs\n");
-		return -EINVAL;
+		return ret;
 	}
 	if (tmp > ALUA_MAX_IMPLICT_TRANS_SECS) {
 		pr_err("Passed implict_trans_secs: %lu, exceeds"
@@ -1887,10 +1887,10 @@ ssize_t core_alua_store_preferred_bit(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract preferred ALUA value\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
 		pr_err("Illegal value for preferred ALUA: %lu\n", tmp);
@@ -1922,10 +1922,10 @@ ssize_t core_alua_store_offline_bit(
 	if (!lun->lun_sep)
 		return -ENODEV;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract alua_tg_pt_offline value\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
 		pr_err("Illegal value for alua_tg_pt_offline: %lu\n",
@@ -1961,10 +1961,10 @@ ssize_t core_alua_store_secondary_status(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract alua_tg_pt_status\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != ALUA_STATUS_NONE) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
@@ -1994,10 +1994,10 @@ ssize_t core_alua_store_secondary_write_metadata(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract alua_tg_pt_write_md\n");
-		return -EINVAL;
+		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
 		pr_err("Illegal value for alua_tg_pt_write_md:"
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index e4d2293..f67a9af 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -577,9 +577,9 @@ static ssize_t target_core_dev_store_attr_##_name(			\
 	unsigned long val;						\
 	int ret;							\
 									\
-	ret = strict_strtoul(page, 0, &val);				\
+	ret = kstrtoul(page, 0, &val);				\
 	if (ret < 0) {							\
-		pr_err("strict_strtoul() failed with"		\
+		pr_err("kstrtoul() failed with"		\
 			" ret: %d\n", ret);				\
 		return -EINVAL;						\
 	}								\
@@ -1310,9 +1310,9 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 				ret = -ENOMEM;
 				goto out;
 			}
-			ret = strict_strtoull(arg_p, 0, &tmp_ll);
+			ret = kstrtoull(arg_p, 0, &tmp_ll);
 			if (ret < 0) {
-				pr_err("strict_strtoull() failed for"
+				pr_err("kstrtoull() failed for"
 					" sa_res_key=\n");
 				goto out;
 			}
@@ -1836,11 +1836,11 @@ static ssize_t target_core_alua_lu_gp_store_attr_lu_gp_id(
 	unsigned long lu_gp_id;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &lu_gp_id);
+	ret = kstrtoul(page, 0, &lu_gp_id);
 	if (ret < 0) {
-		pr_err("strict_strtoul() returned %d for"
+		pr_err("kstrtoul() returned %d for"
 			" lu_gp_id\n", ret);
-		return -EINVAL;
+		return ret;
 	}
 	if (lu_gp_id > 0x0000ffff) {
 		pr_err("ALUA lu_gp_id: %lu exceeds maximum:"
@@ -2032,11 +2032,11 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 		return -EINVAL;
 	}
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract new ALUA access state from"
 				" %s\n", page);
-		return -EINVAL;
+		return ret;
 	}
 	new_state = (int)tmp;
 
@@ -2079,11 +2079,11 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 		return -EINVAL;
 	}
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract new ALUA access status"
 				" from %s\n", page);
-		return -EINVAL;
+		return ret;
 	}
 	new_status = (int)tmp;
 
@@ -2139,10 +2139,10 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_write_metadata(
 	unsigned long tmp;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		pr_err("Unable to extract alua_write_metadata\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	if ((tmp != 0) && (tmp != 1)) {
@@ -2263,11 +2263,11 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_tg_pt_gp_id(
 	unsigned long tg_pt_gp_id;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &tg_pt_gp_id);
+	ret = kstrtoul(page, 0, &tg_pt_gp_id);
 	if (ret < 0) {
-		pr_err("strict_strtoul() returned %d for"
+		pr_err("kstrtoul() returned %d for"
 			" tg_pt_gp_id\n", ret);
-		return -EINVAL;
+		return ret;
 	}
 	if (tg_pt_gp_id > 0x0000ffff) {
 		pr_err("ALUA tg_pt_gp_id: %lu exceeds maximum:"
@@ -2676,10 +2676,10 @@ static ssize_t target_core_hba_store_attr_hba_mode(struct se_hba *hba,
 	if (transport->pmode_enable_hba == NULL)
 		return -EINVAL;
 
-	ret = strict_strtoul(page, 0, &mode_flag);
+	ret = kstrtoul(page, 0, &mode_flag);
 	if (ret < 0) {
 		pr_err("Unable to extract hba mode flag: %d\n", ret);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (hba->dev_count) {
@@ -2767,11 +2767,11 @@ static struct config_group *target_core_call_addhbatotarget(
 		str++; /* Skip to start of plugin dependent ID */
 	}
 
-	ret = strict_strtoul(str, 0, &plugin_dep_id);
+	ret = kstrtoul(str, 0, &plugin_dep_id);
 	if (ret < 0) {
-		pr_err("strict_strtoul() returned %d for"
+		pr_err("kstrtoul() returned %d for"
 				" plugin_dep_id\n", ret);
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(ret);
 	}
 	/*
 	 * Load up TCM subsystem plugins if they have not already been loaded.
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index eb56eb1..f5ce68f 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -189,9 +189,11 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 	struct se_node_acl *se_nacl = lacl->se_lun_nacl;
 	struct se_portal_group *se_tpg = se_nacl->se_tpg;
 	unsigned long op;
+	int ret;
 
-	if (strict_strtoul(page, 0, &op))
-		return -EINVAL;
+	ret = kstrtoul(page, 0, &op);
+	if (ret)
+		return ret;
 
 	if ((op != 1) && (op != 0))
 		return -EINVAL;
@@ -350,7 +352,10 @@ static struct config_group *target_fabric_make_mappedlun(
 	 * Determine the Mapped LUN value.  This is what the SCSI Initiator
 	 * Port will actually see.
 	 */
-	if (strict_strtoul(buf + 4, 0, &mapped_lun) || mapped_lun > UINT_MAX) {
+	ret = kstrtoul(buf + 4, 0, &mapped_lun);
+	if (ret)
+		goto out;
+	if (mapped_lun > UINT_MAX) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -875,7 +880,10 @@ static struct config_group *target_fabric_make_lun(
 				" \"lun_$LUN_NUMBER\"\n");
 		return ERR_PTR(-EINVAL);
 	}
-	if (strict_strtoul(name + 4, 0, &unpacked_lun) || unpacked_lun > UINT_MAX)
+	errno = kstrtoul(name + 4, 0, &unpacked_lun);
+	if (errno)
+		return ERR_PTR(errno);
+	if (unpacked_lun > UINT_MAX)
 		return ERR_PTR(-EINVAL);
 
 	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index b11890d..bc3245d 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -635,10 +635,10 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				ret = -ENOMEM;
 				break;
 			}
-			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
+			ret = kstrtoull(arg_p, 0, &fd_dev->fd_dev_size);
 			kfree(arg_p);
 			if (ret < 0) {
-				pr_err("strict_strtoull() failed for"
+				pr_err("kstrtoull() failed for"
 						" fd_dev_size=\n");
 				goto out;
 			}
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index aa1620a..0a460f3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -536,10 +536,10 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 				ret = -ENOMEM;
 				break;
 			}
-			ret = strict_strtoul(arg_p, 0, &tmp_readonly);
+			ret = kstrtoul(arg_p, 0, &tmp_readonly);
 			kfree(arg_p);
 			if (ret < 0) {
-				pr_err("strict_strtoul() failed for"
+				pr_err("kstrtoul() failed for"
 						" readonly=\n");
 				goto out;
 			}
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index b74feb0..46d963f 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -311,7 +311,11 @@ static struct se_portal_group *ft_add_tpg(
 	 */
 	if (strstr(name, "tpgt_") != name)
 		return NULL;
-	if (strict_strtoul(name + 5, 10, &index) || index > UINT_MAX)
+
+	ret = kstrtoul(name + 5, 10, &index);
+	if (ret)
+		return ret;
+	if (index > UINT_MAX)
 		return NULL;
 
 	lacl = container_of(wwn, struct ft_lport_acl, fc_lport_wwn);
-- 
1.7.10.4



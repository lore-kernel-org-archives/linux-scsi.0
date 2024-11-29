Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9F017A90F;
	Fri, 29 Nov 2024 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894360; cv=none; b=knpnssBOy3SpxJPi4SFGont03jIpNyvV1cQEDFPueSlpVdN8ZgtnbjsGkXeOYwm53ivdoiNbPtsZWxPz63O8cBuh6RSGF7B6HTsL0hmQlkIElAyRO3fkslRoJp1DrRCvq8zndO3QnVdxtoAwey1I+lmvyPi5BeuJrYj1dyRiA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894360; c=relaxed/simple;
	bh=bl7UJWXcEGTfHmaLaXq+Y+IdDUumwU6F81WyFmbq3yI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyvWNCWMfpckE3prFnSZBHiUXLNLfdFimkc83E5LJpjsSXYmesGS4kBdD2SVcg3kYMLWyyuJSVTcRZG+XRd/XwEI24XykdyWBrN8KxQ8yEoRZZ92EnB8rKT6WS0OS26iDpycnhZbQasWg0QfhWHuclQ932bZKaz4CQqG0lQQUCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=omP5VN3n; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=NcJd0a8w; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="omP5VN3n";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="NcJd0a8w"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 954F7E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894350; bh=wWWltgc4V1ZpCkF+5Y9aQqvPmgKfSwX3DO1cTuW2N24=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=omP5VN3nnpTGiUAkgkS41ymZWOB0jHXK/rVYt4CpTjohLH75jA48UMnEvb5zn437X
	 LREQRTCTKEYYi4pGyJq6ET3GFCNj1rYck5oLcfTHTARR0jU7UljA8jNiwtxniOAOFr
	 JZtLNH9B6ScW29p/vnw2W6ExBiaIBu/YofZhJHFhSocmBuQ/iNxdX2zKugAfVN6ZIp
	 YqfyvDq2C/k7o1LTeWF/Clmv9Ot9ATwoNedHw9EdFcQPLm3Sd/XcpOItvJeaBJafYd
	 DaJNt+b1khDjKljpXAyE1DbuREo7f3/WVAFPv9AdZ1x7XZfPFXQlvKZ4ZfHEzOoR+9
	 j/CBt75zypSeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894350; bh=wWWltgc4V1ZpCkF+5Y9aQqvPmgKfSwX3DO1cTuW2N24=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=NcJd0a8wnF1o4nOLd7pNv56SB6ojn/SZuPldJiE/fTaejsRiSP9qUQtoMNHOXbbDB
	 PzBLcdEFqB2kr450ONqKZlLv5sLMkd9IPKmGZnlknS6SPP1xM3boUwE2jI43KXVV23
	 HCaZcE6gWKr6DtxHqAtGifknPdEoyWqcjz9d+ZMdo7S/1b3mcr00pg1LK+fYIfRQDG
	 UcCnRS2HaHqsZYcfODeMQjmbqzgCProftXLvRyeqxBrVcmk4HpyYbk9yRx2Ny3iX4O
	 sAin7Xnnlu/LSHgMkahVyLvEWMxExDO+6+t2jhyxF7RZ+qc9fzVVazwfhJRNYQ+oAd
	 gVz38IxEE/XfA==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 08/10] target: core: Use extended logs where possible
Date: Fri, 29 Nov 2024 18:30:54 +0300
Message-ID: <20241129153056.6985-9-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

1) Change the common logs to the extended ones where it is possible;
2) Change the logs themselves removing repeating parts in the new
   wrapper;
3) Align the format string arguments with clang-config;
4) Remove unused variables;

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/target_core_alua.c            |  72 ++--
 drivers/target/target_core_configfs.c        |   8 +-
 drivers/target/target_core_device.c          |  46 +--
 drivers/target/target_core_fabric_configfs.c |   8 +-
 drivers/target/target_core_file.c            |  45 +--
 drivers/target/target_core_hba.c             |   4 +-
 drivers/target/target_core_iblock.c          |  35 +-
 drivers/target/target_core_pr.c              | 353 ++++++++++---------
 drivers/target/target_core_pscsi.c           |  44 +--
 drivers/target/target_core_rd.c              |  22 +-
 drivers/target/target_core_sbc.c             | 120 +++----
 drivers/target/target_core_spc.c             |  20 +-
 drivers/target/target_core_tmr.c             |  19 +-
 drivers/target/target_core_tpg.c             |   9 +-
 drivers/target/target_core_transport.c       | 104 +++---
 drivers/target/target_core_ua.c              |  14 +-
 drivers/target/target_core_xcopy.c           | 180 +++++-----
 17 files changed, 558 insertions(+), 545 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fd91a2a3b120..04916ecd6ed2 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -64,7 +64,8 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	u32 rd_len = 0, off;
 
 	if (cmd->data_length < 4) {
-		target_warn("REPORT REFERRALS allocation length %u too small\n", cmd->data_length);
+		target_cmd_warn(cmd, "REPORT REFERRALS allocation length %u too small\n",
+				cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -153,8 +154,8 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		off = 4;
 
 	if (cmd->data_length < off) {
-		target_warn("REPORT TARGET PORT GROUPS allocation length %u too small for %s header\n",
-			    cmd->data_length, (ext_hdr) ? "extended" : "normal");
+		target_cmd_warn(cmd, "REPORT TARGET PORT GROUPS allocation length %u too small for %s header\n",
+				cmd->data_length, (ext_hdr) ? "extended" : "normal");
 		return TCM_INVALID_CDB_FIELD;
 	}
 	buf = transport_kmap_data_sg(cmd);
@@ -282,8 +283,8 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	u16 tg_pt_id, rtpi;
 
 	if (cmd->data_length < 4) {
-		target_warn("SET TARGET PORT GROUPS parameter list length %u too small\n",
-			    cmd->data_length);
+		target_cmd_warn(cmd, "SET TARGET PORT GROUPS parameter list length %u too small\n",
+				cmd->data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
@@ -299,14 +300,14 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	l_tg_pt_gp = rcu_dereference(l_lun->lun_tg_pt_gp);
 	if (!l_tg_pt_gp) {
 		rcu_read_unlock();
-		target_err("Unable to access l_lun->tg_pt_gp\n");
+		target_cmd_err(cmd, "Unable to access l_lun->tg_pt_gp\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
 
 	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
 		rcu_read_unlock();
-		target_debug("Unable to process SET_TARGET_PORT_GROUPS while TPGS_EXPLICIT_ALUA is disabled\n");
+		target_cmd_debug(cmd, "Unable to process SET_TARGET_PORT_GROUPS while TPGS_EXPLICIT_ALUA is disabled\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
@@ -662,7 +663,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	 * access state: OFFLINE
 	 */
 	if (atomic_read(&lun->lun_tg_pt_secondary_offline)) {
-		target_debug("ALUA: Got secondary offline status for local target port\n");
+		target_cmd_debug(cmd, "ALUA: Got secondary offline status for local target port\n");
 		return TCM_ALUA_OFFLINE;
 	}
 	rcu_read_lock();
@@ -707,13 +708,13 @@ target_alua_state_check(struct se_cmd *cmd)
 	 */
 	case ALUA_ACCESS_STATE_OFFLINE:
 	default:
-		target_err("Unknown ALUA access state: 0x%02x\n", out_alua_state);
+		target_cmd_err(cmd, "Unknown ALUA access state: 0x%02x\n", out_alua_state);
 		rc = TCM_INVALID_CDB_FIELD;
 	}
 
 	if (rc && rc != TCM_INVALID_CDB_FIELD) {
-		target_debug("[%s]: ALUA TG Port not available, SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
-			     cmd->se_tfo->fabric_name, rc);
+		target_cmd_debug(cmd, "[%s]: ALUA TG Port not available, SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
+				 cmd->se_tfo->fabric_name, rc);
 	}
 
 	return rc;
@@ -1168,7 +1169,7 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
-		target_err("Unable to allocate buf for ALUA metadata\n");
+		target_lun_err(lun, "Unable to allocate buf for ALUA metadata\n");
 		rc = -ENOMEM;
 		goto out_unlock;
 	}
@@ -1216,7 +1217,7 @@ static int core_alua_set_tg_pt_secondary_state(
 	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (!tg_pt_gp) {
 		rcu_read_unlock();
-		target_err("Unable to complete secondary state transition\n");
+		target_lun_err(lun, "Unable to complete secondary state transition\n");
 		return -EINVAL;
 	}
 	trans_delay_msecs = tg_pt_gp->tg_pt_gp_trans_delay_msecs;
@@ -1233,10 +1234,10 @@ static int core_alua_set_tg_pt_secondary_state(
 			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
-	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %u to secondary access state: %s\n",
-		     (explicit) ? "explicit" : "implicit",
-		     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
-		     (offline) ? "OFFLINE" : "ONLINE");
+	target_lun_debug(lun, "Successful %s ALUA transition TG PT Group: %s ID: %u to secondary access state: %s\n",
+			 (explicit) ? "explicit" : "implicit",
+			 config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
+			 (offline) ? "OFFLINE" : "ONLINE");
 
 	rcu_read_unlock();
 	/*
@@ -1898,7 +1899,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		return -ENODEV;
 
 	if (count > TG_PT_GROUP_NAME_BUF) {
-		target_err("ALUA Target Port Group alias too large!\n");
+		target_lun_err(lun, "ALUA Target Port Group alias too large!\n");
 		return -EINVAL;
 	}
 	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
@@ -1928,12 +1929,12 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * with the default_tg_pt_gp.
 		 */
 		if (!tg_pt_gp_new) {
-			target_debug("configfs: Moving %s/tpgt_%u/%s from ALUA Target Port Group: alua/%s, ID: %u back to default_tg_pt_gp\n",
-				     tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-				     tpg->se_tpg_tfo->tpg_get_tag(tpg),
-				     config_item_name(&lun->lun_group.cg_item),
-				     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
-				     tg_pt_gp->tg_pt_gp_id);
+			target_lun_debug(lun, "configfs: Moving %s/tpgt_%u/%s from ALUA Target Port Group: alua/%s, ID: %u back to default_tg_pt_gp\n",
+					 tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+					 tpg->se_tpg_tfo->tpg_get_tag(tpg),
+					 config_item_name(&lun->lun_group.cg_item),
+					 config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+					 tg_pt_gp->tg_pt_gp_id);
 
 			target_swap_tg_pt_gp(lun, tg_pt_gp,
 					dev->t10_alua.default_tg_pt_gp);
@@ -1946,11 +1947,12 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 	target_swap_tg_pt_gp(lun, tg_pt_gp, tg_pt_gp_new);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	target_debug("configfs: %s %s/tpgt_%u/%s to ALUA Target Port Group: alua/%s, ID: %u\n",
-		     (move) ? "Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-		     tpg->se_tpg_tfo->tpg_get_tag(tpg), config_item_name(&lun->lun_group.cg_item),
-		     config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
-		     tg_pt_gp_new->tg_pt_gp_id);
+	target_lun_debug(lun, "configfs: %s %s/tpgt_%u/%s to ALUA Target Port Group: alua/%s, ID: %u\n",
+			 (move) ? "Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+			 tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			 config_item_name(&lun->lun_group.cg_item),
+			 config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
+			 tg_pt_gp_new->tg_pt_gp_id);
 
 	core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
 sync_rcu:
@@ -2147,11 +2149,11 @@ ssize_t core_alua_store_offline_bit(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		target_err("Unable to extract alua_tg_pt_offline value\n");
+		target_lun_err(lun, "Unable to extract alua_tg_pt_offline value\n");
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		target_err("Illegal value for alua_tg_pt_offline: %lu\n", tmp);
+		target_lun_err(lun, "Illegal value for alua_tg_pt_offline: %lu\n", tmp);
 		return -EINVAL;
 	}
 
@@ -2179,13 +2181,13 @@ ssize_t core_alua_store_secondary_status(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		target_err("Unable to extract alua_tg_pt_status\n");
+		target_lun_err(lun, "Unable to extract alua_tg_pt_status\n");
 		return ret;
 	}
 	if ((tmp != ALUA_STATUS_NONE) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA)) {
-		target_err("Illegal value for alua_tg_pt_status: %lu\n", tmp);
+		target_lun_err(lun, "Illegal value for alua_tg_pt_status: %lu\n", tmp);
 		return -EINVAL;
 	}
 	lun->lun_tg_pt_secondary_stat = (int)tmp;
@@ -2210,11 +2212,11 @@ ssize_t core_alua_store_secondary_write_metadata(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		target_err("Unable to extract alua_tg_pt_write_md\n");
+		target_lun_err(lun, "Unable to extract alua_tg_pt_write_md\n");
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		target_err("Illegal value for alua_tg_pt_write_md: %lu\n", tmp);
+		target_lun_err(lun, "Illegal value for alua_tg_pt_write_md: %lu\n", tmp);
 		return -EINVAL;
 	}
 	lun->lun_tg_pt_secondary_write_md = (int)tmp;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ea958b9a21b8..4c058472acb7 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -196,7 +196,7 @@ static struct config_group *target_core_register_fabric(
 
 	tf = target_core_get_fabric(name);
 	if (!tf) {
-		target_debug("target_core_register_fabric() trying autoload for %s\n", name);
+		target_debug("%s trying autoload for %s\n", __func__, name);
 
 		/*
 		 * Below are some hardcoded request_module() calls to automatically
@@ -3589,8 +3589,8 @@ static int __init target_core_init_configfs(void)
 	const struct cred *old_cred;
 	int ret;
 
-	target_debug("TARGET_CORE[0]: Loading Generic Kernel Storage Engine: %s on %s/%s on "
-		     UTS_RELEASE "\n", TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
+	target_debug("Loading Generic Kernel Storage Engine: %s on %s/%s on " UTS_RELEASE "\n",
+		     TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
 
 	config_group_init(&subsys->su_group);
 	mutex_init(&subsys->su_mutex);
@@ -3704,7 +3704,7 @@ static void __exit target_core_exit_configfs(void)
 	core_alua_free_lu_gp(default_lu_gp);
 	default_lu_gp = NULL;
 
-	target_debug("TARGET_CORE[0]: Released ConfigFS Fabric Infrastructure\n");
+	target_debug("Released ConfigFS Fabric Infrastructure\n");
 
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1d54579ecca2..e95c5ce31457 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -68,8 +68,8 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    deve->lun_access_ro) {
-			target_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN Access for 0x%08llx\n",
-				   se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun);
+			target_cmd_err(se_cmd, "[%s]: Detected WRITE_PROTECTED LUN Access\n",
+				       se_cmd->se_tfo->fabric_name);
 			rcu_read_unlock();
 			return TCM_WRITE_PROTECTED;
 		}
@@ -96,9 +96,8 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 		 * MappedLUN=0 exists for this Initiator Port.
 		 */
 		if (se_cmd->orig_fe_lun != 0) {
-			target_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN Access for 0x%08llx from %s\n",
-				   se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun,
-				   nacl->initiatorname);
+			target_cmd_err(se_cmd, "[%s]: Detected NON_EXISTENT_LUN Access\n",
+				       se_cmd->se_tfo->fabric_name);
 			return TCM_NON_EXISTENT_LUN;
 		}
 
@@ -164,8 +163,8 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	rcu_read_unlock();
 
 	if (!se_lun) {
-		target_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN Access for 0x%08llx for %s\n",
-			     se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun, nacl->initiatorname);
+		target_cmd_debug(se_cmd, "[%s]: Detected NON_EXISTENT_LUN Access",
+				 se_cmd->se_tfo->fabric_name);
 		return -ENODEV;
 	}
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
@@ -207,7 +206,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		lun = deve->se_lun;
 		if (!lun) {
-			target_err("%s device entries device pointer is NULL, but Initiator has access.\n",
+			target_err("[%s]: device entries lun pointer is NULL, but Initiator has access.\n",
 				   tpg->se_tpg_tfo->fabric_name);
 			continue;
 		}
@@ -319,7 +318,7 @@ int core_enable_device_list_for_node(
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new) {
-		target_err("Unable to allocate se_dev_entry memory\n");
+		target_lun_err(lun, "Unable to allocate se_dev_entry memory\n");
 		return -ENOMEM;
 	}
 
@@ -341,15 +340,15 @@ int core_enable_device_list_for_node(
 		struct se_lun *orig_lun = orig->se_lun;
 
 		if (orig_lun != lun) {
-			target_err("Existing orig->se_lun doesn't match new lun for dynamic -> explicit NodeACL conversion: %s\n",
-				   nacl->initiatorname);
+			target_lun_err(lun, "Existing orig->se_lun doesn't match new lun for dynamic -> explicit NodeACL conversion: %s\n",
+				       nacl->initiatorname);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
 			return -EINVAL;
 		}
 		if (orig->se_lun_acl != NULL) {
-			target_warn_ratelimited("Detected existing explicit se_lun_acl->se_lun_group reference for %s mapped_lun: %llu, failing\n",
-						nacl->initiatorname, mapped_lun);
+			target_lun_warn_ratelimited(lun, "Detected existing explicit se_lun_acl->se_lun_group reference for %s mapped_lun: %llu, failing\n",
+						    nacl->initiatorname, mapped_lun);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
 			return -EINVAL;
@@ -506,9 +505,7 @@ int core_dev_add_lun(
 	if (rc < 0)
 		return rc;
 
-	target_debug("%s_TPG[%u]_LUN[%llu] - Activated %s Logical Unit from CORE HBA: %u\n",
-		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		     lun->unpacked_lun, tpg->se_tpg_tfo->fabric_name, dev->se_hba->hba_id);
+	target_lun_debug(lun, "Activated Logical Unit from CORE HBA: %u\n", dev->se_hba->hba_id);
 	/*
 	 * Update LUN maps for dynamically added initiators when
 	 * generate_node_acl is enabled.
@@ -538,9 +535,7 @@ void core_dev_del_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	target_debug("%s_TPG[%u]_LUN[%llu] - Deactivating %s Logical Unit from device object\n",
-		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		     lun->unpacked_lun, tpg->se_tpg_tfo->fabric_name);
+	target_lun_debug(lun, "Deactivating Logical Unit from device object\n");
 
 	core_tpg_remove_lun(tpg, lun);
 }
@@ -597,10 +592,8 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access_ro, nacl, tpg) < 0)
 		return -EINVAL;
 
-	target_debug("%s_TPG[%u]_LUN[%llu->%llu] - Added %s ACL for  InitiatorNode: %s\n",
-		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		     lun->unpacked_lun, lacl->mapped_lun, lun_access_ro ? "RO" : "RW",
-		     nacl->initiatorname);
+	target_lun_debug(lun, "Added %s ACL for  InitiatorNode: %s, Mapped LUN %llu\n",
+			 lun_access_ro ? "RO" : "RW", nacl->initiatorname, lacl->mapped_lun);
 	/*
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
@@ -628,9 +621,8 @@ int core_dev_del_initiator_node_lun_acl(
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	target_debug("%s_TPG[%u]_LUN[%llu] - Removed ACL for InitiatorNode: %s Mapped LUN: %llu\n",
-		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		     lun->unpacked_lun, nacl->initiatorname, lacl->mapped_lun);
+	target_lun_debug(lun, "Removed ACL for InitiatorNode: %s Mapped LUN: %llu\n",
+			 nacl->initiatorname, lacl->mapped_lun);
 
 	return 0;
 }
@@ -639,7 +631,7 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl)
 {
-	target_debug("%s_TPG[%u] - Freeing ACL for %s InitiatorNode: %s Mapped LUN: %llu\n",
+	target_debug("%s_tpg[%u] - Freeing ACL for %s InitiatorNode: %s Mapped LUN: %llu\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     tpg->se_tpg_tfo->fabric_name, lacl->se_lun_nacl->initiatorname,
 		     lacl->mapped_lun);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index dec8f25c04d0..d524971e5174 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -106,13 +106,13 @@ static int target_fabric_mappedlun_link(
 	 * Make sure the SymLink is going to the same $FABRIC/$WWN/tpgt_$TPGT
 	 */
 	if (strcmp(config_item_name(wwn_ci), config_item_name(wwn_ci_s))) {
-		target_err("Illegal Initiator ACL SymLink outside of %s\n",
-			   config_item_name(wwn_ci));
+		target_lun_err(lun, "Illegal Initiator ACL SymLink outside of %s\n",
+			       config_item_name(wwn_ci));
 		return -EINVAL;
 	}
 	if (strcmp(config_item_name(tpg_ci), config_item_name(tpg_ci_s))) {
-		target_err("Illegal Initiator ACL Symlink outside of %s TPGT: %s\n",
-			   config_item_name(wwn_ci), config_item_name(tpg_ci));
+		target_lun_err(lun, "Illegal Initiator ACL Symlink outside of %s TPGT: %s\n",
+			       config_item_name(wwn_ci), config_item_name(tpg_ci));
 		return -EINVAL;
 	}
 	/*
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 503b53767b8b..7254c6327ed7 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -50,9 +50,9 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = fd_host;
 
-	target_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic Target Core Stack %s\n",
+	target_debug("hba[%d] - TCM FILEIO HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, FD_VERSION, TARGET_CORE_VERSION);
-	target_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic\n", hba->hba_id,
+	target_debug("hba[%d] - Attached FILEIO HBA: %u to Generic\n", hba->hba_id,
 		     fd_host->fd_host_id);
 
 	return 0;
@@ -62,8 +62,8 @@ static void fd_detach_hba(struct se_hba *hba)
 {
 	struct fd_host *fd_host = hba->hba_ptr;
 
-	target_debug("CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic Target Core\n",
-		     hba->hba_id, fd_host->fd_host_id);
+	target_debug("hba[%d] - Detached FILEIO HBA: %u from Generic Target Core\n", hba->hba_id,
+		     fd_host->fd_host_id);
 
 	kfree(fd_host);
 	hba->hba_ptr = NULL;
@@ -202,7 +202,7 @@ static int fd_configure_device(struct se_device *dev)
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
 
-	target_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s, %llu total bytes\n",
+	target_debug("Host[%u] - Added TCM FILEIO Device ID: %u at %s, %llu total bytes\n",
 		     fd_host->fd_host_id, fd_dev->fd_dev_id, fd_dev->fd_dev_name,
 		     fd_dev->fd_dev_size);
 
@@ -319,7 +319,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 
 	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
 	if (!bvec) {
-		target_err("Unable to allocate fd_do_readv iov[]\n");
+		target_cmd_err(cmd, "Unable to allocate fd_do_readv iov[]\n");
 		return -ENOMEM;
 	}
 
@@ -336,7 +336,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 
 	if (is_write) {
 		if (ret < 0 || ret != data_length) {
-			target_err("%s() write returned %d\n", __func__, ret);
+			target_cmd_err(cmd, "%s() write returned %d\n", __func__, ret);
 			if (ret >= 0)
 				ret = -EINVAL;
 		}
@@ -348,14 +348,15 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 		 */
 		if (S_ISBLK(file_inode(fd)->i_mode)) {
 			if (ret < 0 || ret != data_length) {
-				target_err("%s() returned %d, expecting %u for S_ISBLK\n", __func__,
-					   ret, data_length);
+				target_cmd_err(cmd, "%s() returned %d, expecting %u for S_ISBLK\n",
+					       __func__, ret, data_length);
 				if (ret >= 0)
 					ret = -EINVAL;
 			}
 		} else {
 			if (ret < 0) {
-				target_err("%s() returned %d for non S_ISBLK\n", __func__, ret);
+				target_cmd_err(cmd, "%s() returned %d for non S_ISBLK\n", __func__,
+					       ret);
 			} else if (ret != data_length) {
 				/*
 				 * Short read case:
@@ -406,7 +407,7 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 
 	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 	if (ret != 0)
-		target_err("vfs_fsync_range() failed: %d\n", ret);
+		target_cmd_err(cmd, "vfs_fsync_range() failed: %d\n", ret);
 
 	if (immed)
 		return 0;
@@ -432,7 +433,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 	ssize_t ret;
 
 	if (cmd->prot_op) {
-		target_err("WRITE_SAME: Protection information with FILEIO backends not supported\n");
+		target_cmd_err(cmd, "WRITE_SAME: Protection information with FILEIO backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -441,9 +442,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
-		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
-			   cmd->t_data_nents, cmd->t_data_sg[0].length,
-			   cmd->se_dev->dev_attrib.block_size);
+		target_cmd_err(cmd, "WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
+			       cmd->t_data_nents, cmd->t_data_sg[0].length,
+			       cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -463,7 +464,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 
 	kfree(bvec);
 	if (ret < 0 || ret != len) {
-		target_err("vfs_iter_write() returned %zd for write same\n", ret);
+		target_cmd_err(cmd, "vfs_iter_write() returned %zd for write same\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -510,7 +511,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 	buf = (void *)__get_free_page(GFP_KERNEL);
 	if (!buf) {
-		target_err("Unable to allocate FILEIO prot buf\n");
+		target_cmd_err(cmd, "Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
 	}
 
@@ -548,7 +549,7 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 					   target_to_linux_sector(dev,  nolb),
 					   GFP_KERNEL);
 		if (ret < 0) {
-			target_warn("blkdev_issue_discard() failed: %d\n", ret);
+			target_cmd_warn(cmd, "blkdev_issue_discard() failed: %d\n", ret);
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	} else {
@@ -563,7 +564,7 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 		ret = file->f_op->fallocate(file, mode, pos, len);
 		if (ret < 0) {
-			target_warn("fallocate() failed: %d\n", ret);
+			target_cmd_warn(cmd, "fallocate() failed: %d\n", ret);
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	}
@@ -667,8 +668,8 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * single vfs_[writev,readv] call.
 	 */
 	if (cmd->data_length > FD_MAX_BYTES) {
-		target_err("Not able to process I/O of %u bytes due to FD_MAX_BYTES: %u iovec count limitation\n",
-			   cmd->data_length, FD_MAX_BYTES);
+		target_cmd_err(cmd, "Not able to process I/O of %u bytes due to FD_MAX_BYTES: %u iovec count limitation\n",
+			       cmd->data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -821,7 +822,7 @@ static int fd_init_prot(struct se_device *dev)
 
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
-		target_err("FILEIO Protection emulation only supported on !S_ISBLK\n");
+		target_err("Protection emulation only supported on !S_ISBLK\n");
 		return -ENOSYS;
 	}
 
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 31a426fcb3d4..a5b5442d52ce 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -139,7 +139,7 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 	list_add_tail(&hba->hba_node, &hba_list);
 	spin_unlock(&hba_lock);
 
-	target_debug("CORE_HBA[%d] - Attached HBA to Generic Target Core\n", hba->hba_id);
+	target_debug("hba[%d] - Attached HBA to Generic Target Core\n", hba->hba_id);
 
 	return hba;
 
@@ -162,7 +162,7 @@ core_delete_hba(struct se_hba *hba)
 	list_del(&hba->hba_node);
 	spin_unlock(&hba_lock);
 
-	target_debug("CORE_HBA[%d] - Detached HBA from Generic Target Core\n", hba->hba_id);
+	target_debug("hba[%d] - Detached HBA from Generic Target Core\n", hba->hba_id);
 
 	module_put(hba->backend->ops->owner);
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 25cc0815e590..bf6b95285d80 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -47,7 +47,7 @@ static inline struct iblock_dev *IBLOCK_DEV(struct se_device *dev)
 
 static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 {
-	target_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on Generic Target Core Stack %s\n",
+	target_debug("hba[%d] - TCM iBlock HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, IBLOCK_VERSION, TARGET_CORE_VERSION);
 	return 0;
 }
@@ -100,7 +100,7 @@ static int iblock_configure_device(struct se_device *dev)
 	int ret;
 
 	if (!(ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)) {
-		target_err("Missing udev_path= parameters for IBLOCK\n");
+		target_err("Missing udev_path= parameters\n");
 		return -EINVAL;
 	}
 
@@ -175,8 +175,7 @@ static int iblock_configure_device(struct se_device *dev)
 			ret = -ENOMEM;
 			goto out_blkdev_put;
 		}
-		target_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
-			     &bs->bio_integrity_pool);
+		target_debug("Setup BIP bs->bio_integrity_pool: %p\n", &bs->bio_integrity_pool);
 	}
 
 	dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
@@ -344,7 +343,7 @@ static void iblock_bio_done(struct bio *bio)
 	blk_status_t blk_status = bio->bi_status;
 
 	if (bio->bi_status) {
-		target_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
+		target_cmd_err(cmd, "bio error: %p,  err: %d\n", bio, bio->bi_status);
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
@@ -370,7 +369,7 @@ static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
 	bio = bio_alloc_bioset(ib_dev->ibd_bd, bio_max_segs(sg_num), opf,
 			       GFP_NOIO, &ib_dev->ibd_bio_set);
 	if (!bio) {
-		target_err("Unable to allocate memory for bio\n");
+		target_cmd_err(cmd, "Unable to allocate memory for bio\n");
 		return NULL;
 	}
 
@@ -400,7 +399,7 @@ static void iblock_end_io_flush(struct bio *bio)
 	struct se_cmd *cmd = bio->bi_private;
 
 	if (bio->bi_status)
-		target_err("cache flush failed: %d\n", bio->bi_status);
+		target_cmd_err(cmd, "Cache flush failed: %d\n", bio->bi_status);
 
 	if (cmd) {
 		if (bio->bi_status)
@@ -451,7 +450,7 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 				   target_to_linux_sector(dev,  nolb),
 				   GFP_KERNEL);
 	if (ret < 0) {
-		target_err("blkdev_issue_discard() failed: %d\n", ret);
+		target_cmd_err(cmd, "blkdev_issue_discard() failed: %d\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -505,7 +504,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 					sbc_get_write_same_sectors(cmd));
 
 	if (cmd->prot_op) {
-		target_err("WRITE_SAME: Protection information with IBLOCK backends not supported\n");
+		target_cmd_err(cmd, "WRITE_SAME: Protection information with IBLOCK backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -516,8 +515,8 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    sg->length != cmd->se_dev->dev_attrib.block_size) {
-		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
-			   cmd->t_data_nents, sg->length, cmd->se_dev->dev_attrib.block_size);
+		target_cmd_err(cmd, "WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
+			       cmd->t_data_nents, sg->length, cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -680,13 +679,13 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 
 	bi = bdev_get_integrity(ib_dev->ibd_bd);
 	if (!bi) {
-		target_err("Unable to locate bio_integrity\n");
+		target_cmd_err(cmd, "Unable to locate bio_integrity\n");
 		return -ENODEV;
 	}
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, bio_max_segs(cmd->t_prot_nents));
 	if (IS_ERR(bip)) {
-		target_err("Unable to allocate bio_integrity_payload\n");
+		target_cmd_err(cmd, "Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
@@ -694,8 +693,8 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 	bip_set_seed(bip, bio->bi_iter.bi_sector >>
 				  (bi->interval_exp - SECTOR_SHIFT));
 
-	target_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
-		     (unsigned long long)bip->bip_iter.bi_sector);
+	target_cmd_debug(cmd, "BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
+			 (unsigned long long)bip->bip_iter.bi_sector);
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
 	while (resid > 0 && sg_miter_next(miter)) {
@@ -704,13 +703,13 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 		rc = bio_integrity_add_page(bio, miter->page, len,
 					    offset_in_page(miter->addr));
 		if (rc != len) {
-			target_err("bio_integrity_add_page() failed; %d\n", rc);
+			target_cmd_err(cmd, "bio_integrity_add_page() failed; %d\n", rc);
 			sg_miter_stop(miter);
 			return -ENOMEM;
 		}
 
-		target_debug("Added bio integrity page: %p length: %zu offset: %lu\n", miter->page,
-			     len, offset_in_page(miter->addr));
+		target_cmd_debug(cmd, "Added bio integrity page: %p length: %zu offset: %lu\n",
+				 miter->page, len, offset_in_page(miter->addr));
 
 		resid -= len;
 		if (len < miter->length)
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 879624812573..9c2b0da24111 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -61,11 +61,22 @@ enum register_type {
 	REGISTER_AND_MOVE,
 };
 
+static const char *const pr_register_type_table_str[] = {
+	"REGISTER",
+	"REGISTER_AND_IGNORE_EXISTING_KEY",
+	"REGISTER_AND_MOVE",
+};
+
 enum preempt_type {
 	PREEMPT,
 	PREEMPT_AND_ABORT,
 };
 
+static const char *const pr_preempt_type_table_str[] = {
+	"PREEMPT",
+	"PREEMPT_AND_ABORT",
+};
+
 static void __core_scsi3_complete_pro_release(struct se_device *, struct se_node_acl *,
 					      struct t10_pr_registration *, int, int);
 
@@ -180,7 +191,7 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 	}
 
 	if (conflict) {
-		target_err("Received legacy SPC-2 RESERVE/RELEASE while active SPC-3 registrations exist, returning RESERVATION_CONFLICT\n");
+		target_cmd_err(cmd, "Received legacy SPC-2 RESERVE/RELEASE while active SPC-3 registrations exist, returning RESERVATION_CONFLICT\n");
 		return -EBUSY;
 	}
 
@@ -225,9 +236,8 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 
 	target_release_reservation(dev);
 	tpg = sess->se_tpg;
-	target_debug("SCSI-2 Released reservation for %s LUN: %llu -> MAPPED LUN: %llu for %s\n",
-		     tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
-		     sess->se_node_acl->initiatorname);
+	target_cmd_debug(cmd, "SCSI-2 Released reservation for %s LUN: %llu\n",
+			 tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun);
 
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
@@ -247,7 +257,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	if ((cmd->t_task_cdb[1] & 0x01) &&
 	    (cmd->t_task_cdb[1] & 0x02)) {
-		target_err("LongIO and Obsolete Bits set, returning ILLEGAL_REQUEST\n");
+		target_cmd_err(cmd, "LongIO and Obsolete Bits set, returning ILLEGAL_REQUEST\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 	/*
@@ -267,8 +277,8 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->reservation_holder &&
 	    dev->reservation_holder->se_node_acl != sess->se_node_acl) {
-		target_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
-			   tpg->se_tpg_tfo->fabric_name);
+		target_cmd_err(cmd, "SCSI-2 RESERVATION CONFLICT for %s fabric\n",
+			       tpg->se_tpg_tfo->fabric_name);
 		target_err("Original reserver LUN: %llu %s\n", cmd->se_lun->unpacked_lun,
 			   dev->reservation_holder->se_node_acl->initiatorname);
 		target_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu from %s\n",
@@ -284,9 +294,8 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
 		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
-	target_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu for %s\n",
-		     tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
-		     sess->se_node_acl->initiatorname);
+	target_cmd_debug(cmd, "SCSI-2 Reserved %s LUN: %llu \n", tpg->se_tpg_tfo->fabric_name,
+			 cmd->se_lun->unpacked_lun);
 
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
@@ -408,8 +417,8 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			ret = (registered_nexus) ? 0 : 1;
 			break;
 		default:
-			target_err("Unknown PERSISTENT_RESERVE_OUT service action: 0x%02x\n",
-				   cdb[1] & 0x1f);
+			target_cmd_err(cmd, "Unknown PERSISTENT_RESERVE_OUT service action: 0x%02x\n",
+				       cdb[1] & 0x1f);
 			return -EINVAL;
 		}
 		break;
@@ -455,7 +464,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			ret = 0; /* Allowed */
 			break;
 		default:
-			target_err("Unknown MI Service Action: 0x%02x\n", (cdb[1] & 0x1f));
+			target_cmd_err(cmd, "Unknown MI Service Action: 0x%02x\n", (cdb[1] & 0x1f));
 			return -EINVAL;
 		}
 		break;
@@ -479,8 +488,8 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 	 * statement.
 	 */
 	if (!ret && !other_cdb) {
-		target_debug("Allowing explicit CDB: 0x%02x for %s reservation holder\n", cdb[0],
-			     core_scsi3_pr_dump_type(pr_reg_type));
+		target_cmd_debug(cmd, "Allowing explicit CDB: 0x%02x for %s reservation holder\n",
+				 cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
 		return ret;
 	}
@@ -493,10 +502,10 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			/*
 			 * Conflict for write exclusive
 			 */
-			target_debug("%s Conflict for unregistered nexus %s CDB: 0x%02x to %s reservation\n",
-				     transport_dump_cmd_direction(cmd),
-				     se_sess->se_node_acl->initiatorname, cdb[0],
-				     core_scsi3_pr_dump_type(pr_reg_type));
+			target_cmd_debug(cmd, "%s Conflict for unregistered nexus %s CDB: 0x%02x to %s reservation\n",
+					 transport_dump_cmd_direction(cmd),
+					 se_sess->se_node_acl->initiatorname,
+					 cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 			return 1;
 		} else {
 			/*
@@ -510,8 +519,8 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 */
 
 			if (!registered_nexus) {
-				target_debug("Allowing implicit CDB: 0x%02x for %s reservation on unregistered nexus\n",
-					     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
+				target_cmd_debug(cmd, "Allowing implicit CDB: 0x%02x for %s reservation on unregistered nexus\n",
+						 cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 			}
 
 			return 0;
@@ -523,8 +532,8 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 * allow commands from registered nexuses.
 			 */
 
-			target_debug("Allowing implicit CDB: 0x%02x for %s reservation\n", cdb[0],
-				     core_scsi3_pr_dump_type(pr_reg_type));
+			target_cmd_debug(cmd, "Allowing implicit CDB: 0x%02x for %s reservation\n",
+					 cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
 			return 0;
 		}
@@ -534,16 +543,16 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 		 * from all registrants.
 		 */
 		if (cmd->data_direction == DMA_FROM_DEVICE) {
-			target_debug("Allowing READ CDB: 0x%02x for %s reservation\n", cdb[0],
-				     core_scsi3_pr_dump_type(pr_reg_type));
+			target_cmd_debug(cmd, "Allowing READ CDB: 0x%02x for %s reservation\n",
+					 cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
 			return 0;
 		}
 	}
-	target_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x for %s reservation\n",
-		     transport_dump_cmd_direction(cmd), (registered_nexus) ? "" : "un",
-		     se_sess->se_node_acl->initiatorname, cdb[0],
-		     core_scsi3_pr_dump_type(pr_reg_type));
+	target_cmd_debug(cmd, "%s Conflict for %sregistered nexus %s CDB: 0x%2x for %s reservation\n",
+			 transport_dump_cmd_direction(cmd), (registered_nexus) ? "" : "un",
+			 se_sess->se_node_acl->initiatorname, cdb[0],
+			 core_scsi3_pr_dump_type(pr_reg_type));
 
 	return 1; /* Conflict by default */
 }
@@ -942,8 +951,8 @@ static int __core_scsi3_check_aptpl_registration(
 			rcu_read_lock();
 			pr_reg->pr_reg_deve = target_nacl_find_deve(nacl, mapped_lun);
 			if (!pr_reg->pr_reg_deve) {
-				target_err("Unable to locate PR APTPL %s mapped_lun: %llu\n",
-					   nacl->initiatorname, mapped_lun);
+				target_lun_err(lun, "Unable to locate PR APTPL %s mapped_lun: %llu\n",
+					       nacl->initiatorname, mapped_lun);
 				rcu_read_unlock();
 				continue;
 			}
@@ -1464,7 +1473,7 @@ core_scsi3_decode_spec_i_port(
 	 */
 	tidh_new = kzalloc(sizeof(struct pr_transport_id_holder), GFP_KERNEL);
 	if (!tidh_new) {
-		target_err("Unable to allocate tidh_new\n");
+		target_cmd_err(cmd, "Unable to allocate tidh_new\n");
 		return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 	}
 	INIT_LIST_HEAD(&tidh_new->dest_list);
@@ -1492,8 +1501,8 @@ core_scsi3_decode_spec_i_port(
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
 	if (cmd->data_length < 28) {
-		target_warn("SPC-PR: Received PR OUT parameter list length too small: %u\n",
-			    cmd->data_length);
+		target_cmd_warn(cmd, "SPC-PR: Received PR OUT parameter list length too small: %u\n",
+				cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -1512,8 +1521,8 @@ core_scsi3_decode_spec_i_port(
 	tpdl = get_unaligned_be32(&buf[24]);
 
 	if ((tpdl + 28) != cmd->data_length) {
-		target_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header does not equal CDB data_length: %u\n",
-			   tpdl, cmd->data_length);
+		target_cmd_err(cmd, "SPC-3 PR: Illegal tpdl: %u + 28 byte header does not equal CDB data_length: %u\n",
+			       tpdl, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_unmap;
 	}
@@ -1555,8 +1564,8 @@ core_scsi3_decode_spec_i_port(
 			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
 			    dev->dev_attrib.enforce_pr_isids &&
 			    !iport_ptr) {
-				target_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.",
-					    i_str);
+				target_cmd_warn(cmd, "SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.\n",
+						i_str);
 				ret = TCM_INVALID_PARAMETER_LIST;
 				spin_unlock(&dev->se_port_lock);
 				goto out_unmap;
@@ -1566,7 +1575,7 @@ core_scsi3_decode_spec_i_port(
 			spin_unlock(&dev->se_port_lock);
 
 			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
-				target_err(" core_scsi3_tpg_depend_item() for tmp_tpg\n");
+				target_cmd_err(cmd, "core_scsi3_tpg_depend_item() for tmp_tpg\n");
 				atomic_dec_mb(&tmp_tpg->tpg_pr_ref_count);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
@@ -1590,7 +1599,7 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
-				target_err("configfs_depend_item() failed for dest_node_acl->acl_group\n");
+				target_cmd_err(cmd, "configfs_depend_item() failed for dest_node_acl->acl_group\n");
 				atomic_dec_mb(&dest_node_acl->acl_pr_ref_count);
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1598,9 +1607,9 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			dest_tpg = tmp_tpg;
-			target_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s Port RTPI: %u\n",
-				     dest_tpg->se_tpg_tfo->fabric_name,
-				     dest_node_acl->initiatorname, dest_rtpi);
+			target_cmd_debug(cmd, "SPC-3 PR SPEC_I_PT: Located %s Node: %s Port RTPI: %u\n",
+					 dest_tpg->se_tpg_tfo->fabric_name,
+					 dest_node_acl->initiatorname, dest_rtpi);
 
 			spin_lock(&dev->se_port_lock);
 			break;
@@ -1608,18 +1617,18 @@ core_scsi3_decode_spec_i_port(
 		spin_unlock(&dev->se_port_lock);
 
 		if (!dest_tpg) {
-			target_err("SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg\n");
+			target_cmd_err(cmd, "SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg\n");
 			ret = TCM_INVALID_PARAMETER_LIST;
 			goto out_unmap;
 		}
 
-		target_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u tid_len: %d for %s + %s\n",
-			     dest_tpg->se_tpg_tfo->fabric_name, cmd->data_length, tpdl, tid_len,
-			     i_str, iport_ptr);
+		target_cmd_debug(cmd, "SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u tid_len: %d for %s + %s\n",
+				 dest_tpg->se_tpg_tfo->fabric_name, cmd->data_length, tpdl, tid_len,
+				 i_str, iport_ptr);
 
 		if (tid_len > tpdl) {
-			target_err("SPC-3 PR SPEC_I_PT: Illegal tid_len: %u for Transport ID: %s\n",
-				   tid_len, ptr);
+			target_cmd_err(cmd, "SPC-3 PR SPEC_I_PT: Illegal tid_len: %u for Transport ID: %s\n",
+				       tid_len, ptr);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_INVALID_PARAMETER_LIST;
@@ -1633,8 +1642,8 @@ core_scsi3_decode_spec_i_port(
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
 					dest_rtpi);
 		if (!dest_se_deve) {
-			target_err("Unable to locate %s dest_se_deve from destination RTPI: %u\n",
-				   dest_tpg->se_tpg_tfo->fabric_name, dest_rtpi);
+			target_cmd_err(cmd, "Unable to locate %s dest_se_deve from destination RTPI: %u\n",
+				       dest_tpg->se_tpg_tfo->fabric_name, dest_rtpi);
 
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1643,7 +1652,7 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
-			target_err("core_scsi3_lunacl_depend_item() failed\n");
+			target_cmd_err(cmd, "core_scsi3_lunacl_depend_item() failed\n");
 			kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1651,9 +1660,9 @@ core_scsi3_decode_spec_i_port(
 			goto out_unmap;
 		}
 
-		target_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s dest_se_deve mapped_lun: %llu\n",
-			     dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname,
-			     dest_se_deve->mapped_lun);
+		target_cmd_debug(cmd, "SPC-3 PR SPEC_I_PT: Located %s Node: %s dest_se_deve mapped_lun: %llu\n",
+				 dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname,
+				 dest_se_deve->mapped_lun);
 
 		/*
 		 * Skip any TransportIDs that already have a registration for
@@ -1679,7 +1688,7 @@ core_scsi3_decode_spec_i_port(
 		tidh_new = kzalloc(sizeof(struct pr_transport_id_holder),
 				GFP_KERNEL);
 		if (!tidh_new) {
-			target_err("Unable to allocate tidh_new\n");
+			target_cmd_err(cmd, "Unable to allocate tidh_new\n");
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1760,9 +1769,9 @@ core_scsi3_decode_spec_i_port(
 		__core_scsi3_add_registration(cmd->se_dev, dest_node_acl,
 					dest_pr_reg, 0, 0);
 
-		target_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully registered Transport ID for Node: %s%s Mapped LUN: %llu\n",
-			     dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname, i_buf,
-			     (dest_se_deve) ? dest_se_deve->mapped_lun : 0);
+		target_cmd_debug(cmd, "SPC-3 PR [%s] SPEC_I_PT: Successfully registered Transport ID for Node: %s%s Mapped LUN: %llu\n",
+				 dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname,
+				 i_buf, (dest_se_deve) ? dest_se_deve->mapped_lun : 0);
 
 		if (dest_pr_reg == local_pr_reg)
 			continue;
@@ -2024,7 +2033,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!pr_reg) {
 		if (res_key) {
-			target_warn("SPC-3 PR: Reservation Key non-zero for SA REGISTER, returning CONFLICT\n");
+			target_cmd_warn(cmd, "SPC-3 PR: Reservation Key non-zero for SA REGISTER, returning CONFLICT\n");
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
@@ -2044,7 +2053,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					NULL, cmd->orig_fe_lun, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					register_type, 0)) {
-				target_err("Unable to allocate struct t10_pr_registration\n");
+				target_cmd_err(cmd, "Unable to allocate struct t10_pr_registration\n");
 				return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 			}
 		} else {
@@ -2067,14 +2076,14 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	/* ok, existing registration */
 
 	if ((register_type == REGISTER) && (res_key != pr_reg->pr_res_key)) {
-		target_err("SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
-			   res_key, pr_reg->pr_res_key);
+		target_cmd_err(cmd, "SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
+			       res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
 	}
 
 	if (spec_i_pt) {
-		target_err("SPC-3 PR REGISTER: SPEC_I_PT set on a registered nexus\n");
+		target_cmd_err(cmd, "SPC-3 PR REGISTER: SPEC_I_PT set on a registered nexus\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -2084,7 +2093,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	 * must also set ALL_TG_PT=1 in the incoming PROUT.
 	 */
 	if (pr_reg->pr_reg_all_tg_pt && !all_tg_pt) {
-		target_err("SPC-3 PR REGISTER: ALL_TG_PT=1 registration exists, but ALL_TG_PT=1 bit not present in received PROUT\n");
+		target_cmd_err(cmd, "SPC-3 PR REGISTER: ALL_TG_PT=1 registration exists, but ALL_TG_PT=1 bit not present in received PROUT\n");
 		ret = TCM_INVALID_CDB_FIELD;
 		goto out;
 	}
@@ -2100,11 +2109,12 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		 */
 		pr_reg->pr_res_generation = core_scsi3_pr_generation(cmd->se_dev);
 		pr_reg->pr_res_key = sa_res_key;
-		target_debug("SPC-3 PR [%s] REGISTER%s: Changed Reservation Key for %s to: 0x%016Lx PRgeneration: 0x%08x\n",
-			     cmd->se_tfo->fabric_name,
-			     (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
-			     "_AND_IGNORE_EXISTING_KEY" : "", pr_reg->pr_reg_nacl->initiatorname,
-			     pr_reg->pr_res_key, pr_reg->pr_res_generation);
+		target_cmd_debug(cmd, "SPC-3 PR [%s] REGISTER%s: Changed Reservation Key for %s to: 0x%016Lx PRgeneration: 0x%08x\n",
+				 cmd->se_tfo->fabric_name,
+				 (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
+				 "_AND_IGNORE_EXISTING_KEY" : "",
+				 pr_reg->pr_reg_nacl->initiatorname, pr_reg->pr_res_key,
+				 pr_reg->pr_res_generation);
 
 	} else {
 		/*
@@ -2229,7 +2239,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg) {
-		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RESERVE\n");
+		target_cmd_err(cmd, "SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RESERVE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2242,8 +2252,8 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 *	 registered with the logical unit for the I_T nexus; and
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		target_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
-			   res_key, pr_reg->pr_res_key);
+		target_cmd_err(cmd, "SPC-3 PR RESERVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
+			       res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
 	}
@@ -2258,7 +2268,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 * and that persistent reservation has a scope of LU_SCOPE.
 	 */
 	if (scope != PR_SCOPE_LU_SCOPE) {
-		target_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		target_cmd_err(cmd, "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -2283,10 +2293,11 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		if (!is_reservation_holder(pr_res_holder, pr_reg)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 
-			target_err("SPC-3 PR: Attempted RESERVE from [%s]: %s while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
-				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
-				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-				   pr_res_holder->pr_reg_nacl->initiatorname);
+			target_cmd_err(cmd, "SPC-3 PR: Attempted RESERVE from [%s]: %s while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
+				       cmd->se_tfo->fabric_name,
+				       se_sess->se_node_acl->initiatorname,
+				       pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
+				       pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2303,10 +2314,11 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		    (pr_res_holder->pr_res_scope != scope)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 
-			target_err("SPC-3 PR: Attempted RESERVE from [%s]: %s trying to change TYPE and/or SCOPE, while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
-				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
-				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-				   pr_res_holder->pr_reg_nacl->initiatorname);
+			target_cmd_err(cmd, "SPC-3 PR: Attempted RESERVE from [%s]: %s trying to change TYPE and/or SCOPE, while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
+				       cmd->se_tfo->fabric_name,
+				       se_sess->se_node_acl->initiatorname,
+				       pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
+				       pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2336,11 +2348,11 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	dev->dev_pr_res_holder = pr_reg;
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	target_debug("SPC-3 PR [%s] Service Action: RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		     cmd->se_tfo->fabric_name, core_scsi3_pr_dump_type(type),
-		     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	target_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n", cmd->se_tfo->fabric_name,
-		     se_sess->se_node_acl->initiatorname, i_buf);
+	target_cmd_err(cmd, "SPC-3 PR [%s] Service Action: RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		       cmd->se_tfo->fabric_name, core_scsi3_pr_dump_type(type),
+		       (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	target_cmd_err(cmd, "SPC-3 PR [%s] RESERVE Node: %s%s\n", cmd->se_tfo->fabric_name,
+		       se_sess->se_node_acl->initiatorname, i_buf);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (pr_tmpl->pr_aptpl_active)
@@ -2365,7 +2377,8 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
 		return core_scsi3_pro_reserve(cmd, type, scope, res_key);
 	default:
-		target_err("SPC-3 PR: Unknown Service Action RESERVE Type: 0x%02x\n", type);
+		target_cmd_err(cmd, "SPC-3 PR: Unknown Service Action RESERVE Type: 0x%02x\n",
+			       type);
 		return TCM_INVALID_CDB_FIELD;
 	}
 }
@@ -2455,7 +2468,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!pr_reg) {
-		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE\n");
+		target_cmd_err(cmd, "SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2504,8 +2517,8 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 *	  that is registered with the logical unit for the I_T nexus;
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		target_err("SPC-3 PR RELEASE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
-			   res_key, pr_reg->pr_res_key);
+		target_cmd_err(cmd, "SPC-3 PR RELEASE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
+			       res_key, pr_reg->pr_res_key);
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
@@ -2520,10 +2533,10 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	    (pr_res_holder->pr_res_scope != scope)) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 
-		target_err("SPC-3 PR RELEASE: Attempted to release reservation from [%s]: %s with different TYPE and/or SCOPE  while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
-			   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
-			   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-			   pr_res_holder->pr_reg_nacl->initiatorname);
+		target_cmd_err(cmd, "SPC-3 PR RELEASE: Attempted to release reservation from [%s]: %s with different TYPE and/or SCOPE  while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
+			       cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
+			       pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
+			       pr_res_holder->pr_reg_nacl->initiatorname);
 
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
@@ -2603,7 +2616,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev,
 			se_sess->se_node_acl, se_sess);
 	if (!pr_reg_n) {
-		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for CLEAR\n");
+		target_cmd_err(cmd, "SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for CLEAR\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2618,8 +2631,8 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	 *	   that is registered with the logical unit for the I_T nexus.
 	 */
 	if (res_key != pr_reg_n->pr_res_key) {
-		target_err("SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
-			   res_key, pr_reg_n->pr_res_key);
+		target_cmd_err(cmd, "SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
+			       res_key, pr_reg_n->pr_res_key);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_RESERVATION_CONFLICT;
 	}
@@ -2660,7 +2673,8 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 
-	target_debug("SPC-3 PR [%s] Service Action: CLEAR complete\n", cmd->se_tfo->fabric_name);
+	target_cmd_debug(cmd, "SPC-3 PR [%s] Service Action: CLEAR complete\n",
+			 cmd->se_tfo->fabric_name);
 
 	core_scsi3_update_and_write_aptpl(cmd->se_dev, false);
 
@@ -2755,8 +2769,8 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg_n) {
-		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for PREEMPT%s\n",
-			   (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "");
+		target_cmd_err(cmd, "SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for PREEMPT%s\n",
+			       (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "");
 		return TCM_RESERVATION_CONFLICT;
 	}
 	if (pr_reg_n->pr_res_key != res_key) {
@@ -2764,7 +2778,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		return TCM_RESERVATION_CONFLICT;
 	}
 	if (scope != PR_SCOPE_LU_SCOPE) {
-		target_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		target_cmd_err(cmd, "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
@@ -3057,8 +3071,8 @@ core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, int type, int scope,
 		return core_scsi3_pro_preempt(cmd, type, scope, res_key,
 					      sa_res_key, preempt_type);
 	default:
-		target_err("SPC-3 PR: Unknown Service Action PREEMPT%s Type: 0x%02x\n",
-			   (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", type);
+		target_cmd_err(cmd, "SPC-3 PR: Unknown Service Action PREEMPT%s Type: 0x%02x\n",
+			       (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", type);
 		return TCM_INVALID_CDB_FIELD;
 	}
 }
@@ -3102,7 +3116,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg) {
-		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for REGISTER_AND_MOVE\n");
+		target_cmd_err(cmd, "SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for REGISTER_AND_MOVE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -3110,8 +3124,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * provided during this initiator's I_T nexus registration.
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
-			    res_key, pr_reg->pr_res_key);
+		target_cmd_warn(cmd, "SPC-3 PR REGISTER_AND_MOVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
+				res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
 	}
@@ -3119,7 +3133,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * The service active reservation key needs to be non zero
 	 */
 	if (!sa_res_key) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero sa_res_key\n");
+		target_cmd_warn(cmd, "SPC-3 PR REGISTER_AND_MOVE: Received zero sa_res_key\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3141,8 +3155,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	buf = NULL;
 
 	if ((tid_len + 24) != cmd->data_length) {
-		target_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header does not equal CDB data_length: %u\n",
-			   tid_len, cmd->data_length);
+		target_cmd_err(cmd, "SPC-3 PR: Illegal tid_len: %u + 24 byte header does not equal CDB data_length: %u\n",
+			       tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3160,7 +3174,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		spin_unlock(&dev->se_port_lock);
 
 		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
-			target_err("core_scsi3_tpg_depend_item() failed for dest_se_tpg\n");
+			target_cmd_err(cmd, "core_scsi3_tpg_depend_item() failed for dest_se_tpg\n");
 			atomic_dec_mb(&dest_se_tpg->tpg_pr_ref_count);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto out_put_pr_reg;
@@ -3172,8 +3186,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_unlock(&dev->se_port_lock);
 
 	if (!dest_se_tpg || !dest_tf_ops) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate fabric ops from Relative Target Port Identifier: %u\n",
-			   rtpi);
+		target_cmd_err(cmd, "SPC-3 PR REGISTER_AND_MOVE: Unable to locate fabric ops from Relative Target Port Identifier: %u\n",
+			       rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3185,19 +3199,19 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	}
 	proto_ident = (buf[24] & 0x0f);
 
-	target_debug("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier: 0x%02x\n",
-		     proto_ident);
+	target_cmd_debug(cmd, "SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier: 0x%02x\n",
+			 proto_ident);
 
 	if (proto_ident != dest_se_tpg->proto_id) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Received proto_ident: 0x%02x does not match ident: 0x%02x from fabric: %s\n",
-			   proto_ident, dest_se_tpg->proto_id, dest_tf_ops->fabric_name);
+		target_cmd_err(cmd, "SPC-3 PR REGISTER_AND_MOVE: Received proto_ident: 0x%02x does not match ident: 0x%02x from fabric: %s\n",
+			       proto_ident, dest_se_tpg->proto_id, dest_tf_ops->fabric_name);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
 			&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!initiator_str) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate initiator_str from Transport ID\n");
+		target_cmd_err(cmd, "SPC-3 PR REGISTER_AND_MOVE: Unable to locate initiator_str from Transport ID\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -3205,9 +3219,9 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	target_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s %s\n",
-		     dest_tf_ops->fabric_name, (iport_ptr != NULL) ? "port" : "device",
-		     initiator_str, (iport_ptr != NULL) ? iport_ptr : "");
+	target_cmd_debug(cmd, "SPC-3 PR [%s] Extracted initiator %s identifier: %s %s\n",
+			 dest_tf_ops->fabric_name, (iport_ptr != NULL) ? "port" : "device",
+			 initiator_str, (iport_ptr != NULL) ? iport_ptr : "");
 	/*
 	 * If a PERSISTENT RESERVE OUT command with a REGISTER AND MOVE service
 	 * action specifies a TransportID that is the same as the initiator port
@@ -3223,8 +3237,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		goto after_iport_check;
 
 	if (!iport_ptr || !pr_reg->isid_present_at_reg) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s matches: %s on received I_T Nexus\n",
-			   initiator_str, pr_reg_nacl->initiatorname);
+		target_cmd_err(cmd, "SPC-3 PR REGISTER_AND_MOVE: TransportID: %s matches: %s on received I_T Nexus\n",
+			       initiator_str, pr_reg_nacl->initiatorname);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -3247,22 +3261,22 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	mutex_unlock(&dest_se_tpg->acl_node_mutex);
 
 	if (!dest_node_acl) {
-		target_err("Unable to locate %s dest_node_acl for TransportID%s\n",
-			   dest_tf_ops->fabric_name, initiator_str);
+		target_cmd_err(cmd, "Unable to locate %s dest_node_acl for TransportID%s\n",
+			       dest_tf_ops->fabric_name, initiator_str);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
 	if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
-		target_err("core_scsi3_nodeacl_depend_item() for dest_node_acl\n");
+		target_cmd_err(cmd, "core_scsi3_nodeacl_depend_item() for dest_node_acl\n");
 		atomic_dec_mb(&dest_node_acl->acl_pr_ref_count);
 		dest_node_acl = NULL;
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
-	target_debug("SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl: %s from TransportID\n",
-		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname);
+	target_cmd_debug(cmd, "SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl: %s from TransportID\n",
+			 dest_tf_ops->fabric_name, dest_node_acl->initiatorname);
 
 	/*
 	 * Locate the struct se_dev_entry pointer for the matching RELATIVE TARGET
@@ -3270,23 +3284,23 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!dest_se_deve) {
-		target_err("Unable to locate %s dest_se_deve from RTPI: %u\n",
-			   dest_tf_ops->fabric_name, rtpi);
+		target_cmd_err(cmd, "Unable to locate %s dest_se_deve from RTPI: %u\n",
+			       dest_tf_ops->fabric_name, rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
-		target_err("core_scsi3_lunacl_depend_item() failed\n");
+		target_cmd_err(cmd, "core_scsi3_lunacl_depend_item() failed\n");
 		kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
 	}
 
-	target_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN ACL for dest_se_deve->mapped_lun: %llu\n",
-		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
-		     dest_se_deve->mapped_lun);
+	target_cmd_debug(cmd, "SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN ACL for dest_se_deve->mapped_lun: %llu\n",
+			 dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
+			 dest_se_deve->mapped_lun);
 
 	/*
 	 * A persistent reservation needs to already existing in order to
@@ -3295,7 +3309,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (!pr_res_holder) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation currently held\n");
+		target_cmd_warn(cmd, "SPC-3 PR REGISTER_AND_MOVE: No reservation currently held\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto out;
@@ -3307,7 +3321,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 *	Register behaviors for a REGISTER AND MOVE service action
 	 */
 	if (!is_reservation_holder(pr_res_holder, pr_reg)) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T Nexus is not reservation holder\n");
+		target_cmd_warn(cmd, "SPC-3 PR REGISTER_AND_MOVE: Calling I_T Nexus is not reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
@@ -3323,8 +3337,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	if ((pr_res_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
 	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Unable to move reservation for type: %s\n",
-			    core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
+		target_cmd_warn(cmd, "SPC-3 PR REGISTER_AND_MOVE: Unable to move reservation for type: %s\n",
+				core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
@@ -3399,13 +3413,13 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	target_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE created new reservation holder TYPE: %s on object RTPI: %u  PRGeneration: 0x%08x\n",
-		     dest_tf_ops->fabric_name, core_scsi3_pr_dump_type(type), rtpi,
-		     dest_pr_reg->pr_res_generation);
-	target_debug("SPC-3 PR Successfully moved reservation from %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
-		     tf_ops->fabric_name, pr_reg_nacl->initiatorname, i_buf,
-		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
-		     (iport_ptr != NULL) ? iport_ptr : "");
+	target_cmd_debug(cmd, "SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE created new reservation holder TYPE: %s on object RTPI: %u  PRGeneration: 0x%08x\n",
+			 dest_tf_ops->fabric_name, core_scsi3_pr_dump_type(type), rtpi,
+			 dest_pr_reg->pr_res_generation);
+	target_cmd_debug(cmd, "SPC-3 PR Successfully moved reservation from %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
+			 tf_ops->fabric_name, pr_reg_nacl->initiatorname, i_buf,
+			 dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
+			 (iport_ptr != NULL) ? iport_ptr : "");
 	/*
 	 * It is now safe to release configfs group dependencies for destination
 	 * of Transport ID Initiator Device/Port Identifier
@@ -3454,19 +3468,19 @@ target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
 	}
 
 	if (!ops->execute_pr_out) {
-		target_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		target_cmd_err(cmd, "SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	switch (sa) {
 	case PRO_REGISTER_AND_MOVE:
 	case PRO_REPLACE_LOST_RESERVATION:
-		target_err("SPC-3 PR: PRO_REGISTER_AND_MOVE and PRO_REPLACE_LOST_RESERVATION are not supported by PR passthrough.\n");
+		target_cmd_err(cmd, "SPC-3 PR: PRO_REGISTER_AND_MOVE and PRO_REPLACE_LOST_RESERVATION are not supported by PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (spec_i_pt || all_tg_pt) {
-		target_err("SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
+		target_cmd_err(cmd, "SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -3497,7 +3511,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (cmd->se_dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		target_err("Received PERSISTENT_RESERVE CDB while legacy SPC-2 reservation is held, returning RESERVATION_CONFLICT\n");
+		target_cmd_err(cmd, "Received PERSISTENT_RESERVE CDB while legacy SPC-2 reservation is held, returning RESERVATION_CONFLICT\n");
 		return TCM_RESERVATION_CONFLICT;
 	}
 
@@ -3509,8 +3523,8 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	if (cmd->data_length < 24) {
-		target_warn("SPC-PR: Received PR OUT parameter list length too small: %u\n",
-			    cmd->data_length);
+		target_cmd_warn(cmd, "SPC-PR: Received PR OUT parameter list length too small: %u\n",
+				cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -3569,8 +3583,8 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 */
 	if (!spec_i_pt && (sa != PRO_REGISTER_AND_MOVE) &&
 	    (cmd->data_length != 24)) {
-		target_warn("SPC-PR: Received PR OUT illegal parameter list length: %u\n",
-			    cmd->data_length);
+		target_cmd_warn(cmd, "SPC-PR: Received PR OUT illegal parameter list length: %u\n",
+				cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -3616,7 +3630,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 				sa_res_key, aptpl, unreg);
 		break;
 	default:
-		target_err("Unknown PERSISTENT_RESERVE_OUT service action: 0x%02x\n", sa);
+		target_cmd_err(cmd, "Unknown PERSISTENT_RESERVE_OUT service action: 0x%02x\n", sa);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3640,7 +3654,8 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA READ_KEYS SCSI Data Length: %u too small\n", cmd->data_length);
+		target_cmd_err(cmd, "PRIN SA READ_KEYS SCSI Data Length: %u too small\n",
+			       cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3694,8 +3709,8 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	u32 add_len = 0;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u too small\n",
-			   cmd->data_length);
+		target_cmd_err(cmd, "PRIN SA READ_RESERVATIONS SCSI Data Length: %u too small\n",
+			       cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3770,8 +3785,8 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	u16 len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
-		target_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length: %u too small\n",
-			   cmd->data_length);
+		target_cmd_err(cmd, "PRIN SA REPORT_CAPABILITIES SCSI Data Length: %u too small\n",
+			       cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3836,8 +3851,8 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	bool all_reg = false;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u too small\n",
-			   cmd->data_length);
+		target_cmd_err(cmd, "PRIN SA READ_FULL_STATUS SCSI Data Length: %u too small\n",
+			       cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3878,8 +3893,8 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 					&format_code);
 		if (exp_desc_len < 0 ||
 		    exp_desc_len + add_len > cmd->data_length) {
-			target_warn("SPC-3 PRIN READ_FULL_STATUS ran out of buffer: %d\n",
-				    cmd->data_length);
+			target_cmd_warn(cmd, "SPC-3 PRIN READ_FULL_STATUS ran out of buffer: %d\n",
+					cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec_mb(&pr_reg->pr_res_holders);
 			break;
@@ -3984,17 +3999,17 @@ static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
 	sense_reason_t ret;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA SCSI Data Length: %u too small\n", cmd->data_length);
+		target_cmd_err(cmd, "PRIN SA SCSI Data Length: %u too small\n", cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
 	if (!ops->execute_pr_in) {
-		target_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		target_cmd_err(cmd, "SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (sa == PRI_READ_FULL_STATUS) {
-		target_err("SPC-3 PR: PRI_READ_FULL_STATUS is not supported by PR passthrough.\n");
+		target_cmd_err(cmd, "SPC-3 PR: PRI_READ_FULL_STATUS is not supported by PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -4024,7 +4039,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (cmd->se_dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		target_err("Received PERSISTENT_RESERVE CDB while legacy SPC-2 reservation is held, returning RESERVATION_CONFLICT\n");
+		target_cmd_err(cmd, "Received PERSISTENT_RESERVE CDB while legacy SPC-2 reservation is held, returning RESERVATION_CONFLICT\n");
 		return TCM_RESERVATION_CONFLICT;
 	}
 
@@ -4047,8 +4062,8 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		ret = core_scsi3_pri_read_full_status(cmd);
 		break;
 	default:
-		target_err("Unknown PERSISTENT_RESERVE_IN service action: 0x%02x\n",
-			   cmd->t_task_cdb[1] & 0x1f);
+		target_cmd_err(cmd, "Unknown PERSISTENT_RESERVE_IN service action: 0x%02x\n",
+			       cmd->t_task_cdb[1] & 0x1f);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 51b0998b9a9e..95f7c8dffaf2 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -62,9 +62,9 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = phv;
 
-	target_debug("CORE_HBA[%d] - TCM SCSI HBA Driver %s on Generic Target Core Stack %s\n",
+	target_debug("hba[%d] - TCM SCSI HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, PSCSI_VERSION, TARGET_CORE_VERSION);
-	target_debug("CORE_HBA[%d] - Attached SCSI HBA to Generic\n", hba->hba_id);
+	target_debug("hba[%d] - Attached SCSI HBA to Generic\n", hba->hba_id);
 
 	return 0;
 }
@@ -77,11 +77,11 @@ static void pscsi_detach_hba(struct se_hba *hba)
 	if (scsi_host) {
 		scsi_host_put(scsi_host);
 
-		target_debug("CORE_HBA[%d] - Detached SCSI HBA: %s from Generic Target Core\n",
+		target_debug("hba[%d] - Detached SCSI HBA: %s from Generic Target Core\n",
 			     hba->hba_id,
 			     (scsi_host->hostt->name) ? (scsi_host->hostt->name) : "Unknown");
 	} else
-		target_debug("CORE_HBA[%d] - Detached Virtual SCSI HBA from Generic Target Core\n",
+		target_debug("hba[%d] - Detached Virtual SCSI HBA from Generic Target Core\n",
 			     hba->hba_id);
 
 	kfree(phv);
@@ -102,7 +102,7 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 		phv->phv_lld_host = NULL;
 		phv->phv_mode = PHV_VIRTUAL_HOST_ID;
 
-		target_debug("CORE_HBA[%d] - Disabled pSCSI HBA Passthrough %s\n", hba->hba_id,
+		target_debug("hba[%d] - Disabled pSCSI HBA Passthrough %s\n", hba->hba_id,
 			     (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
 
 		scsi_host_put(sh);
@@ -376,7 +376,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 		return ret;
 	}
 
-	target_debug("CORE_PSCSI[%d] - Added TYPE_%s for %d:%d:%d:%llu\n", phv->phv_host_id,
+	target_debug("host[%d] - Added TYPE_%s for %d:%d:%d:%llu\n", phv->phv_host_id,
 		     sd->type == TYPE_DISK ? "DISK" : "ZBC", sh->host_no, sd->channel, sd->id,
 		     sd->lun);
 	return 0;
@@ -405,7 +405,7 @@ static int pscsi_create_type_nondisk(struct se_device *dev, struct scsi_device *
 		scsi_device_put(sd);
 		return ret;
 	}
-	target_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%llu\n", phv->phv_host_id,
+	target_debug("host[%d] - Added Type: %s for %d:%d:%d:%llu\n", phv->phv_host_id,
 		     scsi_device_type(sd->type), sh->host_no, sd->channel, sd->id, sd->lun);
 
 	return 0;
@@ -635,7 +635,7 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 
 		buf = sg_virt(&cmd->t_data_sg[0]);
 		if (!buf) {
-			target_err("Unable to get buf for scatterlist\n");
+			target_cmd_err(cmd, "Unable to get buf for scatterlist\n");
 			goto after_mode_select;
 		}
 
@@ -674,7 +674,7 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			if (req_sense[0] == 0xf0 &&	/* valid, fixed format */
 			    req_sense[2] & 0xe0 &&	/* FM, EOM, or ILI */
 			    (req_sense[2] & 0xf) == 0) { /* key==NO_SENSE */
-				target_debug("Tape FM/EOM/ILI status detected. Treat as normal read.\n");
+				target_cmd_debug(cmd, "Tape FM/EOM/ILI status detected. Treat as normal read.\n");
 				cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
 			}
 		}
@@ -717,7 +717,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 		switch (token) {
 		case Opt_scsi_host_id:
 			if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-				target_err("PSCSI[%d]: Unable to accept scsi_host_id while phv_mode == PHV_LLD_SCSI_HOST_NO\n",
+				target_err("host[%d]: Unable to accept scsi_host_id while phv_mode == PHV_LLD_SCSI_HOST_NO\n",
 					   phv->phv_host_id);
 				ret = -EINVAL;
 				goto out;
@@ -726,7 +726,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_host_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI Host ID: %d\n", phv->phv_host_id,
+			target_debug("host[%d]: Referencing SCSI Host ID: %d\n", phv->phv_host_id,
 				     pdv->pdv_host_id);
 			pdv->pdv_flags |= PDF_HAS_VIRT_HOST_ID;
 			break;
@@ -735,7 +735,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_channel_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI Channel ID: %d\n",
+			target_debug("host[%d]: Referencing SCSI Channel ID: %d\n",
 				     phv->phv_host_id, pdv->pdv_channel_id);
 			pdv->pdv_flags |= PDF_HAS_CHANNEL_ID;
 			break;
@@ -744,8 +744,8 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_target_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI Target ID: %d\n",
-				     phv->phv_host_id, pdv->pdv_target_id);
+			target_debug("host[%d]: Referencing SCSI Target ID: %d\n", phv->phv_host_id,
+				     pdv->pdv_target_id);
 			pdv->pdv_flags |= PDF_HAS_TARGET_ID;
 			break;
 		case Opt_scsi_lun_id:
@@ -753,7 +753,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_lun_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI LUN ID: %d\n", phv->phv_host_id,
+			target_debug("host[%d]: Referencing SCSI LUN ID: %d\n", phv->phv_host_id,
 				     pdv->pdv_lun_id);
 			pdv->pdv_flags |= PDF_HAS_LUN_ID;
 			break;
@@ -818,7 +818,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	BUG_ON(!cmd->data_length);
 
-	target_debug("nr_pages: %d\n", nr_pages);
+	target_cmd_debug(cmd, "nr_pages: %d\n", nr_pages);
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		page = sg_page(sg);
@@ -864,7 +864,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 				rc = blk_rq_append_bio(req, bio);
 				if (rc) {
-					target_err("failed to append bio\n");
+					target_cmd_err(cmd, "Failed to append bio\n");
 					goto fail;
 				}
 
@@ -878,7 +878,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (bio) {
 		rc = blk_rq_append_bio(req, bio);
 		if (rc) {
-			target_err("failed to append bio\n");
+			target_cmd_err(cmd, "Failed to append bio\n");
 			goto fail;
 		}
 	}
@@ -990,8 +990,8 @@ static enum rq_end_io_ret pscsi_req_done(struct request *req,
 	u8 *cdb = cmd->priv;
 
 	if (scsi_status != SAM_STAT_GOOD) {
-		target_debug("PSCSI Status Byte exception at cmd: %p CDB: 0x%02x Result: 0x%08x\n",
-			     cmd, cdb[0], scmd->result);
+		target_cmd_debug(cmd, "Status Byte exception at cmd: %p CDB: 0x%02x Result: 0x%08x\n",
+				 cmd, cdb[0], scmd->result);
 	}
 
 	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer, valid_data);
@@ -1001,8 +1001,8 @@ static enum rq_end_io_ret pscsi_req_done(struct request *req,
 		target_complete_cmd_with_length(cmd, scsi_status, valid_data);
 		break;
 	default:
-		target_debug("PSCSI Host Byte exception at cmd: %p CDB: 0x%02x Result: 0x%08x\n",
-			     cmd, cdb[0], scmd->result);
+		target_cmd_debug(cmd, "Host Byte exception at cmd: %p CDB: 0x%02x Result: 0x%08x\n",
+				 cmd, cdb[0], scmd->result);
 		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
 		break;
 	}
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 3a109a61c83b..c460e9b4c83d 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -44,7 +44,7 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = rd_host;
 
-	target_debug("CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on Generic Target Core Stack %s\n",
+	target_debug("hba[%d] - TCM Ramdisk HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, RD_HBA_VERSION, TARGET_CORE_VERSION);
 
 	return 0;
@@ -54,8 +54,8 @@ static void rd_detach_hba(struct se_hba *hba)
 {
 	struct rd_host *rd_host = hba->hba_ptr;
 
-	target_debug("CORE_HBA[%d] - Detached Ramdisk HBA: %u from Generic Target Core\n",
-		     hba->hba_id, rd_host->rd_host_id);
+	target_debug("hba[%d] - Detached Ramdisk HBA: %u from Generic Target Core\n", hba->hba_id,
+		     rd_host->rd_host_id);
 
 	kfree(rd_host);
 	hba->hba_ptr = NULL;
@@ -96,7 +96,7 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_table_array,
 					  rd_dev->sg_table_count);
 
-	target_debug("CORE_RD[%u] - Released device space for Ramdisk Device ID: %u, pages %u in %u tables total bytes %lu\n",
+	target_debug("host[%u] - Released device space for Ramdisk Device ID: %u, pages %u in %u tables total bytes %lu\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
 		     rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
@@ -201,7 +201,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (rc)
 		return rc;
 
-	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of %u pages in %u tables\n",
+	target_debug("host[%u] - Built Ramdisk Device ID: %u space of %u pages in %u tables\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
 		     rd_dev->sg_table_count);
 
@@ -218,7 +218,7 @@ static void rd_release_prot_space(struct rd_dev *rd_dev)
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_prot_array,
 					  rd_dev->sg_prot_count);
 
-	target_debug("CORE_RD[%u] - Released protection space for Ramdisk Device ID: %u, pages %u in %u tables total bytes %lu\n",
+	target_debug("host[%u] - Released protection space for Ramdisk Device ID: %u, pages %u in %u tables total bytes %lu\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
 		     rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
@@ -256,7 +256,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	if (rc)
 		return rc;
 
-	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of %u pages in %u tables\n",
+	target_debug("host[%u] - Built Ramdisk Device ID: %u prot space of %u pages in %u tables\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, total_sg_needed,
 		     rd_dev->sg_prot_count);
 
@@ -299,7 +299,7 @@ static int rd_configure_device(struct se_device *dev)
 
 	rd_dev->rd_dev_id = rd_host->rd_host_dev_id_count++;
 
-	target_debug("CORE_RD[%u] - Added TCM MEMCPY Ramdisk Device ID: %u of %u pages in %u tables, %lu total bytes\n",
+	target_debug("host[%u] - Added TCM MEMCPY Ramdisk Device ID: %u of %u pages in %u tables, %lu total bytes\n",
 		     rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
 		     rd_dev->sg_table_count, (unsigned long)(rd_dev->rd_page_count * PAGE_SIZE));
 
@@ -437,7 +437,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	rd_sg = &table->sg_table[rd_page - table->page_start_offset];
 
-	target_debug("RD[%u]: %s LBA: %llu, Size: %u Page: %u, Offset: %u\n", dev->rd_dev_id,
+	target_debug("device[%u]: %s LBA: %llu, Size: %u Page: %u, Offset: %u\n", dev->rd_dev_id,
 		     data_direction == DMA_FROM_DEVICE ? "Read" : "Write", cmd->t_task_lba, rd_size,
 		     rd_page, rd_offset);
 
@@ -458,14 +458,14 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 		sg_miter_next(&m);
 		if (!(u32)m.length) {
-			target_debug("RD[%u]: invalid sgl %p len %zu\n", dev->rd_dev_id, m.addr,
+			target_debug("device[%u]: invalid sgl %p len %zu\n", dev->rd_dev_id, m.addr,
 				     m.length);
 			sg_miter_stop(&m);
 			return TCM_INCORRECT_AMOUNT_OF_DATA;
 		}
 		len = min((u32)m.length, src_len);
 		if (len > rd_size) {
-			target_debug("RD[%u]: size underrun page %d offset %d size %d\n",
+			target_debug("device[%u]: size underrun page %d offset %d size %d\n",
 				     dev->rd_dev_id, rd_page, rd_offset, rd_size);
 			len = rd_size;
 		}
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 22b705bc7f91..caccb505fef2 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -282,12 +282,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 	sense_reason_t ret;
 
 	if ((flags & 0x04) || (flags & 0x02)) {
-		target_err("WRITE_SAME PBDATA and LBDATA bits not supported for Block Discard Emulation\n");
+		target_cmd_err(cmd, "WRITE_SAME PBDATA and LBDATA bits not supported for Block Discard Emulation\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
-		target_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n", sectors,
-			    cmd->se_dev->dev_attrib.max_write_same_len);
+		target_cmd_warn(cmd, "WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n",
+				sectors, cmd->se_dev->dev_attrib.max_write_same_len);
 		return TCM_INVALID_CDB_FIELD;
 	}
 	/*
@@ -295,19 +295,19 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 	 */
 	if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
 	    ((cmd->t_task_lba + sectors) > end_lba)) {
-		target_err("WRITE_SAME exceeds last lba %llu (lba %llu, sectors %u)\n",
-			   (unsigned long long)end_lba, cmd->t_task_lba, sectors);
+		target_cmd_err(cmd, "WRITE_SAME exceeds last lba %llu (lba %llu, sectors %u)\n",
+			       (unsigned long long)end_lba, cmd->t_task_lba, sectors);
 		return TCM_ADDRESS_OUT_OF_RANGE;
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
 	if (flags & 0x10) {
-		target_warn("WRITE SAME with ANCHOR not supported\n");
+		target_cmd_warn(cmd, "WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
 	if (flags & 0x01) {
-		target_warn("WRITE SAME with NDOB not supported\n");
+		target_cmd_warn(cmd, "WRITE SAME with NDOB not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -320,7 +320,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (!dev->dev_attrib.emulate_tpws) {
-			target_err("Got WRITE_SAME w/ UNMAP=1, but backend device has emulate_tpws disabled\n");
+			target_cmd_err(cmd, "Got WRITE_SAME w/ UNMAP=1, but backend device has emulate_tpws disabled\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		cmd->execute_cmd = sbc_execute_write_same_unmap;
@@ -473,8 +473,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * been failed with a non-zero SCSI status.
 	 */
 	if (cmd->scsi_status) {
-		target_debug("compare_and_write_callback: non zero scsi_status: 0x%02x\n",
-			     cmd->scsi_status);
+		target_cmd_debug(cmd, "%s: non zero scsi_status: 0x%02x\n", __func__,
+				 cmd->scsi_status);
 		*post_ret = 1;
 		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -495,7 +495,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		goto out;
 
 	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
-		target_err("Unable to allocate compare_and_write sg\n");
+		target_cmd_err(cmd, "Unable to allocate compare_and_write sg\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
@@ -624,7 +624,7 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
 			break;
 		default:
-			target_err("Unsupported protect field %d\n", protect);
+			target_cmd_err(cmd, "Unsupported protect field %d\n", protect);
 			return -EINVAL;
 		}
 	} else {
@@ -650,7 +650,7 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
 			break;
 		default:
-			target_err("Unsupported protect field %d\n", protect);
+			target_cmd_err(cmd, "Unsupported protect field %d\n", protect);
 			return -EINVAL;
 		}
 	}
@@ -669,7 +669,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (!cmd->t_prot_sg || !cmd->t_prot_nents) {
 		if (unlikely(protect &&
 		    !dev->dev_attrib.pi_prot_type && !cmd->se_sess->sess_prot_type)) {
-			target_err("CDB contains protect bit, but device + fabric does not advertise PROTECT=1 feature bit\n");
+			target_cmd_err(cmd, "CDB contains protect bit, but device + fabric does not advertise PROTECT=1 feature bit\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (cmd->prot_pto)
@@ -707,8 +707,8 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 			return TCM_NO_SENSE;
 		fallthrough;
 	default:
-		target_err("Unable to determine pi_prot_type for CDB: 0x%02x PROTECT: 0x%02x\n",
-			   cmd->t_task_cdb[0], protect);
+		target_cmd_err(cmd, "Unable to determine pi_prot_type for CDB: 0x%02x PROTECT: 0x%02x\n",
+			       cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -727,9 +727,9 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (protect)
 		cmd->data_length = sectors * dev->dev_attrib.block_size;
 
-	target_debug("%s: prot_type=%d, data_length=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
-		     __func__, cmd->prot_type, cmd->data_length, cmd->prot_length, cmd->prot_op,
-		     cmd->prot_checks);
+	target_cmd_debug(cmd, "%s: prot_type=%d, data_length=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
+			 __func__, cmd->prot_type, cmd->data_length, cmd->prot_length, cmd->prot_op,
+			 cmd->prot_checks);
 
 	return TCM_NO_SENSE;
 }
@@ -740,15 +740,15 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	if (cdb[1] & 0x10) {
 		/* see explanation in spc_emulate_modesense */
 		if (!target_check_fua(dev)) {
-			target_err("Got CDB: 0x%02x with DPO bit set, but device does not advertise support for DPO\n",
-				   cdb[0]);
+			target_cmd_err(cmd, "Got CDB: 0x%02x with DPO bit set, but device does not advertise support for DPO\n",
+				       cdb[0]);
 			return -EINVAL;
 		}
 	}
 	if (cdb[1] & 0x8) {
 		if (!target_check_fua(dev)) {
-			target_err("Got CDB: 0x%02x with FUA bit set, but device does not advertise support for FUA write\n",
-				   cdb[0]);
+			target_cmd_err(cmd, "Got CDB: 0x%02x with FUA bit set, but device does not advertise support for FUA write\n",
+				       cdb[0]);
 			return -EINVAL;
 		}
 		cmd->se_cmd_flags |= SCF_FUA;
@@ -874,7 +874,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb);
 			if (!sectors) {
-				target_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
+				target_cmd_err(cmd, "WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
 
@@ -886,18 +886,18 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 				return ret;
 			break;
 		default:
-			target_err("VARIABLE_LENGTH_CMD service action 0x%04x not supported\n",
-				   service_action);
+			target_cmd_err(cmd, "VARIABLE_LENGTH_CMD service action 0x%04x not supported\n",
+				       service_action);
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		break;
 	}
 	case COMPARE_AND_WRITE:
 		if (!dev->dev_attrib.emulate_caw) {
-			target_err_ratelimited("se_device %s/%s (vpd_unit_serial %s) reject COMPARE_AND_WRITE\n",
-					       dev->se_hba->backend->ops->name,
-					       config_item_name(&dev->dev_group.cg_item),
-					       dev->t10_wwn.unit_serial);
+			target_cmd_err_ratelimited(cmd, "se_device %s/%s (vpd_unit_serial %s) reject COMPARE_AND_WRITE\n",
+						   dev->se_hba->backend->ops->name,
+						   config_item_name(&dev->dev_group.cg_item),
+						   dev->t10_wwn.unit_serial);
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		sectors = cdb[13];
@@ -905,7 +905,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		 * Currently enforce COMPARE_AND_WRITE for a single sector
 		 */
 		if (sectors > 1) {
-			target_err("COMPARE_AND_WRITE contains NoLB: %u greater than 1\n", sectors);
+			target_cmd_err(cmd, "COMPARE_AND_WRITE contains NoLB: %u greater than 1\n",
+				       sectors);
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (sbc_check_dpofua(dev, cmd, cdb))
@@ -935,7 +936,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			cmd->execute_cmd = target_emulate_report_referrals;
 			break;
 		default:
-			target_err("Unsupported SA: 0x%02x\n", cmd->t_task_cdb[1] & 0x1f);
+			target_cmd_err(cmd, "Unsupported SA: 0x%02x\n", cmd->t_task_cdb[1] & 0x1f);
 			return TCM_INVALID_CDB_FIELD;
 		}
 		size = get_unaligned_be32(&cdb[10]);
@@ -961,7 +962,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (!dev->dev_attrib.emulate_tpu) {
-			target_err("Got UNMAP, but backend device has emulate_tpu disabled\n");
+			target_cmd_err(cmd, "Got UNMAP, but backend device has emulate_tpu disabled\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		size = get_unaligned_be16(&cdb[7]);
@@ -970,7 +971,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 	case WRITE_SAME_16:
 		sectors = transport_get_sectors_16(cdb);
 		if (!sectors) {
-			target_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
+			target_cmd_err(cmd, "WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -984,7 +985,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 	case WRITE_SAME:
 		sectors = transport_get_sectors_10(cdb);
 		if (!sectors) {
-			target_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
+			target_cmd_err(cmd, "WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -1043,8 +1044,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		end_lba = dev->transport->get_blocks(dev) + 1;
 		if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
 		    ((cmd->t_task_lba + sectors) > end_lba)) {
-			target_err("cmd exceeds last lba %llu (lba %llu, sectors %u)\n", end_lba,
-				   cmd->t_task_lba, sectors);
+			target_cmd_err(cmd, "cmd exceeds last lba %llu (lba %llu, sectors %u)\n",
+				       end_lba, cmd->t_task_lba, sectors);
 			return TCM_ADDRESS_OUT_OF_RANGE;
 		}
 
@@ -1084,7 +1085,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 	}
 
 	if (cmd->data_length < 8) {
-		target_warn("UNMAP parameter list length %u too small\n", cmd->data_length);
+		target_cmd_warn(cmd, "UNMAP parameter list length %u too small\n",
+				cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -1097,8 +1099,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 
 	size = cmd->data_length - 8;
 	if (bd_dl > size)
-		target_warn("UNMAP parameter list length %u too small, ignoring bd_dl %u\n",
-			    cmd->data_length, bd_dl);
+		target_cmd_warn(cmd, "UNMAP parameter list length %u too small, ignoring bd_dl %u\n",
+				cmd->data_length, bd_dl);
 	else
 		size = bd_dl;
 
@@ -1109,14 +1111,14 @@ sbc_execute_unmap(struct se_cmd *cmd)
 
 	/* First UNMAP block descriptor starts at 8 byte offset */
 	ptr = &buf[8];
-	target_debug("UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u ptr: %p\n",
-		     dev->transport->name, dl, bd_dl, size, ptr);
+	target_cmd_debug(cmd, "UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u ptr: %p\n",
+			 dev->transport->name, dl, bd_dl, size, ptr);
 
 	while (size >= 16) {
 		lba = get_unaligned_be64(&ptr[0]);
 		range = get_unaligned_be32(&ptr[8]);
-		target_debug("UNMAP: Using lba: %llu and range: %u\n", (unsigned long long)lba,
-			     range);
+		target_cmd_debug(cmd, "UNMAP: Using lba: %llu and range: %u\n",
+				 (unsigned long long)lba, range);
 
 		if (range > dev->dev_attrib.max_unmap_lba_count) {
 			ret = TCM_INVALID_PARAMETER_LIST;
@@ -1198,10 +1200,10 @@ sbc_dif_generate(struct se_cmd *cmd)
 				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
 			sdt->app_tag = 0;
 
-			target_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
-				     (cmd->data_direction == DMA_TO_DEVICE) ? "WRITE" : "READ",
-				     (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
-				     be32_to_cpu(sdt->ref_tag));
+			target_cmd_debug(cmd, "DIF %s INSERT sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
+					 (cmd->data_direction == DMA_TO_DEVICE) ? "WRITE" : "READ",
+					 (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
+					 be32_to_cpu(sdt->ref_tag));
 
 			sector++;
 		}
@@ -1223,9 +1225,9 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 	csum = cpu_to_be16(crc);
 
 	if (sdt->guard_tag != csum) {
-		target_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x csum 0x%04x\n",
-			   (unsigned long long)sector, be16_to_cpu(sdt->guard_tag),
-			   be16_to_cpu(csum));
+		target_cmd_err(cmd, "DIFv1 checksum failed on sector %llu guard tag 0x%04x csum 0x%04x\n",
+			       (unsigned long long)sector, be16_to_cpu(sdt->guard_tag),
+			       be16_to_cpu(csum));
 		return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 	}
 
@@ -1235,16 +1237,16 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 
 	if (cmd->prot_type == TARGET_DIF_TYPE1_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
-		target_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x sector MSB: 0x%08x\n",
-			   (unsigned long long)sector, be32_to_cpu(sdt->ref_tag),
-			   (u32)(sector & 0xffffffff));
+		target_cmd_err(cmd, "DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x sector MSB: 0x%08x\n",
+			       (unsigned long long)sector, be32_to_cpu(sdt->ref_tag),
+			       (u32)(sector & 0xffffffff));
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
 
 	if (cmd->prot_type == TARGET_DIF_TYPE2_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-		target_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x ei_lba: 0x%08x\n",
-			   (unsigned long long)sector, be32_to_cpu(sdt->ref_tag), ei_lba);
+		target_cmd_err(cmd, "DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x ei_lba: 0x%08x\n",
+			       (unsigned long long)sector, be32_to_cpu(sdt->ref_tag), ei_lba);
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
 
@@ -1333,9 +1335,9 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			sdt = paddr + i;
 
-			target_debug("DIF READ sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
-				     (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
-				     be32_to_cpu(sdt->ref_tag));
+			target_cmd_debug(cmd, "DIF READ sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
+					 (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
+					 be32_to_cpu(sdt->ref_tag));
 
 			if (sdt->app_tag == T10_PI_APP_ESCAPE) {
 				dsg_off += block_size;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ce59b5f02ef0..2d506e672bff 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -744,7 +744,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 	buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
 	if (!buf) {
-		target_err("Unable to allocate response buffer for INQUIRY\n");
+		target_cmd_err(cmd, "Unable to allocate response buffer for INQUIRY\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -752,7 +752,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 	if (!(cdb[1] & 0x1)) {
 		if (cdb[2]) {
-			target_err("INQUIRY with EVPD==0 but PAGE CODE=%02x\n", cdb[2]);
+			target_cmd_err(cmd, "INQUIRY with EVPD==0 but PAGE CODE=%02x\n", cdb[2]);
 			ret = TCM_INVALID_CDB_FIELD;
 			goto out;
 		}
@@ -771,7 +771,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 	}
 
-	target_debug("Unknown VPD Code: 0x%02x\n", cdb[2]);
+	target_cmd_debug(cmd, "Unknown VPD Code: 0x%02x\n", cdb[2]);
 	ret = TCM_INVALID_CDB_FIELD;
 
 out:
@@ -1086,7 +1086,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 
 	if (page == 0x3f) {
 		if (subpage != 0x00 && subpage != 0xff) {
-			target_warn("MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
+			target_cmd_warn(cmd, "MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -1120,8 +1120,8 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	 *  - obsolete page 03h "format parameters" (checked by Solaris)
 	 */
 	if (page != 0x03)
-		target_err("MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n", page,
-			   subpage);
+		target_cmd_debug(cmd, "MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n",
+				 page, subpage);
 
 	return TCM_UNKNOWN_MODE_PAGE;
 
@@ -1213,7 +1213,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	memset(buf, 0, SE_SENSE_BUF);
 
 	if (cdb[1] & 0x01) {
-		target_err("REQUEST_SENSE description emulation not supported\n");
+		target_cmd_err(cmd, "REQUEST_SENSE description emulation not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2113,7 +2113,6 @@ static sense_reason_t
 spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 {
 	struct target_opcode_descriptor *descr;
-	struct se_session *sess = cmd->se_sess;
 	unsigned char *cdb = cmd->t_task_cdb;
 	u8 opts = cdb[2] & 0x3;
 	u8 requested_opcode;
@@ -2125,9 +2124,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 	*opcode = NULL;
 
 	if (opts > 3) {
-		target_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
-			     cmd->se_tfo->fabric_name, opts, cmd->se_lun->unpacked_lun,
-			     sess->se_node_acl->initiatorname);
+		target_cmd_debug(cmd, "Invalid REPORT SUPPORTED OPERATION CODES with unsupported REPORTING OPTIONS %#x for 0x%08llx\n",
+				 opts, cmd->se_lun->unpacked_lun);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index db3b0467105d..867a2d604b2f 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -89,8 +89,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 	 */
 	spin_lock(&se_cmd->t_state_lock);
 	if (se_cmd->transport_state & (CMD_T_COMPLETE | CMD_T_FABRIC_STOP)) {
-		target_debug("Attempted to abort io tag: %llu already complete or fabric stop, skipping\n",
-			     se_cmd->tag);
+		target_cmd_debug(se_cmd, "Attempted to abort io tag: %llu already complete or fabric stop, skipping\n",
+				 se_cmd->tag);
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
 	}
@@ -136,8 +136,8 @@ void core_tmr_abort_task(
 			if (tmr->ref_task_tag != ref_tag)
 				continue;
 
-			target_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
-				   se_cmd->se_tfo->fabric_name, ref_tag);
+			target_cmd_err(se_cmd, "ABORT_TASK: Found referenced %s task_tag: %llu\n",
+				       se_cmd->se_tfo->fabric_name, ref_tag);
 
 			spin_lock(&se_sess->sess_cmd_lock);
 			rc = __target_check_io_state(se_cmd, se_sess, 0);
@@ -237,9 +237,9 @@ static void core_tmr_drain_tmr_list(
 		list_del_init(&tmr_p->tmr_list);
 		cmd = tmr_p->task_cmd;
 
-		target_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x, Response: 0x%02x, t_state: %d\n",
-			     (preempt_and_abort_list) ? "Preempt" : "", tmr_p, tmr_p->function,
-			     tmr_p->response, cmd->t_state);
+		target_cmd_debug(cmd, "LUN_RESET: %s releasing TMR %p Function: 0x%02x, Response: 0x%02x, t_state: %d\n",
+				 (preempt_and_abort_list) ? "Preempt" : "", tmr_p, tmr_p->function,
+				 tmr_p->response, cmd->t_state);
 
 		target_put_cmd_and_wait(cmd);
 	}
@@ -344,8 +344,9 @@ static void core_tmr_drain_state_list(
 		list_del_init(&cmd->state_list);
 
 		target_show_cmd("LUN_RESET: ", cmd);
-		target_debug("LUN_RESET: ITT[0x%08llx] - %s pr_res_key: 0x%016Lx\n", cmd->tag,
-			     (preempt_and_abort_list) ? "preempt" : "", cmd->pr_res_key);
+		target_cmd_debug(cmd, "LUN_RESET: ITT[0x%08llx] - %s pr_res_key: 0x%016Lx\n",
+				 cmd->tag, (preempt_and_abort_list) ? "preempt" : "",
+				 cmd->pr_res_key);
 
 		target_put_cmd_and_wait(cmd);
 	}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 3f0b53032aeb..633f64b36aaf 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -136,9 +136,8 @@ void core_tpg_add_node_to_devs(
 				lun_access_ro = false;
 		}
 
-		target_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%llu] - Adding %s access for LUN in Demo Mode\n",
-			     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
-			     lun->unpacked_lun, lun_access_ro ? "READ-ONLY" : "READ-WRITE");
+		target_lun_debug(lun, "Adding %s access for LUN in Demo Mode\n",
+				 lun_access_ro ? "READ-ONLY" : "READ-WRITE");
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
 						 lun_access_ro, acl, tpg);
@@ -544,7 +543,7 @@ int core_tpg_register(
 		}
 	}
 
-	target_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, Proto: %d, Portal Tag: %u\n",
+	target_debug("[%s]: Allocated portal_group for endpoint: %s, Proto: %d, Portal Tag: %u\n",
 		     se_tpg->se_tpg_tfo->fabric_name,
 		     se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
 		     se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
@@ -560,7 +559,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	struct se_node_acl *nacl, *nacl_tmp;
 	LIST_HEAD(node_list);
 
-	target_debug("TARGET_CORE[%s]: Deallocating portal_group for endpoint: %s, Proto: %d, Portal Tag: %u\n",
+	target_debug("[%s]: Deallocating portal_group for endpoint: %s, Proto: %d, Portal Tag: %u\n",
 		     tfo->fabric_name, tfo->tpg_get_wwn(se_tpg) ? tfo->tpg_get_wwn(se_tpg) : NULL,
 		     se_tpg->proto_id, tfo->tpg_get_tag(se_tpg));
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 13fddd94a792..6326eb520fc7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -428,8 +428,7 @@ void __transport_register_session(
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
-	target_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
-		     se_tpg->se_tpg_tfo->fabric_name, se_sess->fabric_sess_ptr);
+	target_sess_debug(se_sess, "Registered fabric_sess_ptr: %p\n", se_sess->fabric_sess_ptr);
 }
 EXPORT_SYMBOL(__transport_register_session);
 
@@ -664,8 +663,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	 */
 	target_for_each_device(target_release_res, se_sess);
 
-	target_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
-		     se_tpg->se_tpg_tfo->fabric_name);
+	target_debug("[%s]: Deregistered fabric_sess\n", se_tpg->se_tpg_tfo->fabric_name);
 	/*
 	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
@@ -734,7 +732,8 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	 * this command for frontend exceptions.
 	 */
 	if (cmd->transport_state & CMD_T_STOP) {
-		target_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n", __func__, __LINE__, cmd->tag);
+		target_cmd_debug(cmd, "%s:%d CMD_T_STOP for ITT: 0x%08llx\n", __func__, __LINE__,
+				 cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
@@ -798,8 +797,8 @@ static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
 
 	cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
 
-	target_debug("HBA_[%u]_PLUG[%s]: Requesting sense for SAM STATUS: 0x%02x\n",
-		     dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
+	target_cmd_debug(cmd, "hba[%u], transport[%s] - Requesting sense for SAM STATUS: 0x%02x\n",
+			 dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
 	return cmd->sense_buffer;
 }
 
@@ -827,13 +826,13 @@ static void target_handle_abort(struct se_cmd *cmd)
 	bool ack_kref = cmd->se_cmd_flags & SCF_ACK_KREF;
 	int ret;
 
-	target_debug("tag %#llx: send_abort_response = %d\n", cmd->tag, tas);
+	target_cmd_debug(cmd, "tag %#llx: send_abort_response = %d\n", cmd->tag, tas);
 
 	if (tas) {
 		if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
 			cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-			target_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
-				     cmd->t_task_cdb[0], cmd->tag);
+			target_cmd_debug(cmd, "Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
+					 cmd->t_task_cdb[0], cmd->tag);
 			trace_target_cmd_complete(cmd);
 			ret = cmd->se_tfo->queue_status(cmd);
 			if (ret) {
@@ -1006,11 +1005,11 @@ void target_qf_do_work(struct work_struct *work)
 		list_del(&cmd->se_qf_node);
 		atomic_dec_mb(&dev->dev_qf_count);
 
-		target_debug("Processing %s cmd: %p QUEUE_FULL in work queue context: %s\n",
-			     cmd->se_tfo->fabric_name, cmd,
-			     (cmd->t_state == TRANSPORT_COMPLETE_QF_OK) ? "COMPLETE_OK" :
-			     (cmd->t_state == TRANSPORT_COMPLETE_QF_WP) ? "WRITE_PENDING"
-			     : "UNKNOWN");
+		target_cmd_debug(cmd, "Processing %s cmd: %p QUEUE_FULL in work queue context: %s\n",
+				 cmd->se_tfo->fabric_name, cmd,
+				 (cmd->t_state == TRANSPORT_COMPLETE_QF_OK) ? "COMPLETE_OK" :
+				 (cmd->t_state == TRANSPORT_COMPLETE_QF_WP) ? "WRITE_PENDING" :
+				 "UNKNOWN");
 
 		if (cmd->t_state == TRANSPORT_COMPLETE_QF_WP)
 			transport_write_pending_qf(cmd);
@@ -1382,9 +1381,8 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 	if (cmd->unknown_data_length) {
 		cmd->data_length = size;
 	} else if (size != cmd->data_length) {
-		target_warn_ratelimited("TARGET_CORE[%s]: Expected Transfer Length: %u does not match SCSI CDB Length: %u for SAM Opcode: 0x%02x\n",
-					cmd->se_tfo->fabric_name, cmd->data_length, size,
-					cmd->t_task_cdb[0]);
+		target_cmd_warn_ratelimited(cmd, "Expected Transfer Length: %u does not match SCSI CDB Length: %u for SAM Opcode: 0x%02x\n",
+					    cmd->data_length, size, cmd->t_task_cdb[0]);
 		/*
 		 * For READ command for the overflow case keep the existing
 		 * fabric provided ->data_length. Otherwise for the underflow
@@ -1408,7 +1406,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 
 		if (cmd->data_direction == DMA_TO_DEVICE) {
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-				target_err_ratelimited("Rejecting underflow/overflow for WRITE data CDB\n");
+				target_cmd_err_ratelimited(cmd, "Rejecting underflow/overflow for WRITE data CDB\n");
 				return TCM_INVALID_FIELD_IN_COMMAND_IU;
 			}
 			/*
@@ -1418,7 +1416,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			 * is introduced tree-wide.
 			 */
 			if (size > cmd->data_length) {
-				target_err_ratelimited("Rejecting overflow for WRITE control CDB\n");
+				target_cmd_err_ratelimited(cmd, "Rejecting overflow for WRITE control CDB\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
@@ -1481,7 +1479,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 		return 0;
 
 	if (cmd->sam_task_attr == TCM_ACA_TAG) {
-		target_debug("SAM Task Attribute ACA emulation is not supported\n");
+		target_cmd_debug(cmd, "SAM Task Attribute ACA emulation is not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -1498,8 +1496,8 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 	 * for VARIABLE_LENGTH_CMD
 	 */
 	if (scsi_command_size(cdb) > SCSI_MAX_VARLEN_CDB_SIZE) {
-		target_err("Received SCSI CDB with command_size: %d that exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
-			   scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
+		target_cmd_err(cmd, "Received SCSI CDB with command_size: %d that exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
+			       scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto err;
 	}
@@ -1511,9 +1509,9 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
-			target_err("Unable to allocate cmd->t_task_cdb %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
-				   scsi_command_size(cdb),
-				   (unsigned long)sizeof(cmd->__t_task_cdb));
+			target_cmd_err(cmd, "Unable to allocate cmd->t_task_cdb %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
+				       scsi_command_size(cdb),
+				       (unsigned long)sizeof(cmd->__t_task_cdb));
 			ret = TCM_OUT_OF_RESOURCES;
 			goto err;
 		}
@@ -1545,10 +1543,10 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
-		target_debug_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
-					 cmd->se_tfo->fabric_name,
-					 cmd->se_sess->se_node_acl->initiatorname,
-					 cmd->t_task_cdb[0]);
+		target_cmd_debug_ratelimited(cmd, "%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
+					     cmd->se_tfo->fabric_name,
+					     cmd->se_sess->se_node_acl->initiatorname,
+					     cmd->t_task_cdb[0]);
 	if (ret)
 		return ret;
 
@@ -1636,7 +1634,7 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 	 * passes for the original expected data transfer length.
 	 */
 	if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
-		target_warn("Rejecting SCSI DATA overflow for fabric using SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
+		target_cmd_warn(cmd, "Rejecting SCSI DATA overflow for fabric using SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2093,8 +2091,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 
 		goto queue_status;
 	default:
-		target_err("Unknown transport error for CDB 0x%02x: %d\n", cmd->t_task_cdb[0],
-			   sense_reason);
+		target_cmd_err(cmd, "Unknown transport error for CDB 0x%02x: %d\n",
+			       cmd->t_task_cdb[0], sense_reason);
 		sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
 		break;
 	}
@@ -2210,12 +2208,13 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	switch (cmd->sam_task_attr) {
 	case TCM_HEAD_TAG:
 		atomic_inc_mb(&dev->non_ordered);
-		target_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n", cmd->t_task_cdb[0]);
+		target_cmd_debug(cmd, "Added HEAD_OF_QUEUE for CDB: 0x%02x\n", cmd->t_task_cdb[0]);
 		return false;
 	case TCM_ORDERED_TAG:
 		atomic_inc_mb(&dev->delayed_cmd_count);
 
-		target_debug("Added ORDERED for CDB: 0x%02x to ordered list\n", cmd->t_task_cdb[0]);
+		target_cmd_debug(cmd, "Added ORDERED for CDB: 0x%02x to ordered list\n",
+				 cmd->t_task_cdb[0]);
 		break;
 	default:
 		/*
@@ -2245,8 +2244,8 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
 	spin_unlock(&dev->delayed_cmd_lock);
 
-	target_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn", cmd->t_task_cdb[0],
-		     cmd->sam_task_attr);
+	target_cmd_debug(cmd, "Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn",
+			 cmd->t_task_cdb[0], cmd->sam_task_attr);
 	/*
 	 * We may have no non ordered cmds when this function started or we
 	 * could have raced with the last simple/head cmd completing, so kick
@@ -2350,16 +2349,16 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
 		atomic_dec_mb(&dev->non_ordered);
 		dev->dev_cur_ordered_id++;
-		target_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
-			     dev->dev_cur_ordered_id);
+		target_cmd_debug(cmd, "Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
+				 dev->dev_cur_ordered_id);
 	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
 		spin_lock(&dev->delayed_cmd_lock);
 		dev->ordered_sync_in_progress = false;
 		spin_unlock(&dev->delayed_cmd_lock);
 
 		dev->dev_cur_ordered_id++;
-		target_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
-			     dev->dev_cur_ordered_id);
+		target_cmd_debug(cmd, "Incremented dev_cur_ordered_id: %u for ORDERED\n",
+				 dev->dev_cur_ordered_id);
 	}
 	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
 
@@ -2451,7 +2450,7 @@ static void transport_handle_queue_full(struct se_cmd *cmd, struct se_device *de
 		cmd->t_state = (write_pending) ? TRANSPORT_COMPLETE_QF_WP :
 						 TRANSPORT_COMPLETE_QF_OK;
 	} else {
-		target_warn_ratelimited("Got unknown fabric queue status: %d\n", err);
+		target_cmd_warn_ratelimited(cmd, "Got unknown fabric queue status: %d\n", err);
 		cmd->t_state = TRANSPORT_COMPLETE_QF_ERR;
 	}
 
@@ -2630,8 +2629,8 @@ static void target_complete_ok_work(struct work_struct *work)
 	return;
 
 queue_full:
-	target_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p, data_direction: %d\n", cmd,
-		     cmd->data_direction);
+	target_cmd_debug(cmd, "Handling complete_ok QUEUE_FULL: se_cmd: %p, data_direction: %d\n",
+			 cmd, cmd->data_direction);
 
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
@@ -2836,7 +2835,8 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 */
 	if (cmd->transport_state & CMD_T_STOP &&
 	    !cmd->se_tfo->write_pending_must_be_called) {
-		target_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n", __func__, __LINE__, cmd->tag);
+		target_cmd_debug(cmd, "%s:%d CMD_T_STOP for ITT: 0x%08llx\n", __func__, __LINE__,
+				 cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
@@ -2853,7 +2853,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	return 0;
 
 queue_full:
-	target_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
+	target_cmd_debug(cmd, "Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, true);
 	return 0;
 }
@@ -2870,15 +2870,15 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (stop) {
-		target_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n", __func__,
-			     __LINE__, cmd->tag);
+		target_cmd_debug(cmd, "%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
+				 __func__, __LINE__, cmd->tag);
 		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	}
 
 	ret = cmd->se_tfo->write_pending(cmd);
 	if (ret) {
-		target_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
+		target_cmd_debug(cmd, "Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, true);
 	}
 }
@@ -3619,9 +3619,9 @@ int transport_generic_handle_tmr(
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (aborted) {
-		target_warn_ratelimited("handle_tmr caught CMD_T_ABORTED TMR %d ref_tag: %llu tag: %llu\n",
-					cmd->se_tmr_req->function, cmd->se_tmr_req->ref_task_tag,
-					cmd->tag);
+		target_cmd_warn_ratelimited(cmd, "handle_tmr caught CMD_T_ABORTED TMR %d ref_tag: %llu tag: %llu\n",
+					    cmd->se_tmr_req->function,
+					    cmd->se_tmr_req->ref_task_tag, cmd->tag);
 		target_handle_abort(cmd);
 		return 0;
 	}
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 11d50a1da03c..df4d884b76ae 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -253,11 +253,11 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
-	target_debug("[%s]: %s UNIT ATTENTION condition with INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x reported ASC: 0x%02x, ASCQ: 0x%02x\n",
-		     nacl->se_tpg->se_tpg_tfo->fabric_name,
-		     dev_ua_intlck_clear ? "Releasing" : "Reporting",
-		     dev->dev_attrib.emulate_ua_intlck_ctrl, cmd->orig_fe_lun, cmd->t_task_cdb[0],
-		     *asc, *ascq);
+	target_cmd_debug(cmd, "[%s]: %s UNIT ATTENTION condition with INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x reported ASC: 0x%02x, ASCQ: 0x%02x\n",
+			 nacl->se_tpg->se_tpg_tfo->fabric_name,
+			 dev_ua_intlck_clear ? "Releasing" : "Reporting",
+			 dev->dev_attrib.emulate_ua_intlck_ctrl, cmd->orig_fe_lun,
+			 cmd->t_task_cdb[0], *asc, *ascq);
 
 	return head == 0;
 }
@@ -313,8 +313,8 @@ int core_scsi3_ua_clear_for_request_sense(
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
-	target_debug("[%s]: Released UNIT ATTENTION condition, mapped LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x, ASCQ: 0x%02x\n",
-		     nacl->se_tpg->se_tpg_tfo->fabric_name, cmd->orig_fe_lun, *asc, *ascq);
+	target_cmd_debug(cmd, "[%s]: Released UNIT ATTENTION condition, mapped LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x, ASCQ: 0x%02x\n",
+			 nacl->se_tpg->se_tpg_tfo->fabric_name, cmd->orig_fe_lun, *asc, *ascq);
 
 	return (head) ? -EPERM : 0;
 }
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 341adcc82db8..c6ebb9cfe6e5 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -59,10 +59,10 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 
 	rc = memcmp(&tmp_dev_wwn[0], dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
 	if (rc != 0) {
-		target_debug("skip non-matching: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN, tmp_dev_wwn);
+		target_debug("Skip non-matching: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN, tmp_dev_wwn);
 		return 0;
 	}
-	target_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
+	target_debug("0xe4: located se_dev: %p\n", se_dev);
 
 	return 1;
 }
@@ -81,7 +81,7 @@ static int target_xcopy_locate_se_dev_e4(struct se_session *sess,
 	if (!sess)
 		goto err_out;
 
-	target_debug("XCOPY 0xe4: searching for: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN, dev_wwn);
+	target_sess_debug(sess, "0xe4: searching for: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN, dev_wwn);
 
 	nacl = sess->se_node_acl;
 	rcu_read_lock();
@@ -103,13 +103,13 @@ static int target_xcopy_locate_se_dev_e4(struct se_session *sess,
 	if (found_dev == NULL)
 		goto err_out;
 
-	target_debug("lun_ref held for se_dev: %p se_dev->se_dev_group: %p\n", found_dev,
-		     &found_dev->dev_group);
+	target_sess_debug(sess, "lun_ref held for se_dev: %p se_dev->se_dev_group: %p\n", found_dev,
+			  &found_dev->dev_group);
 	*_found_dev = found_dev;
 	*_found_lun_ref = &this_lun->lun_ref;
 	return 0;
 err_out:
-	target_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
+	target_sess_debug_ratelimited(sess, "Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
 	return -EINVAL;
 }
 
@@ -123,20 +123,21 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 * Extract RELATIVE INITIATOR PORT IDENTIFIER
 	 */
 	ript = get_unaligned_be16(&desc[2]);
-	target_debug("XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: %u\n", ript);
+	target_cmd_debug(se_cmd, "0xe4: RELATIVE INITIATOR PORT IDENTIFIER: %u\n", ript);
 	/*
 	 * Check for supported code set, association, and designator type
 	 */
 	if ((desc[4] & 0x0f) != 0x1) {
-		target_err("XCOPY 0xe4: code set of non binary type not supported\n");
+		target_cmd_err(se_cmd, "0xe4: code set of non binary type not supported\n");
 		return -EINVAL;
 	}
 	if ((desc[5] & 0x30) != 0x00) {
-		target_err("XCOPY 0xe4: association other than LUN not supported\n");
+		target_cmd_err(se_cmd, "0xe4: association other than LUN not supported\n");
 		return -EINVAL;
 	}
 	if ((desc[5] & 0x0f) != 0x3) {
-		target_err("XCOPY 0xe4: designator type unsupported: 0x%02x\n", (desc[5] & 0x0f));
+		target_cmd_err(se_cmd, "0xe4: designator type unsupported: 0x%02x\n",
+			       (desc[5] & 0x0f));
 		return -EINVAL;
 	}
 	/*
@@ -145,21 +146,22 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 */
 	desig_len = desc[7];
 	if (desig_len != XCOPY_NAA_IEEE_REGEX_LEN) {
-		target_err("XCOPY 0xe4: invalid desig_len: %d\n", (int)desig_len);
+		target_cmd_err(se_cmd, "0xe4: invalid desig_len: %d\n", (int)desig_len);
 		return -EINVAL;
 	}
-	target_debug("XCOPY 0xe4: desig_len: %d\n", (int)desig_len);
+	target_cmd_debug(se_cmd, "0xe4: desig_len: %d\n", (int)desig_len);
 	/*
 	 * Check for NAA IEEE Registered Extended Assigned header..
 	 */
 	if ((desc[8] & 0xf0) != 0x60) {
-		target_err("XCOPY 0xe4: Unsupported DESIGNATOR TYPE: 0x%02x\n", (desc[8] & 0xf0));
+		target_cmd_err(se_cmd, "0xe4: Unsupported DESIGNATOR TYPE: 0x%02x\n",
+			       (desc[8] & 0xf0));
 		return -EINVAL;
 	}
 
 	if (cscd_index != xop->stdi && cscd_index != xop->dtdi) {
-		target_debug("XCOPY 0xe4: ignoring CSCD entry %d - neither src nor dest\n",
-			     cscd_index);
+		target_cmd_debug(se_cmd, "0xe4: ignoring CSCD entry %d - neither src nor dest\n",
+				 cscd_index);
 		return 0;
 	}
 
@@ -172,8 +174,8 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
 			xop->op_origin = XCOL_SOURCE_RECV_OP;
 			xop->src_dev = se_cmd->se_dev;
-			target_debug("XCOPY 0xe4: Set xop->src_dev %p from source received xop\n",
-				     xop->src_dev);
+			target_cmd_debug(se_cmd, "0xe4: Set xop->src_dev %p from source received xop\n",
+					 xop->src_dev);
 		}
 	}
 
@@ -189,8 +191,8 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
 			xop->op_origin = XCOL_DEST_RECV_OP;
 			xop->dst_dev = se_cmd->se_dev;
-			target_debug("XCOPY 0xe4: Set xop->dst_dev: %p from destination received xop\n",
-				     xop->dst_dev);
+			target_cmd_debug(se_cmd, "0xe4: Set xop->dst_dev: %p from destination received xop\n",
+					 xop->dst_dev);
 		}
 	}
 
@@ -210,14 +212,14 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
 	if (offset != 0) {
-		target_err("XCOPY target descriptor list length is not multiple of %d\n",
-			   XCOPY_TARGET_DESC_LEN);
+		target_cmd_err(se_cmd, "Target descriptor list length is not multiple of %d\n",
+			       XCOPY_TARGET_DESC_LEN);
 		*sense_ret = TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE;
 		return -EINVAL;
 	}
 	if (tdll > RCR_OP_MAX_TARGET_DESC_COUNT * XCOPY_TARGET_DESC_LEN) {
-		target_err("XCOPY target descriptor supports a maximum two src/dest descriptors, tdll: %u too large..\n",
-			   tdll);
+		target_cmd_err(se_cmd, "Target descriptor supports a maximum two src/dest descriptors, tdll: %u too large..\n",
+			       tdll);
 		/* spc4r37 6.4.3.4 CSCD DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_TARGET_DESCS;
 		return -EINVAL;
@@ -246,7 +248,8 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 			cscd_index++;
 			break;
 		default:
-			target_err("XCOPY unsupported descriptor type code: 0x%02x\n", desc[0]);
+			target_cmd_err(se_cmd, "Unsupported descriptor type code: 0x%02x\n",
+				       desc[0]);
 			*sense_ret = TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE;
 			goto out;
 		}
@@ -266,8 +269,8 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 						&xop->remote_lun_ref);
 		break;
 	default:
-		target_err("XCOPY CSCD descriptor IDs not found in CSCD list - stdi: %hu dtdi: %hu\n",
-			   xop->stdi, xop->dtdi);
+		target_cmd_err(se_cmd, "CSCD descriptor IDs not found in CSCD list - stdi: %hu dtdi: %hu\n",
+			       xop->stdi, xop->dtdi);
 		rc = -EINVAL;
 		break;
 	}
@@ -282,10 +285,10 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 		goto out;
 	}
 
-	target_debug("XCOPY TGT desc: Source dev: %p NAA IEEE WWN: 0x%16phN\n", xop->src_dev,
-		     &xop->src_tid_wwn[0]);
-	target_debug("XCOPY TGT desc: Dest dev: %p NAA IEEE WWN: 0x%16phN\n", xop->dst_dev,
-		     &xop->dst_tid_wwn[0]);
+	target_cmd_debug(se_cmd, "TGT desc: Source dev: %p NAA IEEE WWN: 0x%16phN\n", xop->src_dev,
+			 &xop->src_tid_wwn[0]);
+	target_cmd_debug(se_cmd, "TGT desc: Dest dev: %p NAA IEEE WWN: 0x%16phN\n", xop->dst_dev,
+			 &xop->dst_tid_wwn[0]);
 
 	return cscd_index;
 
@@ -301,7 +304,7 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	desc_len = get_unaligned_be16(&desc[2]);
 	if (desc_len != 0x18) {
-		target_err("XCOPY segment desc 0x02: Illegal desc_len: %u\n", desc_len);
+		target_err("segment desc 0x02: Illegal desc_len: %u\n", desc_len);
 		return -EINVAL;
 	}
 
@@ -310,18 +313,18 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	if (xop->stdi > XCOPY_CSCD_DESC_ID_LIST_OFF_MAX ||
 	    xop->dtdi > XCOPY_CSCD_DESC_ID_LIST_OFF_MAX) {
-		target_err("XCOPY segment desc 0x02: unsupported CSCD ID > 0x%x; stdi: %u dtdi: %u\n",
+		target_err("Segment desc 0x02: unsupported CSCD ID > 0x%x; stdi: %u dtdi: %u\n",
 			   XCOPY_CSCD_DESC_ID_LIST_OFF_MAX, xop->stdi, xop->dtdi);
 		return -EINVAL;
 	}
 
-	target_debug("XCOPY seg desc 0x02: desc_len: %hu stdi: %hu dtdi: %hu, DC: %d\n", desc_len,
-		     xop->stdi, xop->dtdi, dc);
+	target_debug("seg desc 0x02: desc_len: %hu stdi: %hu dtdi: %hu, DC: %d\n",
+		     desc_len, xop->stdi, xop->dtdi, dc);
 
 	xop->nolb = get_unaligned_be16(&desc[10]);
 	xop->src_lba = get_unaligned_be64(&desc[12]);
 	xop->dst_lba = get_unaligned_be64(&desc[20]);
-	target_debug("XCOPY seg desc 0x02: nolb: %u src_lba: %llu dst_lba: %llu\n", xop->nolb,
+	target_debug("seg desc 0x02: nolb: %u src_lba: %llu dst_lba: %llu\n", xop->nolb,
 		     (unsigned long long)xop->src_lba, (unsigned long long)xop->dst_lba);
 
 	return 0;
@@ -338,13 +341,13 @@ static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
 	if (offset != 0) {
-		target_err("XCOPY segment descriptor list length is not multiple of %d\n",
+		target_err("Segment descriptor list length is not multiple of %d\n",
 			   XCOPY_SEGMENT_DESC_LEN);
 		*sense_ret = TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE;
 		return -EINVAL;
 	}
 	if (sdll > RCR_OP_MAX_SG_DESC_COUNT * XCOPY_SEGMENT_DESC_LEN) {
-		target_err("XCOPY supports %u segment descriptor(s), sdll: %u too large..\n",
+		target_err("Supports %u segment descriptor(s), sdll: %u too large..\n",
 			   RCR_OP_MAX_SG_DESC_COUNT, sdll);
 		/* spc4r37 6.4.3.5 SEGMENT DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_SEGMENT_DESCS;
@@ -366,7 +369,8 @@ static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
 			desc += XCOPY_SEGMENT_DESC_LEN;
 			break;
 		default:
-			target_err("XCOPY unsupported segment descriptortype: 0x%02x\n", desc[0]);
+			target_err("Unsupported segment descriptor type: 0x%02x\n",
+				   desc[0]);
 			*sense_ret = TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE;
 			goto out;
 		}
@@ -535,8 +539,8 @@ static int target_xcopy_setup_pt_cmd(
 					xop->xop_data_nents, NULL, 0))
 		return -EINVAL;
 
-	target_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents: %u\n", cmd->t_data_sg,
-		     cmd->t_data_nents);
+	target_cmd_debug(cmd, "Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents: %u\n",
+			 cmd->t_data_sg, cmd->t_data_nents);
 
 	return 0;
 }
@@ -555,7 +559,7 @@ static int target_xcopy_issue_pt_cmd(struct xcopy_pt_cmd *xpt_cmd)
 
 	wait_for_completion_interruptible(&xpt_cmd->xpt_passthrough_sem);
 
-	target_debug("target_xcopy_issue_pt_cmd(): SCSI status: 0x%02x\n", se_cmd->scsi_status);
+	target_cmd_debug(se_cmd, "%s(): SCSI status: 0x%02x\n", __func__, se_cmd->scsi_status);
 
 	return (se_cmd->scsi_status) ? -EINVAL : 0;
 }
@@ -594,7 +598,7 @@ static int target_xcopy_read_source(
 		goto out;
 	}
 
-	target_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ memory\n",
+	target_debug("READ: Saved xop->xop_data_sg: %p, num: %u for READ memory\n",
 		     xop->xop_data_sg, xop->xop_data_nents);
 
 	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
@@ -692,10 +696,10 @@ static void target_xcopy_do_work(struct work_struct *work)
 	 */
 	max_blocks = max_bytes >> ilog2(src_dev->dev_attrib.block_size);
 
-	target_debug("%s: nolb: %u, max_blocks: %llu end_lba: %llu\n", __func__, nolb, max_blocks,
-		     (unsigned long long)end_lba);
-	target_debug("%s: Starting src_lba: %llu, dst_lba: %llu\n", __func__,
-		     (unsigned long long)src_lba, (unsigned long long)dst_lba);
+	target_cmd_debug(ec_cmd, "%s: nolb: %u, max_blocks: %llu end_lba: %llu\n", __func__, nolb,
+			 max_blocks, (unsigned long long)end_lba);
+	target_cmd_debug(ec_cmd, "%s: Starting src_lba: %llu, dst_lba: %llu\n", __func__,
+			 (unsigned long long)src_lba, (unsigned long long)dst_lba);
 
 	while (nolb) {
 		u32 cur_bytes = min_t(u64, max_bytes, nolb * src_dev->dev_attrib.block_size);
@@ -716,19 +720,19 @@ static void target_xcopy_do_work(struct work_struct *work)
 			xop->xop_data_bytes = cur_bytes;
 		}
 
-		target_debug("%s: Calling read src_dev: %p src_lba: %llu, cur_nolb: %hu\n",
-			     __func__, src_dev, (unsigned long long)src_lba, cur_nolb);
+		target_cmd_debug(ec_cmd, "%s: Calling read src_dev: %p src_lba: %llu, cur_nolb: %hu\n",
+				 __func__, src_dev, (unsigned long long)src_lba, cur_nolb);
 
 		rc = target_xcopy_read_source(ec_cmd, xop, src_dev, src_lba, cur_bytes);
 		if (rc < 0)
 			goto out;
 
 		src_lba += cur_bytes / src_dev->dev_attrib.block_size;
-		target_debug("%s: Incremented READ src_lba to %llu\n", __func__,
-			     (unsigned long long)src_lba);
+		target_cmd_debug(ec_cmd, "%s: Incremented READ src_lba to %llu\n", __func__,
+				 (unsigned long long)src_lba);
 
-		target_debug("%s: Calling write dst_dev: %p dst_lba: %llu, cur_nolb: %u\n",
-			     __func__, dst_dev, (unsigned long long)dst_lba, cur_nolb);
+		target_cmd_debug(ec_cmd, "%s: Calling write dst_dev: %p dst_lba: %llu, cur_nolb: %u\n",
+				 __func__, dst_dev, (unsigned long long)dst_lba, cur_nolb);
 
 		rc = target_xcopy_write_destination(ec_cmd, xop, dst_dev,
 						dst_lba, cur_bytes);
@@ -736,8 +740,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 			goto out;
 
 		dst_lba += cur_bytes / dst_dev->dev_attrib.block_size;
-		target_debug("%s: Incremented WRITE dst_lba to %llu\n", __func__,
-			     (unsigned long long)dst_lba);
+		target_cmd_debug(ec_cmd, "%s: Incremented WRITE dst_lba to %llu\n", __func__,
+				 (unsigned long long)dst_lba);
 
 		copied_bytes += cur_bytes;
 		nolb -= cur_bytes / src_dev->dev_attrib.block_size;
@@ -747,12 +751,12 @@ static void target_xcopy_do_work(struct work_struct *work)
 	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 	kfree(xop);
 
-	target_debug("%s: Final src_lba: %llu, dst_lba: %llu\n", __func__,
-		     (unsigned long long)src_lba, (unsigned long long)dst_lba);
-	target_debug("%s: Blocks copied: %u, Bytes Copied: %u\n", __func__,
-		     copied_bytes / dst_dev->dev_attrib.block_size, copied_bytes);
+	target_cmd_debug(ec_cmd, "%s: Final src_lba: %llu, dst_lba: %llu\n", __func__,
+			 (unsigned long long)src_lba, (unsigned long long)dst_lba);
+	target_cmd_debug(ec_cmd, "%s: Blocks copied: %u, Bytes Copied: %u\n", __func__,
+			 copied_bytes / dst_dev->dev_attrib.block_size, copied_bytes);
 
-	target_debug("%s: Setting X-COPY GOOD status -> sending response\n", __func__);
+	target_cmd_debug(ec_cmd, "%s: Setting X-COPY GOOD status -> sending response\n", __func__);
 	target_complete_cmd(ec_cmd, SAM_STAT_GOOD);
 	return;
 
@@ -768,8 +772,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 err_free:
 	kfree(xop);
-	target_warn_ratelimited("%s: rc: %d, sense: %u, XCOPY operation failed\n", __func__, rc,
-				sense_rc);
+	target_cmd_warn_ratelimited(ec_cmd, "%s: rc: %d, sense: %u, XCOPY operation failed\n",
+				    __func__, rc, sense_rc);
 	target_complete_cmd_with_sense(ec_cmd, SAM_STAT_CHECK_CONDITION, sense_rc);
 }
 
@@ -788,7 +792,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 
 	p = transport_kmap_data_sg(se_cmd);
 	if (!p) {
-		target_err("transport_kmap_data_sg() failed in target_do_xcopy\n");
+		target_cmd_err(se_cmd, "transport_kmap_data_sg() failed in target_do_xcopy\n");
 		return TCM_OUT_OF_RESOURCES;
 	}
 
@@ -801,27 +805,27 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	tdll = get_unaligned_be16(&p[2]);
 	sdll = get_unaligned_be32(&p[8]);
 	if (tdll + sdll > RCR_OP_MAX_DESC_LIST_LEN) {
-		target_err("XCOPY descriptor list length %u exceeds maximum %u\n", tdll + sdll,
-			   RCR_OP_MAX_DESC_LIST_LEN);
+		target_cmd_err(se_cmd, "Descriptor list length %u exceeds maximum %u\n",
+			       tdll + sdll, RCR_OP_MAX_DESC_LIST_LEN);
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
 	}
 
 	inline_dl = get_unaligned_be32(&p[12]);
 	if (inline_dl != 0) {
-		target_err("XCOPY with non zero inline data length\n");
+		target_cmd_err(se_cmd, "Command with non zero inline data length\n");
 		goto out;
 	}
 
 	if (se_cmd->data_length < (XCOPY_HDR_LEN + tdll + sdll + inline_dl)) {
-		target_err("XCOPY parameter truncation: data length %u too small for tdll: %u sdll: %u inline_dl: %u\n",
-			   se_cmd->data_length, tdll, sdll, inline_dl);
+		target_cmd_err(se_cmd, "Parameter truncation: data length %u too small for tdll: %u sdll: %u inline_dl: %u\n",
+			       se_cmd->data_length, tdll, sdll, inline_dl);
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
 	}
 
-	target_debug("Processing XCOPY with list_id: 0x%02x list_id_usage: 0x%02x tdll: %hu sdll: %u inline_dl: %u\n",
-		     list_id, list_id_usage, tdll, sdll, inline_dl);
+	target_cmd_debug(se_cmd, "Processing  with list_id: 0x%02x list_id_usage: 0x%02x tdll: %hu sdll: %u inline_dl: %u\n",
+			 list_id, list_id_usage, tdll, sdll, inline_dl);
 
 	/*
 	 * skip over the target descriptors until segment descriptors
@@ -833,8 +837,8 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	if (rc <= 0)
 		goto out;
 
-	target_debug("Processed %d segment descriptors, length: %u\n", rc,
-		     rc * XCOPY_SEGMENT_DESC_LEN);
+	target_cmd_debug(se_cmd, "Processed %d segment descriptors, length: %u\n", rc,
+			 rc * XCOPY_SEGMENT_DESC_LEN);
 
 	rc = target_xcopy_parse_target_descriptors(se_cmd, xop, &p[16], tdll, &ret);
 	if (rc <= 0)
@@ -842,16 +846,16 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 
 	if (xop->src_dev->dev_attrib.block_size !=
 	    xop->dst_dev->dev_attrib.block_size) {
-		target_err("Non matching src_dev block_size: %u + dst_dev block_size: %u currently unsupported\n",
-			   xop->src_dev->dev_attrib.block_size,
-			   xop->dst_dev->dev_attrib.block_size);
+		target_cmd_err(se_cmd, "Non matching src_dev block_size: %u + dst_dev block_size: %u currently unsupported\n",
+			       xop->src_dev->dev_attrib.block_size,
+			       xop->dst_dev->dev_attrib.block_size);
 		xcopy_pt_undepend_remotedev(xop);
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
 	}
 
-	target_debug("Processed %d target descriptors, length: %u\n", rc,
-		     rc * XCOPY_TARGET_DESC_LEN);
+	target_cmd_debug(se_cmd, "Processed %d target descriptors, length: %u\n", rc,
+			 rc * XCOPY_TARGET_DESC_LEN);
 	transport_kunmap_data_sg(se_cmd);
 	return TCM_NO_SENSE;
 
@@ -868,13 +872,13 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 	unsigned int sa;
 
 	if (!dev->dev_attrib.emulate_3pc) {
-		target_err("EXTENDED_COPY operation explicitly disabled\n");
+		target_cmd_err(se_cmd, "EXTENDED_COPY operation explicitly disabled\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	sa = se_cmd->t_task_cdb[1] & 0x1f;
 	if (sa != 0x00) {
-		target_err("EXTENDED_COPY(LID4) not supported\n");
+		target_cmd_err(se_cmd, "EXTENDED_COPY(LID4) not supported\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -883,8 +887,8 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		return TCM_NO_SENSE;
 	}
 	if (se_cmd->data_length < XCOPY_HDR_LEN) {
-		target_err("XCOPY parameter truncation: length %u < hdr_len %u\n",
-			   se_cmd->data_length, XCOPY_HDR_LEN);
+		target_cmd_err(se_cmd, "Parameter truncation: length %u < hdr_len %u\n",
+			       se_cmd->data_length, XCOPY_HDR_LEN);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -910,13 +914,13 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 
 	p = transport_kmap_data_sg(se_cmd);
 	if (!p) {
-		target_err("transport_kmap_data_sg failed in target_rcr_operating_parameters\n");
+		target_cmd_err(se_cmd, "transport_kmap_data_sg failed in target_rcr_operating_parameters\n");
 		return TCM_OUT_OF_RESOURCES;
 	}
 
 	if (se_cmd->data_length < 54) {
-		target_err("Receive Copy Results Op Parameters length too small: %u\n",
-			   se_cmd->data_length);
+		target_cmd_err(se_cmd, "Receive Copy Results Op Parameters length too small: %u\n",
+			       se_cmd->data_length);
 		transport_kunmap_data_sg(se_cmd);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -1001,15 +1005,15 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 	sense_reason_t rc = TCM_NO_SENSE;
 
 	if (!dev->dev_attrib.emulate_3pc) {
-		target_debug("Third-party copy operations explicitly disabled\n");
+		target_cmd_debug(se_cmd, "Third-party copy operations explicitly disabled\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
-	target_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID: 0x%02x, AL: %u\n",
-		     sa, list_id, se_cmd->data_length);
+	target_cmd_debug(se_cmd, "Entering target_do_receive_copy_results: SA: 0x%02x, List ID: 0x%02x, AL: %u\n",
+			 sa, list_id, se_cmd->data_length);
 
 	if (list_id != 0) {
-		target_err("Receive Copy Results with non zero list identifier not supported\n");
+		target_cmd_err(se_cmd, "Receive Copy Results with non zero list identifier not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -1021,7 +1025,7 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 	case RCR_SA_RECEIVE_DATA:
 	case RCR_SA_FAILED_SEGMENT_DETAILS:
 	default:
-		target_err("Unsupported SA for receive copy results: 0x%02x\n", sa);
+		target_cmd_err(se_cmd, "Unsupported SA for receive copy results: 0x%02x\n", sa);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-- 
2.40.3


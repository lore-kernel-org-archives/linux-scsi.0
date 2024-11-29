Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638F11487F4;
	Fri, 29 Nov 2024 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894357; cv=none; b=mB8jzVmud9D0kJnQL61w86Wpk7ijWJLxngvLSQyTGQ8jrDy4bDDDVN6OJZ/p9SQaTe6G00NZyxR+ZiGMz3Fvd09VQYG+mTtAit/9tR30t2egTX/xXMHjqEKIqlvtUBc4AeB3+p+H+wvEIMk0Xqt2owrASmxQ+PV++WdmN8zTTYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894357; c=relaxed/simple;
	bh=uzxJ4WLgfIDfPnSKUtTe3uaPkl34guppoB24Ew7q5+Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQpbKTGSd0Xyxr6z7DBRGo4MtD0jiI2uwlbPUYxsIvW+lZEzx1pxYF8Md/CdG+oBa+x/WQmymZr79YXf/x7atiMaA+7Q79w5/1lmSaZdt+2+8DO/1/5tRkPnHdsQ+uCz9p1VH3O37jHWGqCUFO/UQFBIlcyd3SYGT12pzrB77/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=qFNo3R/M; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=VUISaw+L; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="qFNo3R/M";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="VUISaw+L"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com D1E5BE0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894347; bh=V1JrxeiMVxj6t0d1JUBWEmInSWAJd9sjjc1q01/10LE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=qFNo3R/MH16jAuHvZNxzPFytEK1R80m/dK700rNwWIde6L3yO0+ElCo+9RENPlbHI
	 b3qetYj9lZH+u/tBS99hLj6rQVsIgjo82+AjMZhoTGt/wTOOIrrxKCi9x1Fyg95nMd
	 y0IvMPw4CZM9r58oUgQpj7fP4OXFO76Rwy4ceh2bgjQcx2N7+u0h/AJTSi2Nlms6Tv
	 bA10XPGG51XUoOsD5WYYRjDrzww2/xFUKeV22u+1yCg8mwXmwXZjDpIRz378piN+33
	 N66FFtBmL3QFkI0Nzs33Ly7j5OJ8n5wTraN8j3g0UTEuG4umHAHJ0nGh2dRTVN80Mr
	 WSAF9QvgvpLyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894347; bh=V1JrxeiMVxj6t0d1JUBWEmInSWAJd9sjjc1q01/10LE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=VUISaw+LvCg0jkDi+vo9x8fDwMtek06LoCg73JJiJxRrNmR37ntER4zcVAGy9JvdM
	 kF6r4UWDp6N+ut2RmMx1bb1AnJfzZKPfORbqQ2dVkH9YkCPeYlI3W3JiP6iC50GmmM
	 mN6wIGeCIGIWLRrHYm0VJfRnqQWsezQ3d79tUMFbPZIw6NNcw/aNhd0QJoGY/MpSb0
	 7br/qlarffJfYvZCUK3QOnBO03Nf47pc0K3bBJsEb76//PuVzLnb/RR9vkolVt3cHr
	 yfl8hTfD6AIpBosnFvAwus5Jo40pdAUCxrOd7/9Gdxpy1B7McuXCOxESCYQpZaE6el
	 Ta8JuJjH9WVbA==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 06/10] target: Remove old prefixes from log messages
Date: Fri, 29 Nov 2024 18:30:52 +0300
Message-ID: <20241129153056.6985-7-a.kovaleva@yadro.com>
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
X-ClientProxiedBy: T-EXCH-08.corp.yadro.com (172.17.11.58) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

If TARGET_PREFIX macro doesn't contain some information that the old
prefix had (like in tcm_remote.c, tcm_loop.c, target_core_alua.c etc.),
then remove the repeated prefix parts and unify prefix format:

sed -i 's/TCM_(Loop|Remote)_ConfigFS/configfs/g' drivers/target/**/*.c
sed -i 's/Target_Core_ConfigFS/configfs/g' drivers/target/target_core_alua.c
sed -i 's/CORE\[0\] -/\[0\]:/g' drivers/target/iscsi/iscsi_target.c drivers/target/iscsi/iscsi_target_tpg.c
sed -i 's/LIO-CORE\[0\]/\[0\]:/g' drivers/target/iscsi/iscsi_target_configfs.c
sed -i -E 's/(target_.*[(]\").*(\[.*\]_)TPG(\[.*\]) -/\1\2tpg\3:/g' drivers/target/iscsi/iscsi_target_tpg.c
sed -i -E 's/(target_.*[(]\").*iSCSI_TPG(\[.*\]) -/\1tpg\2:/g' drivers/target/iscsi/iscsi_target_tpg.c
sed -i -E 's/(target_.*[(]\")CORE(\[.*\]) -/\1\2:/g' drivers/target/iscsi/iscsi_target_tpg.c

If new prefixes fully cover old prefixes' information, then remove the
old prefixes:

........................................................................
dir="/home/a.kovaleva/work/scsi/drivers/target"
old_prefix=("FILEIO: " "IBLOCK: " "PSCSI: " "pSCSI: " "RAMDISK: " \
	    "TCM: " "TCMU: " "tcmu: " "XCOPY: " \
	    "Target_Core_ConfigFS: " "LIO_Target_ConfigFS: " \
	    "tcm_fc: ")

for file in $dir/**/*.{c,h}; do
    for prfx in ${old_prefix[@]}; do
        sed -i -E "s/(target_.*[(]\")$prfx/\1/g" $file
    done
done
........................................................................

You may not check it manually.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c          |  8 +--
 drivers/target/iscsi/iscsi_target_configfs.c | 29 +++++-----
 drivers/target/iscsi/iscsi_target_tpg.c      | 36 ++++++------
 drivers/target/loopback/tcm_loop.c           |  4 +-
 drivers/target/target_core_alua.c            |  4 +-
 drivers/target/target_core_configfs.c        | 59 ++++++++------------
 drivers/target/target_core_file.c            | 26 ++++-----
 drivers/target/target_core_hba.c             |  3 +-
 drivers/target/target_core_iblock.c          | 12 ++--
 drivers/target/target_core_pscsi.c           | 37 ++++++------
 drivers/target/target_core_rd.c              |  7 +--
 drivers/target/target_core_user.c            | 12 ++--
 drivers/target/target_core_xcopy.c           | 15 +++--
 drivers/target/tcm_fc/tfc_conf.c             |  2 +-
 drivers/target/tcm_remote/tcm_remote.c       | 12 ++--
 15 files changed, 124 insertions(+), 142 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c67ac066a7c9..7d157d3f84a8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -154,7 +154,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	spin_unlock(&tiqn_lock);
 	idr_preload_end();
 
-	target_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
+	target_debug("[0]: Added iSCSI Target IQN: %s\n", tiqn->tiqn);
 
 	return tiqn;
 
@@ -194,7 +194,7 @@ void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
 	idr_remove(&tiqn_idr, tiqn->tiqn_index);
 	spin_unlock(&tiqn_lock);
 
-	target_debug("CORE[0] - Deleted iSCSI Target IQN: %s\n", tiqn->tiqn);
+	target_debug("[0]: Deleted iSCSI Target IQN: %s\n", tiqn->tiqn);
 	kfree(tiqn);
 }
 
@@ -392,7 +392,7 @@ struct iscsi_np *iscsit_add_np(
 	list_add_tail(&np->np_list, &g_np_list);
 	mutex_unlock(&np_lock);
 
-	target_debug("CORE[0] - Added Network Portal: %pISpc on %s\n", &np->np_sockaddr,
+	target_debug("[0]: Added Network Portal: %pISpc on %s\n", &np->np_sockaddr,
 		     np->np_transport->name);
 
 	return np;
@@ -463,7 +463,7 @@ int iscsit_del_np(struct iscsi_np *np)
 	list_del(&np->np_list);
 	mutex_unlock(&np_lock);
 
-	target_debug("CORE[0] - Removed Network Portal: %pISpc on %s\n", &np->np_sockaddr,
+	target_debug("[0]: Removed Network Portal: %pISpc on %s\n", &np->np_sockaddr,
 		     np->np_transport->name);
 
 	iscsit_put_transport(np->np_transport);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 7082a7ef0a00..14c95c38d002 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -212,7 +212,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	if (ret < 0)
 		return ERR_PTR(-EINVAL);
 
-	target_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %u PORTAL: %s\n",
+	target_debug("REGISTER -> %s TPGT: %u PORTAL: %s\n",
 		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt, name);
 	/*
 	 * Assume ISCSI_TCP by default.  Other network portals for other
@@ -233,7 +233,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		iscsit_put_tpg(tpg);
 		return ERR_CAST(tpg_np);
 	}
-	target_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
+	target_debug("addnptotpg done!\n");
 
 	iscsit_put_tpg(tpg);
 	return &tpg_np->se_tpg_np;
@@ -254,7 +254,7 @@ static void lio_target_call_delnpfromtpg(
 		return;
 
 	se_tpg = &tpg->tpg_se_tpg;
-	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %u PORTAL: %pISpc\n",
+	target_debug("DEREGISTER -> %s TPGT: %u PORTAL: %pISpc\n",
 		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt,
 		     &tpg_np->tpg_np->np_sockaddr);
 
@@ -262,7 +262,7 @@ static void lio_target_call_delnpfromtpg(
 	if (ret < 0)
 		goto out;
 
-	target_debug("LIO_Target_ConfigFS: delnpfromtpg done!\n");
+	target_debug("delnpfromtpg done!\n");
 out:
 	iscsit_put_tpg(tpg);
 }
@@ -678,9 +678,8 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 
 	ret = core_tpg_set_initiator_node_queue_depth(se_nacl, cmdsn_depth);
 
-	target_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for InitiatorName: %s\n",
-		     config_item_name(wwn_ci), config_item_name(tpg_ci), cmdsn_depth,
-		     config_item_name(acl_ci));
+	target_debug("%s/%s Set CmdSN Window: %u for InitiatorName: %s\n", config_item_name(wwn_ci),
+		     config_item_name(tpg_ci), cmdsn_depth, config_item_name(acl_ci));
 
 	iscsit_put_tpg(tpg);
 	return (!ret) ? count : (ssize_t)ret;
@@ -1066,8 +1065,8 @@ static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
 	if (ret != 0)
 		goto out;
 
-	target_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	target_debug("LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\n", name);
+	target_debug("REGISTER -> %s\n", tiqn->tiqn);
+	target_debug("REGISTER -> Allocated TPG: %s\n", name);
 	return &tpg->tpg_se_tpg;
 out:
 	core_tpg_deregister(&tpg->tpg_se_tpg);
@@ -1116,7 +1115,7 @@ static void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
 	/*
 	 * iscsit_tpg_del_portal_group() assumes force=1
 	 */
-	target_debug("LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n");
+	target_debug("DEREGISTER -> Releasing TPG\n");
 	iscsit_tpg_del_portal_group(tiqn, tpg, 1);
 }
 
@@ -1184,8 +1183,8 @@ static struct se_wwn *lio_target_call_coreaddtiqn(
 	if (IS_ERR(tiqn))
 		return ERR_CAST(tiqn);
 
-	target_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	target_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node: %s\n", name);
+	target_debug("REGISTER -> %s\n", tiqn->tiqn);
+	target_debug("REGISTER -> Allocated Node: %s\n", name);
 	return &tiqn->tiqn_wwn;
 }
 
@@ -1224,7 +1223,7 @@ static void lio_target_call_coredeltiqn(
 {
 	struct iscsi_tiqn *tiqn = container_of(wwn, struct iscsi_tiqn, tiqn_wwn);
 
-	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s\n", tiqn->tiqn);
+	target_debug("DEREGISTER -> %s\n", tiqn->tiqn);
 	iscsit_del_tiqn(tiqn);
 }
 
@@ -1308,7 +1307,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 		discovery_tpg->tpg_attrib.authentication = 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
-		target_debug("LIO-CORE[0] Successfully enabled authentication enforcement for iSCSI Discovery TPG\n");
+		target_debug("[0]: Successfully enabled authentication enforcement for iSCSI Discovery TPG\n");
 	} else {
 		/*
 		 * Reset the AuthMethod key to CHAP,None
@@ -1318,7 +1317,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 		discovery_tpg->tpg_attrib.authentication = 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
-		target_debug("LIO-CORE[0] Successfully disabled authentication enforcement for iSCSI Discovery TPG\n");
+		target_debug("[0]: Successfully disabled authentication enforcement for iSCSI Discovery TPG\n");
 	}
 
 	return count;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index c18f368976ac..2067c6facb09 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -96,7 +96,7 @@ int iscsit_load_discovery_tpg(void)
 	spin_unlock(&tpg->tpg_state_lock);
 
 	iscsit_global->discovery_tpg = tpg;
-	target_debug("CORE[0] - Allocated Discovery TPG\n");
+	target_debug("[0]: Allocated Discovery TPG\n");
 
 	return 0;
 free_pl_out:
@@ -247,7 +247,7 @@ int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_gro
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	list_add_tail(&tpg->tpg_list, &tiqn->tiqn_tpg_list);
 	tiqn->tiqn_ntpgs++;
-	target_debug("CORE[%s]_TPG[%u] - Added iSCSI Target Portal Group\n", tiqn->tiqn, tpg->tpgt);
+	target_debug("[%s]_tpg[%u]: Added iSCSI Target Portal Group\n", tiqn->tiqn, tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -293,7 +293,7 @@ int iscsit_tpg_del_portal_group(
 	list_del(&tpg->tpg_list);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
-	target_debug("CORE[%s]_TPG[%u] - Deleted iSCSI Target Portal Group\n", tiqn->tiqn,
+	target_debug("[%s]_tpg[%u]: Deleted iSCSI Target Portal Group\n", tiqn->tiqn,
 		     tpg->tpgt);
 
 	kfree(tpg);
@@ -338,7 +338,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs++;
-	target_debug("iSCSI_TPG[%u] - Enabled iSCSI Target Portal Group\n", tpg->tpgt);
+	target_debug("tpg[%u]: Enabled iSCSI Target Portal Group\n", tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -379,7 +379,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs--;
-	target_debug("iSCSI_TPG[%u] - Disabled iSCSI Target Portal Group\n", tpg->tpgt);
+	target_debug("tpg[%u]: Disabled iSCSI Target Portal Group\n", tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -501,7 +501,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 		spin_unlock(&tpg_np_parent->tpg_np_parent_lock);
 	}
 
-	target_debug("CORE[%s] - Added Network Portal: %pISpc,%hu on %s\n", tpg->tpg_tiqn->tiqn,
+	target_debug("[%s]: Added Network Portal: %pISpc,%hu on %s\n", tpg->tpg_tiqn->tiqn,
 		     &np->np_sockaddr, tpg->tpgt, np->np_transport->name);
 
 	return tpg_np;
@@ -514,7 +514,7 @@ static int iscsit_tpg_release_np(
 {
 	iscsit_clear_tpg_np_login_thread(tpg_np, tpg, true);
 
-	target_debug("CORE[%s] - Removed Network Portal: %pISpc,%u on %s\n", tpg->tpg_tiqn->tiqn,
+	target_debug("[%s]: Removed Network Portal: %pISpc,%u on %s\n", tpg->tpg_tiqn->tiqn,
 		     &np->np_sockaddr, tpg->tpgt, np->np_transport->name);
 
 	tpg_np->tpg_np = NULL;
@@ -668,7 +668,7 @@ int iscsit_ta_generate_node_acls(
 	}
 
 	a->generate_node_acls = flag;
-	target_debug("iSCSI_TPG[%u] - Generate Initiator Portal Group ACLs: %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: Generate Initiator Portal Group ACLs: %s\n", tpg->tpgt,
 		     (a->generate_node_acls) ? "Enabled" : "Disabled");
 
 	if (flag == 1 && a->cache_dynamic_acls == 0) {
@@ -696,7 +696,7 @@ int iscsit_ta_default_cmdsn_depth(
 	}
 
 	a->default_cmdsn_depth = tcq_depth;
-	target_debug("iSCSI_TPG[%u] - Set Default CmdSN TCQ Depth to %u\n", tpg->tpgt,
+	target_debug("tpg[%u]: Set Default CmdSN TCQ Depth to %u\n", tpg->tpgt,
 		     a->default_cmdsn_depth);
 
 	return 0;
@@ -719,7 +719,7 @@ int iscsit_ta_cache_dynamic_acls(
 	}
 
 	a->cache_dynamic_acls = flag;
-	target_debug("iSCSI_TPG[%u] - Cache Dynamic Initiator Portal Group ACLs %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: Cache Dynamic Initiator Portal Group ACLs %s\n", tpg->tpgt,
 		     (a->cache_dynamic_acls) ? "Enabled" : "Disabled");
 
 	return 0;
@@ -737,7 +737,7 @@ int iscsit_ta_demo_mode_write_protect(
 	}
 
 	a->demo_mode_write_protect = flag;
-	target_debug("iSCSI_TPG[%u] - Demo Mode Write Protect bit: %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: Demo Mode Write Protect bit: %s\n", tpg->tpgt,
 		     (a->demo_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
@@ -755,7 +755,7 @@ int iscsit_ta_prod_mode_write_protect(
 	}
 
 	a->prod_mode_write_protect = flag;
-	target_debug("iSCSI_TPG[%u] - Production Mode Write Protect bit: %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: Production Mode Write Protect bit: %s\n", tpg->tpgt,
 		     (a->prod_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
@@ -773,7 +773,7 @@ int iscsit_ta_demo_mode_discovery(
 	}
 
 	a->demo_mode_discovery = flag;
-	target_debug("iSCSI_TPG[%u] - Demo Mode Discovery bit: %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: Demo Mode Discovery bit: %s\n", tpg->tpgt,
 		     (a->demo_mode_discovery) ? "ON" : "OFF");
 
 	return 0;
@@ -791,7 +791,7 @@ int iscsit_ta_default_erl(
 	}
 
 	a->default_erl = default_erl;
-	target_debug("iSCSI_TPG[%u] - DefaultERL: %u\n", tpg->tpgt, a->default_erl);
+	target_debug("tpg[%u]: DefaultERL: %u\n", tpg->tpgt, a->default_erl);
 
 	return 0;
 }
@@ -808,7 +808,7 @@ int iscsit_ta_t10_pi(
 	}
 
 	a->t10_pi = flag;
-	target_debug("iSCSI_TPG[%u] - T10 Protection information bit: %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: T10 Protection information bit: %s\n", tpg->tpgt,
 		     (a->t10_pi) ? "ON" : "OFF");
 
 	return 0;
@@ -826,7 +826,7 @@ int iscsit_ta_fabric_prot_type(
 	}
 
 	a->fabric_prot_type = prot_type;
-	target_debug("iSCSI_TPG[%u] - T10 Fabric Protection Type: %u\n", tpg->tpgt, prot_type);
+	target_debug("tpg[%u]: T10 Fabric Protection Type: %u\n", tpg->tpgt, prot_type);
 
 	return 0;
 }
@@ -843,7 +843,7 @@ int iscsit_ta_tpg_enabled_sendtargets(
 	}
 
 	a->tpg_enabled_sendtargets = flag;
-	target_debug("iSCSI_TPG[%u] - TPG enabled bit required for SendTargets: %s\n", tpg->tpgt,
+	target_debug("tpg[%u]: TPG enabled bit required for SendTargets: %s\n", tpg->tpgt,
 		     (a->tpg_enabled_sendtargets) ? "ON" : "OFF");
 
 	return 0;
@@ -861,7 +861,7 @@ int iscsit_ta_login_keys_workaround(
 	}
 
 	a->login_keys_workaround = flag;
-	target_debug("iSCSI_TPG[%u] - TPG enabled bit for login keys workaround: %s ", tpg->tpgt,
+	target_debug("tpg[%u]: TPG enabled bit for login keys workaround: %s ", tpg->tpgt,
 		     (a->login_keys_workaround) ? "ON" : "OFF");
 
 	return 0;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6d0e7be756d7..7b4c3b1ae16d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -592,7 +592,7 @@ static int tcm_loop_port_link(
 	 */
 	scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
 
-	target_debug("TCM_Loop_ConfigFS: Port Link Successful\n");
+	target_debug("configfs: Port Link Successful\n");
 	return 0;
 }
 
@@ -622,7 +622,7 @@ static void tcm_loop_port_unlink(
 
 	atomic_dec_mb(&tl_tpg->tl_tpg_port_count);
 
-	target_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
+	target_debug("configfs: Port Unlink Successful\n");
 }
 
 /* End items for tcm_loop_port_cit */
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 00900189a00d..fd91a2a3b120 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1928,7 +1928,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * with the default_tg_pt_gp.
 		 */
 		if (!tg_pt_gp_new) {
-			target_debug("Target_Core_ConfigFS: Moving %s/tpgt_%u/%s from ALUA Target Port Group: alua/%s, ID: %u back to default_tg_pt_gp\n",
+			target_debug("configfs: Moving %s/tpgt_%u/%s from ALUA Target Port Group: alua/%s, ID: %u back to default_tg_pt_gp\n",
 				     tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 				     tpg->se_tpg_tfo->tpg_get_tag(tpg),
 				     config_item_name(&lun->lun_group.cg_item),
@@ -1946,7 +1946,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 	target_swap_tg_pt_gp(lun, tg_pt_gp, tg_pt_gp_new);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	target_debug("Target_Core_ConfigFS: %s %s/tpgt_%u/%s to ALUA Target Port Group: alua/%s, ID: %u\n",
+	target_debug("configfs: %s %s/tpgt_%u/%s to ALUA Target Port Group: alua/%s, ID: %u\n",
 		     (move) ? "Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 		     tpg->se_tpg_tfo->tpg_get_tag(tpg), config_item_name(&lun->lun_group.cg_item),
 		     config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index aaef72e44b7b..ea958b9a21b8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -146,7 +146,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	filp_close(fp, NULL);
 
 	strncpy(db_root, db_root_stage, read_bytes);
-	target_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+	target_debug("db_root set to %s\n", db_root);
 
 	r = read_bytes;
 
@@ -192,7 +192,7 @@ static struct config_group *target_core_register_fabric(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	target_debug("Target_Core_ConfigFS: REGISTER -> group: %p name: %s\n", group, name);
+	target_debug("REGISTER -> group: %p name: %s\n", group, name);
 
 	tf = target_core_get_fabric(name);
 	if (!tf) {
@@ -243,13 +243,12 @@ static struct config_group *target_core_register_fabric(
 		target_debug("target_core_get_fabric() failed for %s\n", name);
 		return ERR_PTR(-EINVAL);
 	}
-	target_debug("Target_Core_ConfigFS: REGISTER -> Located fabric: %s\n",
-		     tf->tf_ops->fabric_name);
+	target_debug("REGISTER -> Located fabric: %s\n", tf->tf_ops->fabric_name);
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
 	 */
-	target_debug("Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n", &tf->tf_wwn_cit);
+	target_debug("REGISTER tfc_wwn_cit -> %p\n", &tf->tf_wwn_cit);
 
 	config_group_init_type_name(&tf->tf_group, name, &tf->tf_wwn_cit);
 
@@ -257,8 +256,7 @@ static struct config_group *target_core_register_fabric(
 			&tf->tf_discovery_cit);
 	configfs_add_default_group(&tf->tf_disc_group, &tf->tf_group);
 
-	target_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
-		     config_item_name(&tf->tf_group.cg_item));
+	target_debug("REGISTER -> Allocated Fabric: %s\n", config_item_name(&tf->tf_group.cg_item));
 	return &tf->tf_group;
 }
 
@@ -272,15 +270,12 @@ static void target_core_deregister_fabric(
 	struct target_fabric_configfs *tf = container_of(
 		to_config_group(item), struct target_fabric_configfs, tf_group);
 
-	target_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in tf list\n",
-		     config_item_name(item));
+	target_debug("DEREGISTER -> Looking up %s in tf list\n", config_item_name(item));
 
-	target_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric: %s\n",
-		     tf->tf_ops->fabric_name);
+	target_debug("DEREGISTER -> located fabric: %s\n", tf->tf_ops->fabric_name);
 	atomic_dec(&tf->tf_access_cnt);
 
-	target_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci %s\n",
-		     config_item_name(item));
+	target_debug("DEREGISTER -> Releasing ci %s\n", config_item_name(item));
 
 	configfs_remove_default_groups(&tf->tf_group);
 	config_item_put(item);
@@ -1437,8 +1432,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
 	strscpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor));
 
-	target_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification: %s\n",
-		     dev->t10_wwn.vendor);
+	target_debug("Set emulated T10 Vendor Identification: %s\n", dev->t10_wwn.vendor);
 
 	return count;
 }
@@ -1492,8 +1486,7 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
 	strscpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model));
 
-	target_debug("Target_Core_ConfigFS: Set emulated T10 Model Identification: %s\n",
-		     dev->t10_wwn.model);
+	target_debug("Set emulated T10 Model Identification: %s\n", dev->t10_wwn.model);
 
 	return count;
 }
@@ -1547,8 +1540,7 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
 	strscpy(dev->t10_wwn.revision, stripped, sizeof(dev->t10_wwn.revision));
 
-	target_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
-		     dev->t10_wwn.revision);
+	target_debug("Set emulated T10 Revision: %s\n", dev->t10_wwn.revision);
 
 	return count;
 }
@@ -1594,7 +1586,7 @@ target_wwn_company_id_store(struct config_item *item,
 
 	t10_wwn->company_id = val;
 
-	target_debug("Target_Core_ConfigFS: Set IEEE Company ID: %#08x\n", t10_wwn->company_id);
+	target_debug("Set IEEE Company ID: %#08x\n", t10_wwn->company_id);
 
 	return count;
 }
@@ -1659,8 +1651,7 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 			"%s", strstrip(buf));
 	dev->dev_flags |= DF_EMULATED_VPD_UNIT_SERIAL;
 
-	target_debug("Target_Core_ConfigFS: Set emulated VPD Unit Serial: %s\n",
-		     dev->t10_wwn.unit_serial);
+	target_debug("Set emulated VPD Unit Serial: %s\n", dev->t10_wwn.unit_serial);
 
 	return count;
 }
@@ -2286,8 +2277,7 @@ static ssize_t target_dev_alias_store(struct config_item *item,
 
 	dev->dev_flags |= DF_USING_ALIAS;
 
-	target_debug("Target_Core_ConfigFS: %s/%s set alias: %s\n",
-		     config_item_name(&hba->hba_group.cg_item),
+	target_debug("%s/%s set alias: %s\n", config_item_name(&hba->hba_group.cg_item),
 		     config_item_name(&dev->dev_group.cg_item), dev->dev_alias);
 
 	return read_bytes;
@@ -2325,8 +2315,7 @@ static ssize_t target_dev_udev_path_store(struct config_item *item,
 
 	dev->dev_flags |= DF_USING_UDEV_PATH;
 
-	target_debug("Target_Core_ConfigFS: %s/%s set udev_path: %s\n",
-		     config_item_name(&hba->hba_group.cg_item),
+	target_debug("%s/%s set udev_path: %s\n", config_item_name(&hba->hba_group.cg_item),
 		     config_item_name(&dev->dev_group.cg_item), dev->udev_path);
 
 	return read_bytes;
@@ -2424,7 +2413,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		 * with NULL
 		 */
 		if (!lu_gp_new) {
-			target_debug("Target_Core_ConfigFS: Releasing %s/%s from ALUA LU Group: core/alua/lu_gps/%s, ID: %u\n",
+			target_debug("Releasing %s/%s from ALUA LU Group: core/alua/lu_gps/%s, ID: %u\n",
 				     config_item_name(&hba->hba_group.cg_item),
 				     config_item_name(&dev->dev_group.cg_item),
 				     config_item_name(&lu_gp->lu_gp_group.cg_item),
@@ -2447,7 +2436,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
 	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-	target_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group: core/alua/lu_gps/%s, ID: %u\n",
+	target_debug("%s %s/%s to ALUA LU Group: core/alua/lu_gps/%s, ID: %u\n",
 		     (move) ? "Moving" : "Adding", config_item_name(&hba->hba_group.cg_item),
 		     config_item_name(&dev->dev_group.cg_item),
 		     config_item_name(&lu_gp_new->lu_gp_group.cg_item), lu_gp_new->lu_gp_id);
@@ -2693,7 +2682,7 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	target_debug("Target_Core_ConfigFS: Set ALUA Logical Unit Group: core/alua/lu_gps/%s to ID: %u\n",
+	target_debug("Set ALUA Logical Unit Group: core/alua/lu_gps/%s to ID: %u\n",
 		     config_item_name(&alua_lu_gp_cg->cg_item), lu_gp->lu_gp_id);
 
 	return count;
@@ -2779,7 +2768,7 @@ static struct config_group *target_core_alua_create_lu_gp(
 	config_group_init_type_name(alua_lu_gp_cg, name,
 			&target_core_alua_lu_gp_cit);
 
-	target_debug("Target_Core_ConfigFS: Allocated ALUA Logical Unit Group: core/alua/lu_gps/%s\n",
+	target_debug("Allocated ALUA Logical Unit Group: core/alua/lu_gps/%s\n",
 		     config_item_name(alua_lu_gp_ci));
 
 	return alua_lu_gp_cg;
@@ -2793,7 +2782,7 @@ static void target_core_alua_drop_lu_gp(
 	struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
 			struct t10_alua_lu_gp, lu_gp_group);
 
-	target_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit Group: core/alua/lu_gps/%s, ID: %u\n",
+	target_debug("Releasing ALUA Logical Unit Group: core/alua/lu_gps/%s, ID: %u\n",
 		     config_item_name(item), lu_gp->lu_gp_id);
 	/*
 	 * core_alua_free_lu_gp() is called from target_core_alua_lu_gp_ops->release()
@@ -3079,7 +3068,7 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	target_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: core/alua/tg_pt_gps/%s to ID: %u\n",
+	target_debug("Set ALUA Target Port Group: core/alua/tg_pt_gps/%s to ID: %u\n",
 		     config_item_name(&alua_tg_pt_gp_cg->cg_item), tg_pt_gp->tg_pt_gp_id);
 
 	return count;
@@ -3198,7 +3187,7 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 	config_group_init_type_name(alua_tg_pt_gp_cg, name,
 			&target_core_alua_tg_pt_gp_cit);
 
-	target_debug("Target_Core_ConfigFS: Allocated ALUA Target Port Group: alua/tg_pt_gps/%s\n",
+	target_debug("Allocated ALUA Target Port Group: alua/tg_pt_gps/%s\n",
 		     config_item_name(alua_tg_pt_gp_ci));
 
 	return alua_tg_pt_gp_cg;
@@ -3211,7 +3200,7 @@ static void target_core_alua_drop_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(to_config_group(item),
 			struct t10_alua_tg_pt_gp, tg_pt_gp_group);
 
-	target_debug("Target_Core_ConfigFS: Releasing ALUA Target Port Group: alua/tg_pt_gps/%s, ID: %u\n",
+	target_debug("Releasing ALUA Target Port Group: alua/tg_pt_gps/%s, ID: %u\n",
 		     config_item_name(item), tg_pt_gp->tg_pt_gp_id);
 	/*
 	 * core_alua_free_tg_pt_gp() is called from target_core_alua_tg_pt_gp_ops->release()
@@ -3589,7 +3578,7 @@ static void target_init_dbroot(void)
 	filp_close(fp, NULL);
 
 	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
-	target_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+	target_debug("db_root set to %s\n", db_root);
 }
 
 static int __init target_core_init_configfs(void)
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index fd3719cac493..503b53767b8b 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -82,7 +82,7 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 
 	fd_dev->fd_host = fd_host;
 
-	target_debug("FILEIO: Allocated fd_dev for %p\n", name);
+	target_debug("Allocated fd_dev for %p\n", name);
 
 	return &fd_dev->dev;
 }
@@ -134,7 +134,7 @@ static int fd_configure_device(struct se_device *dev)
 	 * to write-out the entire device cache.
 	 */
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
-		target_debug("FILEIO: Disabling O_DSYNC, using buffered FILEIO\n");
+		target_debug("Disabling O_DSYNC, using buffered FILEIO\n");
 		flags &= ~O_DSYNC;
 	}
 
@@ -164,7 +164,7 @@ static int fd_configure_device(struct se_device *dev)
 		dev_size = (i_size_read(file->f_mapping->host) -
 				       fd_dev->fd_block_size);
 
-		target_debug("FILEIO: Using size: %llu bytes from struct block_device blocks: %llu logical_block_size: %d\n",
+		target_debug("Using size: %llu bytes from struct block_device blocks: %llu logical_block_size: %d\n",
 			     dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			     fd_dev->fd_block_size);
 		/*
@@ -177,7 +177,7 @@ static int fd_configure_device(struct se_device *dev)
 			dev->dev_attrib.is_nonrot = 1;
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
-			target_err("FILEIO: Missing fd_dev_size= parameter, and no backing struct block_device\n");
+			target_err("Missing fd_dev_size= parameter, and no backing struct block_device\n");
 			goto fail;
 		}
 
@@ -195,7 +195,7 @@ static int fd_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
-		target_debug("FILEIO: Forcing setting of emulate_write_cache=1 with FDBD_HAS_BUFFERED_IO_WCE\n");
+		target_debug("Forcing setting of emulate_write_cache=1 with FDBD_HAS_BUFFERED_IO_WCE\n");
 		dev->dev_attrib.emulate_write_cache = 1;
 	}
 
@@ -406,7 +406,7 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 
 	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 	if (ret != 0)
-		target_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
+		target_err("vfs_fsync_range() failed: %d\n", ret);
 
 	if (immed)
 		return 0;
@@ -548,7 +548,7 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 					   target_to_linux_sector(dev,  nolb),
 					   GFP_KERNEL);
 		if (ret < 0) {
-			target_warn("FILEIO: blkdev_issue_discard() failed: %d\n", ret);
+			target_warn("blkdev_issue_discard() failed: %d\n", ret);
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	} else {
@@ -563,7 +563,7 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 		ret = file->f_op->fallocate(file, mode, pos, len);
 		if (ret < 0) {
-			target_warn("FILEIO: fallocate() failed: %d\n", ret);
+			target_warn("fallocate() failed: %d\n", ret);
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	}
@@ -667,7 +667,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * single vfs_[writev,readv] call.
 	 */
 	if (cmd->data_length > FD_MAX_BYTES) {
-		target_err("FILEIO: Not able to process I/O of %u bytes due to FD_MAX_BYTES: %u iovec count limitation\n",
+		target_err("Not able to process I/O of %u bytes due to FD_MAX_BYTES: %u iovec count limitation\n",
 			   cmd->data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
@@ -716,7 +716,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			target_debug("FILEIO: Referencing Path: %s\n", fd_dev->fd_dev_name);
+			target_debug("Referencing Path: %s\n", fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
 			break;
 		case Opt_fd_dev_size:
@@ -731,7 +731,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				target_err("kstrtoull() failed for fd_dev_size=\n");
 				goto out;
 			}
-			target_debug("FILEIO: Referencing Size: %llu bytes\n", fd_dev->fd_dev_size);
+			target_debug("Referencing Size: %llu bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
 		case Opt_fd_buffered_io:
@@ -744,7 +744,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				goto out;
 			}
 
-			target_debug("FILEIO: Using buffered I/O operations for struct fd_dev\n");
+			target_debug("Using buffered I/O operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_HAS_BUFFERED_IO_WCE;
 			break;
@@ -758,7 +758,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				goto out;
 			}
 
-			target_debug("FILEIO: Using async I/O operations for struct fd_dev\n");
+			target_debug("Using async I/O operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_HAS_ASYNC_IO;
 			break;
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 48dab83e5be3..31a426fcb3d4 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -59,8 +59,7 @@ int transport_backend_register(const struct target_backend_ops *ops)
 	list_add_tail(&tb->list, &backend_list);
 	mutex_unlock(&backend_mutex);
 
-	target_debug("TCM: Registered subsystem plugin: %s struct module: %p\n", ops->name,
-		     ops->owner);
+	target_debug("Registered subsystem plugin: %s struct module: %p\n", ops->name, ops->owner);
 	return 0;
 }
 EXPORT_SYMBOL(transport_backend_register);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8d71a0f5033e..25cc0815e590 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -71,7 +71,7 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	if (!ib_dev->ibd_plug)
 		goto free_dev;
 
-	target_debug("IBLOCK: Allocated ib_dev for %s\n", name);
+	target_debug("Allocated ib_dev for %s\n", name);
 
 	return &ib_dev->dev;
 
@@ -106,11 +106,11 @@ static int iblock_configure_device(struct se_device *dev)
 
 	ret = bioset_init(&ib_dev->ibd_bio_set, IBLOCK_BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 	if (ret) {
-		target_err("IBLOCK: Unable to create bioset\n");
+		target_err("Unable to create bioset\n");
 		goto out;
 	}
 
-	target_debug("IBLOCK: Claiming struct block_device: %s\n", ib_dev->ibd_udev_path);
+	target_debug("Claiming struct block_device: %s\n", ib_dev->ibd_udev_path);
 
 	if (!ib_dev->ibd_readonly)
 		mode |= BLK_OPEN_WRITE;
@@ -400,7 +400,7 @@ static void iblock_end_io_flush(struct bio *bio)
 	struct se_cmd *cmd = bio->bi_private;
 
 	if (bio->bi_status)
-		target_err("IBLOCK: cache flush failed: %d\n", bio->bi_status);
+		target_err("cache flush failed: %d\n", bio->bi_status);
 
 	if (cmd) {
 		if (bio->bi_status)
@@ -612,7 +612,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			target_debug("IBLOCK: Referencing UDEV path: %s\n", ib_dev->ibd_udev_path);
+			target_debug("Referencing UDEV path: %s\n", ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
 			break;
 		case Opt_readonly:
@@ -628,7 +628,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 				goto out;
 			}
 			ib_dev->ibd_readonly = tmp_readonly;
-			target_debug("IBLOCK: readonly: %d\n", ib_dev->ibd_readonly);
+			target_debug("readonly: %d\n", ib_dev->ibd_readonly);
 			break;
 		case Opt_force:
 			break;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 24e080254c6f..51b0998b9a9e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -114,8 +114,7 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
 	if (!sh) {
-		target_err("pSCSI: Unable to locate SCSI Host for phv_host_id: %d\n",
-			   phv->phv_host_id);
+		target_err("Unable to locate SCSI Host for phv_host_id: %d\n", phv->phv_host_id);
 		return -EINVAL;
 	}
 
@@ -334,7 +333,7 @@ static struct se_device *pscsi_alloc_device(struct se_hba *hba,
 		return NULL;
 	}
 
-	target_debug("PSCSI: Allocated pdv: %p for %s\n", pdv, name);
+	target_debug("Allocated pdv: %p for %s\n", pdv, name);
 	return &pdv->dev;
 }
 
@@ -364,7 +363,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	bdev_file = bdev_file_open_by_path(dev->udev_path,
 				BLK_OPEN_WRITE | BLK_OPEN_READ, pdv, NULL);
 	if (IS_ERR(bdev_file)) {
-		target_err("pSCSI: bdev_file_open_by_path() failed\n");
+		target_err("bdev_file_open_by_path() failed\n");
 		scsi_device_put(sd);
 		return PTR_ERR(bdev_file);
 	}
@@ -435,7 +434,7 @@ static int pscsi_configure_device(struct se_device *dev)
 	 */
 	if (!sh) {
 		if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-			target_err("pSCSI: Unable to locate struct Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
+			target_err("Unable to locate struct Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
 			return -ENODEV;
 		}
 		/*
@@ -443,7 +442,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		 * reference, we enforce that udev_path has been set
 		 */
 		if (!(dev->dev_flags & DF_USING_UDEV_PATH)) {
-			target_err("pSCSI: udev_path attribute has not been set before ENABLE=1\n");
+			target_err("udev_path attribute has not been set before ENABLE=1\n");
 			return -EINVAL;
 		}
 		/*
@@ -453,7 +452,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		 */
 		if (!(pdv->pdv_flags & PDF_HAS_VIRT_HOST_ID)) {
 			if (hba->dev_count) {
-				target_err("pSCSI: Unable to set hba_mode with active devices\n");
+				target_err("Unable to set hba_mode with active devices\n");
 				return -EEXIST;
 			}
 
@@ -466,15 +465,14 @@ static int pscsi_configure_device(struct se_device *dev)
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
 			if (!sh) {
-				target_err("pSCSI: Unable to locate pdv_host_id: %d\n",
-					   pdv->pdv_host_id);
+				target_err("Unable to locate pdv_host_id: %d\n", pdv->pdv_host_id);
 				return -EINVAL;
 			}
 			pdv->pdv_lld_host = sh;
 		}
 	} else {
 		if (phv->phv_mode == PHV_VIRTUAL_HOST_ID) {
-			target_err("pSCSI: PHV_VIRTUAL_HOST_ID set while struct Scsi_Host exists\n");
+			target_err("PHV_VIRTUAL_HOST_ID set while struct Scsi_Host exists\n");
 			return -EEXIST;
 		}
 	}
@@ -514,7 +512,7 @@ static int pscsi_configure_device(struct se_device *dev)
 	}
 	spin_unlock_irq(sh->host_lock);
 
-	target_err("pSCSI: Unable to locate %d:%d:%d:%d\n", sh->host_no, pdv->pdv_channel_id,
+	target_err("Unable to locate %d:%d:%d:%d\n", sh->host_no, pdv->pdv_channel_id,
 		   pdv->pdv_target_id, pdv->pdv_lun_id);
 
 	if (phv->phv_mode == PHV_VIRTUAL_HOST_ID)
@@ -820,14 +818,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	BUG_ON(!cmd->data_length);
 
-	target_debug("PSCSI: nr_pages: %d\n", nr_pages);
+	target_debug("nr_pages: %d\n", nr_pages);
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
 
-		target_debug("PSCSI: i: %d page: %p len: %d off: %d\n", i, page, len, off);
+		target_debug("i: %d page: %p len: %d off: %d\n", i, page, len, off);
 
 		/*
 		 * We only have one page of data in each sg element,
@@ -850,24 +848,23 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					 rw ? REQ_OP_WRITE : REQ_OP_READ);
 				bio->bi_end_io = pscsi_bi_endio;
 
-				target_debug("PSCSI: Allocated bio: %p, dir: %s nr_vecs: %d\n", bio,
+				target_debug("Allocated bio: %p, dir: %s nr_vecs: %d\n", bio,
 					     (rw) ? "rw" : "r", nr_vecs);
 			}
 
-			target_debug("PSCSI: Calling bio_add_pc_page() i: %d bio: %p page: %p len: %d off: %d\n",
+			target_debug("Calling bio_add_pc_page() i: %d bio: %p page: %p len: %d off: %d\n",
 				     i, bio, page, len, off);
 
 			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
 					bio, page, bytes, off);
-			target_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n", bio_segments(bio),
-				     nr_vecs);
+			target_debug("bio->bi_vcnt: %d nr_vecs: %d\n", bio_segments(bio), nr_vecs);
 			if (rc != bytes) {
-				target_debug("PSCSI: Reached bio->bi_vcnt max: %d i: %d bio: %p, allocating another bio\n",
+				target_debug("Reached bio->bi_vcnt max: %d i: %d bio: %p, allocating another bio\n",
 					     bio->bi_vcnt, i, bio);
 
 				rc = blk_rq_append_bio(req, bio);
 				if (rc) {
-					target_err("pSCSI: failed to append bio\n");
+					target_err("failed to append bio\n");
 					goto fail;
 				}
 
@@ -881,7 +878,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (bio) {
 		rc = blk_rq_append_bio(req, bio);
 		if (rc) {
-			target_err("pSCSI: failed to append bio\n");
+			target_err("failed to append bio\n");
 			goto fail;
 		}
 	}
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6e3547847bcc..3a109a61c83b 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -553,8 +553,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		case Opt_rd_pages:
 			match_int(args, &arg);
 			rd_dev->rd_page_count = arg;
-			target_debug("RAMDISK: Referencing Page Count: %u\n",
-				     rd_dev->rd_page_count);
+			target_debug("Referencing Page Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
 		case Opt_rd_nullio:
@@ -562,7 +561,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			if (arg != 1)
 				break;
 
-			target_debug("RAMDISK: Setting NULLIO flag: %d\n", arg);
+			target_debug("Setting NULLIO flag: %d\n", arg);
 			rd_dev->rd_flags |= RDF_NULLIO;
 			break;
 		case Opt_rd_dummy:
@@ -570,7 +569,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			if (arg != 1)
 				break;
 
-			target_debug("RAMDISK: Setting DUMMY flag: %d\n", arg);
+			target_debug("Setting DUMMY flag: %d\n", arg);
 			rd_dev->rd_flags |= RDF_DUMMY;
 			break;
 		default:
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c8f66ef7411b..49f5fd7e399b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1039,7 +1039,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		goto queue;
 
 	if (data_length > (size_t)udev->max_blocks * blk_size) {
-		target_warn("TCMU: Request of size %zu is too big for %zu data area\n", data_length,
+		target_warn("Request of size %zu is too big for %zu data area\n", data_length,
 			    (size_t)udev->max_blocks * blk_size);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
 		return -1;
@@ -1057,7 +1057,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
 	if (command_size > (udev->cmdr_size / 2)) {
-		target_warn("TCMU: Request of size %zu is too big for %u cmd ring\n", command_size,
+		target_warn("Request of size %zu is too big for %u cmd ring\n", command_size,
 			    udev->cmdr_size);
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
@@ -1073,7 +1073,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	if (xa_alloc(&udev->commands, &cmd_id, tcmu_cmd, XA_LIMIT(1, 0xffff),
 		     GFP_NOWAIT) < 0) {
-		target_err("tcmu: Could not allocate cmd id.\n");
+		target_err("Could not allocate cmd id.\n");
 
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
 		*scsi_err = TCM_OUT_OF_RESOURCES;
@@ -1346,7 +1346,7 @@ static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
 	tcmu_cmd_reset_dbi_cur(cmd);
 
 	if (entry->hdr.uflags & TCMU_UFLAG_UNKNOWN_OP) {
-		target_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n", cmd->se_cmd);
+		target_warn("Userspace set UNKNOWN_OP flag on se_cmd %p\n", cmd->se_cmd);
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
 		goto done;
 	}
@@ -1374,7 +1374,7 @@ static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
 	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
 		/* TODO: */
 	} else if (se_cmd->data_direction != DMA_NONE) {
-		target_warn("TCMU: data direction was %d!\n", se_cmd->data_direction);
+		target_warn("data direction was %d!\n", se_cmd->data_direction);
 	}
 
 done:
@@ -2579,7 +2579,7 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			target_debug("TCMU: Referencing Path: %s\n", udev->dev_config);
+			target_debug("Referencing Path: %s\n", udev->dev_config);
 			break;
 		case Opt_dev_size:
 			ret = match_u64(&args[0], &udev->dev_size);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 971299330a98..341adcc82db8 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -50,7 +50,7 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 	int rc;
 
 	if (!se_dev->dev_attrib.emulate_3pc) {
-		target_debug("XCOPY: emulate_3pc disabled on se_dev %p\n", se_dev);
+		target_debug("emulate_3pc disabled on se_dev %p\n", se_dev);
 		return 0;
 	}
 
@@ -59,8 +59,7 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 
 	rc = memcmp(&tmp_dev_wwn[0], dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
 	if (rc != 0) {
-		target_debug("XCOPY: skip non-matching: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN,
-			     tmp_dev_wwn);
+		target_debug("skip non-matching: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN, tmp_dev_wwn);
 		return 0;
 	}
 	target_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
@@ -582,7 +581,7 @@ static int target_xcopy_read_source(
 	cdb[0] = READ_16;
 	put_unaligned_be64(src_lba, &cdb[2]);
 	put_unaligned_be32(transfer_length_block, &cdb[10]);
-	target_debug("XCOPY: Built READ_16: LBA: %llu Blocks: %u Length: %u\n",
+	target_debug("Built READ_16: LBA: %llu Blocks: %u Length: %u\n",
 		     (unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
@@ -627,7 +626,7 @@ static int target_xcopy_write_destination(
 	cdb[0] = WRITE_16;
 	put_unaligned_be64(dst_lba, &cdb[2]);
 	put_unaligned_be32(transfer_length_block, &cdb[10]);
-	target_debug("XCOPY: Built WRITE_16: LBA: %llu Blocks: %u Length: %u\n",
+	target_debug("Built WRITE_16: LBA: %llu Blocks: %u Length: %u\n",
 		     (unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
@@ -834,7 +833,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	if (rc <= 0)
 		goto out;
 
-	target_debug("XCOPY: Processed %d segment descriptors, length: %u\n", rc,
+	target_debug("Processed %d segment descriptors, length: %u\n", rc,
 		     rc * XCOPY_SEGMENT_DESC_LEN);
 
 	rc = target_xcopy_parse_target_descriptors(se_cmd, xop, &p[16], tdll, &ret);
@@ -843,7 +842,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 
 	if (xop->src_dev->dev_attrib.block_size !=
 	    xop->dst_dev->dev_attrib.block_size) {
-		target_err("XCOPY: Non matching src_dev block_size: %u + dst_dev block_size: %u currently unsupported\n",
+		target_err("Non matching src_dev block_size: %u + dst_dev block_size: %u currently unsupported\n",
 			   xop->src_dev->dev_attrib.block_size,
 			   xop->dst_dev->dev_attrib.block_size);
 		xcopy_pt_undepend_remotedev(xop);
@@ -851,7 +850,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 		goto out;
 	}
 
-	target_debug("XCOPY: Processed %d target descriptors, length: %u\n", rc,
+	target_debug("Processed %d target descriptors, length: %u\n", rc,
 		     rc * XCOPY_TARGET_DESC_LEN);
 	transport_kunmap_data_sg(se_cmd);
 	return TCM_NO_SENSE;
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 2fd6ed19fbf9..b265159a308a 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -224,7 +224,7 @@ static struct se_portal_group *ft_add_tpg(struct se_wwn *wwn, const char *name)
 	unsigned long index;
 	int ret;
 
-	target_debug("tcm_fc: add tpg %s\n", name);
+	target_debug("add tpg %s\n", name);
 
 	/*
 	 * Name must be "tpgt_" followed by the index.
diff --git a/drivers/target/tcm_remote/tcm_remote.c b/drivers/target/tcm_remote/tcm_remote.c
index b978b831c6c1..309633e44b28 100644
--- a/drivers/target/tcm_remote/tcm_remote.c
+++ b/drivers/target/tcm_remote/tcm_remote.c
@@ -73,7 +73,7 @@ static int tcm_remote_port_link(
 	struct se_portal_group *se_tpg,
 	struct se_lun *lun)
 {
-	target_debug("TCM_Remote_ConfigFS: Port Link LUN %lld Successful\n", lun->unpacked_lun);
+	target_debug("configfs: Port Link LUN %lld Successful\n", lun->unpacked_lun);
 	return 0;
 }
 
@@ -81,7 +81,7 @@ static void tcm_remote_port_unlink(
 	struct se_portal_group *se_tpg,
 	struct se_lun *lun)
 {
-	target_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n", lun->unpacked_lun);
+	target_debug("configfs: Port Unlink LUN %lld Successful\n", lun->unpacked_lun);
 }
 
 static struct se_portal_group *tcm_remote_make_tpg(
@@ -116,7 +116,7 @@ static struct se_portal_group *tcm_remote_make_tpg(
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
-	target_debug("TCM_Remote_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
+	target_debug("configfs: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
 		     tcm_remote_dump_proto_id(remote_hba),
 		     config_item_name(&wwn->wwn_group.cg_item), tpgt);
 	return &remote_tpg->remote_se_tpg;
@@ -141,7 +141,7 @@ static void tcm_remote_drop_tpg(struct se_portal_group *se_tpg)
 	remote_tpg->remote_hba = NULL;
 	remote_tpg->remote_tpgt = 0;
 
-	target_debug("TCM_Remote_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
+	target_debug("configfs: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
 		     tcm_remote_dump_proto_id(remote_hba),
 		     config_item_name(&wwn->wwn_group.cg_item), tpgt);
 }
@@ -197,7 +197,7 @@ static struct se_wwn *tcm_remote_make_wwn(
 	}
 	snprintf(&remote_hba->remote_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
 
-	target_debug("TCM_Remote_ConfigFS: Allocated emulated Target %s Address: %s\n",
+	target_debug("configfs: Allocated emulated Target %s Address: %s\n",
 		     tcm_remote_dump_proto_id(remote_hba), name);
 	return &remote_hba->remote_hba_wwn;
 out:
@@ -210,7 +210,7 @@ static void tcm_remote_drop_wwn(struct se_wwn *wwn)
 	struct tcm_remote_hba *remote_hba = container_of(wwn,
 				struct tcm_remote_hba, remote_hba_wwn);
 
-	target_debug("TCM_Remote_ConfigFS: Deallocating emulated Target %s Address: %s\n",
+	target_debug("configfs: Deallocating emulated Target %s Address: %s\n",
 		     tcm_remote_dump_proto_id(remote_hba), remote_hba->remote_wwn_address);
 	kfree(remote_hba);
 }
-- 
2.40.3


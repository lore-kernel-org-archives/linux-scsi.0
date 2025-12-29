Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AD92D3EF5;
	Mon, 29 Dec 2025 11:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767008203; cv=none; b=ALERvH02Y/rzSjZMMCKpdZ93T1XyDYlrLd91gXsCuGv1QifYF511QIuEZM7WyA6x+YeuWT86KTgjO95cHK0dk+FO1Slx3p3kJ8K/lJTOjqVrjG3s6yLAITSr2d52iYtJKcBr/aBkssG0deSu+T4YkRGUJnkCIpQsx43CL3USqHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767008203; c=relaxed/simple;
	bh=RBdAZEunp1oPf9yyi0Rv3FJ0TcUGquT/vLX6hnnCTdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BE3cy509vvCRBYEIQgh6+boRPqMzTIgepMlDT95kC6AoS4pSiXyBXUK0A7P2//muNp27UgtkpdJFAOZ+oX1RMkmgzTQX1GuJt5TTG1dP75gUfvwi7VPc/UxPLPbi+MX8NpMGfNIgoyRcSNeXTkwrGqchBdTKZFM6ofl1ekAgtJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=XFs0UNkc; arc=none smtp.client-ip=80.12.242.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="XFs0UNkc"
Received: from fedora.home ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id aBWovvCxRxWB5aBWpvfsQM; Mon, 29 Dec 2025 12:35:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1767008111;
	bh=PjNDoZ40U7jR9QIDge77NgufPkianXfBgIHV4I6m4pw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=XFs0UNkcLmMbBZT+r215Chs2mx8qDx5Ejta8ZMXEbOewJipIOGcG3GqudsgTKXFqe
	 tHSTeWwfvVcGXsKhl3QozxCjqTUs6c6VZWMfS0WNLlPYiM9pZrdQvjP2ShtIEf3X3/
	 0w1zsJka//uYpnV3nyr5DYLUH69iKvuTyPBz0I22BnvhoDj0rU3CRjvoLl8K/jIhoW
	 D5pwpO9ZLBeoLB0j2Ld5ScrHHmq2HK6tazfqoU3lPuqjfavdjtAWWfZECsyKZPKXES
	 jedRKfdFjVJzqmEYPOQnhKFTLYHIeApdhvb9DCfGpWvbG+slBdVeWCE+/beZF6RHnH
	 0ols5Pv5mSkqw==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 29 Dec 2025 12:35:11 +0100
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH v2] scsi: target: Constify struct configfs_item_operations and configfs_group_operations
Date: Mon, 29 Dec 2025 12:35:01 +0100
Message-ID: <a0f25237ae86b8c4dd7a3876c4ed2dc3de200173.1767008082.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct configfs_item_operations' and 'configfs_group_operations' are not
modified in this driver.

Constifying these structures moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
 151831	  80058	   4832	 236721	  39cb1	drivers/target/target_core_configfs.o
  45200	  16658	      0	  61858	   f1a2	drivers/target/target_core_fabric_configfs.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
 152599	  79290	   4832	 236721	  39cb1	drivers/target/target_core_configfs.o
  46352	  15506	      0	  61858	   f1a2	drivers/target/target_core_fabric_configfs.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.

This change is possible since commits f2f36500a63b and f7f78098690d.

Changes in v2:
   - The patch was not the one related to scsi: target:. Only the subject
     was right.

v1: https://lore.kernel.org/lkml/f1f05f6c1bc0c6f37cd680f012fe08c525364968.1765705512.git.christophe.jaillet@wanadoo.fr/
---
 drivers/target/target_core_configfs.c        | 18 ++++++------
 drivers/target/target_core_fabric_configfs.c | 30 ++++++++++----------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f7868b41c5e6..c256c7137125 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -288,7 +288,7 @@ static void target_core_deregister_fabric(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_core_fabric_group_ops = {
+static const struct configfs_group_operations target_core_fabric_group_ops = {
 	.make_group	= &target_core_register_fabric,
 	.drop_item	= &target_core_deregister_fabric,
 };
@@ -2810,7 +2810,7 @@ static void target_core_alua_lu_gp_release(struct config_item *item)
 	core_alua_free_lu_gp(lu_gp);
 }
 
-static struct configfs_item_operations target_core_alua_lu_gp_ops = {
+static const struct configfs_item_operations target_core_alua_lu_gp_ops = {
 	.release		= target_core_alua_lu_gp_release,
 };
 
@@ -2867,7 +2867,7 @@ static void target_core_alua_drop_lu_gp(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_core_alua_lu_gps_group_ops = {
+static const struct configfs_group_operations target_core_alua_lu_gps_group_ops = {
 	.make_group		= &target_core_alua_create_lu_gp,
 	.drop_item		= &target_core_alua_drop_lu_gp,
 };
@@ -3240,7 +3240,7 @@ static void target_core_alua_tg_pt_gp_release(struct config_item *item)
 	core_alua_free_tg_pt_gp(tg_pt_gp);
 }
 
-static struct configfs_item_operations target_core_alua_tg_pt_gp_ops = {
+static const struct configfs_item_operations target_core_alua_tg_pt_gp_ops = {
 	.release		= target_core_alua_tg_pt_gp_release,
 };
 
@@ -3298,7 +3298,7 @@ static void target_core_alua_drop_tg_pt_gp(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_core_alua_tg_pt_gps_group_ops = {
+static const struct configfs_group_operations target_core_alua_tg_pt_gps_group_ops = {
 	.make_group		= &target_core_alua_create_tg_pt_gp,
 	.drop_item		= &target_core_alua_drop_tg_pt_gp,
 };
@@ -3339,7 +3339,7 @@ static void target_core_stat_rmdir(
 	return;
 }
 
-static struct configfs_group_operations target_core_stat_group_ops = {
+static const struct configfs_group_operations target_core_stat_group_ops = {
 	.make_group		= &target_core_stat_mkdir,
 	.drop_item		= &target_core_stat_rmdir,
 };
@@ -3466,7 +3466,7 @@ static void target_core_drop_subdev(
 	mutex_unlock(&hba->hba_access_mutex);
 }
 
-static struct configfs_group_operations target_core_hba_group_ops = {
+static const struct configfs_group_operations target_core_hba_group_ops = {
 	.make_group		= target_core_make_subdev,
 	.drop_item		= target_core_drop_subdev,
 };
@@ -3545,7 +3545,7 @@ static struct configfs_attribute *target_core_hba_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations target_core_hba_item_ops = {
+static const struct configfs_item_operations target_core_hba_item_ops = {
 	.release		= target_core_hba_release,
 };
 
@@ -3626,7 +3626,7 @@ static void target_core_call_delhbafromtarget(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_core_group_ops = {
+static const struct configfs_group_operations target_core_group_ops = {
 	.make_group	= target_core_call_addhbatotarget,
 	.drop_item	= target_core_call_delhbafromtarget,
 };
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 13159928e365..59713e9be10a 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -59,7 +59,7 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
-static struct configfs_item_operations target_fabric_port_item_ops;
+static const struct configfs_item_operations target_fabric_port_item_ops;
 
 /* Start of tfc_tpg_mappedlun_cit */
 
@@ -219,7 +219,7 @@ static void target_fabric_mappedlun_release(struct config_item *item)
 	core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
 }
 
-static struct configfs_item_operations target_fabric_mappedlun_item_ops = {
+static const struct configfs_item_operations target_fabric_mappedlun_item_ops = {
 	.release		= target_fabric_mappedlun_release,
 	.allow_link		= target_fabric_mappedlun_link,
 	.drop_link		= target_fabric_mappedlun_unlink,
@@ -246,7 +246,7 @@ static void target_core_mappedlun_stat_rmdir(
 	return;
 }
 
-static struct configfs_group_operations target_fabric_mappedlun_stat_group_ops = {
+static const struct configfs_group_operations target_fabric_mappedlun_stat_group_ops = {
 	.make_group		= target_core_mappedlun_stat_mkdir,
 	.drop_item		= target_core_mappedlun_stat_rmdir,
 };
@@ -345,11 +345,11 @@ static void target_fabric_nacl_base_release(struct config_item *item)
 	core_tpg_del_initiator_node_acl(se_nacl);
 }
 
-static struct configfs_item_operations target_fabric_nacl_base_item_ops = {
+static const struct configfs_item_operations target_fabric_nacl_base_item_ops = {
 	.release		= target_fabric_nacl_base_release,
 };
 
-static struct configfs_group_operations target_fabric_nacl_base_group_ops = {
+static const struct configfs_group_operations target_fabric_nacl_base_group_ops = {
 	.make_group		= target_fabric_make_mappedlun,
 	.drop_item		= target_fabric_drop_mappedlun,
 };
@@ -433,7 +433,7 @@ static void target_fabric_drop_nodeacl(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_fabric_nacl_group_ops = {
+static const struct configfs_group_operations target_fabric_nacl_group_ops = {
 	.make_group	= target_fabric_make_nodeacl,
 	.drop_item	= target_fabric_drop_nodeacl,
 };
@@ -454,7 +454,7 @@ static void target_fabric_np_base_release(struct config_item *item)
 	tf->tf_ops->fabric_drop_np(se_tpg_np);
 }
 
-static struct configfs_item_operations target_fabric_np_base_item_ops = {
+static const struct configfs_item_operations target_fabric_np_base_item_ops = {
 	.release		= target_fabric_np_base_release,
 };
 
@@ -499,7 +499,7 @@ static void target_fabric_drop_np(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_fabric_np_group_ops = {
+static const struct configfs_group_operations target_fabric_np_group_ops = {
 	.make_group	= &target_fabric_make_np,
 	.drop_item	= &target_fabric_drop_np,
 };
@@ -700,7 +700,7 @@ static void target_fabric_port_release(struct config_item *item)
 	call_rcu(&lun->rcu_head, target_tpg_free_lun);
 }
 
-static struct configfs_item_operations target_fabric_port_item_ops = {
+static const struct configfs_item_operations target_fabric_port_item_ops = {
 	.release		= target_fabric_port_release,
 	.allow_link		= target_fabric_port_link,
 	.drop_link		= target_fabric_port_unlink,
@@ -726,7 +726,7 @@ static void target_core_port_stat_rmdir(
 	return;
 }
 
-static struct configfs_group_operations target_fabric_port_stat_group_ops = {
+static const struct configfs_group_operations target_fabric_port_stat_group_ops = {
 	.make_group		= target_core_port_stat_mkdir,
 	.drop_item		= target_core_port_stat_rmdir,
 };
@@ -787,7 +787,7 @@ static void target_fabric_drop_lun(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_fabric_lun_group_ops = {
+static const struct configfs_group_operations target_fabric_lun_group_ops = {
 	.make_group	= &target_fabric_make_lun,
 	.drop_item	= &target_fabric_drop_lun,
 };
@@ -812,7 +812,7 @@ static void target_fabric_tpg_release(struct config_item *item)
 	tf->tf_ops->fabric_drop_tpg(se_tpg);
 }
 
-static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
+static const struct configfs_item_operations target_fabric_tpg_base_item_ops = {
 	.release		= target_fabric_tpg_release,
 };
 
@@ -998,11 +998,11 @@ static void target_fabric_release_wwn(struct config_item *item)
 	tf->tf_ops->fabric_drop_wwn(wwn);
 }
 
-static struct configfs_item_operations target_fabric_tpg_item_ops = {
+static const struct configfs_item_operations target_fabric_tpg_item_ops = {
 	.release	= target_fabric_release_wwn,
 };
 
-static struct configfs_group_operations target_fabric_tpg_group_ops = {
+static const struct configfs_group_operations target_fabric_tpg_group_ops = {
 	.make_group	= target_fabric_make_tpg,
 	.drop_item	= target_fabric_drop_tpg,
 };
@@ -1144,7 +1144,7 @@ static void target_fabric_drop_wwn(
 	config_item_put(item);
 }
 
-static struct configfs_group_operations target_fabric_wwn_group_ops = {
+static const struct configfs_group_operations target_fabric_wwn_group_ops = {
 	.make_group	= target_fabric_make_wwn,
 	.drop_item	= target_fabric_drop_wwn,
 };
-- 
2.52.0


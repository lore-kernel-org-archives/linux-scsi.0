From: Thomas Meyer <thomas@m3y3r.de>
Subject: TARGET: Use ERR_CAST inlined function
Date: Mon, 01 Aug 2011 23:58:18 +0200
Message-ID: <1312235902.2629.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:53241 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1HAWYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 18:24:12 -0400
Received: from [88.68.104.235] (helo=[192.168.2.108])
	by www17.your-server.de with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <thomas@m3y3r.de>)
	id 1Qo0Va-00011E-EB
	for linux-scsi@vger.kernel.org; Mon, 01 Aug 2011 23:58:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/err_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

diff -u -p a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
--- a/drivers/target/target_core_fabric_configfs.c 2011-07-26 00:46:09.670171895 +0200
+++ b/drivers/target/target_core_fabric_configfs.c 2011-08-01 20:49:50.880256441 +0200
@@ -481,7 +481,7 @@ static struct config_group *target_fabri
 
 	se_nacl = tf->tf_ops.fabric_make_nodeacl(se_tpg, group, name);
 	if (IS_ERR(se_nacl))
-		return ERR_PTR(PTR_ERR(se_nacl));
+		return ERR_CAST(se_nacl);
 
 	nacl_cg = &se_nacl->acl_group;
 	nacl_cg->default_groups = se_nacl->acl_default_groups;
diff -u -p a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
--- a/drivers/target/iscsi/iscsi_target_configfs.c 2011-07-28 15:32:18.326584569 +0200
+++ b/drivers/target/iscsi/iscsi_target_configfs.c 2011-08-01 20:49:55.393565325 +0200
@@ -268,7 +268,7 @@ struct se_tpg_np *lio_target_call_addnpt
 				ISCSI_TCP);
 	if (IS_ERR(tpg_np)) {
 		iscsit_put_tpg(tpg);
-		return ERR_PTR(PTR_ERR(tpg_np));
+		return ERR_CAST(tpg_np);
 	}
 	pr_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
 
@@ -1285,7 +1285,7 @@ struct se_wwn *lio_target_call_coreaddti
 
 	tiqn = iscsit_add_tiqn((unsigned char *)name);
 	if (IS_ERR(tiqn))
-		return ERR_PTR(PTR_ERR(tiqn));
+		return ERR_CAST(tiqn);
 	/*
 	 * Setup struct iscsi_wwn_stat_grps for se_wwn->fabric_stat_group.
 	 */



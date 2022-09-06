Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7EBECAAD5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 16:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbiIFQR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiIFQRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 12:17:19 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7192572EC3;
        Tue,  6 Sep 2022 08:45:49 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 104EE43EDA;
        Tue,  6 Sep 2022 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662479146; x=1664293547; bh=VOL48z09Wg5M9JTo+yY9Lsiss
        dAR71LHbr5Sfs9zY0Q=; b=Ev695uqpFKTCUzlTwfXM8MJ/HrfVy8EUHrNJOkk27
        V84a3MqWRbJ50iUSDJ7mlVTwM/HFttiqVdUUMAEN2ps03M3711+FwYqrsOYOMTnP
        Aa5d6pqhhXlUXDC6qYZCG3qBakGtBIwEFT7VQOBNENckCe8DcLhLnprJK5j7JVqv
        VY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ezdS8AMINU2c; Tue,  6 Sep 2022 18:45:46 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F2E244465A;
        Tue,  6 Sep 2022 18:45:42 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 18:45:43 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 18:45:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 5/7] scsi: target: core: Add common port attributes
Date:   Tue, 6 Sep 2022 18:45:17 +0300
Message-ID: <20220906154519.27487-6-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906154519.27487-1-d.bogdanov@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

All SCSI target port attributes (tpgN/attribs/attrname) are defined and
implemented in fabric modules in existing implementation.

The change introduces a way to have common tpg attribs in configfs for
all fabrics without code duplication.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c        |  9 ++++-
 drivers/target/target_core_fabric_configfs.c | 39 +++++++++++++++++++-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_tpg.c             |  4 ++
 4 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 7c0e42e782de..40b9808738d2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -464,13 +464,19 @@ int target_register_template(const struct target_core_fabric_ops *fo)
 	INIT_LIST_HEAD(&tf->tf_list);
 	atomic_set(&tf->tf_access_cnt, 0);
 	tf->tf_ops = fo;
-	target_fabric_setup_cits(tf);
+	ret = target_fabric_setup_cits(tf);
+	if (ret)
+		goto out;
 
 	mutex_lock(&g_tf_lock);
 	list_add_tail(&tf->tf_list, &g_tf_list);
 	mutex_unlock(&g_tf_lock);
 
 	return 0;
+
+out:
+	kfree(tf);
+	return ret;
 }
 EXPORT_SYMBOL(target_register_template);
 
@@ -491,6 +497,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
 			 */
 			rcu_barrier();
 			kfree(t->tf_tpg_base_cit.ct_attrs);
+			kfree(t->tf_tpg_attrib_cit.ct_attrs);
 			kfree(t);
 			return;
 		}
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 95a88f6224cd..a34b5db4eec5 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -795,7 +795,38 @@ TF_CIT_SETUP(tpg_lun, NULL, &target_fabric_lun_group_ops, NULL);
 
 /* End of tfc_tpg_lun_cit */
 
-TF_CIT_SETUP_DRV(tpg_attrib, NULL, NULL);
+static int
+target_fabric_setup_tpg_attrib_cit(struct target_fabric_configfs *tf)
+{
+	int i, k, len = 0;
+	struct config_item_type *cit = &tf->tf_tpg_attrib_cit;
+	struct configfs_attribute **attrs;
+
+	for (i = 0; core_tpg_attrib_attrs[i]; i++)
+		len += sizeof(struct configfs_attribute *);
+	if (tf->tf_ops->tfc_tpg_attrib_attrs)
+		for (i = 0; tf->tf_ops->tfc_tpg_attrib_attrs[i]; i++)
+			len += sizeof(struct configfs_attribute *);
+	len += sizeof(struct configfs_attribute *);
+
+	attrs = kzalloc(len, GFP_KERNEL);
+	if (!attrs)
+		return -ENOMEM;
+
+	for (i = 0; core_tpg_attrib_attrs[i]; i++)
+		attrs[i] = core_tpg_attrib_attrs[i];
+	if (tf->tf_ops->tfc_tpg_attrib_attrs)
+		for (k = 0; tf->tf_ops->tfc_tpg_attrib_attrs[k]; k++, i++)
+			attrs[i] = tf->tf_ops->tfc_tpg_attrib_attrs[k];
+	attrs[i] = NULL;
+
+	cit->ct_attrs = attrs;
+	cit->ct_owner = tf->tf_ops->module;
+	pr_debug("Setup generic tpg_attrib\n");
+
+	return 0;
+}
+
 TF_CIT_SETUP_DRV(tpg_auth, NULL, NULL);
 TF_CIT_SETUP_DRV(tpg_param, NULL, NULL);
 
@@ -1113,7 +1144,11 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 	target_fabric_setup_tpg_lun_cit(tf);
 	target_fabric_setup_tpg_np_cit(tf);
 	target_fabric_setup_tpg_np_base_cit(tf);
-	target_fabric_setup_tpg_attrib_cit(tf);
+
+	ret = target_fabric_setup_tpg_attrib_cit(tf);
+	if (ret)
+		return ret;
+
 	target_fabric_setup_tpg_auth_cit(tf);
 	target_fabric_setup_tpg_param_cit(tf);
 	target_fabric_setup_tpg_nacl_cit(tf);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 7dcc62749edd..d662cdc9a04c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -117,6 +117,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 
 /* target_core_tpg.c */
 extern struct se_device *g_lun0_dev;
+extern struct configfs_attribute *core_tpg_attrib_attrs[];
 
 struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index e340ef00652b..b359c83a99c6 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -714,3 +714,7 @@ void core_tpg_remove_lun(
 
 	percpu_ref_exit(&lun->lun_ref);
 }
+
+struct configfs_attribute *core_tpg_attrib_attrs[] = {
+	NULL,
+};
-- 
2.25.1


Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22FFC83007
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09132083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="qH6tV5md"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgD2Jpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39868 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbgD2Jpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 514BE4C84C;
        Wed, 29 Apr 2020 09:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153528; x=1589967929; bh=k6n1khQmz3eZGpOG2KZIZIjTtD58tijZGl6
        hdagMKW0=; b=qH6tV5mdvzmiv8sN99l+yBQdtm/oPyUusHsj8aiBe1rHnDRTkZ3
        laqGTWWV4NUCLnZQTedZHYg9yPObIFsgJy3GWV2D00hcso8+AazyQxN7erVrqcAN
        ztjBHDCumkzyphh9IL6GS/PS1Wu95RJeF1hTfgz+K2TSCs1mUJo3wyJE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jEDqruWmktXA; Wed, 29 Apr 2020 12:45:28 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DE4EA4C84D;
        Wed, 29 Apr 2020 12:45:27 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:29 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 07/11] scsi: target/core: Add common port attributes
Date:   Wed, 29 Apr 2020 12:44:40 +0300
Message-ID: <20200429094443.43937-8-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All SCSI target port attributes (tpgN/attribs/attrname) are defined and
implemented in fabric modules in existing implementation.

The change introduces a way to have common tpg attribs in configfs for
all fabrics without code duplication.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_configfs.c        |  9 ++++-
 drivers/target/target_core_fabric_configfs.c | 41 +++++++++++++++++++-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_tpg.c             |  4 ++
 4 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 42390ce9d4db..3311d29ecad8 100644
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
 
@@ -490,6 +496,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
 			 * fabric driver unload of TFO->module to proceed.
 			 */
 			rcu_barrier();
+			kfree(t->tf_tpg_attrib_cit.ct_attrs);
 			kfree(t);
 			return;
 		}
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ee85602213f7..883ec9cac835 100644
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
 
@@ -971,6 +1002,8 @@ TF_CIT_SETUP_DRV(discovery, NULL, NULL);
 
 int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 {
+	int ret;
+
 	target_fabric_setup_discovery_cit(tf);
 	target_fabric_setup_wwn_cit(tf);
 	target_fabric_setup_wwn_fabric_stats_cit(tf);
@@ -981,7 +1014,11 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
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
index aed38c9705f8..e1aabb79467a 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -116,6 +116,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 
 /* target_core_tpg.c */
 extern struct se_device *g_lun0_dev;
+extern struct configfs_attribute *core_tpg_attrib_attrs[];
 
 struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 32bc28afe93c..67474690720d 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -719,3 +719,7 @@ void core_tpg_remove_lun(
 
 	percpu_ref_exit(&lun->lun_ref);
 }
+
+struct configfs_attribute *core_tpg_attrib_attrs[] = {
+	NULL,
+};
-- 
2.26.1


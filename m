Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E23C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8188A61972
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhCVIG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:06:28 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39538 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229746AbhCVIGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 04:06:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5DA7A412D6;
        Mon, 22 Mar 2021 08:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1616400371; x=1618214772; bh=uz0+aRISZVgXIhknBdtnI75wTsyR70tf6nh
        vSeNez+8=; b=DBt3f8TZJW6z/nHVEicd4o/QLKKtstibQVgsEx+b0EuowSrp24G
        1mssdQ1nrF7aOG/glpAReThoaQzt/F2s6f/DoB9fSPyjAgpT6xx3drudLMAnoaHi
        lBRuKzRs6fSFuuQ96xuOUroaK5yOXIHDYvWm2600d6HgFS2ThjjAGIx4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8-iKT1IzzyCV; Mon, 22 Mar 2021 11:06:11 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E282841241;
        Mon, 22 Mar 2021 11:06:09 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.33) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 22
 Mar 2021 11:06:08 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 1/7] target: core: add common tpg/enable attribute
Date:   Mon, 22 Mar 2021 11:05:48 +0300
Message-ID: <20210322080554.7611-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322080554.7611-1-d.bogdanov@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.33]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many fabric modules provide their own implementation of enable
attribute in tpg.
The change provides a way to remove code duplication in the fabric
modules and automatically add "enable" attribute if a fabric module has
an implementation of fabric_enable_tpg() ops.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
    create enable atribute only for modules with enable_tpg ops 

 drivers/target/target_core_configfs.c        |  1 +
 drivers/target/target_core_fabric_configfs.c | 40 ++++++++++++++++++-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_tpg.c             | 41 ++++++++++++++++++++
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          |  1 +
 6 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f04352285155..fc3949e91f9c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -490,6 +490,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
 			 * fabric driver unload of TFO->module to proceed.
 			 */
 			rcu_barrier();
+			kfree(t->tf_tpg_base_cit.ct_attrs);
 			kfree(t);
 			return;
 		}
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ee85602213f7..c5e1b0d54330 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -815,8 +815,40 @@ static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
 	.release		= target_fabric_tpg_release,
 };
 
-TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops, NULL);
+static int
+target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
+{
+	int i, k, len = 0;
+	struct config_item_type *cit = &tf->tf_tpg_base_cit;
+	struct configfs_attribute **attrs;
+
+	if (tf->tf_ops->fabric_enable_tpg)
+		for (i = 0; core_tpg_base_enable_attrs[i]; i++)
+			len += sizeof(struct configfs_attribute *);
+	if (tf->tf_ops->tfc_tpg_base_attrs)
+		for (i = 0; tf->tf_ops->tfc_tpg_base_attrs[i]; i++)
+			len += sizeof(struct configfs_attribute *);
+	len += sizeof(struct configfs_attribute *);
+
+	attrs = kzalloc(len, GFP_KERNEL);
+	if (!attrs)
+		return -ENOMEM;
+
+	if (tf->tf_ops->fabric_enable_tpg)
+		for (i = 0; core_tpg_base_enable_attrs[i]; i++)
+			attrs[i] = core_tpg_base_enable_attrs[i];
+	if (tf->tf_ops->tfc_tpg_base_attrs)
+		for (k = 0; tf->tf_ops->tfc_tpg_base_attrs[k]; k++, i++)
+			attrs[i] = tf->tf_ops->tfc_tpg_base_attrs[k];
+	attrs[i] = NULL;
+
+	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
+	cit->ct_attrs = attrs;
+	cit->ct_owner = tf->tf_ops->module;
+	pr_debug("Setup generic tpg_base\n");
 
+	return 0;
+}
 /* End of tfc_tpg_base_cit */
 
 /* Start of tfc_tpg_cit */
@@ -971,11 +1003,15 @@ TF_CIT_SETUP_DRV(discovery, NULL, NULL);
 
 int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 {
+	int ret;
+
 	target_fabric_setup_discovery_cit(tf);
 	target_fabric_setup_wwn_cit(tf);
 	target_fabric_setup_wwn_fabric_stats_cit(tf);
 	target_fabric_setup_tpg_cit(tf);
-	target_fabric_setup_tpg_base_cit(tf);
+	ret = target_fabric_setup_tpg_base_cit(tf);
+	if (ret)
+		return ret;
 	target_fabric_setup_tpg_port_cit(tf);
 	target_fabric_setup_tpg_port_stat_cit(tf);
 	target_fabric_setup_tpg_lun_cit(tf);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e7b3c6e5d574..274fd670bf9c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -117,6 +117,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 
 /* target_core_tpg.c */
 extern struct se_device *g_lun0_dev;
+extern struct configfs_attribute *core_tpg_base_enable_attrs[];
 
 struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..d06b3fbd8511 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -650,3 +650,44 @@ void core_tpg_remove_lun(
 
 	percpu_ref_exit(&lun->lun_ref);
 }
+
+
+static ssize_t core_tpg_base_enable_show(struct config_item *item, char *page)
+{
+	return sysfs_emit(page, "%d\n", to_tpg(item)->enabled);
+}
+
+static ssize_t core_tpg_base_enable_store(struct config_item *item,
+					  const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	int ret;
+	u32 op;
+
+	ret = kstrtou32(page, 0, &op);
+	if (ret)
+		return ret;
+	if ((op != 1) && (op != 0)) {
+		pr_err("Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+
+	if (se_tpg->enabled == op)
+		return count;
+
+	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
+
+	if (ret)
+		return ret;
+
+	se_tpg->enabled = op;
+
+	return count;
+}
+
+CONFIGFS_ATTR(core_tpg_base_, enable);
+
+struct configfs_attribute *core_tpg_base_enable_attrs[] = {
+	&core_tpg_base_attr_enable,
+	NULL,
+};
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 54dcc0eb25fa..fabc9dccfeb2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -885,6 +885,7 @@ struct se_portal_group {
 	 * Negative values can be used by fabric drivers for internal use TPGs.
 	 */
 	int			proto_id;
+	bool			enabled;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d60a3eb7517a..b7e409e9e13e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -89,6 +89,7 @@ struct target_core_fabric_ops {
 	void (*add_wwn_groups)(struct se_wwn *);
 	struct se_portal_group *(*fabric_make_tpg)(struct se_wwn *,
 						   const char *);
+	int (*fabric_enable_tpg)(struct se_portal_group *se_tpg, bool enable);
 	void (*fabric_drop_tpg)(struct se_portal_group *);
 	int (*fabric_post_link)(struct se_portal_group *,
 				struct se_lun *);
-- 
2.25.1


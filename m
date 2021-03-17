Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4193EC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 10:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDD664F21
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 10:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhCQKql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 06:46:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48238 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230146AbhCQKqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 06:46:31 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 692A04124F;
        Wed, 17 Mar 2021 10:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1615977989; x=1617792390; bh=Fi1JWr0E44lARguezv7uQUweOjNi44rfY6L
        bP7qEAhA=; b=HXlOBDW08C3HSvbWTT+NEs1AOs1utKUvlYPVqdCj70WLGeeOJxM
        IwUyAjN1bn28CSSzwUOvgiBfsRUNkEaSmaev2MpW1Egunjt7uoCPun7Gl45ee1Hx
        y9lmmXLAqBgSrs1nA2wXr7CuP4dVJVOS0iFE8aSfS7J/VTaZSZeaHFC4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4DIvjxSum0zo; Wed, 17 Mar 2021 13:46:29 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 11EDC41259;
        Wed, 17 Mar 2021 13:46:29 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.54) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 17
 Mar 2021 13:46:28 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/4] target: core: add common tpg/enable attribute
Date:   Wed, 17 Mar 2021 13:46:06 +0300
Message-ID: <20210317104609.25236-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317104609.25236-1-d.bogdanov@yadro.com>
References: <20210317104609.25236-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.54]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add enable atribute for all target port groups.
Writing to enable attribute will call fabric ops fabric_enable_tpg()

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c        |  1 +
 drivers/target/target_core_fabric_configfs.c | 38 +++++++++++++++++-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_tpg.c             | 42 ++++++++++++++++++++
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          |  1 +
 6 files changed, 82 insertions(+), 2 deletions(-)

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
index ee85602213f7..b0b71a340272 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -815,8 +815,38 @@ static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
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
+	for (i = 0; core_tpg_base_attrs[i]; i++)
+		len += sizeof(struct configfs_attribute *);
+	if (tf->tf_ops->tfc_tpg_base_attrs)
+		for (i = 0; tf->tf_ops->tfc_tpg_base_attrs[i]; i++)
+			len += sizeof(struct configfs_attribute *);
+	len += sizeof(struct configfs_attribute *);
+
+	attrs = kzalloc(len, GFP_KERNEL);
+	if (!attrs)
+		return -ENOMEM;
+
+	for (i = 0; core_tpg_base_attrs[i]; i++)
+		attrs[i] = core_tpg_base_attrs[i];
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
@@ -971,11 +1001,15 @@ TF_CIT_SETUP_DRV(discovery, NULL, NULL);
 
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
index e7b3c6e5d574..a0f85c945511 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -117,6 +117,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 
 /* target_core_tpg.c */
 extern struct se_device *g_lun0_dev;
+extern struct configfs_attribute *core_tpg_base_attrs[];
 
 struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..47270c92e48d 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -650,3 +650,45 @@ void core_tpg_remove_lun(
 
 	percpu_ref_exit(&lun->lun_ref);
 }
+
+
+static ssize_t core_tpg_base_enable_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "%d\n", to_tpg(item)->enabled);
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
+	if (se_tpg->se_tpg_tfo->fabric_enable_tpg)
+		ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
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
+struct configfs_attribute *core_tpg_base_attrs[] = {
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


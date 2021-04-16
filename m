Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21287C43462
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7556115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbhDPIlN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 04:41:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:41976 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239462AbhDPIlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 04:41:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4D37D41369;
        Fri, 16 Apr 2021 08:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1618562435; x=1620376836; bh=pRsUU++uSRO5QyygIcIYhEj0Qo03md9bSxV
        UAdFfiQA=; b=X0bj405XoyK1PVnjxzdgg5CFCDQaX5MU2S87a+0OHqXCBjVXciA
        VUl9YZsnmkSiLMHxhrzHHzawESuv5PX3obsGN1SA8AywTqXgnBKdekE4l9qC52cp
        /OKaI9nR+LrRHGIhvQrSfHNbxVVlQ8lA1Jjo1/Riq5s80jaLHlll8ZN8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id re9opPZ-0vGF; Fri, 16 Apr 2021 11:40:35 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E0AD441373;
        Fri, 16 Apr 2021 11:40:35 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.63) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 16
 Apr 2021 11:40:34 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v4 1/7] target: core: add common tpg/enable attribute
Date:   Fri, 16 Apr 2021 11:26:26 +0300
Message-ID: <20210416082632.2000-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416082632.2000-1-d.bogdanov@yadro.com>
References: <20210416082632.2000-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.63]
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
v4:
 fix compilation error
v3:
 refactor tfc_tpg_base_attrs creation
 avoid alloc of attrs if there are no attributes
 fix newlines
 move enable attribute to target_core_fabric_configfs.c
v2:
 create enable atribute only for modules with enable_tpg ops
---
 drivers/target/target_core_configfs.c        |  1 +
 drivers/target/target_core_fabric_configfs.c | 78 +++++++++++++++++++-
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          |  1 +
 4 files changed, 79 insertions(+), 2 deletions(-)

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
index ee85602213f7..38a0658df370 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -815,8 +815,76 @@ static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
 	.release		= target_fabric_tpg_release,
 };
 
-TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops, NULL);
+static ssize_t target_fabric_tpg_base_enable_show(struct config_item *item,
+						  char *page)
+{
+	return sysfs_emit(page, "%d\n", to_tpg(item)->enabled);
+}
+
+static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
+						   const char *page,
+						   size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	int ret;
+	bool op;
+
+	ret = strtobool(page, &op);
+	if (ret)
+		return ret;
+
+	if (se_tpg->enabled == op)
+		return count;
+
+	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
+	if (ret)
+		return ret;
+
+	se_tpg->enabled = op;
+
+	return count;
+}
+
+CONFIGFS_ATTR(target_fabric_tpg_base_, enable);
 
+static int
+target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
+{
+	struct config_item_type *cit = &tf->tf_tpg_base_cit;
+	struct configfs_attribute **attrs = NULL;
+	size_t nr_attrs = 0;
+	int i = 0;
+
+	if (tf->tf_ops->tfc_tpg_base_attrs)
+		while (tf->tf_ops->tfc_tpg_base_attrs[nr_attrs] != NULL)
+			nr_attrs++;
+
+	if (tf->tf_ops->fabric_enable_tpg)
+		nr_attrs++;
+
+	if (nr_attrs == 0)
+		goto done;
+
+	/* + 1 for final NULL in the array */
+	attrs = kcalloc(nr_attrs + 1, sizeof(*attrs), GFP_KERNEL);
+	if (!attrs)
+		return -ENOMEM;
+
+	if (tf->tf_ops->tfc_tpg_base_attrs)
+		for (; tf->tf_ops->tfc_tpg_base_attrs[i] != NULL; i++)
+			attrs[i] = tf->tf_ops->tfc_tpg_base_attrs[i];
+
+	if (tf->tf_ops->fabric_enable_tpg)
+		attrs[i] = &target_fabric_tpg_base_attr_enable;
+
+done:
+	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
+	cit->ct_attrs = attrs;
+	cit->ct_owner = tf->tf_ops->module;
+	pr_debug("Setup generic tpg_base\n");
+
+	return 0;
+}
 /* End of tfc_tpg_base_cit */
 
 /* Start of tfc_tpg_cit */
@@ -971,11 +1039,17 @@ TF_CIT_SETUP_DRV(discovery, NULL, NULL);
 
 int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 {
+	int ret;
+
 	target_fabric_setup_discovery_cit(tf);
 	target_fabric_setup_wwn_cit(tf);
 	target_fabric_setup_wwn_fabric_stats_cit(tf);
 	target_fabric_setup_tpg_cit(tf);
-	target_fabric_setup_tpg_base_cit(tf);
+
+	ret = target_fabric_setup_tpg_base_cit(tf);
+	if (ret)
+		return ret;
+
 	target_fabric_setup_tpg_port_cit(tf);
 	target_fabric_setup_tpg_port_stat_cit(tf);
 	target_fabric_setup_tpg_lun_cit(tf);
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


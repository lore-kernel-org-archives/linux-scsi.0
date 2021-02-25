Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77941C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiHCQ3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbiHCQ3X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:23 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5407541D32;
        Wed,  3 Aug 2022 09:29:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B9E44412DD;
        Wed,  3 Aug 2022 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544157; x=1661358558; bh=F8zwbwFQerInqTJkM47gn2DFi
        lWIUw9B3wyqG8xTPDM=; b=HES+aTLitYbxxoXdsh206sV6bg2cjkXlOoFQO0ZA8
        lrmBe0LOAk1/d53IgC9VCJtHNqe6c1h61GMCF0fOA2wSpR0zVLAyXRE/whdkfFKO
        pht+TL+aNLp9YX3t5Koi0F5T+2dwEcZqAr0967V4bqpLicAO5oAm/OyBaJfyFnDu
        SM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id L-f30nbTlgaw; Wed,  3 Aug 2022 19:29:17 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E625341239;
        Wed,  3 Aug 2022 19:29:13 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:14 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:12 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 09/48] target: core: check RTPI uniquity for enabled TPG
Date:   Thu, 25 Feb 2021 15:18:00 +0300
Message-ID: <20220803162857.27770-10-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Garantee uniquity of RTPI only for enabled target port groups.
Allow any RPTI for disabled tpg until it is enabled.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_fabric_configfs.c | 29 +++++++++++++-
 drivers/target/target_core_internal.h        |  2 +
 drivers/target/target_core_tpg.c             | 40 +++++++++++++-------
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index a34b5db4eec5..fc1b8f54fb54 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -857,6 +857,7 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
 						   size_t count)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
+	struct se_portal_group *tpg;
 	int ret;
 	bool op;
 
@@ -867,11 +868,37 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
 	if (se_tpg->enabled == op)
 		return count;
 
+	spin_lock(&g_tpg_lock);
+
+	if (op) {
+		tpg = core_get_tpg_by_rtpi(se_tpg->tpg_rtpi);
+		if (tpg) {
+			spin_unlock(&g_tpg_lock);
+
+			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
+			       se_tpg->se_tpg_tfo->fabric_name,
+			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			       se_tpg->tpg_rtpi,
+			       tpg->se_tpg_tfo->fabric_name,
+			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
+			return -EINVAL;
+		}
+	}
+
+	se_tpg->enabled |= 0x10; /* transient state */
+	spin_unlock(&g_tpg_lock);
+
 	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
-	if (ret)
+
+	spin_lock(&g_tpg_lock);
+	if (ret < 0) {
+		se_tpg->enabled	&= ~0x10; /* clear transient state */
+		spin_unlock(&g_tpg_lock);
 		return ret;
+	}
 
 	se_tpg->enabled = op;
+	spin_unlock(&g_tpg_lock);
 
 	return count;
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index d662cdc9a04c..d4ace697edb0 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -116,6 +116,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 		struct list_head *, struct se_cmd *);
 
 /* target_core_tpg.c */
+extern struct spinlock g_tpg_lock;
 extern struct se_device *g_lun0_dev;
 extern struct configfs_attribute *core_tpg_attrib_attrs[];
 
@@ -131,6 +132,7 @@ void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
 		const char *initiatorname);
 void core_tpg_del_initiator_node_acl(struct se_node_acl *acl);
+struct se_portal_group *core_get_tpg_by_rtpi(u16 rtpi);
 
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index a409cf1c4ca0..5a81d592530f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -34,7 +34,7 @@ extern struct se_device *g_lun0_dev;
 static u16 g_tpg_count;
 static u16 g_tpg_rtpi_counter = 1;
 static LIST_HEAD(g_tpg_list);
-static DEFINE_SPINLOCK(g_tpg_lock);
+DEFINE_SPINLOCK(g_tpg_lock);
 
 /*	__core_tpg_get_initiator_node_acl():
  *
@@ -476,7 +476,7 @@ static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
 		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
 		 * for 16-bit wrap..
 		 */
-		if (se_tpg->tpg_rtpi == tpg->tpg_rtpi)
+		if (tpg->enabled && se_tpg->tpg_rtpi == tpg->tpg_rtpi)
 			goto again;
 	}
 	list_add(&se_tpg->tpg_list, &g_tpg_list);
@@ -738,12 +738,26 @@ static ssize_t core_tpg_rtpi_show(struct config_item *item, char *page)
 	return sprintf(page, "%#x\n", se_tpg->tpg_rtpi);
 }
 
+struct se_portal_group *
+core_get_tpg_by_rtpi(u16 rtpi)
+{
+	struct se_portal_group *tpg;
+
+	lockdep_assert_held(&g_tpg_lock);
+
+	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
+		if (tpg->enabled && rtpi == tpg->tpg_rtpi)
+			return tpg;
+	}
+
+	return NULL;
+}
+
 static ssize_t core_tpg_rtpi_store(struct config_item *item,
 				   const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
 	struct se_portal_group *tpg;
-	bool rtpi_changed = false;
 	u16 val;
 	int ret;
 
@@ -753,11 +767,14 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 	if (val == 0)
 		return -EINVAL;
 
-	/* RTPI shouldn't conflict with values of existing ports */
+	if (se_tpg->tpg_rtpi == val)
+		return count;
+
 	spin_lock(&g_tpg_lock);
 
-	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
-		if (se_tpg != tpg && val == tpg->tpg_rtpi) {
+	if (se_tpg->enabled) {
+		tpg = core_get_tpg_by_rtpi(val);
+		if (tpg) {
 			spin_unlock(&g_tpg_lock);
 			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
 			       se_tpg->se_tpg_tfo->fabric_name,
@@ -769,17 +786,12 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 		}
 	}
 
-	if (se_tpg->tpg_rtpi != val) {
-		se_tpg->tpg_rtpi = val;
-		rtpi_changed = true;
-	}
+	se_tpg->tpg_rtpi = val;
 	spin_unlock(&g_tpg_lock);
 
-	if (rtpi_changed)
-		core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
-	ret = count;
+	core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
 
-	return ret;
+	return count;
 }
 
 CONFIGFS_ATTR(core_tpg_, rtpi);
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E005C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 10:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiJFKvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 06:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiJFKvO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 06:51:14 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EB498368;
        Thu,  6 Oct 2022 03:51:10 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E15A541221;
        Thu,  6 Oct 2022 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1665053467; x=1666867868; bh=PzgWVbyKmAcHgJCZlh5TsgKD4
        WtoO+6avzOx/wAmUgY=; b=WRT9rInX9ExC75d2+12yLTpOYqVPie1KJXhLxjcGX
        1vfq9klf0gZsWlmlhoxBQlbC1Jt/bvpFpAP2aR7SBu1txm30mTLcIf3k/s7kWCxU
        kaJknJQnrYs2FqmshnvCpM0c74tZrHwWtJj/8GrjQMrd2xppbGx42ni3daylCbCw
        8A=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ioadTTKKPiQf; Thu,  6 Oct 2022 13:51:07 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A5EFC41222;
        Thu,  6 Oct 2022 13:51:07 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 6 Oct 2022 13:51:06 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 6 Oct 2022 13:51:06 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 1/5] scsi: target: core: Add RTPI field to target port
Date:   Thu, 6 Oct 2022 13:50:53 +0300
Message-ID: <20221006105057.30184-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221006105057.30184-1-d.bogdanov@yadro.com>
References: <20221006105057.30184-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
as unique across SCSI target ports.

The change introduces RTPI attribute to se_portal group. The value is
unique across all enabled SCSI target ports. It also limits number of
SCSI target ports to 65535.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 v2:
   rewrite using XArray to track usage of RTPI
---
 drivers/target/target_core_fabric_configfs.c |  5 +--
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_tpg.c             | 37 ++++++++++++++++++++
 include/target/target_core_base.h            |  2 ++
 4 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 95a88f6224cd..c3a41d4d646b 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -836,12 +836,9 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
 	if (se_tpg->enabled == op)
 		return count;
 
-	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
+	ret = core_tpg_enable(se_tpg, op);
 	if (ret)
 		return ret;
-
-	se_tpg->enabled = op;
-
 	return count;
 }
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 30fcf69e1a1d..fb699f336736 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -131,6 +131,7 @@ void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
 		const char *initiatorname);
 void core_tpg_del_initiator_node_acl(struct se_node_acl *acl);
+int core_tpg_enable(struct se_portal_group *se_tpg, bool enable);
 
 /* target_core_transport.c */
 int	init_se_kmem_caches(void);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..572241eca564 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -31,6 +31,7 @@
 #include "target_core_ua.h"
 
 extern struct se_device *g_lun0_dev;
+DEFINE_XARRAY_ALLOC(tpg_xa);
 
 /*	__core_tpg_get_initiator_node_acl():
  *
@@ -439,6 +440,40 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 	complete(&lun->lun_shutdown_comp);
 }
 
+static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
+{
+	return xa_alloc(&tpg_xa, &se_tpg->tpg_rtpi, se_tpg,
+			       XA_LIMIT(1, USHRT_MAX), GFP_KERNEL);
+}
+
+static void core_tpg_deregister_rtpi(struct se_portal_group *se_tpg)
+{
+	if (se_tpg->tpg_rtpi && se_tpg->enabled)
+		xa_erase(&tpg_xa, se_tpg->tpg_rtpi);
+}
+
+int core_tpg_enable(struct se_portal_group *se_tpg, bool enable)
+{
+	int ret;
+
+	if (enable) {
+		ret = core_tpg_register_rtpi(se_tpg);
+		if (ret)
+			return ret;
+	} else {
+		core_tpg_deregister_rtpi(se_tpg);
+	}
+	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, enable);
+	if (ret) {
+		core_tpg_deregister_rtpi(se_tpg);
+		return ret;
+	}
+
+	se_tpg->enabled = enable;
+
+	return 0;
+}
+
 /* Does not change se_wwn->priv. */
 int core_tpg_register(
 	struct se_wwn *se_wwn,
@@ -535,6 +570,8 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
 	}
 
+	core_tpg_deregister_rtpi(se_tpg);
+
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8c920456edd9..261c5f5228de 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -903,6 +903,8 @@ struct se_portal_group {
 	 */
 	int			proto_id;
 	bool			enabled;
+	/* RELATIVE TARGET PORT IDENTIFIER */
+	u32			tpg_rtpi;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD0FC47088
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 12:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiLBMMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 07:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiLBMMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 07:12:01 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D144CD293E;
        Fri,  2 Dec 2022 04:11:57 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0C39C4014D;
        Fri,  2 Dec 2022 12:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1669983114; x=1671797515; bh=/6z+jdDCe65Pmr9jAU+bKTJYI
        wDI3u/pQxxMm7WO0SU=; b=pWXCEFwUjxjXZ/yihlca6404Iu8+8L9gMWRxHMShc
        dTQ7Xa6m95d5SiFLHXYuYbchzb4QoIqFRXSpl25+mrsNH7pHnuUiLvZlvBSU1QXC
        8R5es4yvtIn5syS40n9swEK9M+B7vTWRB6RkA+F7emIVenAcKTmkTmrsnxXO7X2E
        S8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t5Vs8IopZR0w; Fri,  2 Dec 2022 15:11:54 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BF69540311;
        Fri,  2 Dec 2022 15:11:54 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 2 Dec 2022 15:11:54 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 2 Dec 2022 15:11:53 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v3 1/5] scsi: target: core: Add RTPI field to target port
Date:   Fri, 2 Dec 2022 15:11:35 +0300
Message-ID: <20221202121139.28180-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202121139.28180-1-d.bogdanov@yadro.com>
References: <20221202121139.28180-1-d.bogdanov@yadro.com>
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
  v3:
    make variable static
    change core_ prefix to target_
    split to tpg_enable/tpg_disable functions

 v2:
   rewrite using XArray to track usage of RTPI
---
 drivers/target/target_core_fabric_configfs.c |  9 ++--
 drivers/target/target_core_internal.h        |  2 +
 drivers/target/target_core_tpg.c             | 47 ++++++++++++++++++++
 include/target/target_core_base.h            |  2 +
 4 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 67b18a67317a..873da49ab704 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -836,13 +836,12 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
 
 	if (se_tpg->enabled == op)
 		return count;
-
-	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
+	if (op)
+		ret = target_tpg_enable(se_tpg);
+	else
+		ret = target_tpg_disable(se_tpg);
 	if (ret)
 		return ret;
-
-	se_tpg->enabled = op;
-
 	return count;
 }
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 30fcf69e1a1d..3e720a35567c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -131,6 +131,8 @@ void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
 		const char *initiatorname);
 void core_tpg_del_initiator_node_acl(struct se_node_acl *acl);
+int target_tpg_enable(struct se_portal_group *se_tpg);
+int target_tpg_disable(struct se_portal_group *se_tpg);
 
 /* target_core_transport.c */
 int	init_se_kmem_caches(void);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..5c8794a264aa 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -31,6 +31,7 @@
 #include "target_core_ua.h"
 
 extern struct se_device *g_lun0_dev;
+static DEFINE_XARRAY_ALLOC(tpg_xa);
 
 /*	__core_tpg_get_initiator_node_acl():
  *
@@ -439,6 +440,50 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 	complete(&lun->lun_shutdown_comp);
 }
 
+static int target_tpg_register_rtpi(struct se_portal_group *se_tpg)
+{
+	return xa_alloc(&tpg_xa, &se_tpg->tpg_rtpi, se_tpg,
+			       XA_LIMIT(1, USHRT_MAX), GFP_KERNEL);
+}
+
+static void target_tpg_deregister_rtpi(struct se_portal_group *se_tpg)
+{
+	if (se_tpg->tpg_rtpi && se_tpg->enabled)
+		xa_erase(&tpg_xa, se_tpg->tpg_rtpi);
+}
+
+int target_tpg_enable(struct se_portal_group *se_tpg)
+{
+	int ret;
+
+	ret = target_tpg_register_rtpi(se_tpg);
+	if (ret)
+		return ret;
+
+	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, true);
+	if (ret) {
+		target_tpg_deregister_rtpi(se_tpg);
+		return ret;
+	}
+
+	se_tpg->enabled = true;
+
+	return 0;
+}
+
+int target_tpg_disable(struct se_portal_group *se_tpg)
+{
+	int ret;
+
+	target_tpg_deregister_rtpi(se_tpg);
+
+	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, false);
+
+	se_tpg->enabled = false;
+
+	return 0;
+}
+
 /* Does not change se_wwn->priv. */
 int core_tpg_register(
 	struct se_wwn *se_wwn,
@@ -535,6 +580,8 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
 	}
 
+	target_tpg_deregister_rtpi(se_tpg);
+
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..60ada63c4e04 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -920,6 +920,8 @@ struct se_portal_group {
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


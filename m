Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6837C6FA8B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 16:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiIFQRx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbiIFQRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 12:17:19 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5DE72841;
        Tue,  6 Sep 2022 08:45:46 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4C4FA448FE;
        Tue,  6 Sep 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662479143; x=1664293544; bh=ehDtVd9hnTHEU4OcOjkyIEkQ0
        K+o92F+4FL2C6fYTpY=; b=ZGMEfFVulyr8k2BkFSgSKig9BmlWhevZ7+IDzgeEg
        W4MhBJcVm2l84SntBdU/T6axDEEIoacI/RDlateN9mXi9X5ciS7pb9qZ9eP5Utge
        aG97HyFeI0QtMfDeTLvw5/Y4+BeeL6H+ZmajHGzalSAiwiQ0+mDlCM79lEhzSSDt
        nM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fbpNDPr3j0mz; Tue,  6 Sep 2022 18:45:43 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D5E1643EDA;
        Tue,  6 Sep 2022 18:45:41 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 18:45:41 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 18:45:40 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 2/7] scsi: target: core: Add RTPI field to target port
Date:   Tue, 6 Sep 2022 18:45:14 +0300
Message-ID: <20220906154519.27487-3-d.bogdanov@yadro.com>
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

SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
as unique across SCSI target ports.

The change introduces RTPI attribute to se_portal group. The value is
auto-incremented and unique across all SCSI target ports. It also limits
number of SCSI target ports to 65535.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_tpg.c  | 78 +++++++++++++++++++++++++++++--
 include/target/target_core_base.h |  4 ++
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index f0d38d77edcc..325ef439fb42 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -31,6 +31,10 @@
 #include "target_core_ua.h"
 
 extern struct se_device *g_lun0_dev;
+static u16 g_tpg_count;
+static u16 g_tpg_rtpi_counter = 1;
+static LIST_HEAD(g_tpg_list);
+static DEFINE_SPINLOCK(g_tpg_lock);
 
 /*	__core_tpg_get_initiator_node_acl():
  *
@@ -439,6 +443,57 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 	complete(&lun->lun_shutdown_comp);
 }
 
+static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
+{
+	struct se_portal_group *tpg;
+
+	/*
+	 * Allocate the next RELATIVE TARGET PORT IDENTIFIER.
+	 * Here is the table from SPC-4 4.3.4:
+	 *
+	 *    Table 34 -- Relative target port identifier values
+	 *
+	 * Value		Description
+	 * 0h			Reserved
+	 * 1h			Relative port 1, historically known as port A
+	 * 2h			Relative port 2, historically known as port B
+	 * 3h to FFFFh		Relative port 3 through 65 535
+	 */
+	spin_lock(&g_tpg_lock);
+
+	if (g_tpg_count == 0xffff) {
+		spin_unlock(&g_tpg_lock);
+		pr_warn("Reached g_tpg_count == 0xffff\n");
+		return -ENOSPC;
+	}
+again:
+	se_tpg->tpg_rtpi = g_tpg_rtpi_counter++;
+	if (!se_tpg->tpg_rtpi)
+		goto again;
+
+	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
+		/*
+		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
+		 * for 16-bit wrap..
+		 */
+		if (se_tpg->tpg_rtpi == tpg->tpg_rtpi)
+			goto again;
+	}
+	list_add(&se_tpg->tpg_list, &g_tpg_list);
+	g_tpg_count++;
+	spin_unlock(&g_tpg_lock);
+
+	return 0;
+}
+
+static void core_tpg_deregister_rtpi(struct se_portal_group *se_tpg)
+{
+	spin_lock(&g_tpg_lock);
+	list_del(&se_tpg->tpg_list);
+	g_tpg_count--;
+	spin_unlock(&g_tpg_lock);
+}
+
 /* Does not change se_wwn->priv. */
 int core_tpg_register(
 	struct se_wwn *se_wwn,
@@ -471,6 +526,7 @@ int core_tpg_register(
 	se_tpg->proto_id = proto_id;
 	se_tpg->se_tpg_wwn = se_wwn;
 	atomic_set(&se_tpg->tpg_pr_ref_count, 0);
+	INIT_LIST_HEAD(&se_tpg->tpg_list);
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->session_lock);
@@ -478,9 +534,15 @@ int core_tpg_register(
 	mutex_init(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->proto_id >= 0) {
+		ret = core_tpg_register_rtpi(se_tpg);
+		if (ret < 0)
+			return ret;
+
 		se_tpg->tpg_virt_lun0 = core_tpg_alloc_lun(se_tpg, 0);
-		if (IS_ERR(se_tpg->tpg_virt_lun0))
-			return PTR_ERR(se_tpg->tpg_virt_lun0);
+		if (IS_ERR(se_tpg->tpg_virt_lun0)) {
+			ret = PTR_ERR(se_tpg->tpg_virt_lun0);
+			goto out_deregister_rtpi;
+		}
 
 		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
 				true, g_lun0_dev);
@@ -488,16 +550,20 @@ int core_tpg_register(
 			goto out_free_lun0;
 	}
 
-	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
-		 "Proto: %d, Portal Tag: %u\n", se_tpg->se_tpg_tfo->fabric_name,
+	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, Proto: %d, Portal Tag: %u, RTPI: %#2x\n",
+		se_tpg->se_tpg_tfo->fabric_name,
 		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
 		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
-		se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
+		se_tpg->proto_id,
+		se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
+		se_tpg->tpg_rtpi);
 
 	return 0;
 
 out_free_lun0:
 	kfree(se_tpg->tpg_virt_lun0);
+out_deregister_rtpi:
+	core_tpg_deregister_rtpi(se_tpg);
 	return ret;
 }
 EXPORT_SYMBOL(core_tpg_register);
@@ -535,6 +601,8 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	if (se_tpg->proto_id >= 0) {
 		core_tpg_remove_lun(se_tpg, se_tpg->tpg_virt_lun0);
 		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
+
+		core_tpg_deregister_rtpi(se_tpg);
 	}
 
 	return 0;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 28cce4ed3f0e..08e76e400816 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -904,6 +904,8 @@ struct se_portal_group {
 	 */
 	int			proto_id;
 	bool			enabled;
+	/* RELATIVE TARGET PORT IDENTIFIER */
+	u16			tpg_rtpi;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
@@ -911,6 +913,8 @@ struct se_portal_group {
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
 	struct mutex		tpg_lun_mutex;
+	/* List of all SCSI target ports */
+	struct list_head	tpg_list;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
 	struct hlist_head	tpg_lun_hlist;
-- 
2.25.1


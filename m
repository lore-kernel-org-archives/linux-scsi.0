Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05D3C83004
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83FD20775
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="d+0wcIDt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgD2Jpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39888 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbgD2Jpi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:38 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E080A4C85A;
        Wed, 29 Apr 2020 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153530; x=1589967931; bh=I/yPUsXqSUXPdD2iCTvxKnOd4AtDrGs8n6p
        rVEZDENM=; b=d+0wcIDtTkcqIH3jJYJAhYO8L9REswYIAhXAHEh3LwPb/QjuHQ0
        0FSAxXNHeJ/+tBzJvZDLBmiXszyuOLVYiyEprbEwusj8cvK7X0IbYiZuiMfkuMf1
        +KzSQxEHcgGeg4zZFByvINAJXTN/WKFqFjElvYJLJUoj3SyHwY7LM7Q4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eyXC2O3c-83K; Wed, 29 Apr 2020 12:45:30 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E18E74C84B;
        Wed, 29 Apr 2020 12:45:28 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:30 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 09/11] scsi: target/core: Populate configfs for peer ports
Date:   Wed, 29 Apr 2020 12:44:42 +0300
Message-ID: <20200429094443.43937-10-r.bolshakov@yadro.com>
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

TCM can't report about ports of peer node in REPORT TARGET PORT GROUPS
command if TCM is used in a cluster. The change introduces a way to
store information about such ports in configfs.

Each port group except default_tg_pt_gp has "peers" subdirectory. It can
be used to store RTPI (RELATIVE TARGET PORT IDENTIFIER) of SCSI target
ports that reside on peer nodes:

  mkdir $BACKSTORE/alua/pg1/peers/$RTPI

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_alua.c      |  1 +
 drivers/target/target_core_alua.h      |  1 +
 drivers/target/target_core_configfs.c  | 86 ++++++++++++++++++++++++++
 drivers/target/target_core_transport.c | 15 ++++-
 include/target/target_core_base.h      |  8 +++
 5 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 8053f3989bbb..81ed79500376 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1650,6 +1650,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 	}
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_lun_list);
+	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_peer_list);
 	mutex_init(&tg_pt_gp->tg_pt_gp_transition_mutex);
 	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
 	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index fc9637cce825..bc6d47ed93e8 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -79,6 +79,7 @@
 extern struct kmem_cache *t10_alua_lu_gp_cache;
 extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
+extern struct kmem_cache *t10_alua_tg_pt_gp_peer_cache;
 extern struct kmem_cache *t10_alua_lba_map_cache;
 extern struct kmem_cache *t10_alua_lba_map_mem_cache;
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3311d29ecad8..803e968659e3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3078,6 +3078,87 @@ static const struct config_item_type target_core_alua_tg_pt_gp_cit = {
 	.ct_owner		= THIS_MODULE,
 };
 
+static void target_core_alua_tg_pt_gp_peer_release(struct config_item *item)
+{
+	struct t10_alua_tg_pt_gp_peer *peer_port = container_of(item,
+			struct t10_alua_tg_pt_gp_peer, tg_pt_gp_peer_item);
+	kmem_cache_free(t10_alua_tg_pt_gp_peer_cache, peer_port);
+}
+
+static struct configfs_item_operations target_core_alua_tg_pt_gp_peer_ops = {
+	.release		= target_core_alua_tg_pt_gp_peer_release,
+};
+
+static struct config_item_type target_core_alua_tg_pt_gp_peer_cit = {
+	.ct_item_ops		= &target_core_alua_tg_pt_gp_peer_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+static struct config_item *
+target_core_alua_tg_pt_gp_peers_make(struct config_group *group,
+				     const char *name)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(group,
+			struct t10_alua_tg_pt_gp, tg_pt_gp_peers_group);
+	struct t10_alua_tg_pt_gp_peer *peer_port;
+	u16 val;
+	int ret;
+
+	peer_port = kmem_cache_zalloc(t10_alua_tg_pt_gp_peer_cache, GFP_KERNEL);
+	if (!peer_port) {
+		pr_err("Unable to allocate struct t10_alua_tg_pt_gp_peer\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	INIT_LIST_HEAD(&peer_port->tg_pt_gp_peer_list);
+
+	ret = kstrtou16(name, 0, &val);
+	if (ret < 0)
+		goto out_free;
+	if (!val) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	peer_port->tg_pt_gp_peer_rtpi = val;
+	config_item_init_type_name(&peer_port->tg_pt_gp_peer_item,
+				   name,
+				   &target_core_alua_tg_pt_gp_peer_cit);
+
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	list_add_tail(&peer_port->tg_pt_gp_peer_list,
+		      &tg_pt_gp->tg_pt_gp_peer_list);
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+
+	return &peer_port->tg_pt_gp_peer_item;
+out_free:
+	kfree(peer_port);
+	return ERR_PTR(ret);
+}
+
+static void target_core_alua_tg_pt_gp_peers_drop(struct config_group *group,
+						 struct config_item *item)
+{
+	struct t10_alua_tg_pt_gp_peer *peer_port = container_of(item,
+			struct t10_alua_tg_pt_gp_peer, tg_pt_gp_peer_item);
+	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(group,
+			struct t10_alua_tg_pt_gp, tg_pt_gp_peers_group);
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	list_del(&peer_port->tg_pt_gp_peer_list);
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+
+	config_item_put(item);
+}
+
+static struct configfs_group_operations target_core_alua_tg_pt_gp_peers_ops = {
+	.make_item		= &target_core_alua_tg_pt_gp_peers_make,
+	.drop_item		= &target_core_alua_tg_pt_gp_peers_drop,
+};
+
+static struct config_item_type target_core_alua_tg_pt_gp_peers_cit = {
+	.ct_group_ops		= &target_core_alua_tg_pt_gp_peers_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
 /* End functions for struct config_item_type target_core_alua_tg_pt_gp_cit */
 
 /* Start functions for struct config_item_type tb_alua_tg_pt_gps_cit */
@@ -3101,6 +3182,11 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 
 	config_group_init_type_name(alua_tg_pt_gp_cg, name,
 			&target_core_alua_tg_pt_gp_cit);
+	config_group_init_type_name(&tg_pt_gp->tg_pt_gp_peers_group,
+				    "peers",
+				    &target_core_alua_tg_pt_gp_peers_cit);
+	configfs_add_default_group(&tg_pt_gp->tg_pt_gp_peers_group,
+				   alua_tg_pt_gp_cg);
 
 	pr_debug("Target_Core_ConfigFS: Allocated ALUA Target Port"
 		" Group: alua/tg_pt_gps/%s\n",
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..c3b77b504143 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -47,6 +47,7 @@ struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
 struct kmem_cache *t10_alua_lu_gp_mem_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_cache;
+struct kmem_cache *t10_alua_tg_pt_gp_peer_cache;
 struct kmem_cache *t10_alua_lba_map_cache;
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
@@ -105,6 +106,15 @@ int init_se_kmem_caches(void)
 				"cache failed\n");
 		goto out_free_lu_gp_mem_cache;
 	}
+	t10_alua_tg_pt_gp_peer_cache = kmem_cache_create(
+			"t10_alua_tg_pt_gp_peer_cache",
+			sizeof(struct t10_alua_tg_pt_gp_peer),
+			__alignof__(struct t10_alua_tg_pt_gp_peer), 0, NULL);
+	if (!t10_alua_tg_pt_gp_peer_cache) {
+		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_peer_cache"
+		       " failed\n");
+		goto out_free_tg_pt_gp_cache;
+	}
 	t10_alua_lba_map_cache = kmem_cache_create(
 			"t10_alua_lba_map_cache",
 			sizeof(struct t10_alua_lba_map),
@@ -112,7 +122,7 @@ int init_se_kmem_caches(void)
 	if (!t10_alua_lba_map_cache) {
 		pr_err("kmem_cache_create() for t10_alua_lba_map_"
 				"cache failed\n");
-		goto out_free_tg_pt_gp_cache;
+		goto out_free_tg_pt_gp_peer_cache;
 	}
 	t10_alua_lba_map_mem_cache = kmem_cache_create(
 			"t10_alua_lba_map_mem_cache",
@@ -135,6 +145,8 @@ int init_se_kmem_caches(void)
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 out_free_lba_map_cache:
 	kmem_cache_destroy(t10_alua_lba_map_cache);
+out_free_tg_pt_gp_peer_cache:
+	kmem_cache_destroy(t10_alua_tg_pt_gp_peer_cache);
 out_free_tg_pt_gp_cache:
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 out_free_lu_gp_mem_cache:
@@ -160,6 +172,7 @@ void release_se_kmem_caches(void)
 	kmem_cache_destroy(t10_alua_lu_gp_cache);
 	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
+	kmem_cache_destroy(t10_alua_tg_pt_gp_peer_cache);
 	kmem_cache_destroy(t10_alua_lba_map_cache);
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index cde2f986e9c0..b4801d3f6bec 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -301,12 +301,20 @@ struct t10_alua_tg_pt_gp {
 	struct mutex tg_pt_gp_transition_mutex;
 	struct se_device *tg_pt_gp_dev;
 	struct config_group tg_pt_gp_group;
+	struct config_group tg_pt_gp_peers_group;
 	struct list_head tg_pt_gp_list;
 	struct list_head tg_pt_gp_lun_list;
+	struct list_head tg_pt_gp_peer_list;
 	struct se_lun *tg_pt_gp_alua_lun;
 	struct se_node_acl *tg_pt_gp_alua_nacl;
 };
 
+struct t10_alua_tg_pt_gp_peer {
+	u16    tg_pt_gp_peer_rtpi;
+	struct config_item tg_pt_gp_peer_item;
+	struct list_head tg_pt_gp_peer_list;
+};
+
 struct t10_vpd {
 	unsigned char device_identifier[INQUIRY_VPD_DEVICE_IDENTIFIER_LEN];
 	int protocol_identifier_set;
-- 
2.26.1


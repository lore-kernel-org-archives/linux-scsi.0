Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC73C6FD1E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjCGIId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCGII2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:08:28 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC30C7283;
        Tue,  7 Mar 2023 00:07:55 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id AF2F4341EB0;
        Tue,  7 Mar 2023 11:07:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=d5NpFgk/odjS1rUJmA
        7AcC2xftoy2oCWQyNfpUpzt4M=; b=pcho8Tn2fArdb5wY/VMACiMUP+5trYHe/+
        DjF1zZXnZxolzoKjfiE3E0o0ur8kbiJAmPB0/4yQvQlcRUduF4Tz0zOtq/Z9eC4P
        0v+xsvziP6OcIBwyV9QsVpsUBr6gpYwxqC3da79yguBcAq/Di5PDfqgAYwC9iqR1
        0QpJrwRqE=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id A45BB341E00;
        Tue,  7 Mar 2023 11:07:50 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:50 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 01/12] scsi: target: add default fabric ops callaouts
Date:   Tue, 7 Mar 2023 11:07:31 +0300
Message-ID: <20230307080742.24631-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307080742.24631-1-d.bogdanov@yadro.com>
References: <20230307080742.24631-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are several callout in target fabric ops that most of fabric
drivers fills with a function returning the same value.

Stop requiring such callaouts to exist in the ops, fill them in
TCM Core.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c | 94 +++++++++++++++++----------
 1 file changed, 61 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 611b0424e305..74b67c346dfe 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -335,6 +335,29 @@ EXPORT_SYMBOL(target_undepend_item);
 /*##############################################################################
 // Start functions called by external Target Fabrics Modules
 //############################################################################*/
+static int target_disable_feature(struct se_portal_group *se_tpg)
+{
+	return 0;
+}
+
+static u32 target_default_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static u32 target_default_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static void target_set_default_node_attributes(struct se_node_acl *se_acl)
+{
+}
+
+static int target_default_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return 0;
+}
 
 static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 {
@@ -362,46 +385,14 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 		pr_err("Missing tfo->tpg_get_tag()\n");
 		return -EINVAL;
 	}
-	if (!tfo->tpg_check_demo_mode) {
-		pr_err("Missing tfo->tpg_check_demo_mode()\n");
-		return -EINVAL;
-	}
-	if (!tfo->tpg_check_demo_mode_cache) {
-		pr_err("Missing tfo->tpg_check_demo_mode_cache()\n");
-		return -EINVAL;
-	}
-	if (!tfo->tpg_check_demo_mode_write_protect) {
-		pr_err("Missing tfo->tpg_check_demo_mode_write_protect()\n");
-		return -EINVAL;
-	}
-	if (!tfo->tpg_check_prod_mode_write_protect) {
-		pr_err("Missing tfo->tpg_check_prod_mode_write_protect()\n");
-		return -EINVAL;
-	}
-	if (!tfo->tpg_get_inst_index) {
-		pr_err("Missing tfo->tpg_get_inst_index()\n");
-		return -EINVAL;
-	}
 	if (!tfo->release_cmd) {
 		pr_err("Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
-	if (!tfo->sess_get_index) {
-		pr_err("Missing tfo->sess_get_index()\n");
-		return -EINVAL;
-	}
 	if (!tfo->write_pending) {
 		pr_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
 	}
-	if (!tfo->set_default_node_attributes) {
-		pr_err("Missing tfo->set_default_node_attributes()\n");
-		return -EINVAL;
-	}
-	if (!tfo->get_cmd_state) {
-		pr_err("Missing tfo->get_cmd_state()\n");
-		return -EINVAL;
-	}
 	if (!tfo->queue_data_in) {
 		pr_err("Missing tfo->queue_data_in()\n");
 		return -EINVAL;
@@ -447,8 +438,36 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 	return 0;
 }
 
+static void target_set_default_ops(struct target_core_fabric_ops *tfo)
+{
+	if (!tfo->tpg_check_demo_mode)
+		tfo->tpg_check_demo_mode = target_disable_feature;
+
+	if (!tfo->tpg_check_demo_mode_cache)
+		tfo->tpg_check_demo_mode_cache = target_disable_feature;
+
+	if (!tfo->tpg_check_demo_mode_write_protect)
+		tfo->tpg_check_demo_mode_write_protect = target_disable_feature;
+
+	if (!tfo->tpg_check_prod_mode_write_protect)
+		tfo->tpg_check_prod_mode_write_protect = target_disable_feature;
+
+	if (!tfo->tpg_get_inst_index)
+		tfo->tpg_get_inst_index = target_default_get_inst_index;
+
+	if (!tfo->sess_get_index)
+		tfo->sess_get_index = target_default_sess_get_index;
+
+	if (!tfo->set_default_node_attributes)
+		tfo->set_default_node_attributes = target_set_default_node_attributes;
+
+	if (!tfo->get_cmd_state)
+		tfo->get_cmd_state = target_default_get_cmd_state;
+}
+
 int target_register_template(const struct target_core_fabric_ops *fo)
 {
+	struct target_core_fabric_ops *tfo;
 	struct target_fabric_configfs *tf;
 	int ret;
 
@@ -461,10 +480,18 @@ int target_register_template(const struct target_core_fabric_ops *fo)
 		pr_err("%s: could not allocate memory!\n", __func__);
 		return -ENOMEM;
 	}
+	tfo = kzalloc(sizeof(struct target_core_fabric_ops), GFP_KERNEL);
+	if (!tfo) {
+		kfree(tf);
+		pr_err("%s: could not allocate memory!\n", __func__);
+		return -ENOMEM;
+	}
+	memcpy(tfo, fo, sizeof(*tfo));
+	target_set_default_ops(tfo);
 
 	INIT_LIST_HEAD(&tf->tf_list);
 	atomic_set(&tf->tf_access_cnt, 0);
-	tf->tf_ops = fo;
+	tf->tf_ops = tfo;
 	target_fabric_setup_cits(tf);
 
 	mutex_lock(&g_tf_lock);
@@ -492,6 +519,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
 			 */
 			rcu_barrier();
 			kfree(t->tf_tpg_base_cit.ct_attrs);
+			kfree(t->tf_ops);
 			kfree(t);
 			return;
 		}
-- 
2.25.1



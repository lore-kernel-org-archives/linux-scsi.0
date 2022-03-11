Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EAEC25B07
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiHCQcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbiHCQbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:31:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E82D6348;
        Wed,  3 Aug 2022 09:30:15 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C9E704137B;
        Wed,  3 Aug 2022 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544212; x=1661358613; bh=Wot/84Y8dChAbb4bp4eHumjPs
        XKgO/6Gr7sNnnEq4MA=; b=U437+bpn7GZM34qWNg8dPwEXrGs5VJTTVxCzxVRQn
        zgl1p3CE/rGMCe12mag5Y6MB2GFehZcqf4IPyMOQn4+THfRX0Q1kV9buIILhX51G
        qvp/csQPAnFLu8rS7k6ZWPXjAsmpG3Gsjwmt52R6WMID2TQ+9M+S9DV8fidkfrXP
        gk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BQh7v7g582Ze; Wed,  3 Aug 2022 19:30:12 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C7BF9412C5;
        Wed,  3 Aug 2022 19:29:26 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:26 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:26 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 46/48] target: cluster: implement LUN reset in DLM cluster
Date:   Fri, 11 Mar 2022 12:30:19 +0300
Message-ID: <20220803162857.27770-47-d.bogdanov@yadro.com>
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

Since LUN RESET clears SCSI2 Reservation (cluster wide data of
persistence reservation status) make LUN RESET just one of reasons to
update the Persistence Reservation status as well as Service Actions of
PR OUT.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c   | 31 ++++++++++++++++++++++++++-
 drivers/target/target_core_device.c   |  1 +
 drivers/target/target_core_internal.h |  1 -
 include/target/target_core_base.h     |  2 +-
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 91f8ffc7ad2f..546e28062b8f 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -99,6 +99,9 @@ struct async_group {
 	struct completion compl;
 };
 
+#define PR_SYNC_REASON_RESERVE	10
+#define PR_SYNC_REASON_RESET	11
+
 static void target_pr_sync_cb(void *arg);
 static void target_nodeleft_cb(void *arg, int nodeid);
 static int pr_reg_realloc(struct target_cluster_data *cluster_data,
@@ -842,6 +845,15 @@ static void target_pr_sync_cb(void *arg)
 					pr_reg_res_holder);
 	}
 
+	if (pr_data.pro_sa == PR_SYNC_REASON_RESET) {
+		core_local_lun_reset(dev, NULL, NULL, NULL);
+
+		target_dev_ua_allocate(dev, 0x29,
+				ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
+
+		atomic_long_inc(&dev->num_resets);
+	}
+
 	core_scsi3_update_and_write_aptpl(dev, dev->t10_pr.pr_aptpl_active);
 
 done:
@@ -863,7 +875,23 @@ target_spc2_reserve(struct se_device *dev, struct se_session *sess)
 		cluster_data->reserved_node_id = 0;
 	}
 
-	target_pr_sync_dlm(dev, -1);
+	target_pr_sync_dlm(dev, PR_SYNC_REASON_RESERVE);
+	target_pr_unlock_dlm(dev);
+}
+
+static void
+target_dlm_lun_reset(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+
+	target_pr_lock_dlm(dev);
+	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
+		target_release_reservation(dev);
+		cluster_data->reserved_node_id = 0;
+		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
+	}
+
+	target_pr_sync_dlm(dev, PR_SYNC_REASON_RESET);
 	target_pr_unlock_dlm(dev);
 }
 
@@ -894,6 +922,7 @@ const struct target_cluster_ops dlm_cluster_ops = {
 	.pr_unlock = target_pr_unlock_dlm,
 	.pr_sync = target_pr_sync_dlm,
 	.reserve = target_spc2_reserve,
+	.reset = target_dlm_lun_reset,
 };
 
 static int __init target_cluster_dlm_module_init(void)
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7d0d889961c2..6fe9f40b86f5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -375,6 +375,7 @@ void target_dev_ua_allocate(struct se_device *dev, u8 asc, u8 ascq)
 	}
 	spin_unlock(&dev->se_port_lock);
 }
+EXPORT_SYMBOL(target_dev_ua_allocate);
 
 static void
 target_luns_data_has_changed(struct se_node_acl *nacl, struct se_dev_entry *new,
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index fc7c2a9d9507..7c495dddcb4b 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -93,7 +93,6 @@ int	target_configure_device(struct se_device *dev);
 void	target_free_device(struct se_device *);
 int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 			       void *data);
-void	target_dev_ua_allocate(struct se_device *dev, u8 asc, u8 ascq);
 
 /* target_core_configfs.c */
 extern struct configfs_item_operations target_core_dev_item_ops;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c8900da705b6..4dad7837f603 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -1013,6 +1013,6 @@ int target_cmp_pr_transport_id(struct t10_pr_registration *pr_reg,
 void	target_pr_kref_release(struct kref *kref);
 void	core_local_lun_reset(struct se_device *swc, struct se_tmr_req *tmr,
 		struct list_head *preempt_and_abort_list, struct se_cmd *prout_cmd);
-
+void	target_dev_ua_allocate(struct se_device *dev, u8 asc, u8 ascq);
 
 #endif /* TARGET_CORE_BASE_H */
-- 
2.25.1


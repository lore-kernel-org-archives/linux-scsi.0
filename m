Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52F9C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiHCQbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbiHCQa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:30:58 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DA04F6A7;
        Wed,  3 Aug 2022 09:30:09 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B40E74137B;
        Wed,  3 Aug 2022 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544206; x=1661358607; bh=IxlaNYqM1m4BES/XxCSOI3nqy
        Jy6bGDMyNjTNNedogQ=; b=Te+cy6/K+xpI46IdSTE9m+NapWoWuMWVonQ3LW6DI
        GX1A2R+aW6Byurm/VDe3Hr14flM8yNeTooa3qms6Yo1qS2ZZ9lO9x4sDlNDD8qCd
        7eTztDa6ZZSnTniqt6XshTXENy3ZjsAPSzn/p9FTE2b5x60Jw/6NhMrrmEHzUiNv
        rA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id u4JiokXhGnpG; Wed,  3 Aug 2022 19:30:06 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1C6AD412D2;
        Wed,  3 Aug 2022 19:29:25 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:25 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:24 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 43/48] target: cluster: allocate UAs on PR sync
Date:   Mon, 28 Feb 2022 13:37:58 +0300
Message-ID: <20220803162857.27770-44-d.bogdanov@yadro.com>
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

Establish Unit Attention condition on the peer nodes in the cluster on
PR OUT commands according to SPC-4.
Pass PR OUT Service Action to pr_sync to allow peer nodes to know the
reason of the update of PR state.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c | 115 +++++++++++++++++++++++++++-
 drivers/target/target_core_device.c |   7 +-
 drivers/target/target_core_pr.c     |   2 +-
 drivers/target/target_core_ua.c     |   1 +
 include/target/target_core_base.h   |   2 +-
 5 files changed, 121 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 4c4d337e6a1a..cb44f6c0f0ac 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -7,6 +7,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_backend.h>
+#include "target_core_ua.h"
 #include "target_core_pr.h"
 
 #include "dlm_ckv.h"
@@ -78,7 +79,8 @@ struct pr_lvb {
 	u8	pr_type;
 	u8	pr_scope;
 	u8	pr_aptpl;
-	u8	reserved[3];
+	u8	pro_sa;
+	u8	reserved[2];
 	u32	reserved_by_nodeid;
 };
 
@@ -314,7 +316,7 @@ static int pr_reg_realloc(struct target_cluster_data *cluster_data,
 	return res;
 }
 
-static int target_pr_sync_dlm(struct se_device *dev)
+static int target_pr_sync_dlm(struct se_device *dev, u8 pro_sa)
 {
 	struct target_cluster_data *cluster_data = dev->cluster_data;
 	struct t10_pr_registration *pr_reg;
@@ -328,6 +330,7 @@ static int target_pr_sync_dlm(struct se_device *dev)
 
 	pr_data.version = 1;
 	pr_data.pr_generation = atomic_read(&dev->t10_pr.pr_generation);
+	pr_data.pro_sa = pro_sa;
 	pr_data.nr_registrants = target_get_nr_registrants(dev);
 	pr_data.pr_is_set = !!dev->dev_pr_res_holder;
 	pr_data.pr_aptpl = dev->t10_pr.pr_aptpl_active;
@@ -546,6 +549,19 @@ target_create_pr_reg(struct se_device *dev,
 	return NULL;
 }
 
+static void target_allocate_pr_ua(struct se_device *dev, u8 asc)
+{
+	struct t10_pr_registration *pr_reg;
+
+	list_for_each_entry(pr_reg, &dev->t10_pr.registration_list, pr_reg_list) {
+		target_ua_allocate_lun(
+			pr_reg->pr_reg_nacl,
+			pr_reg->pr_res_mapped_lun,
+			0x2A,
+			asc);
+	}
+}
+
 static void target_pr_sync_cb(void *arg)
 {
 	struct se_device *dev = arg;
@@ -558,6 +574,9 @@ static void target_pr_sync_cb(void *arg)
 	struct async_group grp;
 	struct pr_lvb pr_data;
 	bool res_to_delete = false;
+	struct se_node_acl *pr_reg_nacl;
+	u64 pr_res_mapped_lun;
+	bool reg_deleted = false;
 	bool was_held;
 	u8 was_type;
 	u8 was_scope;
@@ -656,10 +675,41 @@ static void target_pr_sync_cb(void *arg)
 	/* deregister obsolete entries */
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &to_be_deleted_list,
 			pr_reg_list) {
+		reg_deleted = true;
+		pr_reg_nacl = pr_reg->pr_reg_nacl;
+		pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
+
 		if (dev->dev_pr_res_holder != pr_reg)
 			__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
 		else
 			res_to_delete = true;
+
+		switch (pr_data.pro_sa) {
+		case PRO_CLEAR:
+			/*
+			 * establish a unit attention condition for the initiator
+			 * port associated with every registered I_T nexus other
+			 * than the I_T nexus on which the PERSISTENT RESERVE OUT
+			 * command with CLEAR service action was received, with
+			 * the additional sense code set to RESERVATIONS PREEMPTED
+			 */
+			target_ua_allocate_lun(pr_reg_nacl,
+					pr_res_mapped_lun, 0x2A,
+					ASCQ_2AH_RESERVATIONS_PREEMPTED);
+			break;
+		case PRO_PREEMPT_AND_ABORT:
+		case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
+			/*
+			 * establish a unit attention condition for the initiator
+			 * port associated with every I_T nexus that lost its
+			 * persistent reservation and/or registration, with the
+			 * additional sense code set to REGISTRATIONS PREEMPTED;
+			 */
+			target_ua_allocate_lun(pr_reg_nacl,
+					pr_res_mapped_lun, 0x2A,
+					ASCQ_2AH_REGISTRATIONS_PREEMPTED);
+			break;
+		}
 	}
 	spin_unlock(&dev->t10_pr.registration_lock);
 
@@ -677,6 +727,65 @@ static void target_pr_sync_cb(void *arg)
 			pr_reg_res_holder = pr_reg;
 	}
 
+	switch (pr_data.pro_sa) {
+	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
+	case PRO_REGISTER:
+		/*
+		 * If the I_T nexus is the reservation holder and the persistent
+		 * reservation is of a type other than all registrants, then
+		 * the device server shall also release the persistent reservation
+		 *
+		 * If the persistent reservation is a registrants only
+		 * type, the device server shall establish a unit
+		 * attention condition for the initiator port associated
+		 * with every registered I_T nexus except for the I_T
+		 * nexus on which the PERSISTENT RESERVE OUT command was
+		 * received, with the additional sense code set to
+		 * RESERVATIONS RELEASED.
+		 */
+		if (reg_deleted && was_held &&
+		    (was_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY ||
+		     was_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY)) {
+			target_allocate_pr_ua(dev,
+				ASCQ_2AH_RESERVATIONS_RELEASED);
+		}
+		break;
+	case PRO_RELEASE:
+		/*
+		 * if the released persistent reservation is either a registrants
+		 * only type or an all registrants type persistent reservation,
+		 * then the device server shall establish a unit attention
+		 * condition for the initiator port associated with every
+		 * registered I_T nexus other than I_T nexus on which the
+		 * PERSISTENT RESERVE OUT command with RELEASE service action was
+		 * received, with the additional sense code set to RESERVATIONS RELEASED
+		 */
+		if ((was_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY) ||
+		    (was_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY) ||
+		    (was_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
+		    (was_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
+			target_allocate_pr_ua(dev,
+				ASCQ_2AH_RESERVATIONS_RELEASED);
+		}
+		break;
+	case PRO_PREEMPT:
+	case PRO_PREEMPT_AND_ABORT:
+		/*
+		 * if the type or scope has changed, then for every I_T nexus
+		 * whose reservation key was not removed, except for the I_T nexus
+		 * on which the PERSISTENT RESERVE OUT command was received, the
+		 * device server shall establish a unit attention condition for
+		 * the initiator port associated with that I_T nexus, with the
+		 * additional sense code set to RESERVATIONS RELEASED. I
+		 */
+		if (pr_prev_res_holder && pr_reg_res_holder &&
+		    pr_prev_res_holder != pr_reg_res_holder &&
+		    (was_type != pr_reg_res_holder->pr_res_type ||
+		     was_scope != pr_reg_res_holder->pr_res_scope))
+			target_allocate_pr_ua(dev, ASCQ_2AH_RESERVATIONS_RELEASED);
+		break;
+	}
+
 	/* update general data */
 	atomic_set(&dev->t10_pr.pr_generation, pr_data.pr_generation);
 	dev->t10_pr.pr_aptpl_active = pr_data.pr_aptpl;
@@ -741,7 +850,7 @@ target_spc2_reserve(struct se_device *dev, struct se_session *sess)
 		cluster_data->reserved_node_id = 0;
 	}
 
-	target_pr_sync_dlm(dev);
+	target_pr_sync_dlm(dev, -1);
 	target_pr_unlock_dlm(dev);
 }
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9f01a28ef72f..4f36d12d2213 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -788,6 +788,11 @@ int target_dummy_nodlm(struct se_device *dev)
 	return 0;
 }
 
+int target_prsync_nodlm(struct se_device *dev, u8 pro_sa)
+{
+	return 0;
+}
+
 static void target_reserve2_nodlm(struct se_device *dev, struct se_session *sess)
 {
 	if (sess) {
@@ -806,7 +811,7 @@ const struct target_cluster_ops nodlm_cluster_ops = {
 	.caw_unlock = target_caw_unlock_nodlm,
 	.pr_lock = target_dummy_nodlm,
 	.pr_unlock = target_dummy_nodlm,
-	.pr_sync = target_dummy_nodlm,
+	.pr_sync = target_prsync_nodlm,
 	.reserve = target_reserve2_nodlm,
 };
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 930f0bebd75d..fd89647c5ac7 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3624,7 +3624,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	}
 
 	if (!ret)
-		dev->cl_ops->pr_sync(dev);
+		dev->cl_ops->pr_sync(dev, sa);
 	dev->cl_ops->pr_unlock(dev);
 
 	if (!ret)
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 4276690fb6cb..68a7339611f3 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -171,6 +171,7 @@ void target_ua_allocate_lun(struct se_node_acl *nacl,
 	core_scsi3_ua_allocate(deve, asc, ascq);
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL(target_ua_allocate_lun);
 
 void core_scsi3_ua_release_all(
 	struct se_dev_entry *deve)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c49ddf0828f6..6c99fb4aa151 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -789,7 +789,7 @@ struct target_cluster_ops {
 	int (*caw_unlock)(struct se_device *dev, void *lock);
 	int (*pr_lock)(struct se_device *dev);
 	int (*pr_unlock)(struct se_device *dev);
-	int (*pr_sync)(struct se_device *dev);
+	int (*pr_sync)(struct se_device *dev, u8 pro_sa);
 	void (*reserve)(struct se_device *dev, struct se_session *sess);
 };
 
-- 
2.25.1


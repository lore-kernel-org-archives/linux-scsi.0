Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB79C25B08
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbiHCQ3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiHCQ3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C19F459B1;
        Wed,  3 Aug 2022 09:29:23 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 110BC412E7;
        Wed,  3 Aug 2022 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544160; x=1661358561; bh=QveIwksVWIhConjr1nbizK7pq
        av5dltAECoHVmy3pb8=; b=fsnZunNt6fU312rkfEvoZPuzP+upYa+jFO5PWxaLP
        awH2qPJIDcXiPxVhtDllMDvGzimwY2L7YhbtDZkEPRU7NX94KmhBRIW+zxO47Chc
        GvD8+fhLOt5ys81jorn7aBGTlCkiVn2XK+rP4IN0EItms680LqTZ9GQ/0USSkMce
        XA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V-KO2i5Rnnbk; Wed,  3 Aug 2022 19:29:20 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CDF0B41287;
        Wed,  3 Aug 2022 19:29:15 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:15 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:15 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 15/48] target: core: remove unused variable in se_dev_entry
Date:   Wed, 1 Dec 2021 18:42:40 +0300
Message-ID: <20220803162857.27770-16-d.bogdanov@yadro.com>
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

deve->pr_res_key is never set, and se_cmd->pr_res_key is set in
the checks inside __target_execute_cmd

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c | 2 --
 include/target/target_core_base.h   | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 40a582b084d7..c0e4fb7b95d6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -83,7 +83,6 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 		}
 
 		se_cmd->se_lun = se_lun;
-		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		se_cmd->lun_ref_active = true;
 	}
@@ -160,7 +159,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 		}
 
 		se_cmd->se_lun = se_lun;
-		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		se_cmd->lun_ref_active = true;
 	}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7e13db647faa..91c068525c02 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -379,8 +379,6 @@ struct t10_pr_registration {
 };
 
 struct t10_reservation {
-	/* Reservation effects all target ports */
-	int pr_all_tg_pt;
 	/* Activate Persistence across Target Power Loss enabled
 	 * for SCSI device */
 	int pr_aptpl_active;
@@ -398,7 +396,6 @@ struct t10_reservation {
 	 * a single *pr_res_holder of the reservation, but all
 	 * registrations are considered reservation holders.
 	 */
-	struct se_node_acl *pr_res_holder;
 	struct list_head registration_list;
 	struct list_head aptpl_reg_list;
 };
@@ -656,7 +653,6 @@ struct se_lun_acl {
 
 struct se_dev_entry {
 	u64			mapped_lun;
-	u64			pr_res_key;
 	u64			creation_time;
 	bool			lun_access_ro;
 	u32			attach_count;
-- 
2.25.1


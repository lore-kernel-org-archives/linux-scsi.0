Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A424C83003
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA5AD2082E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Lme6C36h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgD2Jpg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:36 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39864 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726669AbgD2Jpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 332074C856;
        Wed, 29 Apr 2020 09:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153528; x=1589967929; bh=FN6/rz+WAmDxJZard1qd1iCShKiO+BBP29G
        Go716LV8=; b=Lme6C36haFL8Hqs/YfgAFmOaN9MNkj2f5ykXMfSJ75V34MPvAeO
        1GJGYw5ltAPGvHUN3wohSDXDopW4YaCpVIXO/Fv05+AXakGympOxT2uem8OkffG4
        nXgZzmHL396NqiW3V5Qa64EWKs4yDIqFnTgK/NDWIKyQK7mNwSoSTsok=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZfLpE0TWKc4H; Wed, 29 Apr 2020 12:45:28 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6D94A4C84C;
        Wed, 29 Apr 2020 12:45:27 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:28 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 06/11] scsi: target/core: Drop device-based RTPI
Date:   Wed, 29 Apr 2020 12:44:39 +0300
Message-ID: <20200429094443.43937-7-r.bolshakov@yadro.com>
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

The code is not needed since target port-based RTPI allocation replaced
it.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_device.c   | 41 ---------------------------
 drivers/target/target_core_internal.h |  1 -
 drivers/target/target_core_tpg.c      |  6 ----
 include/target/target_core_base.h     |  4 ---
 4 files changed, 52 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index cb4d8cc4ff45..24d358f942b8 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -474,47 +474,6 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	mutex_unlock(&tpg->acl_node_mutex);
 }
 
-int core_alloc_rtpi(struct se_lun *lun, struct se_device *dev)
-{
-	struct se_lun *tmp;
-
-	spin_lock(&dev->se_port_lock);
-	if (dev->export_count == 0x0000ffff) {
-		pr_warn("Reached dev->dev_port_count =="
-				" 0x0000ffff\n");
-		spin_unlock(&dev->se_port_lock);
-		return -ENOSPC;
-	}
-again:
-	/*
-	 * Allocate the next RELATIVE TARGET PORT IDENTIFIER for this struct se_device
-	 * Here is the table from spc4r17 section 7.7.3.8.
-	 *
-	 *    Table 473 -- RELATIVE TARGET PORT IDENTIFIER field
-	 *
-	 * Code      Description
-	 * 0h        Reserved
-	 * 1h        Relative port 1, historically known as port A
-	 * 2h        Relative port 2, historically known as port B
-	 * 3h to FFFFh    Relative port 3 through 65 535
-	 */
-	lun->lun_rtpi = dev->dev_rpti_counter++;
-	if (!lun->lun_rtpi)
-		goto again;
-
-	list_for_each_entry(tmp, &dev->dev_sep_list, lun_dev_link) {
-		/*
-		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
-		 * for 16-bit wrap..
-		 */
-		if (lun->lun_rtpi == tmp->lun_rtpi)
-			goto again;
-	}
-	spin_unlock(&dev->se_port_lock);
-
-	return 0;
-}
-
 static void se_release_vpd_for_dev(struct se_device *dev)
 {
 	struct t10_vpd *vpd, *vpd_tmp;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 853344415963..aed38c9705f8 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -58,7 +58,6 @@ struct target_fabric_configfs {
 extern struct t10_alua_lu_gp *default_lu_gp;
 
 /* target_core_device.c */
-int	core_alloc_rtpi(struct se_lun *lun, struct se_device *dev);
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
 void	target_pr_kref_release(struct kref *);
 void	core_free_device_list_for_node(struct se_node_acl *,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index e9f6b0aadbcf..32bc28afe93c 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -652,10 +652,6 @@ int core_tpg_add_lun(
 	if (ret < 0)
 		goto out;
 
-	ret = core_alloc_rtpi(lun, dev);
-	if (ret)
-		goto out_kill_ref;
-
 	if (!(dev->transport->transport_flags &
 	     TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
 	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
@@ -680,8 +676,6 @@ int core_tpg_add_lun(
 
 	return 0;
 
-out_kill_ref:
-	percpu_ref_exit(&lun->lun_ref);
 out:
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index cd7c29f46acc..cde2f986e9c0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -724,8 +724,6 @@ struct se_lun {
 	bool			lun_access_ro;
 	u32			lun_index;
 
-	/* RELATIVE TARGET PORT IDENTIFER */
-	u16			lun_rtpi;
 	atomic_t		lun_acl_count;
 	struct se_device __rcu	*lun_se_dev;
 
@@ -762,8 +760,6 @@ struct se_dev_stat_grps {
 };
 
 struct se_device {
-	/* RELATIVE TARGET PORT IDENTIFER Counter */
-	u16			dev_rpti_counter;
 	/* Used for SAM Task Attribute ordering */
 	u32			dev_cur_ordered_id;
 	u32			dev_flags;
-- 
2.26.1


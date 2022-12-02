Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F176CC4321E
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 12:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiLBMMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 07:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiLBMME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 07:12:04 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8B5D3785;
        Fri,  2 Dec 2022 04:12:02 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B14784120E;
        Fri,  2 Dec 2022 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1669983119; x=1671797520; bh=69Y581iDmq2xim6DB4CQWUEzR
        ExWUhd+Ywz92lw9QgA=; b=XtEegCxZ3TK+mNjQwSE5VHabj8A1fVBmG3TyX8anK
        QGe8JhaRYhGGqwA2/GhzI3eAzMsBK6n4tjU6BjZ8z7bO9BWAsYBRmjbbzczjmXMK
        9hXORi5R9uvuCim6GT0fHDdIeIYq49eqB3SwDtzkkf60YUBU84F0LyniYNsxDRiM
        tM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fH_6pwB15_oR; Fri,  2 Dec 2022 15:11:59 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BD99540311;
        Fri,  2 Dec 2022 15:11:57 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 2 Dec 2022 15:11:57 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 2 Dec 2022 15:11:55 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Christoph Hellwig <hch@lst.de>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v3 3/5] scsi: target: core: Drop device-based RTPI
Date:   Fri, 2 Dec 2022 15:11:37 +0300
Message-ID: <20221202121139.28180-4-d.bogdanov@yadro.com>
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

From: Roman Bolshakov <r.bolshakov@yadro.com>

The code is not needed since target port-based RTPI allocation replaced
it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c   | 41 ---------------------------
 drivers/target/target_core_internal.h |  1 -
 drivers/target/target_core_tpg.c      |  6 ----
 include/target/target_core_base.h     |  4 ---
 4 files changed, 52 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index bf13eb06b76f..cce2475b5324 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -460,47 +460,6 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
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
index 3e720a35567c..40550c702e2a 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -59,7 +59,6 @@ struct target_fabric_configfs {
 extern struct t10_alua_lu_gp *default_lu_gp;
 
 /* target_core_device.c */
-int	core_alloc_rtpi(struct se_lun *lun, struct se_device *dev);
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
 void	target_pr_kref_release(struct kref *);
 void	core_free_device_list_for_node(struct se_node_acl *,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 5c8794a264aa..f33a1419a601 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -625,10 +625,6 @@ int core_tpg_add_lun(
 	if (ret < 0)
 		goto out;
 
-	ret = core_alloc_rtpi(lun, dev);
-	if (ret)
-		goto out_kill_ref;
-
 	if (!(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
 	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
@@ -652,8 +648,6 @@ int core_tpg_add_lun(
 
 	return 0;
 
-out_kill_ref:
-	percpu_ref_exit(&lun->lun_ref);
 out:
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 60ada63c4e04..2e6de5ba8172 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -735,8 +735,6 @@ struct se_lun {
 	bool			lun_access_ro;
 	u32			lun_index;
 
-	/* RELATIVE TARGET PORT IDENTIFER */
-	u16			lun_rtpi;
 	atomic_t		lun_acl_count;
 	struct se_device __rcu	*lun_se_dev;
 
@@ -788,8 +786,6 @@ struct se_device_queue {
 };
 
 struct se_device {
-	/* RELATIVE TARGET PORT IDENTIFER Counter */
-	u16			dev_rpti_counter;
 	/* Used for SAM Task Attribute ordering */
 	u32			dev_cur_ordered_id;
 	u32			dev_flags;
-- 
2.25.1


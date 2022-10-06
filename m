Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87700C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 10:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiJFKvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 06:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiJFKvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 06:51:16 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855B198C81;
        Thu,  6 Oct 2022 03:51:15 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6B87041222;
        Thu,  6 Oct 2022 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1665053470; x=1666867871; bh=2QTWlWStPcwbY+qgYn3MWziHr
        of/mUNKm7V1yyvsgfw=; b=anz80Z0EQTjB16Satk+oCWWsntCTNqozrlIui2nJ2
        ZCVcNm495BmGchmY5SqxnJZU069Gu5E7bsPjYhOXpCU2cKWrN4SgYDsk4ZBcqRLr
        Nme/9YUOap2ZU2DPYAHpGgDOgaGbZSJ2CL1iQ+r8HzQ766kOAkf8BOUyuH0gAHkt
        rk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Aej8xHrkgIBA; Thu,  6 Oct 2022 13:51:10 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 52CDE41223;
        Thu,  6 Oct 2022 13:51:10 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 6 Oct 2022 13:51:10 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 6 Oct 2022 13:51:09 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 5/5] scsi: target: core: Add RTPI attribute for target port
Date:   Thu, 6 Oct 2022 13:50:57 +0300
Message-ID: <20221006105057.30184-6-d.bogdanov@yadro.com>
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

RELATIVE TARGET PORT IDENTIFIER can be read and configured via configfs:
$ echo 0x10 > $TARGET/tpgt_N/attrib/rtpi

RTPI can be changed only on disabled target ports.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 v2:
   do not allow to change RTPI on enabled target port
---
 drivers/target/target_core_tpg.c  | 53 ++++++++++++++++++++++++++++++-
 include/target/target_core_base.h |  1 +
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 25ffc3d7a741..09b37ba005ff 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -442,8 +442,23 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 
 static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
 {
-	return xa_alloc(&tpg_xa, &se_tpg->tpg_rtpi, se_tpg,
+	int ret;
+
+	if (se_tpg->rtpi_manual) {
+		ret = xa_insert(&tpg_xa, se_tpg->tpg_rtpi, se_tpg, GFP_KERNEL);
+		if (ret) {
+			pr_info("%s_TPG[%hu] - Can not set RTPI %#x, it is already busy",
+				se_tpg->se_tpg_tfo->fabric_name,
+				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
+				se_tpg->tpg_rtpi);
+			return -EINVAL;
+		}
+	} else {
+		ret = xa_alloc(&tpg_xa, &se_tpg->tpg_rtpi, se_tpg,
 			       XA_LIMIT(1, USHRT_MAX), GFP_KERNEL);
+	}
+
+	return ret;
 }
 
 static void core_tpg_deregister_rtpi(struct se_portal_group *se_tpg)
@@ -682,6 +697,42 @@ void core_tpg_remove_lun(
 	percpu_ref_exit(&lun->lun_ref);
 }
 
+static ssize_t core_tpg_rtpi_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+
+	return sysfs_emit(page, "%#x\n", se_tpg->tpg_rtpi);
+}
+
+static ssize_t core_tpg_rtpi_store(struct config_item *item,
+				   const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+	u16 val;
+	int ret;
+
+	ret = kstrtou16(page, 0, &val);
+	if (ret < 0)
+		return ret;
+	if (val == 0)
+		return -EINVAL;
+
+	if (se_tpg->enabled) {
+		pr_info("%s_TPG[%hu] - Can not change RTPI on enabled TPG",
+			se_tpg->se_tpg_tfo->fabric_name,
+			se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
+		return -EINVAL;
+	}
+
+	se_tpg->tpg_rtpi = val;
+	se_tpg->rtpi_manual = true;
+
+	return count;
+}
+
+CONFIGFS_ATTR(core_tpg_, rtpi);
+
 struct configfs_attribute *core_tpg_attrib_attrs[] = {
+	&core_tpg_attr_rtpi,
 	NULL,
 };
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 83b396457ed1..f2375280d6a4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -901,6 +901,7 @@ struct se_portal_group {
 	bool			enabled;
 	/* RELATIVE TARGET PORT IDENTIFIER */
 	u32			tpg_rtpi;
+	bool			rtpi_manual;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332FEC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 10:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1402964F30
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 10:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhCQKqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 06:46:40 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48246 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230176AbhCQKqc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 06:46:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 33A3241301;
        Wed, 17 Mar 2021 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1615977990; x=1617792391; bh=UhxmVVhhgnVQKpGwDCP+XOW1gaaPs5k87mv
        C7RgHSLA=; b=nhYS9yelhBD8cxhPkDOXhuryxN+jtd9doU2T/mu6PK2l5VfET/m
        1vQJ/Yb0vm84cMKax0PEszkjU/PrMkhDyzvxd/yTTnKMBeBWspNauK4CylIoLaov
        M7Nwr8UGpxgGuhGFHlQyfxFOBT5TNVRK9xDsGy6OaoUZ4wzbZG/gjyRc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kEsLcCaBYRAt; Wed, 17 Mar 2021 13:46:30 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 310CB41283;
        Wed, 17 Mar 2021 13:46:29 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.54) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 17
 Mar 2021 13:46:28 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 2/4] target: iscsi: replace enable attr to ops.enable
Date:   Wed, 17 Mar 2021 13:46:07 +0300
Message-ID: <20210317104609.25236-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317104609.25236-1-d.bogdanov@yadro.com>
References: <20210317104609.25236-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.54]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove tpg/enable attribute.
Add fabric ops enable_tpg impalmentation instead.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 91 +++++++-------------
 1 file changed, 32 insertions(+), 59 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0fa1d57b26fa..be7289728f2d 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1006,74 +1006,15 @@ static struct configfs_attribute *lio_target_tpg_param_attrs[] = {
 
 /* Start items for lio_target_tpg_cit */
 
-static ssize_t lio_target_tpg_enable_show(struct config_item *item, char *page)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct iscsi_portal_group *tpg = container_of(se_tpg,
-			struct iscsi_portal_group, tpg_se_tpg);
-	ssize_t len;
-
-	spin_lock(&tpg->tpg_state_lock);
-	len = sprintf(page, "%d\n",
-			(tpg->tpg_state == TPG_STATE_ACTIVE) ? 1 : 0);
-	spin_unlock(&tpg->tpg_state_lock);
-
-	return len;
-}
-
-static ssize_t lio_target_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct iscsi_portal_group *tpg = container_of(se_tpg,
-			struct iscsi_portal_group, tpg_se_tpg);
-	u32 op;
-	int ret;
-
-	ret = kstrtou32(page, 0, &op);
-	if (ret)
-		return ret;
-	if ((op != 1) && (op != 0)) {
-		pr_err("Illegal value for tpg_enable: %u\n", op);
-		return -EINVAL;
-	}
-
-	ret = iscsit_get_tpg(tpg);
-	if (ret < 0)
-		return -EINVAL;
-
-	if (op) {
-		ret = iscsit_tpg_enable_portal_group(tpg);
-		if (ret < 0)
-			goto out;
-	} else {
-		/*
-		 * iscsit_tpg_disable_portal_group() assumes force=1
-		 */
-		ret = iscsit_tpg_disable_portal_group(tpg, 1);
-		if (ret < 0)
-			goto out;
-	}
-
-	iscsit_put_tpg(tpg);
-	return count;
-out:
-	iscsit_put_tpg(tpg);
-	return -EINVAL;
-}
-
-
 static ssize_t lio_target_tpg_dynamic_sessions_show(struct config_item *item,
 		char *page)
 {
 	return target_show_dynamic_sessions(to_tpg(item), page);
 }
 
-CONFIGFS_ATTR(lio_target_tpg_, enable);
 CONFIGFS_ATTR_RO(lio_target_tpg_, dynamic_sessions);
 
 static struct configfs_attribute *lio_target_tpg_attrs[] = {
-	&lio_target_tpg_attr_enable,
 	&lio_target_tpg_attr_dynamic_sessions,
 	NULL,
 };
@@ -1130,6 +1071,37 @@ static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
 	return NULL;
 }
 
+static int lio_target_tiqn_enabletpg(struct se_portal_group *se_tpg,
+					 bool enable)
+{
+	struct iscsi_portal_group *tpg = container_of(se_tpg,
+			struct iscsi_portal_group, tpg_se_tpg);
+	int ret;
+
+	ret = iscsit_get_tpg(tpg);
+	if (ret < 0)
+		return -EINVAL;
+
+	if (enable) {
+		ret = iscsit_tpg_enable_portal_group(tpg);
+		if (ret < 0)
+			goto out;
+	} else {
+		/*
+		 * iscsit_tpg_disable_portal_group() assumes force=1
+		 */
+		ret = iscsit_tpg_disable_portal_group(tpg, 1);
+		if (ret < 0)
+			goto out;
+	}
+
+	iscsit_put_tpg(tpg);
+	return 0;
+out:
+	iscsit_put_tpg(tpg);
+	return -EINVAL;
+}
+
 static void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg;
@@ -1557,6 +1529,7 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.fabric_drop_wwn		= lio_target_call_coredeltiqn,
 	.add_wwn_groups			= lio_target_add_wwn_groups,
 	.fabric_make_tpg		= lio_target_tiqn_addtpg,
+	.fabric_enable_tpg		= lio_target_tiqn_enabletpg,
 	.fabric_drop_tpg		= lio_target_tiqn_deltpg,
 	.fabric_make_np			= lio_target_call_addnptotpg,
 	.fabric_drop_np			= lio_target_call_delnpfromtpg,
-- 
2.25.1


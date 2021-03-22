Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B11C433E8
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 680AA61969
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCVIG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:06:28 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39564 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229865AbhCVIGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 04:06:15 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 920E841206;
        Mon, 22 Mar 2021 08:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1616400372; x=1618214773; bh=UhxmVVhhgnVQKpGwDCP+XOW1gaaPs5k87mv
        C7RgHSLA=; b=jEtrjljvRjmgtw0s731vlWgFycBf42i4FLd2yOGI1ISVCiRoKt2
        LA30dt4XPik5ZLN8UJZCz7ajPFqoLe2G+cc2pHbhjpdpunwMYcoINxH8R3JSqIUr
        LTEoleRB85xXQE+ZM5tPOWTYLQE8nSqZwgiQJVu8vAFOVcL8OAFf8wks=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eO1YP6t2p_0O; Mon, 22 Mar 2021 11:06:12 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2E19E4128C;
        Mon, 22 Mar 2021 11:06:10 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.33) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 22
 Mar 2021 11:06:09 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 2/7] target: iscsi: replace enable attr to ops.enable
Date:   Mon, 22 Mar 2021 11:05:49 +0300
Message-ID: <20210322080554.7611-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322080554.7611-1-d.bogdanov@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.33]
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


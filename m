Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FC7C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4F3610CF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhDIMsD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 08:48:03 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55614 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233617AbhDIMr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Apr 2021 08:47:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3CA9941381;
        Fri,  9 Apr 2021 12:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1617972462; x=1619786863; bh=uduGAqCQON2nAWKPqKV7WSGmbjJeL0w7EIG
        R8RS2lwQ=; b=JjAZqApiDZyNXF7ofHytNztN7J88gAv/b+nvPfLhxTkm+/0cv3F
        W971VrjDMnbrPgEAakvlDmrnGsSRUhbGYqcJJB5v6FGL7bScOLufyUqDpe3fNQgw
        mpihPstQAlK+HGDS+G7cbsOvTrI2nWXjHG86YGj6683cKVUtP3IjpogI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U900h78oZl09; Fri,  9 Apr 2021 15:47:42 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 66275414B5;
        Fri,  9 Apr 2021 15:32:49 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.255) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Apr 2021 15:32:48 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 4/7] target: sbp: replace enable attr to ops.enable
Date:   Fri, 9 Apr 2021 15:32:35 +0300
Message-ID: <20210409123238.26671-5-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210409123238.26671-1-d.bogdanov@yadro.com>
References: <20210409123238.26671-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.255]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove tpg/enable attribute.
Add fabric ops enable_tpg implementation instead.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/sbp/sbp_target.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 2a6165febd3b..72f7c00134d3 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2128,32 +2128,13 @@ static ssize_t sbp_tpg_directory_id_store(struct config_item *item,
 	return count;
 }
 
-static ssize_t sbp_tpg_enable_show(struct config_item *item, char *page)
+static int sbp_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 {
-	struct se_portal_group *se_tpg = to_tpg(item);
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
 	struct sbp_tport *tport = tpg->tport;
-	return sprintf(page, "%d\n", tport->enable);
-}
-
-static ssize_t sbp_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
-	struct sbp_tport *tport = tpg->tport;
-	unsigned long val;
 	int ret;
 
-	if (kstrtoul(page, 0, &val) < 0)
-		return -EINVAL;
-	if ((val != 0) && (val != 1))
-		return -EINVAL;
-
-	if (tport->enable == val)
-		return count;
-
-	if (val) {
+	if (enable) {
 		if (sbp_count_se_tpg_luns(&tpg->se_tpg) == 0) {
 			pr_err("Cannot enable a target with no LUNs!\n");
 			return -EINVAL;
@@ -2168,7 +2149,7 @@ static ssize_t sbp_tpg_enable_store(struct config_item *item,
 		spin_unlock_bh(&se_tpg->session_lock);
 	}
 
-	tport->enable = val;
+	tport->enable = enable;
 
 	ret = sbp_update_unit_directory(tport);
 	if (ret < 0) {
@@ -2176,15 +2157,13 @@ static ssize_t sbp_tpg_enable_store(struct config_item *item,
 		return ret;
 	}
 
-	return count;
+	return 0;
 }
 
 CONFIGFS_ATTR(sbp_tpg_, directory_id);
-CONFIGFS_ATTR(sbp_tpg_, enable);
 
 static struct configfs_attribute *sbp_tpg_base_attrs[] = {
 	&sbp_tpg_attr_directory_id,
-	&sbp_tpg_attr_enable,
 	NULL,
 };
 
@@ -2322,6 +2301,7 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.fabric_make_wwn		= sbp_make_tport,
 	.fabric_drop_wwn		= sbp_drop_tport,
 	.fabric_make_tpg		= sbp_make_tpg,
+	.fabric_enable_tpg		= sbp_enable_tpg,
 	.fabric_drop_tpg		= sbp_drop_tpg,
 	.fabric_post_link		= sbp_post_link_lun,
 	.fabric_pre_unlink		= sbp_pre_unlink_lun,
-- 
2.25.1


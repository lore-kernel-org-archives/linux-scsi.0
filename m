Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941AEC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7321B6140F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhFJIHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:07:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9063 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJIHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 04:07:52 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0xL11V1YzZcWn;
        Thu, 10 Jun 2021 16:03:05 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:05:48 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:05:48 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: tcm_qla2xxx: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 16:05:42 +0800
Message-ID: <20210610080542.16186-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes scripts/checkpatch.pl warning:
WARNING: Possible unnecessary 'out of memory' message

Remove it can help us save a bit of memory.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 03de1bcf1461d77..d537a7bc27f08b0 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1035,10 +1035,8 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(struct se_wwn *wwn,
 	}
 
 	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
-	if (!tpg) {
-		pr_err("Unable to allocate struct tcm_qla2xxx_tpg\n");
+	if (!tpg)
 		return ERR_PTR(-ENOMEM);
-	}
 	tpg->lport = lport;
 	tpg->lport_tpgt = tpgt;
 	/*
@@ -1151,10 +1149,8 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(struct se_wwn *wwn,
 		return ERR_PTR(-EINVAL);
 
 	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
-	if (!tpg) {
-		pr_err("Unable to allocate struct tcm_qla2xxx_tpg\n");
+	if (!tpg)
 		return ERR_PTR(-ENOMEM);
-	}
 	tpg->lport = lport;
 	tpg->lport_tpgt = tpgt;
 
@@ -1653,10 +1649,8 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 		return ERR_PTR(-EINVAL);
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
-	if (!lport) {
-		pr_err("Unable to allocate struct tcm_qla2xxx_lport\n");
+	if (!lport)
 		return ERR_PTR(-ENOMEM);
-	}
 	lport->lport_wwpn = wwpn;
 	tcm_qla2xxx_format_wwn(&lport->lport_name[0], TCM_QLA2XXX_NAMELEN,
 				wwpn);
@@ -1779,10 +1773,8 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 		return ERR_PTR(-EINVAL);
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
-	if (!lport) {
-		pr_err("Unable to allocate struct tcm_qla2xxx_lport for NPIV\n");
+	if (!lport)
 		return ERR_PTR(-ENOMEM);
-	}
 	lport->lport_npiv_wwpn = npiv_wwpn;
 	lport->lport_npiv_wwnn = npiv_wwnn;
 	sprintf(lport->lport_naa_name, "naa.%016llx", (unsigned long long) npiv_wwpn);
-- 
2.26.0.106.g9fadedd



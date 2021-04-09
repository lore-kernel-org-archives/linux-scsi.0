Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D70C43460
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A49610CF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhDIMsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 08:48:01 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55604 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232690AbhDIMr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Apr 2021 08:47:56 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1EFD54136C;
        Fri,  9 Apr 2021 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1617972460; x=1619786861; bh=bV/6uRr6ol8405aCmVR4VHGwMPUTvmSN3wC
        /bs6uw7g=; b=nLB1Jy6ShhhiWU5i/9B3y6QUvnPKNdNnYy7Jfb/UeTfnO2EvY6q
        mjTPGiTWZXgf0EJylfHJvuzQwJRFixoyRbTJvKjxVztJFeZ461L9xwHvsqz/bbQa
        Qw2GG3LKqZitDxd7cbUg6pgUDNhsdDKAsp/p9e3yD84Cz1i60n9qsKl8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZneUJvLm1yQr; Fri,  9 Apr 2021 15:47:40 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C616A414B2;
        Fri,  9 Apr 2021 15:32:48 +0300 (MSK)
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
Subject: [PATCH v3 3/7] target: qla2xx: replace enable attr to ops.enable
Date:   Fri, 9 Apr 2021 15:32:34 +0300
Message-ID: <20210409123238.26671-4-d.bogdanov@yadro.com>
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
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 73 +++++-------------------------
 1 file changed, 12 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 8b4890cdd4ca..5beb6dfdade5 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -906,40 +906,17 @@ static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
 
 /* End items for tcm_qla2xxx_tpg_attrib_cit */
 
-static ssize_t tcm_qla2xxx_tpg_enable_show(struct config_item *item,
-		char *page)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
-			struct tcm_qla2xxx_tpg, se_tpg);
-
-	return snprintf(page, PAGE_SIZE, "%d\n",
-			atomic_read(&tpg->lport_tpg_enabled));
-}
-
-static ssize_t tcm_qla2xxx_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
+static int tcm_qla2xxx_enable_tpg(struct se_portal_group *se_tpg,
+				  bool enable)
 {
-	struct se_portal_group *se_tpg = to_tpg(item);
 	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
 	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
 	struct scsi_qla_host *vha = lport->qla_vha;
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 			struct tcm_qla2xxx_tpg, se_tpg);
-	unsigned long op;
-	int rc;
 
-	rc = kstrtoul(page, 0, &op);
-	if (rc < 0) {
-		pr_err("kstrtoul() returned %d\n", rc);
-		return -EINVAL;
-	}
-	if ((op != 1) && (op != 0)) {
-		pr_err("Illegal value for tpg_enable: %lu\n", op);
-		return -EINVAL;
-	}
-	if (op) {
+	if (enable) {
 		if (atomic_read(&tpg->lport_tpg_enabled))
 			return -EEXIST;
 
@@ -947,14 +924,14 @@ static ssize_t tcm_qla2xxx_tpg_enable_store(struct config_item *item,
 		qlt_enable_vha(vha);
 	} else {
 		if (!atomic_read(&tpg->lport_tpg_enabled))
-			return count;
+			return 0;
 
 		atomic_set(&tpg->lport_tpg_enabled, 0);
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 	}
 
-	return count;
+	return 0;
 }
 
 static ssize_t tcm_qla2xxx_tpg_dynamic_sessions_show(struct config_item *item,
@@ -995,12 +972,10 @@ static ssize_t tcm_qla2xxx_tpg_fabric_prot_type_show(struct config_item *item,
 	return sprintf(page, "%d\n", tpg->tpg_attrib.fabric_prot_type);
 }
 
-CONFIGFS_ATTR(tcm_qla2xxx_tpg_, enable);
 CONFIGFS_ATTR_RO(tcm_qla2xxx_tpg_, dynamic_sessions);
 CONFIGFS_ATTR(tcm_qla2xxx_tpg_, fabric_prot_type);
 
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
-	&tcm_qla2xxx_tpg_attr_enable,
 	&tcm_qla2xxx_tpg_attr_dynamic_sessions,
 	&tcm_qla2xxx_tpg_attr_fabric_prot_type,
 	NULL,
@@ -1074,35 +1049,17 @@ static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
 	kfree(tpg);
 }
 
-static ssize_t tcm_qla2xxx_npiv_tpg_enable_show(struct config_item *item,
-		char *page)
-{
-	return tcm_qla2xxx_tpg_enable_show(item, page);
-}
-
-static ssize_t tcm_qla2xxx_npiv_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
+static int tcm_qla2xxx_npiv_enable_tpg(struct se_portal_group *se_tpg,
+				    bool enable)
 {
-	struct se_portal_group *se_tpg = to_tpg(item);
 	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
 	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
 	struct scsi_qla_host *vha = lport->qla_vha;
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 			struct tcm_qla2xxx_tpg, se_tpg);
-	unsigned long op;
-	int rc;
 
-	rc = kstrtoul(page, 0, &op);
-	if (rc < 0) {
-		pr_err("kstrtoul() returned %d\n", rc);
-		return -EINVAL;
-	}
-	if ((op != 1) && (op != 0)) {
-		pr_err("Illegal value for tpg_enable: %lu\n", op);
-		return -EINVAL;
-	}
-	if (op) {
+	if (enable) {
 		if (atomic_read(&tpg->lport_tpg_enabled))
 			return -EEXIST;
 
@@ -1110,23 +1067,16 @@ static ssize_t tcm_qla2xxx_npiv_tpg_enable_store(struct config_item *item,
 		qlt_enable_vha(vha);
 	} else {
 		if (!atomic_read(&tpg->lport_tpg_enabled))
-			return count;
+			return 0;
 
 		atomic_set(&tpg->lport_tpg_enabled, 0);
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 	}
 
-	return count;
+	return 0;
 }
 
-CONFIGFS_ATTR(tcm_qla2xxx_npiv_tpg_, enable);
-
-static struct configfs_attribute *tcm_qla2xxx_npiv_tpg_attrs[] = {
-        &tcm_qla2xxx_npiv_tpg_attr_enable,
-        NULL,
-};
-
 static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(struct se_wwn *wwn,
 							 const char *name)
 {
@@ -1869,6 +1819,7 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.fabric_make_wwn		= tcm_qla2xxx_make_lport,
 	.fabric_drop_wwn		= tcm_qla2xxx_drop_lport,
 	.fabric_make_tpg		= tcm_qla2xxx_make_tpg,
+	.fabric_enable_tpg		= tcm_qla2xxx_enable_tpg,
 	.fabric_drop_tpg		= tcm_qla2xxx_drop_tpg,
 	.fabric_init_nodeacl		= tcm_qla2xxx_init_nodeacl,
 
@@ -1909,11 +1860,11 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.fabric_make_wwn		= tcm_qla2xxx_npiv_make_lport,
 	.fabric_drop_wwn		= tcm_qla2xxx_npiv_drop_lport,
 	.fabric_make_tpg		= tcm_qla2xxx_npiv_make_tpg,
+	.fabric_enable_tpg		= tcm_qla2xxx_npiv_enable_tpg,
 	.fabric_drop_tpg		= tcm_qla2xxx_drop_tpg,
 	.fabric_init_nodeacl		= tcm_qla2xxx_init_nodeacl,
 
 	.tfc_wwn_attrs			= tcm_qla2xxx_wwn_attrs,
-	.tfc_tpg_base_attrs		= tcm_qla2xxx_npiv_tpg_attrs,
 };
 
 static int tcm_qla2xxx_register_configfs(void)
-- 
2.25.1


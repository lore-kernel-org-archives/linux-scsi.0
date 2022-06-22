Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D4FC19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiHCQaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbiHCQ3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:37 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCE4DEDB;
        Wed,  3 Aug 2022 09:29:35 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D426041239;
        Wed,  3 Aug 2022 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544171; x=1661358572; bh=I3rp/BgsyFIeH4WQjR1Cm+2Hz
        +cW1bhj18c1hoF+Dr0=; b=NzMzlWtrJxthWjPtN4tvsX7O2lmfcERwDsg0l0Oks
        eUJ386ziM5my1bhinFZVdGCG8JQMOrIPY2YvFbML//7KsFbPy7Twnekm3q3Ur/fx
        Vmhq8wx+WF0ja2pmxQTuXPvfiRemqvXSJAxIDnzSsimcw6bW81n+1xjvWAwcqUIf
        EQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JLQjFTxNaGVO; Wed,  3 Aug 2022 19:29:31 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 81905412C9;
        Wed,  3 Aug 2022 19:29:19 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:19 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:18 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 26/48] target: core: pr: remove se_tpg from pr_reg
Date:   Wed, 22 Jun 2022 13:25:24 +0300
Message-ID: <20220803162857.27770-27-d.bogdanov@yadro.com>
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

Undepend pr_reg from se_tpg.
Use RTPI at PR creation.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c        |  47 ++++---
 drivers/target/target_core_fabric_configfs.c |   2 +-
 drivers/target/target_core_internal.h        |   1 +
 drivers/target/target_core_pr.c              | 126 ++++++++-----------
 drivers/target/target_core_pr.h              |   2 +-
 drivers/target/target_core_tpg.c             |  17 ++-
 include/target/target_core_base.h            |   1 -
 7 files changed, 104 insertions(+), 92 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f469cfde3f1e..0978279bd5e3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1736,6 +1736,8 @@ static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 		char *page)
 {
 	struct t10_pr_registration *pr_reg;
+	struct se_portal_group *se_tpg;
+	const char *fabric_name = "Unknown";
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	pr_reg = dev->dev_pr_res_holder;
@@ -1744,9 +1746,12 @@ static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
+	se_tpg = core_get_tpg_by_rtpi(pr_reg->tg_pt_sep_rtpi);
+	if (se_tpg)
+		fabric_name = se_tpg->se_tpg_tfo->fabric_name;
+
 	return sprintf(page, "SPC-3 Reservation: %s Initiator: %s%s\n",
-		pr_reg->se_tpg->se_tpg_tfo->fabric_name,
-		pr_reg->pr_iport, i_buf);
+		fabric_name, pr_reg->pr_iport, i_buf);
 }
 
 static ssize_t target_core_dev_pr_show_spc2_res(struct se_device *dev,
@@ -1838,18 +1843,24 @@ static ssize_t target_pr_res_pr_holder_tg_port_show(struct config_item *item,
 		goto out_unlock;
 	}
 
-	se_tpg = pr_reg->se_tpg;
-	tfo = se_tpg->se_tpg_tfo;
-
-	len += sprintf(page+len, "SPC-3 Reservation: %s"
-		" Target Node Endpoint: %s\n", tfo->fabric_name,
-		tfo->tpg_get_wwn(se_tpg));
-	len += sprintf(page+len, "SPC-3 Reservation: Relative Port"
-		" Identifier Tag: %hu %s Portal Group Tag: %hu"
-		" %s Logical Unit: %llu\n", pr_reg->tg_pt_sep_rtpi,
-		tfo->fabric_name, tfo->tpg_get_tag(se_tpg),
-		tfo->fabric_name, pr_reg->pr_aptpl_target_lun);
+	se_tpg = core_get_tpg_by_rtpi(pr_reg->tg_pt_sep_rtpi);
+	if (se_tpg) {
+		tfo = se_tpg->se_tpg_tfo;
 
+		len += sprintf(page+len, "SPC-3 Reservation: %s Target Node Endpoint: %s\n",
+			tfo->fabric_name, tfo->tpg_get_wwn(se_tpg));
+		len += sprintf(page+len, "SPC-3 Reservation: Relative Port Identifier Tag: %hu %s Portal Group Tag: %hu %s Logical Unit: %llu\n",
+			pr_reg->tg_pt_sep_rtpi,
+			tfo->fabric_name, tfo->tpg_get_tag(se_tpg),
+			tfo->fabric_name, pr_reg->pr_aptpl_target_lun);
+	} else {
+		len += sprintf(page+len, "SPC-3 Reservation: %s Target Node Endpoint: %s\n",
+			"Unknown", "Unknown");
+		len += sprintf(page+len, "SPC-3 Reservation: Relative Port Identifier Tag: %hu %s Portal Group Tag: %hu %s Logical Unit: %llu\n",
+			pr_reg->tg_pt_sep_rtpi,
+			"Unknown", 0,
+			"Unknown", pr_reg->pr_aptpl_target_lun);
+	}
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
 	return len;
@@ -1860,8 +1871,9 @@ static ssize_t target_pr_res_pr_registered_i_pts_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = pr_to_dev(item);
-	const struct target_core_fabric_ops *tfo;
 	struct t10_pr_registration *pr_reg;
+	const char *fabric_name = "Unknown";
+	struct se_portal_group *se_tpg;
 	unsigned char buf[384];
 	char i_buf[PR_REG_ISID_ID_LEN];
 	ssize_t len = 0;
@@ -1875,11 +1887,14 @@ static ssize_t target_pr_res_pr_registered_i_pts_show(struct config_item *item,
 
 		memset(buf, 0, 384);
 		memset(i_buf, 0, PR_REG_ISID_ID_LEN);
-		tfo = pr_reg->se_tpg->se_tpg_tfo;
+		se_tpg = core_get_tpg_by_rtpi(pr_reg->tg_pt_sep_rtpi);
+		if (se_tpg)
+			fabric_name = se_tpg->se_tpg_tfo->fabric_name;
+
 		core_pr_dump_initiator_port(pr_reg, i_buf,
 					PR_REG_ISID_ID_LEN);
 		sprintf(buf, "%s Node: %s%s Key: 0x%016Lx PRgen: 0x%08x\n",
-			tfo->fabric_name,
+			fabric_name,
 			pr_reg->pr_iport, i_buf, pr_reg->pr_res_key,
 			pr_reg->pr_res_generation);
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index fc1b8f54fb54..fd8f3b4c4bf8 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -871,7 +871,7 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
 	spin_lock(&g_tpg_lock);
 
 	if (op) {
-		tpg = core_get_tpg_by_rtpi(se_tpg->tpg_rtpi);
+		tpg = _core_get_tpg_by_rtpi(se_tpg->tpg_rtpi);
 		if (tpg) {
 			spin_unlock(&g_tpg_lock);
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 95d5add73578..51c0151c05c2 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -136,6 +136,7 @@ void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
 		const char *initiatorname);
 void core_tpg_del_initiator_node_acl(struct se_node_acl *acl);
+struct se_portal_group *_core_get_tpg_by_rtpi(u16 rtpi);
 struct se_portal_group *core_get_tpg_by_rtpi(u16 rtpi);
 
 /* target_core_transport.c */
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d9e7d177b65a..c4ee6999cf96 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -612,7 +612,7 @@ struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	struct se_node_acl *nacl,
 	const char *initiatorname,
 	u64 unpacked_lun,
-	struct se_portal_group *se_tpg,
+	u16 rtpi,
 	struct se_dev_entry *dest_deve,
 	u64 mapped_lun,
 	unsigned char *isid,
@@ -661,8 +661,7 @@ struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	}
 	pr_reg->pr_res_mapped_lun = mapped_lun;
 	pr_reg->pr_aptpl_target_lun = unpacked_lun;
-	pr_reg->tg_pt_sep_rtpi = se_tpg->tpg_rtpi;
-	pr_reg->se_tpg = se_tpg;
+	pr_reg->tg_pt_sep_rtpi = rtpi;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
@@ -710,7 +709,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 */
 	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl,
 						    nacl->initiatorname, lun->unpacked_lun,
-						    lun->lun_tpg,
+						    lun->lun_tpg->tpg_rtpi,
 						    deve, mapped_lun,
 						    isid, sa_res_key, all_tg_pt,
 						    aptpl);
@@ -797,7 +796,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						nacl_tmp,
 						nacl_tmp->initiatorname,
 						dest_lun->unpacked_lun,
-						lun->lun_tpg,
+						lun->lun_tpg->tpg_rtpi,
 						deve_tmp,
 						deve_tmp->mapped_lun, NULL,
 						sa_res_key, all_tg_pt, aptpl);
@@ -1011,30 +1010,25 @@ int core_scsi3_check_aptpl_registration(
 }
 
 static void __core_scsi3_dump_registration(
-	const struct target_core_fabric_ops *tfo,
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg,
 	enum register_type register_type)
 {
-	struct se_portal_group *se_tpg = pr_reg->se_tpg;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	pr_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
-		" Node: %s%s\n", tfo->fabric_name, (register_type == REGISTER_AND_MOVE) ?
+	pr_debug("SPC-3 PR Service Action: REGISTER%s Initiator Node: %s%s\n",
+		(register_type == REGISTER_AND_MOVE) ?
 		"_AND_MOVE" : (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
 		"_AND_IGNORE_EXISTING_KEY" : "", pr_reg->pr_iport,
 		i_buf);
-	pr_debug("SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
-		 tfo->fabric_name, tfo->tpg_get_wwn(se_tpg),
-		tfo->tpg_get_tag(se_tpg));
-	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		" Port(s)\n",  tfo->fabric_name,
+	pr_debug("SPC-3 PR registration on Target Port: %d\n",
+		 pr_reg->tg_pt_sep_rtpi);
+	pr_debug("SPC-3 PR for %s TCM Subsystem %s Object Target Port(s)\n",
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		dev->transport->name);
-	pr_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x  APTPL: %d\n", tfo->fabric_name,
+	pr_debug("SPC-3 PR SA Res Key: 0x%016llx PRgeneration: 0x%08x  APTPL: %d\n",
 		pr_reg->pr_res_key, pr_reg->pr_res_generation,
 		pr_reg->pr_reg_aptpl);
 }
@@ -1046,7 +1040,6 @@ static void __core_scsi3_add_registration(
 	enum register_type register_type,
 	int register_move)
 {
-	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	struct se_dev_entry *deve;
@@ -1060,7 +1053,7 @@ static void __core_scsi3_add_registration(
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
 
-	__core_scsi3_dump_registration(tfo, dev, pr_reg, register_type);
+	__core_scsi3_dump_registration(dev, pr_reg, register_type);
 	spin_unlock(&pr_tmpl->registration_lock);
 	/*
 	 * Skip extra processing for ALL_TG_PT=0 or REGISTER_AND_MOVE.
@@ -1081,8 +1074,7 @@ static void __core_scsi3_add_registration(
 		list_add_tail(&pr_reg_tmp->pr_reg_list,
 			      &pr_tmpl->registration_list);
 
-		__core_scsi3_dump_registration(tfo, dev, pr_reg_tmp,
-					       register_type);
+		__core_scsi3_dump_registration(dev, pr_reg_tmp, register_type);
 		spin_unlock(&pr_tmpl->registration_lock);
 		/*
 		 * Drop configfs group dependency reference and deve->pr_kref
@@ -1262,8 +1254,6 @@ void __core_scsi3_free_registration(
 	__releases(&pr_tmpl->registration_lock)
 	__acquires(&pr_tmpl->registration_lock)
 {
-	const struct target_core_fabric_ops *tfo =
-			pr_reg->se_tpg->se_tpg_tfo;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	struct se_dev_entry *deve;
@@ -1290,8 +1280,7 @@ void __core_scsi3_free_registration(
 	 * count back to zero, and we release *pr_reg.
 	 */
 	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
-		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
-				tfo->fabric_name);
+		pr_debug("SPC-3 PR waiting for pr_res_holders\n");
 		cpu_relax();
 	}
 
@@ -1302,15 +1291,13 @@ void __core_scsi3_free_registration(
 	rcu_read_unlock();
 
 	spin_lock(&pr_tmpl->registration_lock);
-	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
-		" Node: %s%s\n", tfo->fabric_name,
-		pr_reg->pr_iport, i_buf);
-	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		" Port(s)\n", tfo->fabric_name,
+	pr_debug("SPC-3 PR Service Action: UNREGISTER Initiator Node: %s%s\n",
+		 pr_reg->pr_iport, i_buf);
+	pr_debug("SPC-3 PR for %s TCM Subsystem %s Object Target Port(s)\n",
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		dev->transport->name);
-	pr_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x\n", tfo->fabric_name, pr_reg->pr_res_key,
+	pr_debug("SPC-3 PR SA Res Key: 0x%016llx PRgeneration: 0x%08x\n",
+		pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
 	if (!preempt_and_abort_list) {
@@ -1830,7 +1817,9 @@ static int core_scsi3_update_aptpl_buf(
 
 		tmp[0] = '\0';
 		isid_buf[0] = '\0';
-		tpg = pr_reg->se_tpg;
+
+		tpg = core_get_tpg_by_rtpi(pr_reg->tg_pt_sep_rtpi);
+
 		/*
 		 * Write out any ISID value to APTPL metadata that was included
 		 * in the original registration.
@@ -1874,13 +1863,21 @@ static int core_scsi3_update_aptpl_buf(
 		/*
 		 * Include information about the associated SCSI target port.
 		 */
-		snprintf(tmp, 512, "target_node=%s\n"
-			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%llu\nPR_REG_END: %d\n",
-			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-			tpg->se_tpg_tfo->tpg_get_tag(tpg),
-			pr_reg->tg_pt_sep_rtpi, pr_reg->pr_aptpl_target_lun,
-			reg_count);
-
+		if (tpg) {
+			snprintf(tmp, 512, "target_node=%s\n"
+				"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%llu\nPR_REG_END: %d\n",
+				tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+				tpg->se_tpg_tfo->tpg_get_tag(tpg),
+				pr_reg->tg_pt_sep_rtpi, pr_reg->pr_aptpl_target_lun,
+				reg_count);
+		} else {
+			snprintf(tmp, 512, "target_node=%s\n"
+				"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%llu\nPR_REG_END: %d\n",
+				"",
+				0,
+				pr_reg->tg_pt_sep_rtpi, pr_reg->pr_aptpl_target_lun,
+				reg_count);
+		}
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
 			pr_err("Unable to update renaming APTPL metadata,"
 			       " reallocating larger buffer\n");
@@ -2224,12 +2221,10 @@ void __core_scsi3_set_reservation(struct se_device *dev,
 	dev->dev_pr_res_holder = pr_reg;
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	pr_debug("SPC-3 PR [%s] Service Action: RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		pr_reg->se_tpg->se_tpg_tfo->fabric_name,
+	pr_debug("SPC-3 PR Service Action: RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
-			pr_reg->se_tpg->se_tpg_tfo->fabric_name,
+	pr_debug("SPC-3 PR RESERVE Node: %s%s\n",
 			pr_reg->pr_iport,
 			i_buf);
 }
@@ -2308,12 +2303,10 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 * RESERVATION CONFLICT status.
 		 */
 		if (!is_reservation_holder(pr_res_holder, pr_reg)) {
-			pr_err("SPC-3 PR: Attempted RESERVE from"
-				" [%s]: %s while reservation already held by"
-				" [%s]: %s, returning RESERVATION_CONFLICT\n",
-				cmd->se_tfo->fabric_name,
+			pr_err("SPC-3 PR: Attempted RESERVE from [%d]: %s while reservation already held by [%d]: %s, returning RESERVATION_CONFLICT\n",
+				cmd->se_lun->lun_tpg->tpg_rtpi,
 				se_sess->se_node_acl->initiatorname,
-				pr_res_holder->se_tpg->se_tpg_tfo->fabric_name,
+				pr_res_holder->tg_pt_sep_rtpi,
 				pr_res_holder->pr_iport);
 
 			spin_unlock(&dev->dev_reservation_lock);
@@ -2329,13 +2322,10 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 */
 		if ((pr_res_holder->pr_res_type != type) ||
 		    (pr_res_holder->pr_res_scope != scope)) {
-			pr_err("SPC-3 PR: Attempted RESERVE from"
-				" [%s]: %s trying to change TYPE and/or SCOPE,"
-				" while reservation already held by [%s]: %s,"
-				" returning RESERVATION_CONFLICT\n",
-				cmd->se_tfo->fabric_name,
+			pr_err("SPC-3 PR: Attempted RESERVE from [%d]: %s trying to change TYPE and/or SCOPE, while reservation already held by [%d]: %s, returning RESERVATION_CONFLICT\n",
+				cmd->se_lun->lun_tpg->tpg_rtpi,
 				se_sess->se_node_acl->initiatorname,
-				pr_res_holder->se_tpg->se_tpg_tfo->fabric_name,
+				pr_res_holder->tg_pt_sep_rtpi,
 				pr_res_holder->pr_iport);
 
 			spin_unlock(&dev->dev_reservation_lock);
@@ -2397,7 +2387,6 @@ void __core_scsi3_complete_pro_release(
 	int explicit,
 	int unreg)
 {
-	const struct target_core_fabric_ops *tfo = pr_reg->se_tpg->se_tpg_tfo;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	int pr_res_type = 0, pr_res_scope = 0;
 
@@ -2442,15 +2431,14 @@ void __core_scsi3_complete_pro_release(
 	spin_unlock(&dev->t10_pr.registration_lock);
 out:
 	if (!dev->dev_pr_res_holder) {
-		pr_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
+		pr_debug("SPC-3 PR Service Action: %s RELEASE cleared"
 			" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-			tfo->fabric_name, (explicit) ? "explicit" :
+			(explicit) ? "explicit" :
 			"implicit", core_scsi3_pr_dump_type(pr_res_type),
 			(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	}
-	pr_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n",
-		tfo->fabric_name, pr_reg->pr_iport,
-		i_buf);
+	pr_debug("SPC-3 PR RELEASE Node: %s%s\n",
+		 pr_reg->pr_iport, i_buf);
 	/*
 	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
 	 */
@@ -2542,13 +2530,10 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 */
 	if ((pr_res_holder->pr_res_type != type) ||
 	    (pr_res_holder->pr_res_scope != scope)) {
-		pr_err("SPC-3 PR RELEASE: Attempted to release"
-			" reservation from [%s]: %s with different TYPE "
-			"and/or SCOPE  while reservation already held by"
-			" [%s]: %s, returning RESERVATION_CONFLICT\n",
-			cmd->se_tfo->fabric_name,
+		pr_err("SPC-3 PR RELEASE: Attempted to release reservation from [%d]: %s with different TYPE and/or SCOPE  while reservation already held by [%d]: %s, returning RESERVATION_CONFLICT\n",
+			cmd->se_lun->lun_tpg->tpg_rtpi,
 			se_sess->se_node_acl->initiatorname,
-			pr_res_holder->se_tpg->se_tpg_tfo->fabric_name,
+			pr_res_holder->tg_pt_sep_rtpi,
 			pr_res_holder->pr_iport);
 
 		spin_unlock(&dev->dev_reservation_lock);
@@ -2701,7 +2686,6 @@ static void __core_scsi3_complete_pro_preempt(
 	int scope,
 	enum preempt_type preempt_type)
 {
-	const struct target_core_fabric_ops *tfo = pr_reg->se_tpg->se_tpg_tfo;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	lockdep_assert_held(&dev->dev_reservation_lock);
@@ -2718,13 +2702,13 @@ static void __core_scsi3_complete_pro_preempt(
 	pr_reg->pr_res_type = type;
 	pr_reg->pr_res_scope = scope;
 
-	pr_debug("SPC-3 PR [%s] Service Action: PREEMPT%s created new"
+	pr_debug("SPC-3 PR Service Action: PREEMPT%s created new"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
+		(preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
 		core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n",
-		tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
+	pr_debug("SPC-3 PR PREEMPT%s from Node: %s%s\n",
+		(preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
 		pr_reg->pr_iport, i_buf);
 	/*
 	 * For PREEMPT_AND_ABORT, add the preempting reservation's
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index e4bdabfc4b31..954b0dff32bf 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -86,7 +86,7 @@ struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 					struct se_node_acl *nacl,
 					const char *initiatorname,
 					u64 unpacked_lun,
-					struct se_portal_group *se_tpg,
+					u16 rtpi,
 					struct se_dev_entry *dest_deve,
 					u64 mapped_lun,
 					unsigned char *isid,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 5a81d592530f..bdcd65ce0f62 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -738,8 +738,9 @@ static ssize_t core_tpg_rtpi_show(struct config_item *item, char *page)
 	return sprintf(page, "%#x\n", se_tpg->tpg_rtpi);
 }
 
+
 struct se_portal_group *
-core_get_tpg_by_rtpi(u16 rtpi)
+_core_get_tpg_by_rtpi(u16 rtpi)
 {
 	struct se_portal_group *tpg;
 
@@ -753,6 +754,18 @@ core_get_tpg_by_rtpi(u16 rtpi)
 	return NULL;
 }
 
+struct se_portal_group *
+core_get_tpg_by_rtpi(u16 rtpi)
+{
+	struct se_portal_group *tpg;
+
+	spin_lock(&g_tpg_lock);
+	tpg = _core_get_tpg_by_rtpi(rtpi);
+	spin_unlock(&g_tpg_lock);
+
+	return tpg;
+}
+
 static ssize_t core_tpg_rtpi_store(struct config_item *item,
 				   const char *page, size_t count)
 {
@@ -773,7 +786,7 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 	spin_lock(&g_tpg_lock);
 
 	if (se_tpg->enabled) {
-		tpg = core_get_tpg_by_rtpi(val);
+		tpg = _core_get_tpg_by_rtpi(val);
 		if (tpg) {
 			spin_unlock(&g_tpg_lock);
 			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 64cb943b5d3a..5378e2d3825f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -366,7 +366,6 @@ struct t10_pr_registration {
 	u64 pr_res_key;
 	atomic_t pr_res_holders;
 	struct se_node_acl *pr_reg_nacl;
-	struct se_portal_group *se_tpg;
 	/* Used by ALL_TG_PT=1 registration with deve->pr_ref taken */
 	struct se_dev_entry *pr_reg_deve;
 	struct list_head pr_reg_list;
-- 
2.25.1


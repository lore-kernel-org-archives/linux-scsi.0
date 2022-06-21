Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45481C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiHCQaC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238365AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF90548E87;
        Wed,  3 Aug 2022 09:29:30 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 95044412C8;
        Wed,  3 Aug 2022 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544168; x=1661358569; bh=JHkgEFMleDElEJ2wqhkUHs2WM
        +dDaxJpel72TXz3koY=; b=bRRtaJp7VDpMoEXU4bXRPzl5NVBk8U9HLpGBwQepl
        HEg3+Z+r3cJSnk3bNuytnK1G67psdYiLjmRGY6flFgG7upYnvKyCpAVbs28mD27n
        vF2HY2oV+Lwpf4y1TELO9ZOD75akUKAxak3Unr44u8Umr2tz0DkihZwvBkojhCtN
        DU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hRzGNMd_oW73; Wed,  3 Aug 2022 19:29:28 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D1BEE412DE;
        Wed,  3 Aug 2022 19:29:18 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:18 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:18 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 24/48] target: core: pr: use RTPI in APTPL
Date:   Tue, 21 Jun 2022 16:05:59 +0300
Message-ID: <20220803162857.27770-25-d.bogdanov@yadro.com>
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

Since RTPI is an unique identifier of target port there is no need to
check fabric name and port tag.
RTPI is already saved in APTPL data, so it is backward compatible
change.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c |  4 ++-
 drivers/target/target_core_pr.c       | 41 +++++++--------------------
 drivers/target/target_core_pr.h       |  2 +-
 include/target/target_core_base.h     |  5 ----
 4 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 34901f0b2350..f469cfde3f1e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1993,6 +1993,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	u64 mapped_lun = 0, target_lun = 0;
 	int ret = -1, res_holder = 0, all_tg_pt = 0, arg, token;
 	u16 tpgt = 0;
+	u16 rtpi = 0;
 	u8 type = 0;
 
 	if (!dev->dev_attrib.emulate_pr ||
@@ -2127,6 +2128,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			ret = match_int(args, &arg);
 			if (ret)
 				goto out;
+			rtpi = (u16)arg;
 			break;
 		case Opt_target_lun:
 			ret = match_u64(args, &tmp_ll);
@@ -2153,7 +2155,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	}
 
 	ret = core_scsi3_alloc_aptpl_registration(&dev->t10_pr, sa_res_key,
-			i_port, isid, mapped_lun, t_port, tpgt, target_lun,
+			i_port, isid, mapped_lun, rtpi, target_lun,
 			res_holder, all_tg_pt, type);
 out:
 	kfree(i_fabric);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index dfecb155bf88..1f19bfd0fa00 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -832,8 +832,7 @@ int core_scsi3_alloc_aptpl_registration(
 	unsigned char *i_port,
 	unsigned char *isid,
 	u64 mapped_lun,
-	unsigned char *t_port,
-	u16 tpgt,
+	u16 rtpi,
 	u64 target_lun,
 	int res_holder,
 	int all_tg_pt,
@@ -841,7 +840,7 @@ int core_scsi3_alloc_aptpl_registration(
 {
 	struct t10_pr_registration *pr_reg;
 
-	if (!i_port || !t_port || !sa_res_key) {
+	if (!i_port || !sa_res_key) {
 		pr_err("Illegal parameters for APTPL registration\n");
 		return -EINVAL;
 	}
@@ -867,6 +866,7 @@ int core_scsi3_alloc_aptpl_registration(
 	pr_reg->pr_reg_aptpl = 1;
 	pr_reg->pr_res_scope = 0; /* Always LUN_SCOPE */
 	pr_reg->pr_res_type = type;
+	pr_reg->tg_pt_sep_rtpi = rtpi;
 	/*
 	 * If an ISID value had been saved in APTPL metadata for this
 	 * SCSI Initiator Port, restore it now.
@@ -877,11 +877,9 @@ int core_scsi3_alloc_aptpl_registration(
 		pr_reg->isid_present_at_reg = 1;
 	}
 	/*
-	 * Copy the i_port and t_port information from caller.
+	 * Copy the i_port information from caller.
 	 */
 	snprintf(pr_reg->pr_iport, PR_APTPL_MAX_IPORT_LEN, "%s", i_port);
-	snprintf(pr_reg->pr_tport, PR_APTPL_MAX_TPORT_LEN, "%s", t_port);
-	pr_reg->pr_reg_tpgt = tpgt;
 	/*
 	 * Set pr_res_holder from caller, the pr_reg who is the reservation
 	 * holder will get it's pointer set in core_scsi3_aptpl_reserve() once
@@ -933,17 +931,7 @@ static int __core_scsi3_check_aptpl_registration(
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN] = { };
-	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN] = { };
-	u16 tpgt;
 
-	/*
-	 * Copy Initiator Port information from struct se_node_acl
-	 */
-	snprintf(i_port, PR_APTPL_MAX_IPORT_LEN, "%s", nacl->initiatorname);
-	snprintf(t_port, PR_APTPL_MAX_TPORT_LEN, "%s",
-			tpg->se_tpg_tfo->tpg_get_wwn(tpg));
-	tpgt = tpg->se_tpg_tfo->tpg_get_tag(tpg);
 	/*
 	 * Look for the matching registrations+reservation from those
 	 * created from APTPL metadata.  Note that multiple registrations
@@ -954,11 +942,8 @@ static int __core_scsi3_check_aptpl_registration(
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
 				pr_reg_aptpl_list) {
 
-		if (!strcmp(pr_reg->pr_iport, i_port) &&
-		     (pr_reg->pr_res_mapped_lun == mapped_lun) &&
-		    !(strcmp(pr_reg->pr_tport, t_port)) &&
-		     (pr_reg->pr_reg_tpgt == tpgt) &&
-		     (pr_reg->pr_aptpl_target_lun == target_lun)) {
+		if (!strcmp(pr_reg->pr_iport, nacl->initiatorname) &&
+		     (pr_reg->tg_pt_sep_rtpi == tpg->tpg_rtpi)) {
 			/*
 			 * Obtain the ->pr_reg_deve pointer + reference, that
 			 * is released by __core_scsi3_add_registration() below.
@@ -1851,25 +1836,22 @@ static int core_scsi3_update_aptpl_buf(
 		 * reservation holder.
 		 */
 		if (dev->dev_pr_res_holder == pr_reg) {
-			snprintf(tmp, 512, "PR_REG_START: %d"
-				"\ninitiator_fabric=%s\n"
+			snprintf(tmp, 512, "PR_REG_START: %d\n"
 				"initiator_node=%s\n%s"
 				"sa_res_key=%llu\n"
 				"res_holder=1\nres_type=%02x\n"
 				"res_scope=%02x\nres_all_tg_pt=%d\n"
 				"mapped_lun=%llu\n", reg_count,
-				tpg->se_tpg_tfo->fabric_name,
 				pr_reg->pr_iport, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_res_type,
 				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
 		} else {
 			snprintf(tmp, 512, "PR_REG_START: %d\n"
-				"initiator_fabric=%s\ninitiator_node=%s\n%s"
+				"initiator_node=%s\n%s"
 				"sa_res_key=%llu\nres_holder=0\n"
 				"res_all_tg_pt=%d\nmapped_lun=%llu\n",
-				reg_count, tpg->se_tpg_tfo->fabric_name,
-				pr_reg->pr_iport, isid_buf,
+				reg_count, pr_reg->pr_iport, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
 		}
@@ -1885,9 +1867,8 @@ static int core_scsi3_update_aptpl_buf(
 		/*
 		 * Include information about the associated SCSI target port.
 		 */
-		snprintf(tmp, 512, "target_fabric=%s\ntarget_node=%s\n"
-			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%llu\nPR_REG_END:"
-			" %d\n", tpg->se_tpg_tfo->fabric_name,
+		snprintf(tmp, 512, "target_node=%s\n"
+			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%llu\nPR_REG_END: %d\n",
 			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg),
 			pr_reg->tg_pt_sep_rtpi, pr_reg->pr_aptpl_target_lun,
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 9c4710f34d94..e4bdabfc4b31 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -64,7 +64,7 @@ extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation *, u64,
 			unsigned char *, unsigned char *, u64,
-			unsigned char *, u16, u64, int, int, u8);
+			u16, u64, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
 			struct se_node_acl *, u64);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1b673b25c6cd..095b96cb3557 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -347,11 +347,6 @@ struct t10_pr_registration {
 	/* Used during APTPL metadata reading */
 #define PR_APTPL_MAX_IPORT_LEN			256
 	unsigned char pr_iport[PR_APTPL_MAX_IPORT_LEN];
-	/* Used during APTPL metadata reading */
-#define PR_APTPL_MAX_TPORT_LEN			256
-	unsigned char pr_tport[PR_APTPL_MAX_TPORT_LEN];
-	u16 pr_aptpl_rpti;
-	u16 pr_reg_tpgt;
 	/* Reservation effects all target ports */
 	int pr_reg_all_tg_pt;
 	/* Activate Persistence across Target Power Loss */
-- 
2.25.1


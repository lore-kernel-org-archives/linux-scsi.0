Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC377C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiHCQ3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AB447B9A;
        Wed,  3 Aug 2022 09:29:26 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EE1CE412FB;
        Wed,  3 Aug 2022 16:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544161; x=1661358562; bh=2DK1C7WLPz8HKq9ML7gZnd9y2
        UWaKq7ryGTobmH+KRc=; b=ZKiUaaCWkBxG1LL/e7CBZj0i0oNFZU3O72m2oQn2r
        0w2Ld+PPj/yRwc1g5oJhps+KZxZGQDHG/1/f118MAdcJYYeMYWbTgDk4rR3pTRHS
        Qhk2YdZ+k/Xl0aoDpZgM651wvMsUP5HDb1htEUl85xfF9hOeNTT1yHpBJIaLZREt
        WU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FjStNOJsWKGH; Wed,  3 Aug 2022 19:29:21 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 48FAC412D2;
        Wed,  3 Aug 2022 19:29:16 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:16 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:15 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 16/48] target: core: undepend PR registrant of nacl
Date:   Fri, 24 Dec 2021 12:45:48 +0300
Message-ID: <20220803162857.27770-17-d.bogdanov@yadro.com>
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

Make registration info be independent of nacl. Store and use an
information about initiatror name and target port inside registration
object.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c   |  14 +-
 drivers/target/target_core_device.c     |   7 -
 drivers/target/target_core_fabric_lib.c |  50 ++++----
 drivers/target/target_core_internal.h   |   9 +-
 drivers/target/target_core_pr.c         | 164 ++++++++----------------
 drivers/target/target_core_pr.h         |   2 -
 include/target/target_core_base.h       |   1 +
 7 files changed, 88 insertions(+), 159 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 610de251994e..6e654edc4399 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1735,7 +1735,6 @@ static struct se_device *pr_to_dev(struct config_item *item)
 static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 		char *page)
 {
-	struct se_node_acl *se_nacl;
 	struct t10_pr_registration *pr_reg;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
@@ -1743,12 +1742,11 @@ static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 	if (!pr_reg)
 		return sprintf(page, "No SPC-3 Reservation holder\n");
 
-	se_nacl = pr_reg->pr_reg_nacl;
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	return sprintf(page, "SPC-3 Reservation: %s Initiator: %s%s\n",
-		se_nacl->se_tpg->se_tpg_tfo->fabric_name,
-		se_nacl->initiatorname, i_buf);
+		pr_reg->se_tpg->se_tpg_tfo->fabric_name,
+		pr_reg->pr_iport, i_buf);
 }
 
 static ssize_t target_core_dev_pr_show_spc2_res(struct se_device *dev,
@@ -1823,7 +1821,6 @@ static ssize_t target_pr_res_pr_holder_tg_port_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = pr_to_dev(item);
-	struct se_node_acl *se_nacl;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg;
 	const struct target_core_fabric_ops *tfo;
@@ -1836,8 +1833,7 @@ static ssize_t target_pr_res_pr_holder_tg_port_show(struct config_item *item,
 		goto out_unlock;
 	}
 
-	se_nacl = pr_reg->pr_reg_nacl;
-	se_tpg = se_nacl->se_tpg;
+	se_tpg = pr_reg->se_tpg;
 	tfo = se_tpg->se_tpg_tfo;
 
 	len += sprintf(page+len, "SPC-3 Reservation: %s"
@@ -1874,12 +1870,12 @@ static ssize_t target_pr_res_pr_registered_i_pts_show(struct config_item *item,
 
 		memset(buf, 0, 384);
 		memset(i_buf, 0, PR_REG_ISID_ID_LEN);
-		tfo = pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
+		tfo = pr_reg->se_tpg->se_tpg_tfo;
 		core_pr_dump_initiator_port(pr_reg, i_buf,
 					PR_REG_ISID_ID_LEN);
 		sprintf(buf, "%s Node: %s%s Key: 0x%016Lx PRgen: 0x%08x\n",
 			tfo->fabric_name,
-			pr_reg->pr_reg_nacl->initiatorname, i_buf, pr_reg->pr_res_key,
+			pr_reg->pr_iport, i_buf, pr_reg->pr_res_key,
 			pr_reg->pr_res_generation);
 
 		if (len + strlen(buf) >= PAGE_SIZE)
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c0e4fb7b95d6..a4c31f3112ce 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -391,12 +391,6 @@ void core_disable_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
-	/*
-	 * rcu_dereference_raw protected by se_lun->lun_group symlink
-	 * reference to se_device->dev_group.
-	 */
-	struct se_device *dev = rcu_dereference_raw(lun->lun_se_dev);
-
 	lockdep_assert_held(&nacl->lun_entry_mutex);
 
 	/*
@@ -437,7 +431,6 @@ void core_disable_device_list_for_node(
 
 	kfree_rcu(orig, rcu_head);
 
-	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
 	target_luns_data_has_changed(nacl, NULL, false);
 }
 
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6600ae44f29d..cd1360095036 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -33,14 +33,14 @@
 
 
 static int sas_get_pr_transport_id(
-	struct se_node_acl *nacl,
+	struct t10_pr_registration *pr_reg,
 	int *format_code,
 	unsigned char *buf)
 {
 	int ret;
 
 	/* Skip over 'naa. prefix */
-	ret = hex2bin(&buf[4], &nacl->initiatorname[4], 8);
+	ret = hex2bin(&buf[4], &pr_reg->pr_iport[4], 8);
 	if (ret) {
 		pr_debug("%s: invalid hex string\n", __func__);
 		return ret;
@@ -50,7 +50,7 @@ static int sas_get_pr_transport_id(
 }
 
 static int fc_get_pr_transport_id(
-	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
 	int *format_code,
 	unsigned char *buf)
 {
@@ -62,7 +62,7 @@ static int fc_get_pr_transport_id(
 	 * We convert the ASCII formatted N Port name into a binary
 	 * encoded TransportID.
 	 */
-	ptr = &se_nacl->initiatorname[0];
+	ptr = &pr_reg->pr_iport[0];
 	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
@@ -82,13 +82,13 @@ static int fc_get_pr_transport_id(
 }
 
 static int sbp_get_pr_transport_id(
-	struct se_node_acl *nacl,
+	struct t10_pr_registration *pr_reg,
 	int *format_code,
 	unsigned char *buf)
 {
 	int ret;
 
-	ret = hex2bin(&buf[8], nacl->initiatorname, 8);
+	ret = hex2bin(&buf[8], pr_reg->pr_iport, 8);
 	if (ret) {
 		pr_debug("%s: invalid hex string\n", __func__);
 		return ret;
@@ -98,7 +98,7 @@ static int sbp_get_pr_transport_id(
 }
 
 static int srp_get_pr_transport_id(
-	struct se_node_acl *nacl,
+	struct t10_pr_registration *pr_reg,
 	int *format_code,
 	unsigned char *buf)
 {
@@ -106,7 +106,7 @@ static int srp_get_pr_transport_id(
 	unsigned len, count, leading_zero_bytes;
 	int rc;
 
-	p = nacl->initiatorname;
+	p = pr_reg->pr_iport;
 	if (strncasecmp(p, "0x", 2) == 0)
 		p += 2;
 	len = strlen(p);
@@ -126,7 +126,6 @@ static int srp_get_pr_transport_id(
 }
 
 static int iscsi_get_pr_transport_id(
-	struct se_node_acl *se_nacl,
 	struct t10_pr_registration *pr_reg,
 	int *format_code,
 	unsigned char *buf)
@@ -135,7 +134,6 @@ static int iscsi_get_pr_transport_id(
 	int isid_len;
 	u16 len = 0;
 
-	spin_lock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * Only null terminate the last field.
 	 *
@@ -151,7 +149,7 @@ static int iscsi_get_pr_transport_id(
 	 * length of the iSCSI TransportID or the contents of the ADDITIONAL
 	 * LENGTH field.
 	 */
-	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
+	len = sprintf(&buf[off], "%s", pr_reg->pr_iport);
 	off += len;
 	if ((*format_code == 1) && (pr_reg->isid_present_at_reg)) {
 		/*
@@ -193,7 +191,6 @@ static int iscsi_get_pr_transport_id(
 	}
 	buf[off] = '\0';
 	len += 1;
-	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
 	 * in the TransportID. The additional length shall be at least 20 and
@@ -214,14 +211,12 @@ static int iscsi_get_pr_transport_id(
 }
 
 static int iscsi_get_pr_transport_id_len(
-	struct se_node_acl *se_nacl,
 	struct t10_pr_registration *pr_reg,
 	int *format_code)
 {
 	u32 len = 0, padding = 0;
 
-	spin_lock_irq(&se_nacl->nacl_sess_lock);
-	len = strlen(se_nacl->initiatorname);
+	len = strlen(pr_reg->pr_iport);
 	/*
 	 * Add extra byte for NULL terminator
 	 */
@@ -239,7 +234,6 @@ static int iscsi_get_pr_transport_id_len(
 		*format_code = 1;
 	} else
 		*format_code = 0;
-	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
 	 * in the TransportID. The additional length shall be at least 20 and
@@ -342,19 +336,19 @@ static char *iscsi_parse_pr_out_transport_id(
 	return &buf[4];
 }
 
-int target_get_pr_transport_id_len(struct se_node_acl *nacl,
+int target_get_pr_transport_id_len(
 		struct t10_pr_registration *pr_reg, int *format_code)
 {
-	switch (nacl->se_tpg->proto_id) {
+	switch (pr_reg->se_tpg->proto_id) {
 	case SCSI_PROTOCOL_FCP:
 	case SCSI_PROTOCOL_SBP:
 	case SCSI_PROTOCOL_SRP:
 	case SCSI_PROTOCOL_SAS:
 		break;
 	case SCSI_PROTOCOL_ISCSI:
-		return iscsi_get_pr_transport_id_len(nacl, pr_reg, format_code);
+		return iscsi_get_pr_transport_id_len(pr_reg, format_code);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", nacl->se_tpg->proto_id);
+		pr_err("Unknown proto_id: 0x%02x\n", pr_reg->se_tpg->proto_id);
 		return -EINVAL;
 	}
 
@@ -365,24 +359,24 @@ int target_get_pr_transport_id_len(struct se_node_acl *nacl,
 	return 24;
 }
 
-int target_get_pr_transport_id(struct se_node_acl *nacl,
+int target_get_pr_transport_id(
 		struct t10_pr_registration *pr_reg, int *format_code,
 		unsigned char *buf)
 {
-	switch (nacl->se_tpg->proto_id) {
+	switch (pr_reg->se_tpg->proto_id) {
 	case SCSI_PROTOCOL_SAS:
-		return sas_get_pr_transport_id(nacl, format_code, buf);
+		return sas_get_pr_transport_id(pr_reg, format_code, buf);
 	case SCSI_PROTOCOL_SBP:
-		return sbp_get_pr_transport_id(nacl, format_code, buf);
+		return sbp_get_pr_transport_id(pr_reg, format_code, buf);
 	case SCSI_PROTOCOL_SRP:
-		return srp_get_pr_transport_id(nacl, format_code, buf);
+		return srp_get_pr_transport_id(pr_reg, format_code, buf);
 	case SCSI_PROTOCOL_FCP:
-		return fc_get_pr_transport_id(nacl, format_code, buf);
+		return fc_get_pr_transport_id(pr_reg, format_code, buf);
 	case SCSI_PROTOCOL_ISCSI:
-		return iscsi_get_pr_transport_id(nacl, pr_reg, format_code,
+		return iscsi_get_pr_transport_id(pr_reg, format_code,
 				buf);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", nacl->se_tpg->proto_id);
+		pr_err("Unknown proto_id: 0x%02x\n", pr_reg->se_tpg->proto_id);
 		return -EINVAL;
 	}
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index d4ace697edb0..8bd48eb1cf9b 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -97,11 +97,10 @@ void	target_setup_backend_cits(struct target_backend *);
 int	target_fabric_setup_cits(struct target_fabric_configfs *);
 
 /* target_core_fabric_lib.c */
-int	target_get_pr_transport_id_len(struct se_node_acl *nacl,
-		struct t10_pr_registration *pr_reg, int *format_code);
-int	target_get_pr_transport_id(struct se_node_acl *nacl,
-		struct t10_pr_registration *pr_reg, int *format_code,
-		unsigned char *buf);
+int	target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg,
+				       int *format_code);
+int	target_get_pr_transport_id(struct t10_pr_registration *pr_reg,
+				   int *format_code, unsigned char *buf);
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 844b971827e6..aa967ea74e5b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -64,7 +64,7 @@ enum preempt_type {
 	PREEMPT_AND_ABORT,
 };
 
-static void __core_scsi3_complete_pro_release(struct se_device *, struct se_node_acl *,
+static void __core_scsi3_complete_pro_release(struct se_device *,
 					      struct t10_pr_registration *, int, int);
 
 static int is_reservation_holder(
@@ -609,7 +609,9 @@ static u32 core_scsi3_pr_generation(struct se_device *dev)
 static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
-	struct se_lun *lun,
+	const char *initiatorname,
+	u64 unpacked_lun,
+	struct se_portal_group *se_tpg,
 	struct se_dev_entry *dest_deve,
 	u64 mapped_lun,
 	unsigned char *isid,
@@ -632,6 +634,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
+	strscpy(pr_reg->pr_iport, initiatorname, PR_APTPL_MAX_IPORT_LEN);
 	/*
 	 * For destination registrations for ALL_TG_PT=1 and SPEC_I_PT=1,
 	 * the se_dev_entry->pr_ref will have been already obtained by
@@ -656,8 +659,9 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 		rcu_read_unlock();
 	}
 	pr_reg->pr_res_mapped_lun = mapped_lun;
-	pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
-	pr_reg->tg_pt_sep_rtpi = lun->lun_tpg->tpg_rtpi;
+	pr_reg->pr_aptpl_target_lun = unpacked_lun;
+	pr_reg->tg_pt_sep_rtpi = se_tpg->tpg_rtpi;
+	pr_reg->se_tpg = se_tpg;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
@@ -703,7 +707,10 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 * Create a registration for the I_T Nexus upon which the
 	 * PROUT REGISTER was received.
 	 */
-	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, lun, deve, mapped_lun,
+	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl,
+						    nacl->initiatorname, lun->unpacked_lun,
+						    lun->lun_tpg,
+						    deve, mapped_lun,
 						    isid, sa_res_key, all_tg_pt,
 						    aptpl);
 	if (!pr_reg)
@@ -782,7 +789,11 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				kref_read(&deve_tmp->pr_kref) != 0);
 
 			pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
-						nacl_tmp, dest_lun, deve_tmp,
+						nacl_tmp,
+						nacl_tmp->initiatorname,
+						dest_lun->unpacked_lun,
+						lun->lun_tpg,
+						deve_tmp,
 						deve_tmp->mapped_lun, NULL,
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
@@ -1009,11 +1020,10 @@ int core_scsi3_check_aptpl_registration(
 static void __core_scsi3_dump_registration(
 	const struct target_core_fabric_ops *tfo,
 	struct se_device *dev,
-	struct se_node_acl *nacl,
 	struct t10_pr_registration *pr_reg,
 	enum register_type register_type)
 {
-	struct se_portal_group *se_tpg = nacl->se_tpg;
+	struct se_portal_group *se_tpg = pr_reg->se_tpg;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
@@ -1021,7 +1031,7 @@ static void __core_scsi3_dump_registration(
 	pr_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
 		" Node: %s%s\n", tfo->fabric_name, (register_type == REGISTER_AND_MOVE) ?
 		"_AND_MOVE" : (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
-		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname,
+		"_AND_IGNORE_EXISTING_KEY" : "", pr_reg->pr_iport,
 		i_buf);
 	pr_debug("SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
 		 tfo->fabric_name, tfo->tpg_get_wwn(se_tpg),
@@ -1057,7 +1067,7 @@ static void __core_scsi3_add_registration(
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
 
-	__core_scsi3_dump_registration(tfo, dev, nacl, pr_reg, register_type);
+	__core_scsi3_dump_registration(tfo, dev, pr_reg, register_type);
 	spin_unlock(&pr_tmpl->registration_lock);
 	/*
 	 * Skip extra processing for ALL_TG_PT=0 or REGISTER_AND_MOVE.
@@ -1070,8 +1080,6 @@ static void __core_scsi3_add_registration(
 	 */
 	list_for_each_entry_safe(pr_reg_tmp, pr_reg_tmp_safe,
 			&pr_reg->pr_reg_atp_list, pr_reg_atp_mem_list) {
-		struct se_node_acl *nacl_tmp = pr_reg_tmp->pr_reg_nacl;
-
 		list_del(&pr_reg_tmp->pr_reg_atp_mem_list);
 
 		pr_reg_tmp->pr_res_generation = core_scsi3_pr_generation(dev);
@@ -1080,7 +1088,7 @@ static void __core_scsi3_add_registration(
 		list_add_tail(&pr_reg_tmp->pr_reg_list,
 			      &pr_tmpl->registration_list);
 
-		__core_scsi3_dump_registration(tfo, dev, nacl_tmp, pr_reg_tmp,
+		__core_scsi3_dump_registration(tfo, dev, pr_reg_tmp,
 					       register_type);
 		spin_unlock(&pr_tmpl->registration_lock);
 		/*
@@ -1208,7 +1216,6 @@ static int core_scsi3_check_implicit_release(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg)
 {
-	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	struct t10_pr_registration *pr_res_holder;
 	int ret = 0;
 
@@ -1232,7 +1239,7 @@ static int core_scsi3_check_implicit_release(
 		 *    service action with the SERVICE ACTION RESERVATION KEY
 		 *    field set to zero (see 5.7.11.3).
 		 */
-		__core_scsi3_complete_pro_release(dev, nacl, pr_reg, 0, 1);
+		__core_scsi3_complete_pro_release(dev, pr_reg, 0, 1);
 		ret = 1;
 		/*
 		 * For 'All Registrants' reservation types, all existing
@@ -1241,8 +1248,7 @@ static int core_scsi3_check_implicit_release(
 		 * reservation holder is implicitly released here.
 		 */
 	} else if (pr_reg->pr_reg_all_tg_pt &&
-		  (!strcmp(pr_res_holder->pr_reg_nacl->initiatorname,
-			  pr_reg->pr_reg_nacl->initiatorname)) &&
+		  (!strcmp(pr_res_holder->pr_iport, pr_reg->pr_iport)) &&
 		  (pr_res_holder->pr_res_key == pr_reg->pr_res_key)) {
 		pr_err("SPC-3 PR: Unable to perform ALL_TG_PT=1"
 			" UNREGISTER while existing reservation with matching"
@@ -1264,7 +1270,7 @@ static void __core_scsi3_free_registration(
 	__acquires(&pr_tmpl->registration_lock)
 {
 	const struct target_core_fabric_ops *tfo =
-			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
+			pr_reg->se_tpg->se_tpg_tfo;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	struct se_dev_entry *deve;
@@ -1305,8 +1311,7 @@ static void __core_scsi3_free_registration(
 	spin_lock(&pr_tmpl->registration_lock);
 	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
 		" Node: %s%s\n", tfo->fabric_name,
-		pr_reg->pr_reg_nacl->initiatorname,
-		i_buf);
+		pr_reg->pr_iport, i_buf);
 	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n", tfo->fabric_name,
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
@@ -1328,43 +1333,6 @@ static void __core_scsi3_free_registration(
 	list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
 }
 
-void core_scsi3_free_pr_reg_from_nacl(
-	struct se_device *dev,
-	struct se_node_acl *nacl)
-{
-	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_res_holder;
-	bool free_reg = false;
-	/*
-	 * If the passed se_node_acl matches the reservation holder,
-	 * release the reservation.
-	 */
-	spin_lock(&dev->dev_reservation_lock);
-	pr_res_holder = dev->dev_pr_res_holder;
-	if ((pr_res_holder != NULL) &&
-	    (pr_res_holder->pr_reg_nacl == nacl)) {
-		__core_scsi3_complete_pro_release(dev, nacl, pr_res_holder, 0, 1);
-		free_reg = true;
-	}
-	spin_unlock(&dev->dev_reservation_lock);
-	/*
-	 * Release any registration associated with the struct se_node_acl.
-	 */
-	spin_lock(&pr_tmpl->registration_lock);
-	if (pr_res_holder && free_reg)
-		__core_scsi3_free_registration(dev, pr_res_holder, NULL, 0);
-
-	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
-			&pr_tmpl->registration_list, pr_reg_list) {
-
-		if (pr_reg->pr_reg_nacl != nacl)
-			continue;
-
-		__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
-	}
-	spin_unlock(&pr_tmpl->registration_lock);
-}
-
 void core_scsi3_free_all_registrations(
 	struct se_device *dev)
 {
@@ -1373,11 +1341,8 @@ void core_scsi3_free_all_registrations(
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
-	if (pr_res_holder != NULL) {
-		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
-						  pr_res_holder, 0, 0);
-	}
+	if (pr_res_holder != NULL)
+		__core_scsi3_complete_pro_release(dev, pr_res_holder, 0, 0);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	spin_lock(&pr_tmpl->registration_lock);
@@ -1872,7 +1837,7 @@ static int core_scsi3_update_aptpl_buf(
 
 		tmp[0] = '\0';
 		isid_buf[0] = '\0';
-		tpg = pr_reg->pr_reg_nacl->se_tpg;
+		tpg = pr_reg->se_tpg;
 		/*
 		 * Write out any ISID value to APTPL metadata that was included
 		 * in the original registration.
@@ -1893,7 +1858,7 @@ static int core_scsi3_update_aptpl_buf(
 				"res_scope=%02x\nres_all_tg_pt=%d\n"
 				"mapped_lun=%llu\n", reg_count,
 				tpg->se_tpg_tfo->fabric_name,
-				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
+				pr_reg->pr_iport, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_res_type,
 				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
@@ -1903,7 +1868,7 @@ static int core_scsi3_update_aptpl_buf(
 				"sa_res_key=%llu\nres_holder=0\n"
 				"res_all_tg_pt=%d\nmapped_lun=%llu\n",
 				reg_count, tpg->se_tpg_tfo->fabric_name,
-				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
+				pr_reg->pr_iport, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
 		}
@@ -2149,7 +2114,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			 " Key for %s to: 0x%016Lx PRgeneration:"
 			 " 0x%08x\n", cmd->se_tfo->fabric_name,
 			 (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ? "_AND_IGNORE_EXISTING_KEY" : "",
-			 pr_reg->pr_reg_nacl->initiatorname,
+			 pr_reg->pr_iport,
 			 pr_reg->pr_res_key, pr_reg->pr_res_generation);
 
 	} else {
@@ -2180,8 +2145,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					continue;
 				if (pr_reg == pr_reg_p)
 					continue;
-				if (strcmp(pr_reg->pr_reg_nacl->initiatorname,
-					   pr_reg_p->pr_reg_nacl->initiatorname))
+				if (strcmp(pr_reg->pr_iport,
+					   pr_reg_p->pr_iport))
 					continue;
 
 				__core_scsi3_free_registration(dev,
@@ -2329,14 +2294,13 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 * RESERVATION CONFLICT status.
 		 */
 		if (!is_reservation_holder(pr_res_holder, pr_reg)) {
-			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 			pr_err("SPC-3 PR: Attempted RESERVE from"
 				" [%s]: %s while reservation already held by"
 				" [%s]: %s, returning RESERVATION_CONFLICT\n",
 				cmd->se_tfo->fabric_name,
 				se_sess->se_node_acl->initiatorname,
-				pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-				pr_res_holder->pr_reg_nacl->initiatorname);
+				pr_res_holder->se_tpg->se_tpg_tfo->fabric_name,
+				pr_res_holder->pr_iport);
 
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2351,15 +2315,14 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 */
 		if ((pr_res_holder->pr_res_type != type) ||
 		    (pr_res_holder->pr_res_scope != scope)) {
-			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 			pr_err("SPC-3 PR: Attempted RESERVE from"
 				" [%s]: %s trying to change TYPE and/or SCOPE,"
 				" while reservation already held by [%s]: %s,"
 				" returning RESERVATION_CONFLICT\n",
 				cmd->se_tfo->fabric_name,
 				se_sess->se_node_acl->initiatorname,
-				pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-				pr_res_holder->pr_reg_nacl->initiatorname);
+				pr_res_holder->se_tpg->se_tpg_tfo->fabric_name,
+				pr_res_holder->pr_iport);
 
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2429,12 +2392,11 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 
 static void __core_scsi3_complete_pro_release(
 	struct se_device *dev,
-	struct se_node_acl *se_nacl,
 	struct t10_pr_registration *pr_reg,
 	int explicit,
 	int unreg)
 {
-	const struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
+	const struct target_core_fabric_ops *tfo = pr_reg->se_tpg->se_tpg_tfo;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	int pr_res_type = 0, pr_res_scope = 0;
 
@@ -2486,7 +2448,7 @@ static void __core_scsi3_complete_pro_release(
 			(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	}
 	pr_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n",
-		tfo->fabric_name, se_nacl->initiatorname,
+		tfo->fabric_name, pr_reg->pr_iport,
 		i_buf);
 	/*
 	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
@@ -2579,15 +2541,14 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 */
 	if ((pr_res_holder->pr_res_type != type) ||
 	    (pr_res_holder->pr_res_scope != scope)) {
-		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 		pr_err("SPC-3 PR RELEASE: Attempted to release"
 			" reservation from [%s]: %s with different TYPE "
 			"and/or SCOPE  while reservation already held by"
 			" [%s]: %s, returning RESERVATION_CONFLICT\n",
 			cmd->se_tfo->fabric_name,
 			se_sess->se_node_acl->initiatorname,
-			pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-			pr_res_holder->pr_reg_nacl->initiatorname);
+			pr_res_holder->se_tpg->se_tpg_tfo->fabric_name,
+			pr_res_holder->pr_iport);
 
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
@@ -2609,8 +2570,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 * d) If the persistent reservation is of any other type, the device
 	 *    server shall not establish a unit attention condition.
 	 */
-	__core_scsi3_complete_pro_release(dev, se_sess->se_node_acl,
-					  pr_reg, 1, 0);
+	__core_scsi3_complete_pro_release(dev, pr_reg, 1, 0);
 
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -2695,11 +2655,8 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	 */
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
-	if (pr_res_holder) {
-		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
-						  pr_res_holder, 0, 0);
-	}
+	if (pr_res_holder)
+		__core_scsi3_complete_pro_release(dev, pr_res_holder, 0, 0);
 	spin_unlock(&dev->dev_reservation_lock);
 	/*
 	 * b) Remove all registration(s) (see spc4r17 5.7.7);
@@ -2743,8 +2700,7 @@ static void __core_scsi3_complete_pro_preempt(
 	int scope,
 	enum preempt_type preempt_type)
 {
-	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
-	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	const struct target_core_fabric_ops *tfo = pr_reg->se_tpg->se_tpg_tfo;
 	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	lockdep_assert_held(&dev->dev_reservation_lock);
@@ -2754,8 +2710,7 @@ static void __core_scsi3_complete_pro_preempt(
 	 * Do an implicit RELEASE of the existing reservation.
 	 */
 	if (dev->dev_pr_res_holder)
-		__core_scsi3_complete_pro_release(dev, nacl,
-						  dev->dev_pr_res_holder, 0, 0);
+		__core_scsi3_complete_pro_release(dev, dev->dev_pr_res_holder, 0, 0);
 
 	dev->dev_pr_res_holder = pr_reg;
 	pr_reg->pr_res_holder = 1;
@@ -2769,7 +2724,7 @@ static void __core_scsi3_complete_pro_preempt(
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	pr_debug("SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n",
 		tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
-		nacl->initiatorname, i_buf);
+		pr_reg->pr_iport, i_buf);
 	/*
 	 * For PREEMPT_AND_ABORT, add the preempting reservation's
 	 * struct t10_pr_registration to the list that will be compared
@@ -3015,7 +2970,6 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	 */
 	if (pr_reg_n != pr_res_holder)
 		__core_scsi3_complete_pro_release(dev,
-						  pr_res_holder->pr_reg_nacl,
 						  dev->dev_pr_res_holder, 0, 0);
 	/*
 	 * b) Remove the registrations for all I_T nexuses identified
@@ -3142,7 +3096,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *dest_se_deve = NULL;
 	struct se_lun *se_lun = cmd->se_lun, *tmp_lun;
-	struct se_node_acl *pr_res_nacl, *pr_reg_nacl, *dest_node_acl = NULL;
+	struct se_node_acl *dest_node_acl = NULL;
 	struct se_portal_group *se_tpg, *dest_se_tpg = NULL;
 	const struct target_core_fabric_ops *dest_tf_ops = NULL, *tf_ops;
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
@@ -3297,23 +3251,21 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * ILLEGAL REQUEST, and the additional sense code set to INVALID FIELD
 	 * IN PARAMETER LIST.
 	 */
-	pr_reg_nacl = pr_reg->pr_reg_nacl;
-	matching_iname = (!strcmp(initiator_str,
-				  pr_reg_nacl->initiatorname)) ? 1 : 0;
+	matching_iname = !strcmp(initiator_str, pr_reg->pr_iport);
 	if (!matching_iname)
 		goto after_iport_check;
 
 	if (!iport_ptr || !pr_reg->isid_present_at_reg) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
 			" matches: %s on received I_T Nexus\n", initiator_str,
-			pr_reg_nacl->initiatorname);
+			pr_reg->pr_iport);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 	if (!strcmp(iport_ptr, pr_reg->pr_reg_isid)) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
 			" matches: %s %s on received I_T Nexus\n",
-			initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
+			initiator_str, iport_ptr, pr_reg->pr_iport,
 			pr_reg->pr_reg_isid);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3419,7 +3371,6 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
 	}
-	pr_res_nacl = pr_res_holder->pr_reg_nacl;
 	/*
 	 * b) Ignore the contents of the (received) SCOPE and TYPE fields;
 	 */
@@ -3471,8 +3422,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * f) Release the persistent reservation for the persistent reservation
 	 *    holder (i.e., the I_T nexus on which the
 	 */
-	__core_scsi3_complete_pro_release(dev, pr_res_nacl,
-					  dev->dev_pr_res_holder, 0, 0);
+	__core_scsi3_complete_pro_release(dev, dev->dev_pr_res_holder, 0, 0);
 	/*
 	 * g) Move the persistent reservation to the specified I_T nexus using
 	 *    the same scope and type as the persistent reservation released in
@@ -3497,7 +3447,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		dest_pr_reg->pr_res_generation);
 	pr_debug("SPC-3 PR Successfully moved reservation from"
 		" %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
-		tf_ops->fabric_name, pr_reg_nacl->initiatorname,
+		tf_ops->fabric_name, pr_reg->pr_iport,
 		i_buf, dest_tf_ops->fabric_name,
 		dest_node_acl->initiatorname, (iport_ptr != NULL) ?
 		iport_ptr : "");
@@ -3885,7 +3835,6 @@ static sense_reason_t
 core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_node_acl *se_nacl;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
@@ -3925,8 +3874,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
 
-		se_nacl = pr_reg->pr_reg_nacl;
-		se_tpg = pr_reg->pr_reg_nacl->se_tpg;
+		se_tpg = pr_reg->se_tpg;
 		add_desc_len = 0;
 
 		atomic_inc_mb(&pr_reg->pr_res_holders);
@@ -3935,7 +3883,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		 * Determine expected length of $FABRIC_MOD specific
 		 * TransportID full status descriptor..
 		 */
-		exp_desc_len = target_get_pr_transport_id_len(se_nacl, pr_reg,
+		exp_desc_len = target_get_pr_transport_id_len(pr_reg,
 					&format_code);
 		if (exp_desc_len < 0 ||
 		    exp_desc_len + add_len > cmd->data_length) {
@@ -4001,7 +3949,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		/*
 		 * Now, have the $FABRIC_MOD fill in the transport ID.
 		 */
-		desc_len = target_get_pr_transport_id(se_nacl, pr_reg,
+		desc_len = target_get_pr_transport_id(pr_reg,
 				&format_code, &buf[off+4]);
 
 		spin_lock(&pr_tmpl->registration_lock);
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index b793c99637ab..202f9aec963a 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -68,8 +68,6 @@ extern int core_scsi3_alloc_aptpl_registration(
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
 			struct se_node_acl *, u64);
-extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
-					     struct se_node_acl *);
 extern void core_scsi3_free_all_registrations(struct se_device *);
 extern unsigned char *core_scsi3_pr_dump_type(int);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 91c068525c02..1b673b25c6cd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -369,6 +369,7 @@ struct t10_pr_registration {
 	u64 pr_res_key;
 	atomic_t pr_res_holders;
 	struct se_node_acl *pr_reg_nacl;
+	struct se_portal_group *se_tpg;
 	/* Used by ALL_TG_PT=1 registration with deve->pr_ref taken */
 	struct se_dev_entry *pr_reg_deve;
 	struct list_head pr_reg_list;
-- 
2.25.1


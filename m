Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AD4C19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbiHCQaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20FF48EAA;
        Wed,  3 Aug 2022 09:29:32 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 62655412DE;
        Wed,  3 Aug 2022 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544169; x=1661358570; bh=ZtkUYIiT6/VUOQLgeQB4CnRUx
        cqaT5oWQY8y1mEYyMw=; b=iqMknBiXmhWWjQIYeiBNKlLD84tE+P+625Eh35RHU
        NoMyYicWMpkURDqWoEaYhc4GiAwU+AHbTZ4qpau/B+eY6lTCxz+fUFTwuer0EKzi
        cydN66u8IGI5gia/d/tN83MguwLDYg1oz4XASveKtwmbGtSB4+ztyu/2JN5iaUZE
        kk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SNVQ2N-9_AQQ; Wed,  3 Aug 2022 19:29:29 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3D3E041239;
        Wed,  3 Aug 2022 19:29:19 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
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
Subject: [RFC PATCH 25/48] target: core: pr: have Transport ID stored
Date:   Wed, 27 Jul 2022 19:21:02 +0300
Message-ID: <20220803162857.27770-26-d.bogdanov@yadro.com>
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

Store TransportID in pr_reg at its creation.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_fabric_lib.c | 130 +++++++++---------------
 drivers/target/target_core_internal.h   |   9 +-
 drivers/target/target_core_pr.c         |  19 ++--
 include/target/target_core_base.h       |   2 +
 4 files changed, 68 insertions(+), 92 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index cd1360095036..32c2afbb3033 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -33,14 +33,14 @@
 
 
 static int sas_get_pr_transport_id(
-	struct t10_pr_registration *pr_reg,
-	int *format_code,
+	const char *initiatorname,
 	unsigned char *buf)
 {
 	int ret;
 
+	buf[0] = SCSI_PROTOCOL_SAS;
 	/* Skip over 'naa. prefix */
-	ret = hex2bin(&buf[4], &pr_reg->pr_iport[4], 8);
+	ret = hex2bin(&buf[4], &initiatorname[4], 8);
 	if (ret) {
 		pr_debug("%s: invalid hex string\n", __func__);
 		return ret;
@@ -50,19 +50,19 @@ static int sas_get_pr_transport_id(
 }
 
 static int fc_get_pr_transport_id(
-	struct t10_pr_registration *pr_reg,
-	int *format_code,
+	const char *initiatorname,
 	unsigned char *buf)
 {
-	unsigned char *ptr;
+	const char *ptr;
 	int i, ret;
 	u32 off = 8;
 
+	buf[0] = SCSI_PROTOCOL_FCP;
 	/*
 	 * We convert the ASCII formatted N Port name into a binary
 	 * encoded TransportID.
 	 */
-	ptr = &pr_reg->pr_iport[0];
+	ptr = &initiatorname[0];
 	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
@@ -82,13 +82,14 @@ static int fc_get_pr_transport_id(
 }
 
 static int sbp_get_pr_transport_id(
-	struct t10_pr_registration *pr_reg,
-	int *format_code,
+	const char *initiatorname,
 	unsigned char *buf)
 {
 	int ret;
 
-	ret = hex2bin(&buf[8], pr_reg->pr_iport, 8);
+	buf[0] = SCSI_PROTOCOL_SBP;
+
+	ret = hex2bin(&buf[8], initiatorname, 8);
 	if (ret) {
 		pr_debug("%s: invalid hex string\n", __func__);
 		return ret;
@@ -98,15 +99,16 @@ static int sbp_get_pr_transport_id(
 }
 
 static int srp_get_pr_transport_id(
-	struct t10_pr_registration *pr_reg,
-	int *format_code,
+	const char *initiatorname,
 	unsigned char *buf)
 {
 	const char *p;
 	unsigned len, count, leading_zero_bytes;
 	int rc;
 
-	p = pr_reg->pr_iport;
+	buf[0] = SCSI_PROTOCOL_SRP;
+
+	p = initiatorname;
 	if (strncasecmp(p, "0x", 2) == 0)
 		p += 2;
 	len = strlen(p);
@@ -126,14 +128,16 @@ static int srp_get_pr_transport_id(
 }
 
 static int iscsi_get_pr_transport_id(
-	struct t10_pr_registration *pr_reg,
-	int *format_code,
+	const char *initiatorname,
+	unsigned char *isid,
 	unsigned char *buf)
 {
 	u32 off = 4, padding = 0;
 	int isid_len;
 	u16 len = 0;
 
+	buf[0] = SCSI_PROTOCOL_ISCSI;
+
 	/*
 	 * Only null terminate the last field.
 	 *
@@ -149,9 +153,9 @@ static int iscsi_get_pr_transport_id(
 	 * length of the iSCSI TransportID or the contents of the ADDITIONAL
 	 * LENGTH field.
 	 */
-	len = sprintf(&buf[off], "%s", pr_reg->pr_iport);
+	len = sprintf(&buf[off], "%s", initiatorname);
 	off += len;
-	if ((*format_code == 1) && (pr_reg->isid_present_at_reg)) {
+	if (isid) {
 		/*
 		 * Set FORMAT CODE 01b for iSCSI Initiator port TransportID
 		 * format.
@@ -185,7 +189,7 @@ static int iscsi_get_pr_transport_id(
 		buf[off++] = 0x78; /* ASCII Character: "x" */
 		len += 5;
 
-		isid_len = sprintf(buf + off, "%s", pr_reg->pr_reg_isid);
+		isid_len = sprintf(buf + off, "%s", isid);
 		off += isid_len;
 		len += isid_len;
 	}
@@ -210,47 +214,6 @@ static int iscsi_get_pr_transport_id(
 	return len;
 }
 
-static int iscsi_get_pr_transport_id_len(
-	struct t10_pr_registration *pr_reg,
-	int *format_code)
-{
-	u32 len = 0, padding = 0;
-
-	len = strlen(pr_reg->pr_iport);
-	/*
-	 * Add extra byte for NULL terminator
-	 */
-	len++;
-	/*
-	 * If there is ISID present with the registration, use format code:
-	 * 01b: iSCSI Initiator port TransportID format
-	 *
-	 * If there is not an active iSCSI session, use format code:
-	 * 00b: iSCSI Initiator device TransportID format
-	 */
-	if (pr_reg->isid_present_at_reg) {
-		len += 5; /* For ",i,0x" ASCII separator */
-		len += strlen(pr_reg->pr_reg_isid);
-		*format_code = 1;
-	} else
-		*format_code = 0;
-	/*
-	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
-	 * in the TransportID. The additional length shall be at least 20 and
-	 * shall be a multiple of four.
-	 */
-	padding = ((-len) & 3);
-	if (padding != 0)
-		len += padding;
-	/*
-	 * Increment value for total payload + header length for
-	 * full status descriptor
-	 */
-	len += 4;
-
-	return len;
-}
-
 static char *iscsi_parse_pr_out_transport_id(
 	struct se_portal_group *se_tpg,
 	char *buf,
@@ -336,47 +299,54 @@ static char *iscsi_parse_pr_out_transport_id(
 	return &buf[4];
 }
 
-int target_get_pr_transport_id_len(
-		struct t10_pr_registration *pr_reg, int *format_code)
+int target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg)
 {
-	switch (pr_reg->se_tpg->proto_id) {
+	switch (pr_reg->pr_tid[0] & 0xF) {
 	case SCSI_PROTOCOL_FCP:
 	case SCSI_PROTOCOL_SBP:
 	case SCSI_PROTOCOL_SRP:
 	case SCSI_PROTOCOL_SAS:
-		break;
+		return 24;
 	case SCSI_PROTOCOL_ISCSI:
-		return iscsi_get_pr_transport_id_len(pr_reg, format_code);
+		return get_unaligned_be16(&pr_reg->pr_tid[2]) + 4;
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", pr_reg->se_tpg->proto_id);
+		WARN(1, "Unknown proto_id: %#x\n", pr_reg->pr_tid[0] & 0xF);
 		return -EINVAL;
 	}
-
-	/*
-	 * Most transports use a fixed length 24 byte identifier.
-	 */
-	*format_code = 0;
-	return 24;
 }
 
 int target_get_pr_transport_id(
-		struct t10_pr_registration *pr_reg, int *format_code,
+		struct t10_pr_registration *pr_reg,
 		unsigned char *buf)
 {
-	switch (pr_reg->se_tpg->proto_id) {
+	int len =  target_get_pr_transport_id_len(pr_reg);
+
+	if (len > 0)
+		memcpy(buf, pr_reg->pr_tid, len);
+
+	return  len;
+}
+
+int target_gen_pr_transport_id(
+	struct t10_pr_registration *pr_reg,
+	int proto_id,
+	const char *initiatorname,
+	unsigned char *isid)
+{
+
+	switch (proto_id) {
 	case SCSI_PROTOCOL_SAS:
-		return sas_get_pr_transport_id(pr_reg, format_code, buf);
+		return sas_get_pr_transport_id(initiatorname, pr_reg->pr_tid);
 	case SCSI_PROTOCOL_SBP:
-		return sbp_get_pr_transport_id(pr_reg, format_code, buf);
+		return sbp_get_pr_transport_id(initiatorname, pr_reg->pr_tid);
 	case SCSI_PROTOCOL_SRP:
-		return srp_get_pr_transport_id(pr_reg, format_code, buf);
+		return srp_get_pr_transport_id(initiatorname, pr_reg->pr_tid);
 	case SCSI_PROTOCOL_FCP:
-		return fc_get_pr_transport_id(pr_reg, format_code, buf);
+		return fc_get_pr_transport_id(initiatorname, pr_reg->pr_tid);
 	case SCSI_PROTOCOL_ISCSI:
-		return iscsi_get_pr_transport_id(pr_reg, format_code,
-				buf);
+		return iscsi_get_pr_transport_id(initiatorname, isid, pr_reg->pr_tid);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", pr_reg->se_tpg->proto_id);
+		pr_err("Unknown proto_id: 0x%02x\n", proto_id);
 		return -EINVAL;
 	}
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index b32ac78a26b0..95d5add73578 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -98,10 +98,13 @@ void	target_setup_backend_cits(struct target_backend *);
 int	target_fabric_setup_cits(struct target_fabric_configfs *);
 
 /* target_core_fabric_lib.c */
-int	target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg,
-				       int *format_code);
+int	target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg);
 int	target_get_pr_transport_id(struct t10_pr_registration *pr_reg,
-				   int *format_code, unsigned char *buf);
+				   unsigned char *buf);
+int target_gen_pr_transport_id(struct t10_pr_registration *pr_reg,
+			       int proto_id,
+			       const char *initiatorname,
+			       unsigned char *isid);
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1f19bfd0fa00..d9e7d177b65a 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -716,6 +716,10 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						    aptpl);
 	if (!pr_reg)
 		return NULL;
+
+	target_gen_pr_transport_id(pr_reg, nacl->se_tpg->proto_id,
+				   nacl->initiatorname, isid);
+
 	/*
 	 * Return pointer to pr_reg for ALL_TG_PT=0
 	 */
@@ -802,6 +806,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
+			target_gen_pr_transport_id(pr_reg_atp,
+						   nacl_tmp->se_tpg->proto_id,
+						   nacl_tmp->initiatorname, isid);
 
 			list_add_tail(&pr_reg_atp->pr_reg_atp_mem_list,
 				      &pr_reg->pr_reg_atp_list);
@@ -3829,13 +3836,12 @@ static sense_reason_t
 core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
 	u32 add_desc_len = 0, add_len = 0;
 	u32 off = 8; /* off into first Full Status descriptor */
-	int format_code = 0, pr_res_type = 0, pr_res_scope = 0;
+	int pr_res_type = 0, pr_res_scope = 0;
 	int exp_desc_len, desc_len;
 	bool all_reg = false;
 
@@ -3868,7 +3874,6 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
 
-		se_tpg = pr_reg->se_tpg;
 		add_desc_len = 0;
 
 		atomic_inc_mb(&pr_reg->pr_res_holders);
@@ -3877,8 +3882,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		 * Determine expected length of $FABRIC_MOD specific
 		 * TransportID full status descriptor..
 		 */
-		exp_desc_len = target_get_pr_transport_id_len(pr_reg,
-					&format_code);
+		exp_desc_len = target_get_pr_transport_id_len(pr_reg);
 		if (exp_desc_len < 0 ||
 		    exp_desc_len + add_len > cmd->data_length) {
 			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
@@ -3938,13 +3942,10 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		} else
 			off += 2; /* Skip over RELATIVE TARGET PORT IDENTIFIER */
 
-		buf[off+4] = se_tpg->proto_id;
-
 		/*
 		 * Now, have the $FABRIC_MOD fill in the transport ID.
 		 */
-		desc_len = target_get_pr_transport_id(pr_reg,
-				&format_code, &buf[off+4]);
+		desc_len = target_get_pr_transport_id(pr_reg, &buf[off+4]);
 
 		spin_lock(&pr_tmpl->registration_lock);
 		atomic_dec_mb(&pr_reg->pr_res_holders);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 095b96cb3557..64cb943b5d3a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -347,6 +347,8 @@ struct t10_pr_registration {
 	/* Used during APTPL metadata reading */
 #define PR_APTPL_MAX_IPORT_LEN			256
 	unsigned char pr_iport[PR_APTPL_MAX_IPORT_LEN];
+#define PR_REG_TID_LEN				228
+	char pr_tid[PR_REG_TID_LEN];
 	/* Reservation effects all target ports */
 	int pr_reg_all_tg_pt;
 	/* Activate Persistence across Target Power Loss */
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC83EC19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiHCQaG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238391AbiHCQ3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:38 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5466459B6;
        Wed,  3 Aug 2022 09:29:36 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7A7AD412C9;
        Wed,  3 Aug 2022 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544173; x=1661358574; bh=TCXblozmIVmynphH0B4NyTbP9
        sorYOmcrwF9Vmk/j2s=; b=h248h8LPmIFcudGiZ/r1U1LJIWz4Ydh0vKMjp/Nwb
        KUqYumI8dKpw0n+z5Jdil4mCHP2yfOrRvqhG5bvMCroNj5UTd5U/J/FX5AApCU7o
        YrUcNcwFV2LBUb0l07idcrwfnacK/JBb6NYRfrKtrfHUXe7Pc+A9rmz2nPQFh8mI
        iE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9W0VOue28IP1; Wed,  3 Aug 2022 19:29:33 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C9161412E1;
        Wed,  3 Aug 2022 19:29:19 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:19 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:19 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 27/48] target: core: fix parsing PR OUT TID
Date:   Wed, 29 Jun 2022 10:50:28 +0300
Message-ID: <20220803162857.27770-28-d.bogdanov@yadro.com>
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

Now only iSCSI TransportID is parsed. From other protocols the binary
representation is passed to tcm core. That is wrong as that TID is
compared against nacl->initiatorname which is in human readable format.
This patch adds a parsing of TID for other protocols.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_fabric_lib.c | 119 ++++++++++++++++--------
 drivers/target/target_core_internal.h   |   4 +-
 drivers/target/target_core_pr.c         |  14 ++-
 3 files changed, 89 insertions(+), 48 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 32c2afbb3033..34fdab558e24 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -214,15 +214,67 @@ static int iscsi_get_pr_transport_id(
 	return len;
 }
 
-static char *iscsi_parse_pr_out_transport_id(
-	struct se_portal_group *se_tpg,
-	char *buf,
-	u32 *out_tid_len,
+static u32 sas_parse_pr_out_transport_id(
+	const char *buf,
+	char *initiatorname,
+	char **port_nexus_ptr)
+{
+	char port_name[17];
+
+	bin2hex(port_name, buf + 4, 8);
+	snprintf(initiatorname, 36, "naa.%s", port_name);
+
+	return 24;
+}
+
+
+static u32 sbp_parse_pr_out_transport_id(
+	const char *buf,
+	char *initiatorname,
+	char **port_nexus_ptr)
+{
+	bin2hex(initiatorname, buf + 8, 8);
+
+	return 24;
+}
+
+static u32 srp_parse_pr_out_transport_id(
+	const char *buf,
+	char *initiatorname,
+	char **port_nexus_ptr)
+{
+	char port_name[33];
+
+	bin2hex(port_name, buf + 8, 16);
+	snprintf(initiatorname, 36, "0x%s", port_name);
+
+	return 24;
+}
+
+static u32 fc_parse_pr_out_transport_id(
+	const char *buf,
+	char *initiatorname,
+	char **port_nexus_ptr)
+{
+	/*
+	 * Format the FCP Initiator port_name into colon separated values to
+	 * match the format by tcm_qla2xxx explicit ConfigFS NodeACLs.
+	 */
+	snprintf(initiatorname, 36, "%8phC", buf + 8);
+
+	return 24;
+}
+
+u32 iscsi_parse_pr_out_transport_id(
+	const char *buf,
+	char *initiatorname,
 	char **port_nexus_ptr)
 {
 	char *p;
 	int i;
 	u8 format_code = (buf[0] & 0xc0);
+	u32 out_tid_len;
+
 	/*
 	 * Check for FORMAT CODE 00b or 01b from spc4r17, section 7.5.4.6:
 	 *
@@ -239,18 +291,10 @@ static char *iscsi_parse_pr_out_transport_id(
 	if ((format_code != 0x00) && (format_code != 0x40)) {
 		pr_err("Illegal format code: 0x%02x for iSCSI"
 			" Initiator Transport ID\n", format_code);
-		return NULL;
-	}
-	/*
-	 * If the caller wants the TransportID Length, we set that value for the
-	 * entire iSCSI Tarnsport ID now.
-	 */
-	if (out_tid_len) {
-		/* The shift works thanks to integer promotion rules */
-		*out_tid_len = get_unaligned_be16(&buf[2]);
-		/* Add four bytes for iSCSI Transport ID header */
-		*out_tid_len += 4;
+		return 0;
 	}
+	/* The shift works thanks to integer promotion rules */
+	out_tid_len = get_unaligned_be16(&buf[2]);
 
 	/*
 	 * Check for ',i,0x' separator between iSCSI Name and iSCSI Initiator
@@ -263,9 +307,10 @@ static char *iscsi_parse_pr_out_transport_id(
 			pr_err("Unable to locate \",i,0x\" separator"
 				" for Initiator port identifier: %s\n",
 				&buf[4]);
-			return NULL;
+			return 0;
 		}
-		*p = '\0'; /* Terminate iSCSI Name */
+		memcpy(initiatorname, &buf[4], p - buf - 4);
+		initiatorname[p - buf - 4] = '\0'; /* Terminate iSCSI Name */
 		p += 5; /* Skip over ",i,0x" separator */
 
 		*port_nexus_ptr = p;
@@ -293,10 +338,16 @@ static char *iscsi_parse_pr_out_transport_id(
 			*p = tolower(*p);
 			p++;
 		}
-	} else
+	} else {
+		strscpy(initiatorname, &buf[4], out_tid_len);
+		initiatorname[p - buf] = '\0'; /* Terminate iSCSI Name */
 		*port_nexus_ptr = NULL;
+	}
+
+	/* Add four bytes for iSCSI Transport ID header */
+	out_tid_len += 4;
 
-	return &buf[4];
+	return out_tid_len;
 }
 
 int target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg)
@@ -351,33 +402,25 @@ int target_gen_pr_transport_id(
 	}
 }
 
-const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr)
+u32 target_parse_pr_out_transport_id(
+	const char *buf, char *initiatorname, char **port_nexus_ptr)
 {
-	u32 offset;
-
-	switch (tpg->proto_id) {
+	switch (buf[0] & 0xF) {
 	case SCSI_PROTOCOL_SAS:
-		/*
-		 * Assume the FORMAT CODE 00b from spc4r17, 7.5.4.7 TransportID
-		 * for initiator ports using SCSI over SAS Serial SCSI Protocol.
-		 */
-		offset = 4;
-		break;
+		return sas_parse_pr_out_transport_id(buf, initiatorname, port_nexus_ptr);
 	case SCSI_PROTOCOL_SBP:
+		return sbp_parse_pr_out_transport_id(buf, initiatorname, port_nexus_ptr);
 	case SCSI_PROTOCOL_SRP:
+		return srp_parse_pr_out_transport_id(buf, initiatorname, port_nexus_ptr);
 	case SCSI_PROTOCOL_FCP:
-		offset = 8;
-		break;
+		return fc_parse_pr_out_transport_id(buf, initiatorname, port_nexus_ptr);
 	case SCSI_PROTOCOL_ISCSI:
-		return iscsi_parse_pr_out_transport_id(tpg, buf, out_tid_len,
-					port_nexus_ptr);
+		return iscsi_parse_pr_out_transport_id(buf, initiatorname, port_nexus_ptr);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
-		return NULL;
+		pr_err("Unknown proto_id: 0x%02x\n", buf[0] & 0xF);
+		return 0;
 	}
 
 	*port_nexus_ptr = NULL;
-	*out_tid_len = 24;
-	return buf + offset;
+	return 24;
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 51c0151c05c2..bbdddcd83fa4 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -105,8 +105,8 @@ int target_gen_pr_transport_id(struct t10_pr_registration *pr_reg,
 			       int proto_id,
 			       const char *initiatorname,
 			       unsigned char *isid);
-const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
+u32 target_parse_pr_out_transport_id(
+	const char *buf, char *initiatorname, char **port_nexus_ptr);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c4ee6999cf96..f5796d60ed76 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1419,7 +1419,7 @@ core_scsi3_decode_spec_i_port(
 	LIST_HEAD(tid_dest_list);
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	unsigned char *buf, *ptr, proto_ident;
-	const unsigned char *i_str = NULL;
+	unsigned char i_str[TRANSPORT_IQN_LEN] = {0};
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
 	sense_reason_t ret;
 	u32 tpdl, tid_len = 0;
@@ -1512,9 +1512,8 @@ core_scsi3_decode_spec_i_port(
 			dest_rtpi = tmp_lun->lun_tpg->tpg_rtpi;
 
 			iport_ptr = NULL;
-			i_str = target_parse_pr_out_transport_id(tmp_tpg,
-					ptr, &tid_len, &iport_ptr);
-			if (!i_str)
+			tid_len = target_parse_pr_out_transport_id(ptr, i_str, &iport_ptr);
+			if (!tid_len)
 				continue;
 			/*
 			 * Determine if this SCSI device server requires that
@@ -3087,7 +3086,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
-	const unsigned char *initiator_str;
+	unsigned char initiator_str[TRANSPORT_IQN_LEN] = { };
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
 	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, matching_iname;
@@ -3212,9 +3211,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
-	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
-			&buf[24], &tmp_tid_len, &iport_ptr);
-	if (!initiator_str) {
+	tmp_tid_len = target_parse_pr_out_transport_id(&buf[24], initiator_str, &iport_ptr);
+	if (!tmp_tid_len) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
-- 
2.25.1


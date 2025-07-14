Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252E2528E1
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752500271; cv=none; b=qjJkYRq/PdonMb8X5goI5IIWPB97l1muCbM29tn9g6dyIWWvuz2TJmDK2+0IbNUg59nEjZ7hqt1T23j+xrc1c3nVrtrJC24pnTelNnl4z0XIbeLpFjW1ol62QhBoCoozzCPKSnw6cWjA8JUevclGWhtjOENd8o9/K4xavMnxt60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752500271; c=relaxed/simple;
	bh=YatwpfxrbEitvFmI9E+PoSe5eko165qICvPcu/DuRZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UIOirFEc1v50bmJx1SuTUjanlucsFsI56iyW2T2Yq9InR8aWKnhlNmhf/fXCBYVo8Rp429pghadsT3qn2pvsVUAuZHjEGOTGTJDJxqQCDNRdADQ8c9ETea4y4NIArGhwKj4b0+d4GIpIkvYYSIhIc2WLuthoxzzOfskJBeG+GVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZE3hINgB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZE3hINgB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752500267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VwKW6rgiDMqpjIQvviXbCo2O5UPkr3UFFlsGe4E5f5Y=;
	b=ZE3hINgBDDWq8CX9bjHDGg47lz8xMIEb5pzhqT+PTFMllXlAGyGYO2gD3Slx1V/7K6MhWo
	DoB7mOtHfcXQ0F+S68ab0TTtWr8OmcVm60oYDDbFFae4vF5vVpIUt22oO1p+bwkGt/xdWl
	8O+jq6lsR1SOaiO5QcrJBNxddXWEyF8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-wDLvMxhKNuG-cO_ISWyU4Q-1; Mon,
 14 Jul 2025 09:37:46 -0400
X-MC-Unique: wDLvMxhKNuG-cO_ISWyU4Q-1
X-Mimecast-MFC-AGG-ID: wDLvMxhKNuG-cO_ISWyU4Q_1752500265
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAAD819560AD;
	Mon, 14 Jul 2025 13:37:44 +0000 (UTC)
Received: from kinzhal.redhat.com (unknown [10.47.238.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CB44819560A3;
	Mon, 14 Jul 2025 13:37:40 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@bsdbackstore.eu,
	d.bogdanov@yadro.com,
	bvanassche@acm.org
Subject: [PATCH V3] target: generate correct string identifiers for PR OUT transport IDs
Date: Mon, 14 Jul 2025 15:37:38 +0200
Message-ID: <20250714133738.11054-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix target_parse_pr_out_transport_id() to
return a string representing the transport ID
in a human-readable format (e.g., naa.xxxxxxxx...)
for various SCSI protocol types (SAS, FCP, SRP, SBP).

Previously, the function returned a pointer to the raw binary buffer,
which was incorrectly compared against human-readable strings,
causing comparisons to fail.
Now, the function writes a properly formatted string into a
buffer provided by the caller.
The output format depends on the transport protocol:

* SAS: 64-bit identifier, "naa." prefix.
* FCP: 64-bit identifier, colon separated values.
* SBP: 64-bit identifier, no prefix.
* SRP: 128-bit identifier, "0x" prefix.
* iSCSI: IQN string.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---

v3: replaced {0} with {} and strncpy() with strscpy()

v2: Fix the prefixes, using Dmitry Bogdanov's patch as a reference.
    target_parse_pr_out_transport_id() runs in atomic context
    because it's called in a spin_lock() protected section,
    therefore I rewrote the patch to avoid using kasprintf().

 drivers/target/target_core_fabric_lib.c | 63 +++++++++++++++++++------
 drivers/target/target_core_internal.h   |  4 +-
 drivers/target/target_core_pr.c         | 18 +++----
 3 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 43f47e3aa448..ec7bc6e30228 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -257,11 +257,41 @@ static int iscsi_get_pr_transport_id_len(
 	return len;
 }
 
-static char *iscsi_parse_pr_out_transport_id(
+static void sas_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	char hex[17] = {};
+
+	bin2hex(hex, buf + 4, 8);
+	snprintf(i_str, TRANSPORT_IQN_LEN, "naa.%s", hex);
+}
+
+static void srp_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	char hex[33] = {};
+
+	bin2hex(hex, buf + 8, 16);
+	snprintf(i_str, TRANSPORT_IQN_LEN, "0x%s", hex);
+}
+
+static void fcp_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	snprintf(i_str, TRANSPORT_IQN_LEN, "%8phC", buf + 8);
+}
+
+static void sbp_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	char hex[17] = {};
+
+	bin2hex(hex, buf + 8, 8);
+	snprintf(i_str, TRANSPORT_IQN_LEN, "%s", hex);
+}
+
+static bool iscsi_parse_pr_out_transport_id(
 	struct se_portal_group *se_tpg,
 	char *buf,
 	u32 *out_tid_len,
-	char **port_nexus_ptr)
+	char **port_nexus_ptr,
+	char *i_str)
 {
 	char *p;
 	int i;
@@ -282,7 +312,7 @@ static char *iscsi_parse_pr_out_transport_id(
 	if ((format_code != 0x00) && (format_code != 0x40)) {
 		pr_err("Illegal format code: 0x%02x for iSCSI"
 			" Initiator Transport ID\n", format_code);
-		return NULL;
+		return false;
 	}
 	/*
 	 * If the caller wants the TransportID Length, we set that value for the
@@ -306,7 +336,7 @@ static char *iscsi_parse_pr_out_transport_id(
 			pr_err("Unable to locate \",i,0x\" separator"
 				" for Initiator port identifier: %s\n",
 				&buf[4]);
-			return NULL;
+			return false;
 		}
 		*p = '\0'; /* Terminate iSCSI Name */
 		p += 5; /* Skip over ",i,0x" separator */
@@ -339,7 +369,8 @@ static char *iscsi_parse_pr_out_transport_id(
 	} else
 		*port_nexus_ptr = NULL;
 
-	return &buf[4];
+	strscpy(i_str, &buf[4], TRANSPORT_IQN_LEN);
+	return true;
 }
 
 int target_get_pr_transport_id_len(struct se_node_acl *nacl,
@@ -387,33 +418,35 @@ int target_get_pr_transport_id(struct se_node_acl *nacl,
 	}
 }
 
-const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr)
+bool target_parse_pr_out_transport_id(struct se_portal_group *tpg,
+		char *buf, u32 *out_tid_len, char **port_nexus_ptr, char *i_str)
 {
-	u32 offset;
-
 	switch (tpg->proto_id) {
 	case SCSI_PROTOCOL_SAS:
 		/*
 		 * Assume the FORMAT CODE 00b from spc4r17, 7.5.4.7 TransportID
 		 * for initiator ports using SCSI over SAS Serial SCSI Protocol.
 		 */
-		offset = 4;
+		sas_parse_pr_out_transport_id(buf, i_str);
 		break;
-	case SCSI_PROTOCOL_SBP:
 	case SCSI_PROTOCOL_SRP:
+		srp_parse_pr_out_transport_id(buf, i_str);
+		break;
 	case SCSI_PROTOCOL_FCP:
-		offset = 8;
+		fcp_parse_pr_out_transport_id(buf, i_str);
+		break;
+	case SCSI_PROTOCOL_SBP:
+		sbp_parse_pr_out_transport_id(buf, i_str);
 		break;
 	case SCSI_PROTOCOL_ISCSI:
 		return iscsi_parse_pr_out_transport_id(tpg, buf, out_tid_len,
-					port_nexus_ptr);
+					port_nexus_ptr, i_str);
 	default:
 		pr_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
-		return NULL;
+		return false;
 	}
 
 	*port_nexus_ptr = NULL;
 	*out_tid_len = 24;
-	return buf + offset;
+	return true;
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 408be26d2e9b..20aab1f50565 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -103,8 +103,8 @@ int	target_get_pr_transport_id_len(struct se_node_acl *nacl,
 int	target_get_pr_transport_id(struct se_node_acl *nacl,
 		struct t10_pr_registration *pr_reg, int *format_code,
 		unsigned char *buf);
-const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
+bool target_parse_pr_out_transport_id(struct se_portal_group *tpg,
+		char *buf, u32 *out_tid_len, char **port_nexus_ptr, char *i_str);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 70905805cb17..83e172c92238 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1478,11 +1478,12 @@ core_scsi3_decode_spec_i_port(
 	LIST_HEAD(tid_dest_list);
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	unsigned char *buf, *ptr, proto_ident;
-	const unsigned char *i_str = NULL;
+	unsigned char i_str[TRANSPORT_IQN_LEN];
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
 	sense_reason_t ret;
 	u32 tpdl, tid_len = 0;
 	u32 dest_rtpi = 0;
+	bool tid_found;
 
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
@@ -1571,9 +1572,9 @@ core_scsi3_decode_spec_i_port(
 			dest_rtpi = tmp_lun->lun_tpg->tpg_rtpi;
 
 			iport_ptr = NULL;
-			i_str = target_parse_pr_out_transport_id(tmp_tpg,
-					ptr, &tid_len, &iport_ptr);
-			if (!i_str)
+			tid_found = target_parse_pr_out_transport_id(tmp_tpg,
+					ptr, &tid_len, &iport_ptr, i_str);
+			if (!tid_found)
 				continue;
 			/*
 			 * Determine if this SCSI device server requires that
@@ -3153,13 +3154,14 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
-	const unsigned char *initiator_str;
+	unsigned char initiator_str[TRANSPORT_IQN_LEN];
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
 	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, matching_iname;
 	sense_reason_t ret;
 	unsigned short rtpi;
 	unsigned char proto_ident;
+	bool tid_found;
 
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
@@ -3278,9 +3280,9 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
-	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
-			&buf[24], &tmp_tid_len, &iport_ptr);
-	if (!initiator_str) {
+	tid_found = target_parse_pr_out_transport_id(dest_se_tpg,
+			&buf[24], &tmp_tid_len, &iport_ptr, initiator_str);
+	if (!tid_found) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
-- 
2.47.1


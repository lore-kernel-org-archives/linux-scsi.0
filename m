Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7482DB640;
	Sun, 10 Aug 2025 00:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785281; cv=none; b=IRZY/+A4Uo0jrh6PEO9sr9X75hRsyRivp6cvdUifJTDIl5Gi3fFNVChb4YnJkD1FuaLo9iss4MuRDN+3xGlw48/4V2kx7nd2aW4e4qZY1q1Q0c9iMnZidnwowbT7bXtpe2MGjvsFMKV0YKVyFoI4kOV44jkPUEMXAkbHtcKy8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785281; c=relaxed/simple;
	bh=b+Wx5qsCI9nVtIdtHwKmoyGGopfCJx5c/5WGFR/T4Ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NGjHFm2dATVzPuGxF46oRCM/GzPuXLOzwcIjU8EouEY1vx1EIDOTOTrbYMIiH10lZvs70356ehkKPwdRAIAC77rb6HFvgMPYeuw6etRIssUZbJPzCJewv/snK0WnjSDF8sDJPomB/h+zxivPtGCxygr7nWwyQ+r7YkrbCnJPF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXNGXP+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXNGXP+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B00C4CEE7;
	Sun, 10 Aug 2025 00:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785281;
	bh=b+Wx5qsCI9nVtIdtHwKmoyGGopfCJx5c/5WGFR/T4Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXNGXP+PQZyLuXrPGfUttmyYc1/FKQfHZaZiQ9P/tJpDu+dVNLHmy5o5ORC/XfP+Q
	 2YLjcXy6d/AUBBnvqBsdJQjjiUEyiyFHscfyi/0BXtxjUEJcMrR85C2rJiTpG0XQIm
	 FGoGcE8GtqClTO2bbioQOoAWN0TsctyhG2oPXBZUw3Mo2EmGFBqD72DncZ37oZxomv
	 SocwngshKLvTKtIOvluv2SmdR9sd/51G6JrJJC0cFopfBN9fRPZZMEQnmNppLRW1si
	 iECbZVInsCLFi2BtPqMkZHoV2Rad4xYbR3lb6H7fKd/Ga/q4vIgn8TWDaq4WklhMRc
	 +AlG7r04SWrQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.15] scsi: target: core: Generate correct identifiers for PR OUT transport IDs
Date: Sat,  9 Aug 2025 20:20:55 -0400
Message-Id: <20250810002104.1545396-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 6e0f6aa44b68335df404a2df955055f416b5f2aa ]

Fix target_parse_pr_out_transport_id() to return a string representing
the transport ID in a human-readable format (e.g., naa.xxxxxxxx...)  for
various SCSI protocol types (SAS, FCP, SRP, SBP).

Previously, the function returned a pointer to the raw binary buffer,
which was incorrectly compared against human-readable strings, causing
comparisons to fail.  Now, the function writes a properly formatted
string into a buffer provided by the caller.  The output format depends
on the transport protocol:

* SAS: 64-bit identifier, "naa." prefix.
* FCP: 64-bit identifier, colon separated values.
* SBP: 64-bit identifier, no prefix.
* SRP: 128-bit identifier, "0x" prefix.
* iSCSI: IQN string.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20250714133738.11054-1-mlombard@redhat.com
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Nature

This commit fixes a **critical functional bug** in the SCSI target
subsystem's Persistent Reservation (PR) handling. The bug causes PR
operations to fail when comparing transport IDs, which is a core
functionality for SCSI target implementations.

## Technical Analysis of the Bug

1. **Original Problem**: The function
   `target_parse_pr_out_transport_id()` was returning a pointer to raw
   binary data (`buf + offset`) instead of a human-readable string
   representation. This raw binary data was then incorrectly compared
   against human-readable string formats in callers.

2. **Impact on Functionality**:
   - In `core_scsi3_decode_spec_i_port()` at line 1610-1611, the code
     calls `__core_tpg_get_initiator_node_acl(tmp_tpg, i_str)` where
     `i_str` was previously pointing to binary data
   - The function `__core_tpg_get_initiator_node_acl()` expects a human-
     readable initiator string (like "naa.1234567890abcdef" for SAS)
   - This mismatch would cause the lookup to fail, breaking PR
     operations

3. **Protocols Affected**: The bug affects multiple SCSI transport
   protocols:
   - SAS (SCSI_PROTOCOL_SAS)
   - Fibre Channel (SCSI_PROTOCOL_FCP)
   - SRP (SCSI_PROTOCOL_SRP)
   - SBP (SCSI_PROTOCOL_SBP)
   - iSCSI (SCSI_PROTOCOL_ISCSI)

## Fix Implementation

The fix properly converts binary transport IDs to their expected string
formats:
- **SAS**: Converts 8 bytes to "naa.XXXXXXXXXXXX" format
- **FCP**: Converts to colon-separated format using `%8phC`
- **SRP**: Converts 16 bytes to "0x" prefixed hex string
- **SBP**: Converts to plain hex string
- **iSCSI**: Already handled strings correctly, but API updated for
  consistency

## Stable Backport Criteria

This commit meets several key stable tree criteria:

1. **Fixes a Real Bug**: Yes - PR operations would fail for non-iSCSI
   transports
2. **Small and Contained**: The fix is localized to transport ID parsing
   functions
3. **No New Features**: Only fixes existing functionality
4. **Minimal Risk**: Changes are straightforward format conversions
5. **Important for Users**: PR is a critical feature for enterprise
   storage environments
6. **No Architectural Changes**: Simple bug fix without design changes

## Additional Evidence

Looking at the commit history, there have been other PR-related fixes
recently (e.g., `d8ab68bdb294` fixing a NULL pointer dereference),
indicating this is an actively maintained critical subsystem where bugs
need to be fixed in stable kernels.

The fact that this went unnoticed suggests it affects less common code
paths, but when triggered, it would completely break PR functionality
for affected transport types - a serious issue for production storage
systems relying on persistent reservations for cluster coordination.

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
2.39.5


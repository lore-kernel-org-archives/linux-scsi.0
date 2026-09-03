Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC2F3A5440;
	Thu,  3 Sep 2026 03:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407005; cv=none; b=nMG09ANHZEpLRNn3HcaKbIZrNJuP6WtD4jDaNLqgWAO7NSk+tH9B2vJKcUF6J7GS95AIlq2XVu65vYP1xpyCfLGVfqbfj4faFpr2/m/DKxZSVdTznjMw4S5SqKuJ7TX3wKZb9qs8XzpPczRXX6gNHoLGRsTAJh/MhLeSaum15bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407005; c=relaxed/simple;
	bh=8EfbPvkwO3qccyw7tncVOYcWTPre/XjWVcq4ZfaW++s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pp2aPVVFDTZ4QukS34nKONc7OvqVnJ8Amo41/1d3pWwRMhJHh9SaOWrgFM03DogQkK6D1HUxZvcQ7Uw2mgXixQfedbefoNEUoIrKXdQ9WGmMKXB0zXBZ2ZI+SC808FOlU65Ftu54pFO1wcDbPsTtn46S2UyyAlQJRXCF/4wTv30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U07X8rYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U07X8rYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B621F00A3D;
	Thu,  3 Sep 2026 03:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406997;
	bh=OdUuaFt3TZKGFhX9s1fxvfjqRfVHn3J23Qbpega+/70=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=U07X8rYRDDJqvoEwbxhF4fZR8WXgpV3/+41wbupWENNrDMFZ3Xzy5Y4Uxqqn7oh2O
	 N0LWMdkvCkCxewo6WoPAj1YH7p0zkDD1FJILhGhCRD/5MDNbDlGNYJkmvcmiUgL8Io
	 nEZdP4HaYDFqimHnI1ciysGLB+vUZzqMLdV0JwlSV8ti3ePyKV7CM45aogUI4DkVAg
	 ehoMtkve3A+CWB03v9+VaeFCEKw4DTU/H/IxzqkznKwtH24w9tQD/I+ZpZOO0aWcXq
	 y+Q/2wwnsmQOelodQZYgV+Xa5296oHM2gTJFMXIOXVwxdUriT60ojzlnOE+4LXD9hO
	 ZR9Db2v0v2g0g==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 34/40] target: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:55 +0900
Message-ID: <20260903034201.112211-35-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the target core code to use the 16-bits sense codes for building
sense and replace all hard-coded additional sense codes and additional
sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/target/target_core_spc.c       | 11 +++++-----
 drivers/target/target_core_transport.c | 11 +++++-----
 drivers/target/target_core_ua.c        | 28 ++++++++++----------------
 drivers/target/target_core_ua.h        |  7 +++----
 4 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f964a531e053..f11766dfb542 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1226,9 +1226,9 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 {
 	unsigned char *cdb = cmd->t_task_cdb;
 	unsigned char *rbuf;
-	u8 ua_asc = 0, ua_ascq = 0;
 	unsigned char buf[SE_SENSE_BUF];
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
+	u16 sense_code;
 
 	memset(buf, 0, SE_SENSE_BUF);
 
@@ -1242,11 +1242,12 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	if (!rbuf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
-		scsi_build_sense_buffer(desc_format, buf, UNIT_ATTENTION,
-					ua_asc, ua_ascq);
+	if (!core_scsi3_ua_clear_for_request_sense(cmd, &sense_code))
+		scsi_set_sense_buffer(desc_format, buf, UNIT_ATTENTION,
+				      sense_code);
 	else
-		scsi_build_sense_buffer(desc_format, buf, NO_SENSE, 0x0, 0x0);
+		scsi_set_sense_buffer(desc_format, buf, NO_SENSE,
+				      NO_ADDITIONAL_SENSE_INFORMATION);
 
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcfe94594916..ba208def8cb5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3555,7 +3555,8 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	const struct sense_detail *sd;
 	u8 *buffer = cmd->sense_buffer;
 	int r = (__force int)reason;
-	u8 key, asc, ascq;
+	u16 code;
+	u8 key;
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
 	if (r < ARRAY_SIZE(sense_detail_table) && sense_detail_table[r].key)
@@ -3566,21 +3567,19 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 
 	key = sd->key;
 	if (reason == TCM_CHECK_CONDITION_UNIT_ATTENTION) {
-		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
-						       &ascq)) {
+		if (!core_scsi3_ua_for_check_condition(cmd, &key, &code)) {
 			cmd->scsi_status = SAM_STAT_BUSY;
 			return;
 		}
 	} else {
 		WARN_ON_ONCE(sd->asc == 0);
-		asc = sd->asc;
-		ascq = sd->ascq;
+		code = scsi_sense_code(sd->asc, sd->ascq);
 	}
 
 	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
-	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
+	scsi_set_sense_buffer(desc_format, buffer, key, code);
 	if (sd->add_sense_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 4276690fb6cb..ea97b05d47ab 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -187,11 +187,10 @@ void core_scsi3_ua_release_all(
 
 /*
  * Dequeue a unit attention from the unit attention list. This function
- * returns true if the dequeuing succeeded and if *@key, *@asc and *@ascq have
+ * returns true if the dequeuing succeeded and if *@key and *@code have
  * been set.
  */
-bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
-				       u8 *ascq)
+bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u16 *code)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *deve;
@@ -214,8 +213,7 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 	if (!deve) {
 		rcu_read_unlock();
 		*key = ILLEGAL_REQUEST;
-		*asc = 0x25; /* LOGICAL UNIT NOT SUPPORTED */
-		*ascq = 0;
+		*code = LU_NOT_SUPPORTED;
 		return true;
 	}
 	*key = UNIT_ATTENTION;
@@ -232,8 +230,7 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 		 * clearing it.
 		 */
 		if (!dev_ua_intlck_clear) {
-			*asc = ua->ua_asc;
-			*ascq = ua->ua_ascq;
+			*code = scsi_sense_code(ua->ua_asc, ua->ua_ascq);
 			break;
 		}
 		/*
@@ -242,8 +239,7 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 		 * (head of the list) in the outgoing CHECK_CONDITION + sense.
 		 */
 		if (head) {
-			*asc = ua->ua_asc;
-			*ascq = ua->ua_ascq;
+			*code = scsi_sense_code(ua->ua_asc, ua->ua_ascq);
 			head = 0;
 		}
 		list_del(&ua->ua_nacl_list);
@@ -258,15 +254,13 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 		nacl->se_tpg->se_tpg_tfo->fabric_name,
 		dev_ua_intlck_clear ? "Releasing" : "Reporting",
 		dev->dev_attrib.emulate_ua_intlck_ctrl,
-		cmd->orig_fe_lun, cmd->t_task_cdb[0], *asc, *ascq);
+		cmd->orig_fe_lun, cmd->t_task_cdb[0],
+		scsi_sense_code_asc(*code), scsi_sense_code_ascq(*code));
 
 	return head == 0;
 }
 
-int core_scsi3_ua_clear_for_request_sense(
-	struct se_cmd *cmd,
-	u8 *asc,
-	u8 *ascq)
+int core_scsi3_ua_clear_for_request_sense(struct se_cmd *cmd, u16 *code)
 {
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
@@ -304,8 +298,7 @@ int core_scsi3_ua_clear_for_request_sense(
 	spin_lock(&deve->ua_lock);
 	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
 		if (head) {
-			*asc = ua->ua_asc;
-			*ascq = ua->ua_ascq;
+			*code = scsi_sense_code(ua->ua_asc, ua->ua_ascq);
 			head = 0;
 		}
 		list_del(&ua->ua_nacl_list);
@@ -317,7 +310,8 @@ int core_scsi3_ua_clear_for_request_sense(
 	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x,"
 		" ASCQ: 0x%02x\n", nacl->se_tpg->se_tpg_tfo->fabric_name,
-		cmd->orig_fe_lun, *asc, *ascq);
+		cmd->orig_fe_lun, scsi_sense_code_asc(*code),
+		scsi_sense_code_ascq(*code));
 
 	return (head) ? -EPERM : 0;
 }
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 76487c9be090..6b636c13fee2 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -37,9 +37,8 @@ extern sense_reason_t target_scsi3_ua_check(struct se_cmd *);
 extern int core_scsi3_ua_allocate(struct se_dev_entry *, u8, u8);
 extern void target_ua_allocate_lun(struct se_node_acl *, u32, u8, u8);
 extern void core_scsi3_ua_release_all(struct se_dev_entry *);
-extern bool core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *,
-					      u8 *);
-extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *,
-						u8 *, u8 *);
+extern bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key,
+					      u16 *code);
+extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *cmd, u16 *code);
 
 #endif /* TARGET_CORE_UA_H */
-- 
2.55.0


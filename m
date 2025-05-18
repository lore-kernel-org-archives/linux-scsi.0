Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFDA2F43;
	Sun, 18 May 2025 18:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747592827; cv=none; b=MaspyW2jcNUIDgn5cbqP8/6f2H8C1LAKEsZIxcW+7zgyjPD4lR2tonTsW6P+5RKViMzuutS4k+52OweR1r2fATCPUpVDOeGNrQ6SOVCfcyIDtW7GxK70bxw2PJrtIQhCLqdGgGTIWSyRKei0DJAWIbHxocxWyTrbPqH94TEBFTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747592827; c=relaxed/simple;
	bh=F9Z/ENdDJ25JvlWE8sTMJE7DhQs/d+bdVhn0A45FA00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LGlvYelMkDyYrEQgp2uYgNuPUjHJLWU9hf0PNvrc53zzlJ1igodU86XiR0qKGuJFV73wS/xEgPXXlErSigTJ4hUboqtcxi7Zt4OEa5hHUoX+8nKwHogBrA2WKPKC5opypWcGythCgi39J4eO+HycRgkXw8xOFjeIe9erFN9cf+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=ZI1yGS6P; arc=none smtp.client-ip=80.12.242.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="ZI1yGS6P"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id GiisuX7N2iGrFGiisuLTlJ; Sun, 18 May 2025 20:26:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1747592815;
	bh=djwdUH7DAC1Q0fj+cv27S0cUkc1dTrTheQRhzc0zaoI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ZI1yGS6PF2sCZBsEDlAR8VZ2pRJIAVD386LtV/bzwRdGhrP1Zf6gxN0bpcVvi2vjd
	 zqz0c+ljOADrHoQfG4htm58rtof7qHTtQEiZUKKCfC8JeS+lq/8lUuUHr1haxKO/Zh
	 8QArpn3pbQBJG8r2ft15u61UksonTIsWqxR2tQbj0qGWfJ76khFBmLE0cjdtAcxSC2
	 cz3RmWWq1/qhtSAyJ+Nq/2sx3cmw05ksbZstTWO1dFoZU3z9Hqp/bm91p8K428Z773
	 gh010BSvy3GBm1e7HJ073g+vzDoxlQurSuY59thJc1Mnb3u2e9JItNQtnKRGhDLTvJ
	 d1933dr+21xBw==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 May 2025 20:26:55 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 1/2] scsi: target: core: Constify enabled() in struct target_opcode_descriptor
Date: Sun, 18 May 2025 20:26:42 +0200
Message-ID: <4290cf1dbe100c1b1edf2ede5e5aef19b04ee7f2.1747592774.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Constify the first argument of the enabled() function in struct
target_opcode_descriptor.

This is the first step in order to constify struct
target_opcode_descriptor.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 drivers/target/target_core_spc.c  | 16 ++++++++--------
 include/target/target_core_base.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 0a02492bef70..07d7eba99cc0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1424,7 +1424,7 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static bool tcm_is_ws_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_ws_enabled(const struct target_opcode_descriptor *descr,
 			      struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
@@ -1452,7 +1452,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
-static bool tcm_is_caw_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_caw_enabled(const struct target_opcode_descriptor *descr,
 			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1493,7 +1493,7 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_rep_ref_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_rep_ref_enabled(const struct target_opcode_descriptor *descr,
 				   struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1539,7 +1539,7 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_unmap_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_unmap_enabled(const struct target_opcode_descriptor *descr,
 				 struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
@@ -1662,7 +1662,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_pr_enabled(const struct target_opcode_descriptor *descr,
 			      struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1880,7 +1880,7 @@ static struct target_opcode_descriptor tcm_opcode_inquiry = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_3pc_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_3pc_enabled(const struct target_opcode_descriptor *descr,
 			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1942,7 +1942,7 @@ static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-static bool spc_rsoc_enabled(struct target_opcode_descriptor *descr,
+static bool spc_rsoc_enabled(const struct target_opcode_descriptor *descr,
 			     struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1963,7 +1963,7 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.enabled = spc_rsoc_enabled,
 };
 
-static bool tcm_is_set_tpg_enabled(struct target_opcode_descriptor *descr,
+static bool tcm_is_set_tpg_enabled(const struct target_opcode_descriptor *descr,
 				   struct se_cmd *cmd)
 {
 	struct t10_alua_tg_pt_gp *l_tg_pt_gp;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a52d4967c0d3..c4d9116904aa 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -898,7 +898,7 @@ struct target_opcode_descriptor {
 	u8			specific_timeout;
 	u16			nominal_timeout;
 	u16			recommended_timeout;
-	bool			(*enabled)(struct target_opcode_descriptor *descr,
+	bool			(*enabled)(const struct target_opcode_descriptor *descr,
 					   struct se_cmd *cmd);
 	void			(*update_usage_bits)(u8 *usage_bits,
 						     struct se_device *dev);
-- 
2.49.0


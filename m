Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5B41D5CC7;
	Sun, 18 May 2025 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747592831; cv=none; b=T8WL81XUxq7w9p1S73xUw2rVygTfLiRDtKw3NTbw3G0tdM6SUamnvcBYH6C9pXR8J4t1ZjI7tLjlajOhTGOFkf54E95oHO8a7s5pMT6x8awrvIl5/+Rnouf4imc4h059lm15/yrVurk2WWQTiTWNmi8k8FnPFq0qBZdIIHa0xJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747592831; c=relaxed/simple;
	bh=Lv8/r5dJ0M6IocmFwkCZaanhWzXj2PZWZ1qj/Cu9cVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIwe0e+87MZUcdySCCspg4sHJjvmve6vnrTFKrPrxnb1m7UQo9IFDODl+WfNJHzfGMRqoECHu/5Le0pLS4LtFwas49TOCKtLRDa+97E9UB+CoXkcBP5l1ztGeSU2M8u0EG2bQ4dhijKSPEkFcK20Lm1QM3OhFGJJp/53Qe0kGvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=KSODE0i3; arc=none smtp.client-ip=80.12.242.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="KSODE0i3"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id GiisuX7N2iGrFGij1uLU1M; Sun, 18 May 2025 20:27:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1747592824;
	bh=RO9dcMiKg4BsFSv3uqUi9bUYBDRc6gn6LPZiB/GPves=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=KSODE0i39zlXrI4FGsSnK0v0Q9dl5iFgCb1Y1Yrx1GlryrOSM8U5IGTRiOr8ejkCO
	 HfHEi84Iy0Lr2Io5EJf1qmh8Itsedj0QTMo4GwdxM2Y33MhPuyIkjwOFpTMb1jImqZ
	 GcuMYS930G+tOLiLZdLhr7/0Nq8PHydwFqoutNSTJ1h56MXwIHfWuC1dm/dzx/pDAf
	 JPaNck15MXF/AxgFtr0VEQSKeJM/AG3Ni2ANAu2uLWQ81eKvznUfL470Eu4rW5adsl
	 uWFtJST9moX50E9NdpSJ/JTO5b8KRAR1Ok0iungXHx0oB9JMdaiPmz33pjWb/JxfWR
	 haJZZ4uJZP05w==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 May 2025 20:27:04 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 2/2] scsi: target: core: Constify struct target_opcode_descriptor
Date: Sun, 18 May 2025 20:26:43 +0200
Message-ID: <889ee46e75db33e8ab997a627a1d3d651ad648db.1747592774.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <4290cf1dbe100c1b1edf2ede5e5aef19b04ee7f2.1747592774.git.christophe.jaillet@wanadoo.fr>
References: <4290cf1dbe100c1b1edf2ede5e5aef19b04ee7f2.1747592774.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct target_opcode_descriptor' are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  53602	  19750	      0	  73352	  11e88	drivers/target/target_core_spc.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  58594	  14758	      0	  73352	  11e88	drivers/target/target_core_spc.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only.
---
 drivers/target/target_core_spc.c | 118 +++++++++++++++----------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 07d7eba99cc0..aad0096afa21 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1325,7 +1325,7 @@ static void set_dpofua_usage_bits32(u8 *usage_bits, struct se_device *dev)
 		usage_bits[10] |= 0x18;
 }
 
-static struct target_opcode_descriptor tcm_opcode_read6 = {
+static const struct target_opcode_descriptor tcm_opcode_read6 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = READ_6,
 	.cdb_size = 6,
@@ -1333,7 +1333,7 @@ static struct target_opcode_descriptor tcm_opcode_read6 = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_read10 = {
+static const struct target_opcode_descriptor tcm_opcode_read10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = READ_10,
 	.cdb_size = 10,
@@ -1343,7 +1343,7 @@ static struct target_opcode_descriptor tcm_opcode_read10 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_read12 = {
+static const struct target_opcode_descriptor tcm_opcode_read12 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = READ_12,
 	.cdb_size = 12,
@@ -1353,7 +1353,7 @@ static struct target_opcode_descriptor tcm_opcode_read12 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_read16 = {
+static const struct target_opcode_descriptor tcm_opcode_read16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = READ_16,
 	.cdb_size = 16,
@@ -1364,7 +1364,7 @@ static struct target_opcode_descriptor tcm_opcode_read16 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write6 = {
+static const struct target_opcode_descriptor tcm_opcode_write6 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_6,
 	.cdb_size = 6,
@@ -1372,7 +1372,7 @@ static struct target_opcode_descriptor tcm_opcode_write6 = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_write10 = {
+static const struct target_opcode_descriptor tcm_opcode_write10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_10,
 	.cdb_size = 10,
@@ -1382,7 +1382,7 @@ static struct target_opcode_descriptor tcm_opcode_write10 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write_verify10 = {
+static const struct target_opcode_descriptor tcm_opcode_write_verify10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_VERIFY,
 	.cdb_size = 10,
@@ -1392,7 +1392,7 @@ static struct target_opcode_descriptor tcm_opcode_write_verify10 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write12 = {
+static const struct target_opcode_descriptor tcm_opcode_write12 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_12,
 	.cdb_size = 12,
@@ -1402,7 +1402,7 @@ static struct target_opcode_descriptor tcm_opcode_write12 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write16 = {
+static const struct target_opcode_descriptor tcm_opcode_write16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_16,
 	.cdb_size = 16,
@@ -1413,7 +1413,7 @@ static struct target_opcode_descriptor tcm_opcode_write16 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
+static const struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_VERIFY_16,
 	.cdb_size = 16,
@@ -1434,7 +1434,7 @@ static bool tcm_is_ws_enabled(const struct target_opcode_descriptor *descr,
 	       !!ops->execute_write_same;
 }
 
-static struct target_opcode_descriptor tcm_opcode_write_same32 = {
+static const struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = VARIABLE_LENGTH_CMD,
@@ -1460,7 +1460,7 @@ static bool tcm_is_caw_enabled(const struct target_opcode_descriptor *descr,
 	return dev->dev_attrib.emulate_caw;
 }
 
-static struct target_opcode_descriptor tcm_opcode_compare_write = {
+static const struct target_opcode_descriptor tcm_opcode_compare_write = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = COMPARE_AND_WRITE,
 	.cdb_size = 16,
@@ -1472,7 +1472,7 @@ static struct target_opcode_descriptor tcm_opcode_compare_write = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static struct target_opcode_descriptor tcm_opcode_read_capacity = {
+static const struct target_opcode_descriptor tcm_opcode_read_capacity = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = READ_CAPACITY,
 	.cdb_size = 10,
@@ -1481,7 +1481,7 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity = {
 		       0x01, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
+static const struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = SERVICE_ACTION_IN_16,
@@ -1507,7 +1507,7 @@ static bool tcm_is_rep_ref_enabled(const struct target_opcode_descriptor *descr,
 	return true;
 }
 
-static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
+static const struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = SERVICE_ACTION_IN_16,
@@ -1520,7 +1520,7 @@ static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
 	.enabled = tcm_is_rep_ref_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_sync_cache = {
+static const struct target_opcode_descriptor tcm_opcode_sync_cache = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = SYNCHRONIZE_CACHE,
 	.cdb_size = 10,
@@ -1529,7 +1529,7 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
+static const struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = SYNCHRONIZE_CACHE_16,
 	.cdb_size = 16,
@@ -1548,7 +1548,7 @@ static bool tcm_is_unmap_enabled(const struct target_opcode_descriptor *descr,
 	return ops->execute_unmap && dev->dev_attrib.emulate_tpu;
 }
 
-static struct target_opcode_descriptor tcm_opcode_unmap = {
+static const struct target_opcode_descriptor tcm_opcode_unmap = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = UNMAP,
 	.cdb_size = 10,
@@ -1558,7 +1558,7 @@ static struct target_opcode_descriptor tcm_opcode_unmap = {
 	.enabled = tcm_is_unmap_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write_same = {
+static const struct target_opcode_descriptor tcm_opcode_write_same = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_SAME,
 	.cdb_size = 10,
@@ -1568,7 +1568,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same = {
 	.enabled = tcm_is_ws_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_write_same16 = {
+static const struct target_opcode_descriptor tcm_opcode_write_same16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = WRITE_SAME_16,
 	.cdb_size = 16,
@@ -1579,7 +1579,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same16 = {
 	.enabled = tcm_is_ws_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_verify = {
+static const struct target_opcode_descriptor tcm_opcode_verify = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = VERIFY,
 	.cdb_size = 10,
@@ -1588,7 +1588,7 @@ static struct target_opcode_descriptor tcm_opcode_verify = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_verify16 = {
+static const struct target_opcode_descriptor tcm_opcode_verify16 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = VERIFY_16,
 	.cdb_size = 16,
@@ -1598,7 +1598,7 @@ static struct target_opcode_descriptor tcm_opcode_verify16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_start_stop = {
+static const struct target_opcode_descriptor tcm_opcode_start_stop = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = START_STOP,
 	.cdb_size = 6,
@@ -1606,7 +1606,7 @@ static struct target_opcode_descriptor tcm_opcode_start_stop = {
 		       0x01, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_mode_select = {
+static const struct target_opcode_descriptor tcm_opcode_mode_select = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = MODE_SELECT,
 	.cdb_size = 6,
@@ -1614,7 +1614,7 @@ static struct target_opcode_descriptor tcm_opcode_mode_select = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_mode_select10 = {
+static const struct target_opcode_descriptor tcm_opcode_mode_select10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = MODE_SELECT_10,
 	.cdb_size = 10,
@@ -1623,7 +1623,7 @@ static struct target_opcode_descriptor tcm_opcode_mode_select10 = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_mode_sense = {
+static const struct target_opcode_descriptor tcm_opcode_mode_sense = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = MODE_SENSE,
 	.cdb_size = 6,
@@ -1631,7 +1631,7 @@ static struct target_opcode_descriptor tcm_opcode_mode_sense = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_mode_sense10 = {
+static const struct target_opcode_descriptor tcm_opcode_mode_sense10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = MODE_SENSE_10,
 	.cdb_size = 10,
@@ -1640,7 +1640,7 @@ static struct target_opcode_descriptor tcm_opcode_mode_sense10 = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_pri_read_keys = {
+static const struct target_opcode_descriptor tcm_opcode_pri_read_keys = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_IN,
@@ -1651,7 +1651,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_keys = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
+static const struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_IN,
@@ -1704,7 +1704,7 @@ static bool tcm_is_pr_enabled(const struct target_opcode_descriptor *descr,
 	return true;
 }
 
-static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
+static const struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_IN,
@@ -1716,7 +1716,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
+static const struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_IN,
@@ -1728,7 +1728,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_register = {
+static const struct target_opcode_descriptor tcm_opcode_pro_register = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1740,7 +1740,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_register = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
+static const struct target_opcode_descriptor tcm_opcode_pro_reserve = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1752,7 +1752,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_release = {
+static const struct target_opcode_descriptor tcm_opcode_pro_release = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1764,7 +1764,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_release = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_clear = {
+static const struct target_opcode_descriptor tcm_opcode_pro_clear = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1776,7 +1776,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_clear = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
+static const struct target_opcode_descriptor tcm_opcode_pro_preempt = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1788,7 +1788,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
+static const struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1800,7 +1800,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
+static const struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1814,7 +1814,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
+static const struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = PERSISTENT_RESERVE_OUT,
@@ -1826,7 +1826,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_release = {
+static const struct target_opcode_descriptor tcm_opcode_release = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RELEASE_6,
 	.cdb_size = 6,
@@ -1835,7 +1835,7 @@ static struct target_opcode_descriptor tcm_opcode_release = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_release10 = {
+static const struct target_opcode_descriptor tcm_opcode_release10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RELEASE_10,
 	.cdb_size = 10,
@@ -1845,7 +1845,7 @@ static struct target_opcode_descriptor tcm_opcode_release10 = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_reserve = {
+static const struct target_opcode_descriptor tcm_opcode_reserve = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RESERVE_6,
 	.cdb_size = 6,
@@ -1854,7 +1854,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_reserve10 = {
+static const struct target_opcode_descriptor tcm_opcode_reserve10 = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RESERVE_10,
 	.cdb_size = 10,
@@ -1864,7 +1864,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve10 = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_request_sense = {
+static const struct target_opcode_descriptor tcm_opcode_request_sense = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = REQUEST_SENSE,
 	.cdb_size = 6,
@@ -1872,7 +1872,7 @@ static struct target_opcode_descriptor tcm_opcode_request_sense = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_inquiry = {
+static const struct target_opcode_descriptor tcm_opcode_inquiry = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = INQUIRY,
 	.cdb_size = 6,
@@ -1888,7 +1888,7 @@ static bool tcm_is_3pc_enabled(const struct target_opcode_descriptor *descr,
 	return dev->dev_attrib.emulate_3pc;
 }
 
-static struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
+static const struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = EXTENDED_COPY,
@@ -1900,7 +1900,7 @@ static struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
 	.enabled = tcm_is_3pc_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
+static const struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = RECEIVE_COPY_RESULTS,
@@ -1914,7 +1914,7 @@ static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
 	.enabled = tcm_is_3pc_enabled,
 };
 
-static struct target_opcode_descriptor tcm_opcode_report_luns = {
+static const struct target_opcode_descriptor tcm_opcode_report_luns = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = REPORT_LUNS,
 	.cdb_size = 12,
@@ -1923,7 +1923,7 @@ static struct target_opcode_descriptor tcm_opcode_report_luns = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_test_unit_ready = {
+static const struct target_opcode_descriptor tcm_opcode_test_unit_ready = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = TEST_UNIT_READY,
 	.cdb_size = 6,
@@ -1931,7 +1931,7 @@ static struct target_opcode_descriptor tcm_opcode_test_unit_ready = {
 		       0x00, SCSI_CONTROL_MASK},
 };
 
-static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
+static const struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = MAINTENANCE_IN,
@@ -1950,7 +1950,7 @@ static bool spc_rsoc_enabled(const struct target_opcode_descriptor *descr,
 	return dev->dev_attrib.emulate_rsoc;
 }
 
-static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
+static const struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = MAINTENANCE_IN,
@@ -1984,7 +1984,7 @@ static bool tcm_is_set_tpg_enabled(const struct target_opcode_descriptor *descr,
 	return true;
 }
 
-static struct target_opcode_descriptor tcm_opcode_set_tpg = {
+static const struct target_opcode_descriptor tcm_opcode_set_tpg = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
 	.opcode = MAINTENANCE_OUT,
@@ -1996,7 +1996,7 @@ static struct target_opcode_descriptor tcm_opcode_set_tpg = {
 	.enabled = tcm_is_set_tpg_enabled,
 };
 
-static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
+static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_read6,
 	&tcm_opcode_read10,
 	&tcm_opcode_read12,
@@ -2053,7 +2053,7 @@ static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 
 static int
 spc_rsoc_encode_command_timeouts_descriptor(unsigned char *buf, u8 ctdp,
-				struct target_opcode_descriptor *descr)
+				const struct target_opcode_descriptor *descr)
 {
 	if (!ctdp)
 		return 0;
@@ -2068,7 +2068,7 @@ spc_rsoc_encode_command_timeouts_descriptor(unsigned char *buf, u8 ctdp,
 
 static int
 spc_rsoc_encode_command_descriptor(unsigned char *buf, u8 ctdp,
-				   struct target_opcode_descriptor *descr)
+				   const struct target_opcode_descriptor *descr)
 {
 	int td_size = 0;
 
@@ -2087,7 +2087,7 @@ spc_rsoc_encode_command_descriptor(unsigned char *buf, u8 ctdp,
 
 static int
 spc_rsoc_encode_one_command_descriptor(unsigned char *buf, u8 ctdp,
-				       struct target_opcode_descriptor *descr,
+				       const struct target_opcode_descriptor *descr,
 				       struct se_device *dev)
 {
 	int td_size = 0;
@@ -2110,9 +2110,9 @@ spc_rsoc_encode_one_command_descriptor(unsigned char *buf, u8 ctdp,
 }
 
 static sense_reason_t
-spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
+spc_rsoc_get_descr(struct se_cmd *cmd, const struct target_opcode_descriptor **opcode)
 {
-	struct target_opcode_descriptor *descr;
+	const struct target_opcode_descriptor *descr;
 	struct se_session *sess = cmd->se_sess;
 	unsigned char *cdb = cmd->t_task_cdb;
 	u8 opts = cdb[2] & 0x3;
@@ -2199,7 +2199,7 @@ static sense_reason_t
 spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 {
 	int descr_num = ARRAY_SIZE(tcm_supported_opcodes);
-	struct target_opcode_descriptor *descr = NULL;
+	const struct target_opcode_descriptor *descr = NULL;
 	unsigned char *cdb = cmd->t_task_cdb;
 	u8 rctd = (cdb[2] >> 7) & 0x1;
 	unsigned char *buf = NULL;
-- 
2.49.0


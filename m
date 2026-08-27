Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68223EAA0;
	Thu, 27 Aug 2026 01:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787794387; cv=none; b=rUxO83h4Aj2xhCli777R1dA3oOhchFDfhLPuEGJ2fi6EMUN06Zc66rILvj1PJoRcg9rKMbqg3Wgva//Ao3JUlAAFWrBCIxclp4+TKbM1dG1RayDKmWH+f/uRHG+G/F9h3c/5combs3NDHhOXUaCGVHp/D3d7nTQzCWredrpzLpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787794387; c=relaxed/simple;
	bh=MB/LVh6IvL9fgyrBiG1se/VXlzz6S89Sb+Ts7WSlJF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ETy9nNQ3X5pZhYuXM+9ZMQxjKwwO1OcO/8o3anz+W5P7gouxrGHweF4V98Dl3hkrB5ot/UsETjvnds/QoU18cFN9eipYNth1MzB85PKC9dKKWWAjD5JLCNdRou1ubIi0P7DZti7XLwvQ2g8Guinh9rtqwwDqxPA0NGMuELKiuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UMh2bbQE; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UMh2bbQE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Qd
	f/9O/ikCIzL+++ZJBYi7IldqURvSfUUvVHb4OMlTs=; b=UMh2bbQE9+3lah+ktl
	DoN+RksjBfwYMeAIQ1TffpcAqxfakDKDbF3AoCjW8XPh6UG0+DK1nMPf3PAPwxuu
	WciLMicYpZOuWm6q8gBaBet2pmZMN8NtqcecuVtwfDMdy0o3YLcOg3FTEAHFtsQg
	CdcHDD8s2a/OcDomy+Hm3Il4I=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBn3yLCk49qjjrxSA--.11671S2;
	Thu, 27 Aug 2026 09:32:52 +0800 (CST)
From: ghuicao@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH v3] scsi: target: iscsi: Reject CDB size exceeding available buffer
Date: Thu, 27 Aug 2026 09:32:45 +0800
Message-Id: <20260827013245.21289-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826100526.106011-1-ghuicao@163.com>
References: <20260826100526.106011-1-ghuicao@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBn3yLCk49qjjrxSA--.11671S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ww18GryfXFWrtw18JF17Awb_yoW7CFWkpF
	12gw1FyrWrZayIkwnxAayYvry5u39akayDKa43G34UCrn8JFy0ga42ga4agayUt3Z2grWU
	tr1qva4rGF4Iqr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOPEfUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC+wSUJ2qPk8T-0QAA3Q

From: Cao Guanghui <caoguanghui@kylinos.cn>

In iscsit_setup_scsi_cmd(), the CDB is later re-parsed by
scsi_command_size() based on its SCSI opcode. For a VARIABLE_LENGTH_CMD
(0x7f) the returned size is cdb[7] + 8, where both cdb[0] and cdb[7]
come verbatim from the initiator-controlled PDU. The amount of CDB data
actually available is never cross-checked against this opcode-declared
length before the CDB is handed to target_cmd_init_cdb(), which does:

  memcpy(cmd->t_task_cdb, cdb, scsi_command_size(cdb));

An initiator can set cdb[0]=0x7f and cdb[7]=252 so that
scsi_command_size() returns 260, while the available CDB space is only
16 bytes (the basic header, when no Extended CDB AHS is present) or the
AHS-provided length. target_cmd_init_cdb() then reads up to 244 bytes
past the end of the CDB buffer, a heap out-of-bounds read. The leaked
bytes are later parsed as the CDB and can be indirectly observed by the
initiator through sense data and responses.

Additionally, when an Extended CDB AHS is present with a large
ahslength (up to 1017, bounded only by hlength), the code copies
cdb_length - ISCSI_CDB_SIZE bytes from ecdb_ahdr->ecdb, a fixed 244-byte
array declared in struct iscsi_ecdb_ahdr. When cdb_length exceeds
SCSI_MAX_VARLEN_CDB_SIZE (260) this reads past the array, and with
CONFIG_FORTIFY_SOURCE=y the runtime check in fortify_memcpy_chk()
detects the overflow and panics the kernel, causing a system-wide
Denial of Service.

Reject the command before either memcpy can occur:

- Without an Extended CDB AHS the CDB is limited to ISCSI_CDB_SIZE (16)
  bytes in the basic header, so reject when scsi_command_size() >
  ISCSI_CDB_SIZE.
- With an Extended CDB AHS reject when cdb_length exceeds
  SCSI_MAX_VARLEN_CDB_SIZE (260), which also bounds the read from the
  fixed-size ecdb array, and reject when scsi_command_size() >
  cdb_length.

commit 2f3835771dff ("scsi: target: iscsi: reject invalid size Extended
CDB AHS") fixed the zero-length ahslength overflows and the AHS-buffer
overread, but did not cover the orthogonal "available CDB space vs.
opcode-declared size" path or the ecdb array overread.

Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
v3:
  - Add cdb_length > SCSI_MAX_VARLEN_CDB_SIZE check in AHS path to
    prevent FORTIFY_SOURCE panic from ecdb array overread (Sashiko)
  - Shorten subject line to fit 75-char convention
  - Add Cc: stable@vger.kernel.org

v2:
  - Add bounds check for standard path without AHS (hdr->hlength == 0)
  - Use if/else to make the two paths explicit

 drivers/target/iscsi/iscsi_target.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1100,7 +1100,22 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	cdb = hdr->cdb;
 
-	if (hdr->hlength) {
+	if (!hdr->hlength) {
+		/*
+		 * Without an Extended CDB AHS the CDB is limited to the 16
+		 * bytes in the basic header. The CDB is later re-parsed by
+		 * scsi_command_size() based on its opcode, which may claim a
+		 * larger length (e.g. VARIABLE_LENGTH_CMD with cdb[7]=252).
+		 * Reject such a mismatch before handing the CDB to
+		 * target_cmd_init_cdb() to avoid an out-of-bounds read.
+		 */
+		if (scsi_command_size(hdr->cdb) > ISCSI_CDB_SIZE) {
+			pr_err("SCSI command size %u exceeds CDB size %u, protocol error.\n",
+			       scsi_command_size(hdr->cdb), ISCSI_CDB_SIZE);
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+	} else {
 		ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
 		if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
 			pr_err("Additional Header Segment type %d not supported!\n",
@@ -1124,7 +1139,36 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
 
+		/*
+		 * The Extended CDB AHS ecdb field is a fixed-size array of
+		 * SCSI_MAX_VARLEN_CDB_SIZE - ISCSI_CDB_SIZE (244) bytes. An
+		 * attacker-controlled ahslength can make cdb_length exceed
+		 * this, causing the memcpy below to read past the ecdb array
+		 * and triggering a FORTIFY_SOURCE runtime panic. Reject CDB
+		 * lengths exceeding the SCSI maximum before allocating.
+		 */
+		if (cdb_length > SCSI_MAX_VARLEN_CDB_SIZE) {
+			pr_err("Extended CDB length %u exceeds maximum %u, protocol error.\n",
+			       cdb_length, SCSI_MAX_VARLEN_CDB_SIZE);
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+
+		/*
+		 * The CDB buffer is later re-parsed by scsi_command_size()
+		 * based on its opcode, which may claim a length larger than
+		 * the AHS provided. Reject such a mismatch before allocating
+		 * to avoid an out-of-bounds read of the CDB buffer in
+		 * target_cmd_init_cdb().
+		 */
+		if (scsi_command_size(hdr->cdb) > cdb_length) {
+			pr_err("Extended CDB AHS: SCSI command size %u exceeds AHS-provided CDB length %u, protocol error.\n",
+			       scsi_command_size(hdr->cdb), cdb_length);
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+
 		cdb = kmalloc(cdb_length, GFP_KERNEL);
 		if (cdb == NULL)
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
-- 
2.34.1


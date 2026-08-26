Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F447184524;
	Wed, 26 Aug 2026 10:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738753; cv=none; b=coM1yFodB20P68hrYulynjWKsyjx+8tLWA6P9jWV3eWyOqm8/QhtJ+FyvSKX/TZ/n16k1ggzgY7EGOaeVe1LiFFLE1N2a92/8OvmwqsV19Lo4PZw0ZtEkOEXWjaj7UaDl+rk1agC47J9/swUYDwYCKCYCdi6WX9mRerlfQzl3os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738753; c=relaxed/simple;
	bh=glXVtIQdJhH2pcno9ro3WEksTGlJcK305M6o2dxO/CU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mqx0KaqqPOFt+ljOJlwy34VfSi2OaulS8ij+c7jYKiX4WjgqIcgcOTcIA5Dav/fDo0+bl94thoiGovMOeit+PJ1OuHNwHbf9m6tfJgThlvpb4ZTnamRS8jPjPLYjUT4k3zRKTMs+4qfiXuWF2rSUl6zbCz7n0EUbHdqPejlbdAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oRB9S1fG; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oRB9S1fG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9L
	VqB061la4DYfd6hh7Xv4e5X+jspRnDO2GKLNTEToY=; b=oRB9S1fGVRWJcyYZua
	QpW9QqCylTxS4BMKnrlat6bz1a5l2vRC6sgmkeB5Wqzfmmo5ZFpwIVRtui47mF5M
	lYA+/Z+fP9JRLOcuaPbpWs4oBJ5ydaWWz765l8h03gLJQNoCk2d1kVLxkIhcjUj4
	ym/GaVkEoNcw6V2ACBj7MOVrc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wCnHhlouo5qDh9vSA--.16080S2;
	Wed, 26 Aug 2026 18:05:30 +0800 (CST)
From: ghuicao@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH v2] scsi: target: iscsi: Reject CDB size exceeding available buffer in iscsit_setup_scsi_cmd
Date: Wed, 26 Aug 2026 18:05:26 +0800
Message-Id: <20260826100526.106011-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnHhlouo5qDh9vSA--.16080S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF43Aw43Wr45Aw17Xry8AFb_yoWrWFy7pF
	42gw1IyrWrZ3yIkwsxAFWYvry5Zrsaka4qka43K3yUCrnxGFW0gFy2ga43WayUJ3Z2gryU
	Krs0va48GF4Utw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jY5lbUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC3woHmWqOumrD5gAA3a

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

Reject the command when the opcode-declared CDB size exceeds the
available CDB space, before the CDB is passed on:

- Without an Extended CDB AHS the CDB is limited to ISCSI_CDB_SIZE (16)
  bytes in the basic header, so reject when scsi_command_size() >
  ISCSI_CDB_SIZE.
- With an Extended CDB AHS the buffer is allocated from the AHS-declared
  length, so reject when scsi_command_size() > cdb_length.

commit 2f3835771dff ("scsi: target: iscsi: reject invalid size Extended
CDB AHS") fixed the zero-length ahslength overflows and the AHS-buffer
overread, but did not cover the orthogonal "available CDB space vs.
opcode-declared size" path.

Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
v2:
  - Add bounds check for standard path without AHS (hdr->hlength == 0)
  - Use if/else to make the two paths explicit
  
drivers/target/iscsi/iscsi_target.c | 31 +++++++++++++++++++++++++++++
1 file changed, 31 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 62ada3a52210..56f8fd461192 100644
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
@@ -1124,6 +1139,20 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
 
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
-- 
2.34.1


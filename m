Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611463909A2
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 06:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785999201; cv=none; b=KixfhWfRIWeWZBIwiO2y3EKuL0b9aaZwNFG/pt4KkMKTmqp+RrE02ZhM+DLj0MAUOy7E+g62h/gWQpQDW+e7gb4qYTrTGbwZXi9x+C6/bjYXI73u1r1xBEH58xmwyMGSZ4rYlGxxsg0Vyfwk5v5OTq785y4v9CVy86hegu+VzPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785999201; c=relaxed/simple;
	bh=USBg4QW2BWEra48054158xF0+/X/wOPgiJbSiKmpNyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r6sy3Hz9ehT/+QWNiMrnlKy+3RfgWzRTyGpB5Ezuip/BLIBLLu+ZKik3zsWWq4mKv1qnvmvy379FjaNAzPXCcIHKyggddn+mEYhpnQPhkV1Qse/6CkgdhjXp5xv5d+7pNPa03eI2c2YdwoiPTWOAcH1iUwU43b/tfujGSxeWVhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QudBCZnU; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QudBCZnU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=42
	k59IWHZj4Gk53TFlXayEgT+4jqQ5aFWzKhR10GFFQ=; b=QudBCZnUOPNvNWwlPu
	yO/nq3i7kAOYC9fVjn/t6Fq/J+elXYCh6fgiZ7V4U7ZvIqW+nVcW125uEM/xGVEO
	j58tx+RnEbtcGi/h44gRXZYdKE3Q0J7MFdbv13KWSl8V5YDkPPDun/BHrIHFzy0q
	X5Ll3MY2JtoF88XbQjUWQjUrk=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCHo8dHL3RqroDSOA--.36133S2;
	Thu, 06 Aug 2026 14:52:55 +0800 (CST)
From: ghuicao@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH v2] scsi: target: iscsi: Reject CDB size exceeding available buffer in iscsit_setup_scsi_cmd
Date: Thu,  6 Aug 2026 14:52:52 +0800
Message-Id: <20260806065252.91800-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806054820.75950-1-ghuicao@163.com>
References: <20260806054820.75950-1-ghuicao@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHo8dHL3RqroDSOA--.36133S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF43Aw43Wr45Aw17Xry8AFb_yoWruF47pF
	4Ygw1IkrZ3Z3yxtwsxAayYvryYvrsaka4qkFy3K3yUCwnxGFy0gFyFga43WayUJFn2gry5
	Kws0va48GF4UXw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U9zV8UUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC3wiVKGp0L0gvsgAA3O

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
Hi Martin,

Thanks for the review (via Sashiko). You are right that the original patch
only covered the Extended CDB AHS path and missed the standard command
path without an AHS, where the same out-of-bounds read is reachable. v2
adds the same bounds check for hdr->hlength == 0 and switches the two
paths to if/else for clarity.

v2:
  - Add the bounds check for the standard path without an AHS
    (hdr->hlength == 0) as well, fixing the same out-of-bounds read
    that was previously only covered for the Extended CDB AHS path.
  - Use if/else to make the two (mutually exclusive) paths explicit.

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


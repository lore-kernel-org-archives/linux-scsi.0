Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4671D9663;
	Thu,  6 Aug 2026 05:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785995335; cv=none; b=IBY+HzBOP3qb/4SSUf2Urm9/9x/4A9173w8LpgLcucF8Np2a5MTTTkuzyMGvigELBhk7dcVFDi6DHsJszG8TvkTiZDW+VQUTYZznpBkLAHFeD+Ecg2N9ZlMlmNgW3ZIJ6+x8VEDZ6miUsvv/MhCS+74yJsaepRCRizRqkj7nU+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785995335; c=relaxed/simple;
	bh=eR4P+V9jnFW3OGh2xSOpQLhxNr4KUzaSDuzW7l2ksBY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OBZpBMbHOCdkBFhLBfRHCsL+x91TvnC3Bg9vEmjThuzw64UL3mkk57nsqsU0Cv4TzZ6nRAEd/4TT67Qk2H5IRPEWfD/ShNSekJeQOiRwPzjFITKnYPRc//OH/Fv9BNRcljLQM4xhvXOtqFwF/vWQppfQ+LTtDqFHOla3fRCAnak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YszmQctY; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YszmQctY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=CP
	aaxY7dcgaMnSa3hBTvaMHgHF/iEN3FHumqoLd+74g=; b=YszmQctYcNFUv/tzvC
	XFrGSVJQcqvPDpJCzKs1hZsz03cAChK6BcWy93Sz3q3FpgAeWw1JT3gPx5ia32P9
	9BTdo5U0nC4rAwwiHblFXjm1Y7DSXI3fNANMdK7ieIjEWmmwOmvlempOwXnEenlI
	Sk3C6lH/6jtYA9N4E6Vh/2Wk0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wA3rhgoIHRqVXB8OA--.9908S2;
	Thu, 06 Aug 2026 13:48:24 +0800 (CST)
From: ghuicao@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mike Christie <michael.christie@oracle.com>,
	Kees Cook <kees@kernel.org>,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] scsi: target: iscsi: Reject Extended CDB AHS when CDB size exceeds AHS length
Date: Thu,  6 Aug 2026 13:48:20 +0800
Message-Id: <20260806054820.75950-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3rhgoIHRqVXB8OA--.9908S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFy8JrykWw4kuF1rXr1DKFg_yoW5Xw1xpF
	4qgw10yrZYg3yxCwnxAa1YqryYqan5GFyjka43K34DuwnxJFyIgFyYga4agay5Jan2gFy3
	Kan0vFyrGr4UGw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U_3k_UUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC4AnJXGp0ICksyQAA3O

From: Cao Guanghui <caoguanghui@kylinos.cn>

In iscsit_setup_scsi_cmd(), the Extended CDB AHS path allocates the CDB
buffer using only the iSCSI AHS-declared length. The buffer is then
handed to target_cmd_init_cdb(), which re-derives the CDB length from
the SCSI opcode via scsi_command_size(). For a VARIABLE_LENGTH_CMD
(0x7f) the size is cdb[7] + 8, where both cdb[0] and cdb[7] come
verbatim from the initiator-controlled hdr->cdb. The AHS-declared length
and the opcode-declared length are never cross-checked.

An initiator can thus advertise a minimal AHS (ahslength = 1, which
passes the !ahslength and ahslength > hlength*4 - 3 checks added by
commit 2f3835771dff ("scsi: target: iscsi: reject invalid size Extended
CDB AHS") while setting cdb[0]=0x7f and cdb[7]=252. This yields a
16-byte kmalloc but scsi_command_size() returns 260, so
target_cmd_init_cdb() reads 260 bytes from a 16-byte heap object, a heap
out-of-bounds read. The leaked bytes are later parsed as the CDB and can
be indirectly observed by the initiator through sense data and
responses.

commit 2f3835771dff ("scsi: target: iscsi: reject invalid size Extended
CDB AHS") fixed the zero-length ahslength overflows and the AHS-buffer
overread, but did not cover the orthogonal "allocation size vs.
opcode-declared size" path. Reject the command when the opcode-declared
CDB size exceeds the AHS-provided length, before the kmalloc.

Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/target/iscsi/iscsi_target.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 62ada3a52210..e3e9254df960 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1124,6 +1124,19 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
 
+		/*
+		 * The CDB buffer is later re-parsed by scsi_command_size() based
+		 * on its opcode, which may claim a length larger than the AHS
+		 * provided. Reject such a mismatch before allocating to avoid
+		 * an out-of-bounds read of the CDB buffer in target_cmd_init_cdb().
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


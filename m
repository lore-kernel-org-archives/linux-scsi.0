Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A6E434E50
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 13:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182526; cv=none; b=LGEQBv7p/tKZ9b9ooSlM+stH7ZiuTTj6/9AyZjdoR/H7pspGI6ZlkCZ8rHaUklh2V0U0us5N2A/n1IR82kJxhW8XLR9YzkdFUFlT4HBo1P4YOn2vjdmALvvV0N5Xnt2vQGyv3057arTf5Bu12Y+tbGon9vWCAWlUdTUihfjNpVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182526; c=relaxed/simple;
	bh=Z99y3W+Jp+BBxP0dT9ocAAQAdReiGw83GVMdtID0gnk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=UwWvaz7KIFoQ1DmbQTYl0DhlhDzKkFxjQL808Goh0ZkjrKX5R+fmoB3rlIuUR9lxAIlifQlJSyoqhBTPcCt5WM0LUIF8xLLlgKv9LfMNqtZJ15S1EnRM/fnGq+Gp1mvyyFvmWC1hVsH7t2kU+71Ru3z7SYW/d2kD4sb+MJPlZM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uySohnx+; arc=none smtp.client-ip=95.215.58.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uySohnx+"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z99y3W+Jp+BBxP0dT9ocAAQAdReiGw83GVMdtID0gnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788182521; v=1; x=1788787321;
 b=uySohnx+l0d9/LgrCSCzRz09hrzE9ZZ34D06w/OlLfr0Wx61VcOImfu+UDZXDON2cUXkJoEf
 oJQk1SrJiCp8XdfFE5OONO5C9J5P+W2MTfz89w8JzSatVOz7STxIIlW+FRAta3QmWSkPfzK+Izd
 G2Pz7P0ZuhEoougFqmgcSvAs=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 06215eb84a0c848f;
	Mon, 31 Aug 2026 13:21:51 +0000
X-Mizu-Trace-ID: 06215eb84a0c848f
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 31 Aug 2026 13:21:51 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>
TLS-Required: No
Subject: [PATCH] scsi: target: fix PRIN READ_FULL_STATUS buffer bounds check
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Tianchu Chen <flynnnchen@tencent.com>

core_scsi3_pri_read_full_status() writes one Full Status descriptor
per registered I_T nexus into the PRIN response buffer: a fixed
24-byte descriptor header followed by the variable-length
TransportID.  The overflow check, however, compares

	exp_desc_len + add_len > cmd->data_length

where exp_desc_len covers only the TransportID and add_len
accumulates only after completed descriptors, so it undershoots the actua=
l
write extent by a constant 32 bytes (the 8-byte PRIN header, since
off =3D add_len + 8, plus the 24-byte descriptor header), leading a
remotely-triggerable heap OOB-write.

The allocation length of the PERSISTENT RESERVE IN CDB is fully
controlled by the (possibly remote) initiator and truncates
cmd->data_length, so an initiator that registered itself can pick a
data_length in [desc_len, desc_len + 31] and make the first
descriptor write up to 32 bytes past the end of the command's data
buffer.

Base the check on the actual write offset instead, so the test
covers exactly what the loop is about to write (24-byte descriptor
header plus TransportID, matching add_desc_len =3D 24 + desc_len
below), as core_scsi3_pri_read_keys() already does. Same principle
as commit c58a252beb04c ("target: fix buffer offset in
core_scsi3_pri_read_full_status").

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: c66ac9db8d4ad ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/target/target_core_pr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
index 25b1bcacc0c8f..1d34887e9e845 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3990,7 +3990,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		exp_desc_len =3D target_get_pr_transport_id_len(se_nacl, pr_reg,
 					&format_code);
 		if (exp_desc_len < 0 ||
-		    exp_desc_len + add_len > cmd->data_length) {
+		    off + 24 + exp_desc_len > cmd->data_length) {
 			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
 				" out of buffer: %d\n", cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
--=20
2.51.0

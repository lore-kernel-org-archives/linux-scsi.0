Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2658B5013B8
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788188430; cv=none; b=jLPfnB3iMog28oqAO7GlrdkYZNjh4zcANUS22V34T55V4zOP3muGJslK9Pdk5vt+6F3vaU/mkw8P5X2JlRzw1LPr925lsNIly91vCeitM9NOsEAotDgvlCKuWbWkqp5dyGJQHw1EpoCFO5jt/AHcpxyU9pD5bP0nV/92h8pdcLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788188430; c=relaxed/simple;
	bh=Z+IiAM0IGaWyF902a+5GcKClNGt9Sf0qjw/5zkcbadI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=XtpuDsLUFNe29hMqcKejDwhRFFmS4ZH1Am2aQyFyDX7aJygvaqgw6WxrFXnn5gyW4wWhyVymgnFtEhlyU4mMTIgwkwjljpRrJZZSi7pbqfN/RiXaBBRGL8g8F5cC9lNx/LsuYWwkjKV7a5KpMGgG18BTgCEF0eNFa18unTpYR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CoMUFw81; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CoMUFw81"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z+IiAM0IGaWyF902a+5GcKClNGt9Sf0qjw/5zkcbadI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788188427; v=1; x=1788793227;
 b=CoMUFw812UD4/U8p43+olxkXgt73A/fbhcq7jqjsbZfjS3PuZbIMD/R2zzwqDxLJ8618XKjb
 LIOvf/8/IFXLibxM+u/gTfbCr7IbpZ/EL1sbws6CmQf4XIeN/VTCV57pKKB26oGL7s1ZqPcYPOA
 Jaj5DdIv7jlmSUUvdvC6Smog=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id db2c0d8a4f1cca73;
	Mon, 31 Aug 2026 15:00:26 +0000
X-Mizu-Trace-ID: db2c0d8a4f1cca73
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 31 Aug 2026 15:00:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <ddf3c216cf486a1939784731bd1fb50e58092256@linux.dev>
TLS-Required: No
Subject: [PATCH] scsi: target: fix use-after-free on self-preempt in PROUT
 PREEMPT
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>
References: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>

From: Tianchu Chen <flynnnchen@tencent.com>

In core_scsi3_emulate_pro_preempt(), the !all_reg first path removes
every registration whose key matches the SA RESERVATION KEY field -
including the caller's own.  Unlike the two sibling loops, this one
does not skip the calling I_T nexus; instead it passes
dec_holders =3D calling_it_nexus, so __core_scsi3_free_registration()
drops the reference taken by core_scsi3_locate_pr_reg() and, for
plain PREEMPT, kmem_cache_free()s the registration right away.

The function tail then unconditionally calls
core_scsi3_put_pr_reg(pr_reg_n), decrementing pr_res_holders of the
already freed object.

A remote initiator can trigger this with two commands: REGISTER with
key K, then PREEMPT with SA RESERVATION KEY K while no reservation is
held (or it is held with a different key).  The dangling decrement
silently corrupts the freed slot, or underflows pr_res_holders of
whatever registration reuses the t10_pr_reg_cache slot, which can
later turn into an early free / double free of a live registration.

Track that the free path consumed the locate reference and skip the
final put in that case.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: c66ac9db8d4ad ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/target/target_core_pr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
index 1d34887e9e845..80e112efd6ead 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2823,6 +2823,7 @@ core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, =
int type, int scope, u64 res_
 	u64 pr_res_mapped_lun =3D 0;
 	int all_reg =3D 0, calling_it_nexus =3D 0;
 	bool sa_res_key_unmatched =3D sa_res_key !=3D 0;
+	bool reg_n_released =3D false;
 	int prh_type =3D 0, prh_scope =3D 0;
=20
=20	if (!se_sess)
@@ -2926,6 +2927,13 @@ core_scsi3_emulate_pro_preempt(struct se_cmd *cmd,=
 int type, int scope, u64 res_
 				sa_res_key_unmatched =3D false;
=20
=20				calling_it_nexus =3D (pr_reg_n =3D=3D pr_reg) ? 1 : 0;
+				/*
+				 * dec_holders=3D1 makes the free path drop the
+				 * reference core_scsi3_locate_pr_reg() took on
+				 * pr_reg_n, so the tail must not put it again.
+				 */
+				if (calling_it_nexus)
+					reg_n_released =3D true;
 				pr_reg_nacl =3D pr_reg->pr_reg_nacl;
 				pr_res_mapped_lun =3D pr_reg->pr_res_mapped_lun;
 				__core_scsi3_free_registration(dev, pr_reg,
@@ -3012,7 +3020,8 @@ core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, =
int type, int scope, u64 res_
 		if (pr_tmpl->pr_aptpl_active)
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
=20
-=09	core_scsi3_put_pr_reg(pr_reg_n);
+		if (!reg_n_released)
+			core_scsi3_put_pr_reg(pr_reg_n);
 		core_scsi3_pr_generation(cmd->se_dev);
 		return 0;
 	}
--=20
2.51.0

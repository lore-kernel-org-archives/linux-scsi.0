Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C03C9429
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712980; cv=none; b=MC/vZOFufBZmbZA/+bcMkovYgDqjhxHP7FiucZRDoO9evc8AoHx3Hp1bf19MBYMJdIrWkITADNMYNTEb1GwHs/6kEL3QUcsEot1TJs9xIz30zN+AyYbIJQF+lJwTuRV+wQ6uf7oLC1kyRaVhFetGW+VIInhn+e7uLZ2SB3BE2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712980; c=relaxed/simple;
	bh=vmL40prHt4bFr0AX8qgJbFl0AqOYvOuvC/Q9v+8GGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abWx2UBa3e9xCQ7Ae4uIJnZivoqKBYzi98ZzPBhNDRvW+X8M1fhQgRSAvOGm2cqpq7FdNebXPYvmzafui2bJAAp2r6ncBqusxdQVwb+nRqijpbYAcLm7FkFxqrCdtfxJwnPxXtHt5wgK5JA3/iPUBt37xwzfpm9/HV4z/KyudXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NN399S0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NN399S0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D0A1F00893;
	Fri, 18 Sep 2026 06:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712978;
	bh=inWy/sswwkXOTTs1x8RtSgqJRYF6h65OvDE5QbY39mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NN399S0VrjRSB25bDSeu0K0k0y/D7kwqMMgYvZn8wsA1GODcRvfmHNpWtas+cVwbj
	 gSsYmPCeuVFwp0uCaqlBvRPv38qT6GdD9/eh1Fi82HM4llXEFq4UH5/iacct7/q3Ns
	 aKkxlLL6KtANdkjfbjPzBrS4AlrWIIf86yhBMl1skaAuACmWgxqDAp0Mq8wBSF2A0F
	 jY8UFeIl5FpAF/VDjgFc7jJfWTiYpaS6upgL8Whbrrf5Uo18btjlSw0+Tcctadyy7/
	 L2eHLDtYbcHDUASnJWrSiKidLtcCV19MNKHXvVnyjQ/F0pAVTLT4uH3kDlyBqBtPta
	 ErOohUxXMTtrA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 04/10] scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
Date: Fri, 18 Sep 2026 08:29:15 +0200
Message-ID: <20260918062910.1709791-16-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4451; i=cassel@kernel.org; h=from:subject; bh=vmL40prHt4bFr0AX8qgJbFl0AqOYvOuvC/Q9v+8GGnE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LKzc/ZoPLajN/FfhPa+DR1rLE2Ps+yfsHbyCceac pHrpg46HaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZgIAxcjw+wXocr6so0/s5Ic CluLurLjD7Hm8d3fu6B09cVz4RdN1jL8jzURS5uZs/HiPr6JbZxPgg3/n264xlR5jyHIdmLC+uw 2ZgA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

corrupt_lbas(), resp_write_dt0() and resp_write_same() call
scsi_debug_lbp() to decide whether to take the zone metadata lock, and
then call it again to decide whether to read or write the provisioning
map that the lock protects.

The result is not a constant. scsi_debug_lbp() is false while the
fake_rw module parameter is set, and fake_rw can be written at any time,
both as a module parameter and through its driver attribute in sysfs.
The two calls can therefore disagree, and the later one can decide to
touch the provisioning map after the earlier one decided not to take the
lock that protects it.

Call it once and use the result throughout.

Assisted-by: LLM
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=128 lbpu=1 lbpws=1

A WRITE(16) completes and GET LBA STATUS then reports the region as
mapped, which covers resp_write_dt0(). A WRITE SAME and a WRITE SAME
with the UNMAP bit set complete, and GET LBA STATUS reports the first
region as mapped and the second as deallocated, which covers all three
uses of the result in resp_write_same().

corrupt_lbas() is not covered. It is reached by writing to the corrupt
file in debugfs, and that interface rejected the requests that were
tried, for a reason that has nothing to do with this patch.

The window that the change closes was not reproduced. It needs fake_rw
to be written between two calls, and was found by review.
---
 drivers/scsi/scsi_debug.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 18aefe83b7b6..c68dba6dbbdd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4953,12 +4953,13 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
 {
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 	u32 block, num_mapped, b, i;
 	int error = 0;
 
 	if (sdebug_dev_is_zoned(devip) ||
 	    sdebug_dix ||
-	    scsi_debug_lbp())  {
+	    lbp)  {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
@@ -4975,7 +4976,7 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
 		goto out_unlock;
 	}
 
-	if (scsi_debug_lbp() &&
+	if (lbp &&
 	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
 		pr_err("can't modify unmapped logical blocks: %llu:%u",
 			lba, num);
@@ -5035,6 +5036,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
 	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 
 	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
 		     atomic_read(&sdeb_inject_pending))) {
@@ -5102,7 +5104,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	if (sdebug_dev_is_zoned(devip) ||
 	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
-	    scsi_debug_lbp())  {
+	    lbp)  {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
@@ -5147,7 +5149,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	ret = do_device_access(sip, scp, 0, lba, num, group, true, false);
-	if (unlikely(scsi_debug_lbp()))
+	if (unlikely(lbp))
 		map_region(sip, lba, num);
 
 	/* If ZBC zone then bump its write pointer */
@@ -5374,8 +5376,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	u8 *fs1p;
 	u8 *fsp;
 	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 
-	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
+	if (sdebug_dev_is_zoned(devip) || lbp) {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
@@ -5384,7 +5387,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (ret)
 		goto out;
 
-	if (unmap && scsi_debug_lbp()) {
+	if (unmap && lbp) {
 		unmap_region(sip, lba, num);
 		goto out;
 	}
@@ -5414,7 +5417,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		block = do_div(lbaa, sdebug_store_sectors);
 		memmove(fsp + (block * lb_size), fs1p, lb_size);
 	}
-	if (scsi_debug_lbp())
+	if (lbp)
 		map_region(sip, lba, num);
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
-- 
2.55.0


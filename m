Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AC854707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486833; cv=none; b=mKxYVagAB/hPenyG6vWZQBrZcpOhsTV7yNe4Ku+pnhdUfIkWAPMlHaDxcKIkpCryZ2sFHMm1XUi6B2DRd159kbfWeqfcUtMDEozOC0AE0EGCF4HqYzRkQ8ImMWtFsT/N9M9ov7o0S92wFVLDBtWQgfWsy1zUwqsw0d16Chm89n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486833; c=relaxed/simple;
	bh=F7nX+NIyj3FKOhrLKfm177u3r/818rOOdk2qittHW3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMKr7aVXwWU69YxxFKKWKw3h81+c4let0rgpX+isfyDM0l0ZdOtOybqzJC/V+Jl/BgOd4j8PbcWDcfaVYtRqSd4zUctIL4fyQLhITzUeEps0AFdtw3E+thCCToO3Es0bCiHt+laV9HXg89p4qxLuvyiMbXcvLccGbc5cCS1dq48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALtv3KD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALtv3KD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A1C1F000FF;
	Sun, 27 Sep 2026 05:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486831;
	bh=kSyn8ga3WMtouJGkBr0s86Tq06eXrWAoL03pSshKw/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALtv3KD27K8siYqOjbfec5oKvqUobznpLrk32RoXu59KMVvVWLdm8ho9bldq28k3r
	 nN99yOA+5Lr7meDSwIBR/pc8smeCki2GCNxvymfibCYwokunXbmHy+FsdGRJEUHWVl
	 xOKnbydCFyeOQIX4cPcw/UHhRKdaWzf5z68JK5jqdf2ACRw9ZqyrO3VOyPToid1Y5Y
	 GkbUPNHoDsYrHMGUKZqP501XOcfI5+jvyCrO0giIs3MwTmsJXxy2wDZ0DTu3VGcQBa
	 lRWqqVfC7oTCn5Z6kU2Dojfd0efE7QjXDh468DnJQ4iaqQyb1PFqCtXrwaKbLRXzWE
	 Tb5yra/fMuuLA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 04/11] scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
Date: Sun, 27 Sep 2026 07:26:55 +0200
Message-ID: <20260927052650.567035-17-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4597; i=cassel@kernel.org; h=from:subject; bh=F7nX+NIyj3FKOhrLKfm177u3r/818rOOdk2qittHW3o=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFQo135XFLnn24LNfZy+izaLJMxbwZ0bcOlNmF3as jsW18UDO0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARBwtGhtfvLr+0MjvlVJi9 9BK/rqXHopOsMzymNX6/kvLv0gERnqeMDJPvpJwKdJ2o8b+b+4ycWmLMn5fznM7cO6Jws31qmsT XaVwA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

corrupt_lbas(), resp_write_dt0() and resp_write_same() call
scsi_debug_lbp() to decide whether to take the zone metadata lock, and
call it again to decide whether to touch the provisioning map that the
lock protects.

The result is not constant: scsi_debug_lbp() is false while fake_rw is
set, and fake_rw is writable at runtime, both as a module parameter and
through its driver attribute. The second call can therefore touch the
map after the first decided not to take the lock.

Call it once and use the result throughout.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
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
 drivers/scsi/scsi_debug.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 18aefe83b7b6..b64ae3ad300d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4953,12 +4953,11 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
 {
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 	u32 block, num_mapped, b, i;
 	int error = 0;
 
-	if (sdebug_dev_is_zoned(devip) ||
-	    sdebug_dix ||
-	    scsi_debug_lbp())  {
+	if (sdebug_dev_is_zoned(devip) || sdebug_dix || lbp) {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
@@ -4975,8 +4974,7 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
 		goto out_unlock;
 	}
 
-	if (scsi_debug_lbp() &&
-	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
+	if (lbp && (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
 		pr_err("can't modify unmapped logical blocks: %llu:%u",
 			lba, num);
 		error = -EINVAL;
@@ -5035,6 +5033,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
 	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 
 	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
 		     atomic_read(&sdeb_inject_pending))) {
@@ -5101,8 +5100,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	if (sdebug_dev_is_zoned(devip) ||
-	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
-	    scsi_debug_lbp())  {
+	    (sdebug_dix && scsi_prot_sg_count(scp)) || lbp) {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
@@ -5147,7 +5145,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	ret = do_device_access(sip, scp, 0, lba, num, group, true, false);
-	if (unlikely(scsi_debug_lbp()))
+	if (unlikely(lbp))
 		map_region(sip, lba, num);
 
 	/* If ZBC zone then bump its write pointer */
@@ -5374,8 +5372,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	u8 *fs1p;
 	u8 *fsp;
 	bool meta_data_locked = false;
+	bool lbp = scsi_debug_lbp();
 
-	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
+	if (sdebug_dev_is_zoned(devip) || lbp) {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
@@ -5384,7 +5383,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (ret)
 		goto out;
 
-	if (unmap && scsi_debug_lbp()) {
+	if (unmap && lbp) {
 		unmap_region(sip, lba, num);
 		goto out;
 	}
@@ -5414,7 +5413,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
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


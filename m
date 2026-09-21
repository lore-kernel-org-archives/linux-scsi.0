Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4114B5CD0
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005275; cv=none; b=g3XfKSqyc5++IzvaSJzLJ0O1IoZDMu0gXUCrTvVdJ/b5MQpnUaX8BqH0YDZmX96i1ou6MdGPJUnIvRKnfAGpyY/fxNrPzCNRlMZpoiu+doE1uJBZmCuau+vlkyfUZGdQ7gFz3fh9kb7pid5y7oeMg9N2Y2R8CcUbS3utwLD2dEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005275; c=relaxed/simple;
	bh=+f25S+PZfMdlJ8Xk1Aie9ve2ruviURhWIqYzWlazu3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBff2QvzOVM0tG5fDAnNPlFIU2JPOomKYppcNBP9THaZrv+brYnybWEuqSDGzLIQIoWrXL0kpX1R4nEaumxKgH/IK84H8GChKnHAQHe2u2IGdKU2iGv5RiDMfD9bzryrRkv6KdTH9ZhKeXtlJ+C4+aqrhpVcI+Fk5a/IN9eogI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYv/nG+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYv/nG+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5377F1F00893;
	Mon, 21 Sep 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005273;
	bh=RhK3ZSBaY8sX9m3irkk8OS4CC+5GbpCeqcjnraT98/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYv/nG+poPfhKGm3h6QlKNfya4XuMBBxGAl2qIdKK1GdR4PgosIBsLzP0oFeKD+9U
	 QoFRvAkc7b6ZHpQrbYKDZFt1ma14LYggFYqNbmIBZinPVKTtW4SIZBr+C1WMEbsesp
	 ZyB/ali4tFkw58Lzk4hfBgDVkQJa/jFAwQ+ot6FPSZrlfNG3KuFHazudTeUUacVwOV
	 hCDy+qufMdB4uDoJ+6NS2sV3TNjO1G6dHhDzX/9eIXFH4Wly/T3v2j1ESZU2ZwbFC6
	 hcd1sWPURYUb7i5XcIaR72vfV0jEqPgcFI0VSMHMWSDEUnGv/hEr7iU5AMN9wSghCP
	 JyDW/u+Bf95pw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 04/10] scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
Date: Mon, 21 Sep 2026 17:40:20 +0200
Message-ID: <20260921154015.2971990-16-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4501; i=cassel@kernel.org; h=from:subject; bh=+f25S+PZfMdlJ8Xk1Aie9ve2ruviURhWIqYzWlazu3A=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j87ftSPycRtRVggv9iCA+rLbSbfmiAguP9dhUT3j dairuV7O0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARS31GhuOyjyqPvNi6QHfm EaH/lmdy1WrmTzrwzlDHJlPN2KHgZTMjw5Yr8z7dYWQ7anfA6jiDx6HJWj0nJpZ3+Gx82H1lS6G ZMTMA
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8E633A02B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580084; cv=none; b=TFWpV9neP94GlWlhGnEXfFokTucFI/Dku63+Jj9pd9G32ajHuJeywajneA0yqAFOsfNz7hnQsaFcUlXaNY5ZhPHNlHSQeunU+pBZEYhNVUoXa7B55+2fZLHf7s7zh2LDP7ckRybrBmjEH5IVqXICTrsLFybn2lJbc3MKf2S7Sds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580084; c=relaxed/simple;
	bh=nmjuZFO0BBFM5JvVGrYoomOd2fuI7TM3QkSgOhiuq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knPfCgkNPQLitYJt37kj1ovkCMGgx0ajhLV5Ye93lSuasOEUp9BoCEWj0FC6rf/2toNPQP7bkRl6K84Ptsf4wtXoULxFAs7QrH/fVe2XMdXIexitaPctef59QVSZjaTNVI9Tc0eZh1hwlIkAWmQPwXi9CgCKNlyXnsWhn+xeu5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhRocRW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhRocRW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5751F00893;
	Mon, 28 Sep 2026 07:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580082;
	bh=QhOtyp16dNvAdT5Q2z+76wjxjhZTGlHPBTMwV1uyT0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhRocRW8NVxsaiJ6T8cV1FGswmWmX3ayOFczDnP/7zVhQ6a9n21EEzAsrWFLpyrro
	 pPnFcm+3JZ+GJ8TJkex/b1qQA/UTfj7TZiMxPCl18DLF+IA/KP7FqDuNIPHXMMzV/0
	 Dj8tRU7B3QNUTIJYULXZflTDgRJ+wy6/mA90weiilJZRH2pi9cMimtlRU09B4/3KXT
	 aSIs4Zu4uRX9UyTKiCsx8WhWeCaVNYEIq9sTCM6p1APlVcwj7KwAklaj6NJ2mOBTMN
	 u/e/1qBx2V3BsTQeG5pBmagKT9R24GEhk888vd/pofermUbSZgfLRpRZB6q1vYk6lQ
	 tpq48XJqvbJwA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 03/12] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Mon, 28 Sep 2026 09:21:06 +0200
Message-ID: <20260928072102.725566-17-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2333; i=cassel@kernel.org; h=from:subject; bh=nmjuZFO0BBFM5JvVGrYoomOd2fuI7TM3QkSgOhiuq0s=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iaZtz9qm5VQkEm0/4QHzJN363CUvtc6cejllou6/y yLcFtG2HSUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZiI0hOGfzrLrD9yRnzh6viv oDtpT9LHGU8M7Pv6vk+0mLEsdVOkdD7DN6Xph2u9+z78mv/RL+DEmz/8h5ZI/L767ihzSsXnWe6 SXAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_comp_write() takes the data lock and then the zone metadata lock,
while every other command that takes both takes the metadata lock first
and reaches the data lock through do_device_access(). A COMPARE AND
WRITE and any other write to the same store can therefore deadlock each
other.

Take the locks in the same order as everywhere else.

Correct the comment above map_region() while here: the provisioning map
is covered by the metadata lock rather than the data lock, which is why
resp_unmap() takes only the metadata lock.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=128 lbpu=1 lbpws=1

COMPARE AND WRITE completes, and a READ(16) of the block that it wrote
returns, so the reordered locks are still taken and released correctly.

The deadlock itself was not reproduced. This kernel is built without
lockdep, and the window needs a COMPARE AND WRITE and another write to
the same store to interleave between the two acquisitions. Found by
review.
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8e45a57ae406..18aefe83b7b6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5575,8 +5575,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 
-	sdeb_data_write_lock(sip);
 	sdeb_meta_write_lock(sip);
+	sdeb_data_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE,
 				MISCOMPARE_DURING_VERIFY_OPERATION);
@@ -5584,12 +5584,12 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		goto cleanup_unlock;
 	}
 
-	/* Cover sip->map_storep (which map_region()) sets with data lock */
+	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup_unlock:
-	sdeb_meta_write_unlock(sip);
 	sdeb_data_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 cleanup_free:
 	kfree(arr);
 	return retval;
-- 
2.55.0


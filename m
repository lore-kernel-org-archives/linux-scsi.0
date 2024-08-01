Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE9914C58E;
	Thu,  1 Aug 2024 05:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722490959; cv=none; b=DyZSeASbIsuiTNz0qyJVH8IZSabQUxVVOyJvnqKsKdQt/1tlScGoUoYdwvGmaQ1gl8YQpBhpPU7jSGKEIpa7pO0DnML3k18D5M/Acvj5AjdZFbh+r8q16lhrMzt53ZkiLSnff0oSUm/dGSU+DfJ12ebLJtBgzbyhX1vps67zCOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722490959; c=relaxed/simple;
	bh=V8Fc8yJKmYW061eVlMN3P3crU7VpmpmQ9s2+yRXA3xA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mv5NTVb9jAKABfLmoT4l6vcsx6UTNPqRc1zCAhsI3LTR2GV7NzKAHT9Y2IFDV4dhzjc6izebkX0dVijhDXZ07tJC+wLXD7Yqw7dneGRFNk9aqLiSLbdtSgvnR6ePy5wlvKM+ARqAommCXJprDn3bTSw4baGb95TOSQZfXTBHJhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MlBbtIqe; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MlBbtIqe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722490957; x=1754026957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V8Fc8yJKmYW061eVlMN3P3crU7VpmpmQ9s2+yRXA3xA=;
  b=MlBbtIqedk8RUdRvc/QXNZzJbrJa7trykUuOFVyrbs7ELrtoZOEDIA/L
   nRl8cPJ07QZeKapv8b766dllVXCQQyQPwoU4owAWalTemssXKBoIq0MjI
   /K+b4C3UOw/XSLhKM3L5WtDO8Pa97HlSKgsiNIa4uw3i9U4ycZmgY8iwW
   GQPMoOZ0VBDTBMEfa3sQcHHnaKZBqkjsresrccKFqG6ajHLuQ1GbOzdlb
   CBGQCpjnHL1rZJ3p0jyoJ8+djr8NnEOlZZKnc/pZsx2GZcLilpvJJE+nE
   bu3kGGBrWJPIEXGJKyR68R995oZ273VB9r3+fLxSwRjrDPJxiqF/L8KWn
   w==;
X-CSE-ConnectionGUID: u7IJ47SEQy2JevqLbkHPeQ==
X-CSE-MsgGUID: EF5Eo5+RSjedIJkxpP68kw==
X-IronPort-AV: E=Sophos;i="6.09,253,1716220800"; 
   d="scan'208";a="23250163"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Aug 2024 13:42:36 +0800
IronPort-SDR: 66ab1259_dzX/Gz12i/mYUHg8eYPFZQVp+f5WrkQSnxXDpmTK/CqrvZe
 kb7T4yb1o88lB/Rg2peFbyNLxAuQwGPQN2gzBLQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 21:43:06 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 31 Jul 2024 22:42:36 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Coelho,
	Luciano <luciano.coelho@intel.com>,
	Saarinen,
	Jani <jani.saarinen@intel.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: sd: Move sd_read_cpr() out of the q->limits_lock region
Date: Thu,  1 Aug 2024 14:42:34 +0900
Message-ID: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 804e498e0496 ("sd: convert to the atomic queue limits API")
introduced pairs of function calls to queue_limits_start_update() and
queue_limits_commit_update(). These two functions lock and unlock
q->limits_lock. In sd_revalidate_disk(), sd_read_cpr() is called after
queue_limits_start_update() call and before
queue_limits_commit_update() call. sd_read_cpr() locks q->sysfs_dir_lock
and &q->sysfs_lock. Then new lock dependencies were created between
q->limits_lock, q->sysfs_dir_lock and q->sysfs_lock, as follows:

sd_revalidate_disk
  queue_limits_start_update
    mutex_lock(&q->limits_lock)
  sd_read_cpr
    disk_set_independent_access_ranges
      mutex_lock(&q->sysfs_dir_lock)
      mutex_lock(&q->sysfs_lock)
      mutex_unlock(&q->sysfs_lock)
      mutex_unlock(&q->sysfs_dir_lock)
  queue_limits_commit_update
    mutex_unlock(&q->limits_lock)

However, the three locks already had reversed dependencies in other
places. Then the new dependencies triggered the lockdep WARN "possible
circular locking dependency detected" [1]. This WARN was observed by
running the blktests test case srp/002.

To avoid the WARN, move the sd_read_cpr() call in sd_revalidate_disk()
after the queue_limits_commit_update() call. In other words, move the
sd_read_cpr() call out of the q->limits_lock region.

[1] https://lore.kernel.org/linux-scsi/vlmv53ni3ltwxplig5qnw4xsl2h6ccxijfbqzekx76vxoim5a5@dekv7q3es3tx/

Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/sd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adeaa8ab9951..08cbe3815006 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3753,7 +3753,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 			sd_read_block_limits_ext(sdkp);
 			sd_read_block_characteristics(sdkp, &lim);
 			sd_zbc_read_zones(sdkp, &lim, buffer);
-			sd_read_cpr(sdkp);
 		}
 
 		sd_print_capacity(sdkp, old_capacity);
@@ -3808,6 +3807,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (err)
 		return err;
 
+	/*
+	 * Query concurrent positioning ranges after
+	 * queue_limits_commit_update() unlocked q->limits_lock to avoid
+	 * deadlock with q->sysfs_dir_lock and q->sysfs_lock.
+	 */
+	if (sdkp->media_present && scsi_device_supports_vpd(sdp))
+		sd_read_cpr(sdkp);
+
 	/*
 	 * For a zoned drive, revalidating the zones can be done only once
 	 * the gendisk capacity is set. So if this fails, set back the gendisk
-- 
2.45.2


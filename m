Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07D02580D2
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 06:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749796258; cv=none; b=g6c2L7wXMrhYQOqIEBDhB9kP3JaB7g/LK2ZhW42lJ6Bt2xYU9mumD4Z73x9MnuTjFkWw/5TEa8m0uSiDLLR/feBdSvVVXL8KO/l6A6hguwzwhsQlyGzSFKNgXyDTkImrs2s7ULNnflWBUm7LN5dbAyhKkSrHQ7JQg4XcKF0SVEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749796258; c=relaxed/simple;
	bh=iYeisXjzkeYEgFrwGuxBQGzdD6n9Q2wMtJo4KIca0AE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smC3s5o0TMNniH0eQYO72AFC+DMd/w9UUeoixlbuhlx5o22gg9VkPtde7h6AHm1HmzLr+3yhKthveCBmR8Lyk2sQ2i+oWQIxn5fG3urnbTdRbT+IpJ8iYN61saV9mql7bmZYYQHBF0ZVdazGNISj8lWqcjXFqck0uuoqEriY/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKeEpv2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKeEpv2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3170BC4CEE3;
	Fri, 13 Jun 2025 06:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749796257;
	bh=iYeisXjzkeYEgFrwGuxBQGzdD6n9Q2wMtJo4KIca0AE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kKeEpv2PGKdXhNVdPfmRMs3t16dtKOp9Ivxyl2DHLtLFMUExHXGo1nTk5YJcjG1gi
	 b4kV67cDtWgyyO+3Ektnj2if/ATgcrRENxP0Npl8vgq7EFknP/3xmX4qryGxWGYUt3
	 sgoi7Z69H3AoBmqJfPVvSBqy6saivnQdyqeqM8+eGo9KVVV+gf1dGIb8cL3Bo8VPeT
	 oWGSmEacL7yadrA5I1dxl+VsOBwjD4KK/e4QyWgY0K3vfJ/dstYwQfeBWXjtJ0Jb3E
	 jR4sEzhYeN8g9Rkzxa9y4FwTCQSxRs8W6695EcK8TroqsgyBsvzCpYEizgp2GJuurp
	 oPB6sJ8kug7Yg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 2/2] scsi: sd: Set a default optimal IO size if one is not defined
Date: Fri, 13 Jun 2025 15:29:09 +0900
Message-ID: <20250613062909.2505759-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613062909.2505759-1-dlemoal@kernel.org>
References: <20250613062909.2505759-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the helper function sd_set_io_opt() to set a disk io_opt
limit. This new way of setting this limit falls back to using the
max_sectors limit if the host does not define an optimal sector limit
and the device did not indicate an optimal transfer size (e.g. as is
the case for ATA devices). io_opt calculation is done using a local
64-bits variable to avoid overflows. The final value is clamped to
UINT_MAX aligned down to the device physical block size.

This fallback io_opt limit avoids setting up the disk with a zero
io_opt limit, which result in the rather small 128 KB read_ahead_kb
attribute. The larger read_ahead_kb value set with the default non-zero
io_opt limit significantly improves buffered read performance with file
systems without any intervention from the user.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index daddef2e9e87..8070356285a7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3681,6 +3681,40 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
 	kfree(buffer);
 }
 
+/*
+ * Set the optimal I/O size: limit the default to the SCSI host optimal sector
+ * limit if it is set. There may be an impact on performance when the size of
+ * a request exceeds this host limit. If the host did not set any optimal
+ * sector limit and the device did not indicate an optimal transfer size
+ * (e.g. ATA devices), default to using the device max_sectors limit.
+ */
+static void sd_set_io_opt(struct scsi_disk *sdkp, unsigned int dev_max,
+			  struct queue_limits *lim)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct Scsi_Host *shost = sdp->host;
+	u64 io_opt;
+
+	io_opt = (u64)shost->opt_sectors << SECTOR_SHIFT;
+	if (sd_validate_opt_xfer_size(sdkp, dev_max))
+		io_opt = min_not_zero(io_opt,
+				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
+	if (io_opt) {
+		lim->io_opt = ALIGN_DOWN(min_t(u64, io_opt, UINT_MAX),
+					 sdkp->physical_block_size - 1);
+		return;
+	}
+
+	/* Set default */
+	io_opt = (u64)lim->max_sectors << SECTOR_SHIFT;
+	lim->io_opt = ALIGN_DOWN(min_t(u64, io_opt, UINT_MAX),
+				 sdkp->physical_block_size - 1);
+
+	sd_first_printk(KERN_INFO, sdkp,
+			"Using default optimal transfer size of %u bytes\n",
+			lim->io_opt);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3777,16 +3811,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	else
 		lim.io_min = 0;
 
-	/*
-	 * Limit default to SCSI host optimal sector limit if set. There may be
-	 * an impact on performance for when the size of a request exceeds this
-	 * host limit.
-	 */
-	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
-	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
-		lim.io_opt = min_not_zero(lim.io_opt,
-				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
-	}
+	sd_set_io_opt(sdkp, dev_max, &lim);
 
 	sdkp->first_scan = 0;
 
-- 
2.49.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B32D231839
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627652; cv=none; b=RtBi1Um8gnQkb4AlzYRAFokMXWAitO1H32JRY5jCiMbWhxs9lGb2OpontiU+Up7Bfi/qlX0cDXcspOG7M/Py/Mwn3R/bIXUjDIdurDXG2q/MjGexWjY3USc1n9JWCWt7+h6l15UH06az5g6oRc/CTaxisGwgmB4ktM5k55lK/Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627652; c=relaxed/simple;
	bh=LH/99foafaSWmmvuo0qyDyyHh5B/pUskHGUOzZvZmgU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Hpk/N9pXL1GTdvTqpfDQooGp4MrTs2WQx72hJB5OJ4ZszTXzDhOUnSQLXbdFBBGKdx0dBGgY79giZTdXlD53AzP21isLemdjdIfJa7ZZu1rTtTikG8LDP/XrDeEWx6O1i0Vcc6TRHgbZWCwW0T/4gxNsnoiosWZuWCbb2hHXGxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNvx5h2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNvx5h2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722A0C4CEEE;
	Wed, 11 Jun 2025 07:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749627651;
	bh=LH/99foafaSWmmvuo0qyDyyHh5B/pUskHGUOzZvZmgU=;
	h=From:To:Subject:Date:From;
	b=oNvx5h2RFDZa7qRetf9iSKh2kdUar493rdsrc8V6eLxBRhCnFfBLMEv/3Rtehv7Hq
	 xBtxAlPntwp6Up7wNqWAqdHCIlDM4Y43Y3ck5MK29iiV/6Vq3L8caPkVIk77pNEMHA
	 EljslqiOVt70WEIEnmN9uxkaCyaxuUdyT06iOj58esgrG7uQ8lssWGlEWoyaz2kbp4
	 Zg5ojYZcGvFYMMPUutPpmo5k6ac+1t1LiW6BK3AhmlE2GL+zd+0UmVqURs8etWMFzT
	 6DFeWmKD1V/DpHfdpI32bQOSE8+5HS1N2eI9ms4UdqCyTrioCKspG5L5cpZ7xG5KPJ
	 +ddiBnHO+QSWQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sd: Set a default optimal IO size if one is not defined
Date: Wed, 11 Jun 2025 16:39:05 +0900
Message-ID: <20250611073905.2173785-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
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
the case for ATA devices). This fallback io_opt limit avoids the disk to
be setup with the rather small 128 KB for as the read_ahead_kb
attribute. The larger read_ahead_kb value set with the default io_opt
limit significantly improves buffered read performance with file
systems without any intervention from the user.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f6e87705b62..ebcc1358d3bd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3686,6 +3686,32 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
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
+
+	lim->io_opt = shost->opt_sectors << SECTOR_SHIFT;
+	if (sd_validate_opt_xfer_size(sdkp, dev_max))
+		lim->io_opt = min_not_zero(lim->io_opt,
+				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
+	if (!lim->io_opt) {
+		lim->io_opt = ALIGN_DOWN(lim->max_sectors << SECTOR_SHIFT,
+					 sdkp->physical_block_size - 1);
+		sd_first_printk(KERN_WARNING, sdkp,
+			"Using default optimal transfer size of %u bytes\n",
+			lim->io_opt);
+	}
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3782,16 +3808,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
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


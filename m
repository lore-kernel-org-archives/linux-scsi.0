Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2218479
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749645069; cv=none; b=GjY2nuCnTe2x90Keogoa6oyYTzPLTmpiaQ39uYr09CmvsqKM4TTbGAi810/OvB71hpDi5BMT2KEB5Z5dKt8H12lwm1wr2lqEly8TKPtQ176IHVsTXWT3lysFS+uIALVvgyBCZl77POHclj9angvh7eG2fIRllThBziPT6Ldk0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749645069; c=relaxed/simple;
	bh=GPAoc1RhjAcOvQTmrRrchjFnFIGToNpKDZfZyoxuLP4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MS+iOaOYGSCDQdYg3NGQCkCRXooneYmAXlBPyyxUdqH9zjKHZ6tFkf4QKvbozWu45BmnTq+wP+dUFea6MZ+5sfATQqJC9A/6eCkW39bWnI+5pSY6S6gGsuE1lIW0CDJ/DazncGCda/BW/At7xYerBBPYQLbPLtdVNl1crdu4abA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GChjpCik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GChjpCik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38B9C4CEEE;
	Wed, 11 Jun 2025 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749645068;
	bh=GPAoc1RhjAcOvQTmrRrchjFnFIGToNpKDZfZyoxuLP4=;
	h=From:To:Subject:Date:From;
	b=GChjpCikzmxT6yzDoCjU9cqzrEio88dNTFtspl5q1BSPVJcbsIzEPgRoLD1nXRgKC
	 njZGiDZpaniAlnEphcCCw0uyl4n2oo+a+07q9Vo3Wt9elxkmj/jXFu++mi4bWgY98q
	 RCr3HTsls+BPI4fbE9n9fmfIePSoAzkjN9uY7joS0p0EePJ3WOKfSAnND8M3DsXXsP
	 Dvdw9MMGGMXbMuh8vyxC5tRgvQxVzrud3ACp1ARUaTeMLr8XhH5VquJJ0jNVpNFyaG
	 32kygmjkS5fdZeG/QrtBEegVooKNBqJFtCJM9VeYC0aZuIZcXAIygy9bKCD36R1W8Y
	 aTosGsLpVKgMw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: sd: Set a default optimal IO size if one is not defined
Date: Wed, 11 Jun 2025 21:29:21 +0900
Message-ID: <20250611122921.3960656-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes from v1:
 - Changed message level from wrong WARNING level to INFO level
 - Added review tag

 drivers/scsi/sd.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index daddef2e9e87..92d5b4900c0e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3681,6 +3681,32 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
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
+		sd_first_printk(KERN_INFO, sdkp,
+			"Using default optimal transfer size of %u bytes\n",
+			lim->io_opt);
+	}
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3777,16 +3803,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
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


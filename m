Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB01EEA28
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 06:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749708240; cv=none; b=ZOWgwltJZMQwkm0i9JTXjsekMAlY7QoJ4txPIPiFwkKdlQuFBI8DmzmkwGt9paBAk+lmZdwEkJ105ERs541cFmjokA6Oe1DBp9b//ifNcwaB+L2vuDZFlffOCn3XWzvbGY8krqWjXVABjTyVDVJMc5OU0nekGIna/NvcongX0ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749708240; c=relaxed/simple;
	bh=WtGXBAqnnP89EcvfhqMvn4YNXCU8xT6+2QPx+55dDrs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkJ08J+eZNukK4p/SyYrhB0WU8hfuImxfK9uVOokwjfE7uYepRP5wi78101BRlTSNZ7fCx7+HY3kWAREWeXrfkI3T1G/whogWXLFMI2HN0DCpiw2GgHNsPbqE44tIxY21VrWyriIX20dJ5xd/PW2oQKU610LuTR6pj9/nMWZqQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kW0ZVSQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kW0ZVSQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1577BC4CEEA;
	Thu, 12 Jun 2025 06:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749708239;
	bh=WtGXBAqnnP89EcvfhqMvn4YNXCU8xT6+2QPx+55dDrs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kW0ZVSQgujU1rtMS6vfFURiM/DG0M/wn1siyvG5mq0sJMuoF9Keb9tCOVqCQtlQ3H
	 TnD/bGMud0awD6lre5Ly3pawMBpb85A1nOu6q+6dnSYLcpiLMsgF28E7n9WAvyRkP8
	 D/W9dxFjDLKoq4uCuprzC5z6d2S31YN603Bj6wO8WNuG8TYy/elJs5yZ99LrWOge9p
	 q19kbxHt6Tt57JiuWAfFz51uZ1rw2EOjO0PNg+orv17n4fgzUAiPe3RvZrqLyr6UDD
	 LD2WR3XZx821DIKHvIhE5pKXzVkpxxW+5A2WYaWnFr8LO6zeW4j57EOWlcdRE8gWvz
	 lmpINuLDILnDw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 2/2] scsi: sd: Set a default optimal IO size if one is not defined
Date: Thu, 12 Jun 2025 15:02:11 +0900
Message-ID: <20250612060211.1970933-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612060211.1970933-1-dlemoal@kernel.org>
References: <20250612060211.1970933-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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


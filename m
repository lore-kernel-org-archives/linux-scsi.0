Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA84A38330E
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712988; cv=none; b=JhBpy3RWv3AJGRT4ej/8+WwlT2bkCaj9h5NT/STajJPAZdFy6kh0h/6pkNJlU90Nqpu3u9GST3TX/wNa5l9Nz1FqB1V+QoncCT6zH7ebdUmdnIV/3TFVWUx9vT0dF5R4MMdvOfUvX8n38Fxt3J/8b8ob+nmD8ZHKzp+ezO5PANY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712988; c=relaxed/simple;
	bh=rHjY4HF/t8/PFWx4gvJ18HXzEzsd17Ys30qI3tNUJqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuIJHAAsFQ3Pe2aIhuULDa8OToIb4Id9jcEY9a3/x+eRnyZ31bGfNL5XePSoUNnIqopPLAJgA63+RLC4C0eFYBPqFaZCjXvKgQGpDl9pBa2wmxZB83AoO1he6PE0lfgssVVkFMVOSBq7987nyX2emKrvJ2Ayidjz/DSxEtlYO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbr6H16s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbr6H16s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0461B1F00893;
	Fri, 18 Sep 2026 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712986;
	bh=hnTm/BdX60t6XvTY+ay7ZEVHqYf/WPDWVyyBdQuMcmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbr6H16s30sAmJdolvhr4ZL16FSLHvjjskm9BNt0Tkagfho5xHbaHre6KOE+DkRZa
	 v3kNtRf+VLc5B2YMyOg6pv5PjYQqkw4ds5bqcc3RT0HZiYhAGZ6O6vupR1GNVj3wid
	 mBe5h9jpdlKWFlq9f/4t75m0HgRX/VKWobJm4lWML2GtvNLrutBHR8JtnXAu5aBJqx
	 DMnRIgkU9fGkEU/kXskZtAX1I8tifLFxDA3HkdSOle4l5Y/jN7NQ/YeIpPyXViXPLa
	 kIZ7y4aTiDd3egeG8tTsX1H/wPZPVt9aOKB1XbkWlp777MmbEiIFTei1AwHOO7M4+K
	 FstXh2iS5DxEw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 08/10] scsi: scsi_debug: Advance the write pointer over the data written
Date: Fri, 18 Sep 2026 08:29:19 +0200
Message-ID: <20260918062910.1709791-20-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3638; i=cassel@kernel.org; h=from:subject; bh=rHjY4HF/t8/PFWx4gvJ18HXzEzsd17Ys30qI3tNUJqg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LK/v2v/ncu+ry7LXK+8Zppkp3KvPWN/QFKoaMbdR efXzA8S6ihlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEPjxk+Kf81E792XG2u+pS yf0lhlHnOjcsDbn7yOT/w5IF8V2Ge2IZ/pf92rWzQ8nvxf6ahL7E+YW3dortDTh23bq459wsO54 HS7kA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_dt0() and resp_write_scat() advance the write pointer of a
sequential write required zone by the transfer length of the command
before looking at what do_device_access() returned. It does not always
move that much data: it returns -1 when the data direction of the
command does not match the operation, and a short byte count when the
data-out buffer is smaller than the transfer length, both of which an
initiator can produce with SG_IO. The first terminates the command, the
second completes it with GOOD status and a residual.

The zone state then describes more data than is on the medium, and a
write at the position where the data really ends is terminated with
UNALIGNED WRITE COMMAND, because the write pointer has moved beyond it.
The zone has to be reset before it can be written to again.

Advance the write pointer over the data that was written instead. As
do_device_access() does not write a partial physical block to a
sequential write required zone, what it reports for such a zone is a
whole number of physical blocks, so the write pointer is left on a
physical block boundary, which is where a write can end.

resp_write_same() does not need the same treatment, as it writes with
memmove() and cannot fail part way through.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

issuing WRITE(16) through SG_IO with a data-out buffer shorter than the
transfer length of the command. A sixteen block write with a buffer of
twelve blocks leaves the write pointer of an empty sequential write
required zone eight blocks on, which is where the data it wrote ends,
and a following eight block write continues from there. An eight block
write with a buffer of one block writes nothing and leaves the write
pointer where it was.

Before this patch both advanced the write pointer by the full transfer
length, and a write at the end of the data that had actually been
written was then terminated with UNALIGNED WRITE COMMAND.
---
 drivers/scsi/scsi_debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 837077a4e740..cdea21b570c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5182,9 +5182,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(lbp))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
+	/* If ZBC zone then bump its write pointer over the data written */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret / sdebug_sector_size);
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
@@ -5348,9 +5348,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * writes behaviour as possible.
 		 */
 		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
-		/* If ZBC zone then bump its write pointer */
-		if (sdebug_dev_is_zoned(devip))
-			zbc_inc_wp(devip, lba, num);
+		/* If ZBC zone then bump its write pointer over the data written */
+		if (sdebug_dev_is_zoned(devip) && ret > 0)
+			zbc_inc_wp(devip, lba, ret / sdebug_sector_size);
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
-- 
2.55.0


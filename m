Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6FD1DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320682; cv=none; b=MhKG4y78dI+Sq8Iymb33Oayfvxm7q/py+km6XSsobe3aI/gGjwu206RDw0qoNJ9QVvnmonFX2iOIqkNWU1x4dEdcVnW6RFWUDzqZG7Ah1GS7RhcORLmZzsb5u6ewP4zHZqpzrQinTtVBZXJu4oDy0DrI9/C93x/s2Expt+fB8o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320682; c=relaxed/simple;
	bh=Tj/047mZQjkVXo7cJq1r3Fg2OJALpTF6rahMgACH/to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0/s9iApGuHj3fW2ut8kvTWO7s8hB0KbYd9iAPNkmpvNOtdwGoGmeONhWQQGkiQdDDAYE6ouB0ufL+u7Uxi+EPomYuf2PrFdcHYBcINPOTENzgWYQysjSFC6EnMqtDXJ0E0dLlSXb+y2mLJrJegBuLi137mQ2nRKHfVkXfjeu60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOV5pM7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOV5pM7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7545E1F000FF;
	Fri, 25 Sep 2026 07:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320681;
	bh=ASL7cVunHdztOJyl8AvmhHoihcUbGsSTTUkhN1wqZQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOV5pM7pQACQliYtmeZatzgzOSrqlNCBCYMyHFlVUM5ObqasKyB5GFm39PzM6M+ei
	 2sSqLqQD+S8jm4TxyADolhm5rb1iC27GNiEi1gSgW/+04bP+x+0+PCKwtcNSeg01mY
	 OgVSxi9i8u/Ws8RBWjRpeSIJRFembrrPP+rle7e4fFP3Xsh5ym22HgJurvj65XaWg4
	 +Ba/mMxTz8FcPN8vwOMPVyCXyRRQmtufwkqSeMT6AvI0rJ+qfsvwR/mHIb+EU0UrmE
	 0tSMI5Vs8bE6ur5Thby6vP6rBG9NtrpoN5wGJD4x2dZ3YfQMKCKk0CVxBsxq07t5YR
	 IjrebWgkGMm6Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 08/11] scsi: scsi_debug: Advance the write pointer over the data written
Date: Fri, 25 Sep 2026 09:17:35 +0200
Message-ID: <20260925071726.140915-21-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3223; i=cassel@kernel.org; h=from:subject; bh=Tj/047mZQjkVXo7cJq1r3Fg2OJALpTF6rahMgACH/to=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQj5nX4uc0c86OI1q7Tie3vckhR8K6uuhItkzZFUf v/F+NLfjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExEfh4jw6XY1zd8+N6f956c LPqszvzj2leRPBVNqVvMT1zXe9veP4WR4ZaarUFqcau1aVZQw5ZVDz4cCyhbpXpV91xOZ9/lia6 JfAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_write_dt0() and resp_write_scat() advance the write pointer of a
sequential write required zone by the transfer length of the command
without looking at what do_device_access() returned, which is -1 when
the data direction of the command does not match the operation, and a
short byte count when the data-out buffer is smaller than the transfer
length. An initiator can produce both with SG_IO.

The zone then describes more data than is on the medium, and a write at
the position where the data really ends is terminated with UNALIGNED
WRITE COMMAND, so the zone has to be reset before it can be written to
again.

Advance the write pointer over the data that was written instead. As
do_device_access() does not write a partial physical block to such a
zone, that leaves the write pointer where a write can end.

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
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2c6a9e17e4a8..f59c4f11c851 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5179,9 +5179,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(lbp))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
+	/* If ZBC zone then bump its write pointer over the data written */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
@@ -5347,9 +5347,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * writes behaviour as possible.
 		 */
 		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
-		/* If ZBC zone then bump its write pointer */
-		if (sdebug_dev_is_zoned(devip))
-			zbc_inc_wp(devip, lba, num);
+		/* If ZBC zone then bump its write pointer over the data written */
+		if (sdebug_dev_is_zoned(devip) && ret > 0)
+			zbc_inc_wp(devip, lba,
+				   ret >> ilog2(sdebug_sector_size));
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A034BB27E
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005282; cv=none; b=i+Sn5Skhlyd+PQR6ZibNEWcw+u1Wi2Nu4BuwmoFwvuuIsJ0RKOXx2/nWCk30XjyO/o/lfiVBxVz11ryGabJTOzsmb5y4dMGBAkfyKpmgL+GPbsxfSr3Iurpq0K3MeesajNYF9yRhGDKAJgy0ScZko28IYQoJMvr8DXvUKcDrgZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005282; c=relaxed/simple;
	bh=cXoCJ3y3tjq2GVJx4pCd4JhM+DnyayuifDYk5bzwadM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJecLQQTeOnNKPg7aES5A5sd0A3ezJFjIvK0AlRgnVQs694shgRoJLI7x91uzZ5sCsY+n/F13CzkPTsMQ50C/oHYRP6wPTnW9zTrfXg/EboMw+J94wQmarZEM+9bv3GN0QBBfpNP2xvR6H7cCN2LlbPz0GbhHLufbfSCyjqKwtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeM4e11C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeM4e11C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A451F00893;
	Mon, 21 Sep 2026 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005281;
	bh=M/og2Q0a2/MFPZjy2C7z74sYLCbiuEwsFC5gl9RUhaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeM4e11C0h98aUp9ZR9nmgbzo5ACAR7lQgv6Din3ZuFS7OaJrzQ2wruKUaa3MmmOJ
	 utj1GmlY+VIPSZdGcit4aVj7DskbmIsymxtWd3xg1cZFt5kwQw3mSKrGRrCJd9azb1
	 7wHd6VC5sGuOnDbAkAKdhY9TpCLD4MXMM/N90/f6G/CMk60+1RdB+D6QINm70P0IxT
	 hjcuooe3A5OBC/+tNRKM/2fM8OimzlkBIg+7NoGr8bgvRE6eye7R1rdhxLiQFnMZe8
	 R6iXI2Y61l/1OC9MhkEtrsrGR8NGL8ITWH7dsDKKTxQLbjHsBbyLuGmBAwIE6/bktj
	 Rp+ey1j/rSqvg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 08/10] scsi: scsi_debug: Advance the write pointer over the data written
Date: Mon, 21 Sep 2026 17:40:24 +0200
Message-ID: <20260921154015.2971990-20-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3738; i=cassel@kernel.org; h=from:subject; bh=cXoCJ3y3tjq2GVJx4pCd4JhM+DnyayuifDYk5bzwadM=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j/3Ft2hxjrj1K3ql4rXDR/Zn5WcfI0nVKrjcD9D6 hJF0VUHOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARjQ0M/zTe67/50vBp1VGR libJMjb/3TYmZet5lkYGzz88Leq1wXVGhqvRwn1rP7zhrpTnu6e7ePalOe/33wi5VOxbsk4hbHH 0ay4A
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

Changes since v4: the two divisions are bit shifts now, as suggested.
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cf5037e81952..d07f6f891951 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5183,9 +5183,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
 
@@ -5349,9 +5349,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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


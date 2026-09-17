Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D474F649E
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649753; cv=none; b=Nm2B725pnv40hN0DN/Keoak3mkTtUIFTFrD4ojkJSHvrd4vNvmERqMJ4etZ5/eulcF0k50pOk8Yk2pgAtozeZolTQ8BFFMPyyMj8Ha42CKKyPGP3uDqOlIbLif2uCq0v97lgQKua0ol38h8/zW5mF2qLHRzGKmQx4tf+Aia58V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649753; c=relaxed/simple;
	bh=ut/4pCigDMzBiDiWCBvLd0nB6Z5Hb3XlvSZ7vaX/T1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRJRzwUk8DrQFV7CiTDCNvUmmQJyo5lg9DJ5oWge3jAAS7AU9/98o/ADSd4JeTkBdSkKA9My81ojdZLZJ/fKVd0hyweE0qwb4tr4fG98fum6yKZBn6rLpvVOyuQ8971HvHFqS6mzNMnsWAI40UTmW22XDaXsmefq/iat3qo8yz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqJj0yFc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqJj0yFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917C31F0089A;
	Thu, 17 Sep 2026 12:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649749;
	bh=UVNPLnprsM7l0lF1QpAv1hQxxzqAhFACyHJTnBW0jzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqJj0yFcN1kLPz+13GTijQTTKG6CNi3IE8pUzsJfefsKa1QQJKqbmksPHBMa+BHfW
	 l2/Lic7MLoz9Ng817XnzITNGkosAK0srHnjHdBjA8D0mEO7VPNv6jcq3eXfpPpJcpl
	 6QxMHb6bTY6IU04O6AFJJSA156dYUX504aVXSMRJ42npKNDOeJNz441r0WaSx+skid
	 Ns/HsojGY0q7fx5ddT8IEehPtX3WhzFfxDWROYGrJa6TxTF8GXsbKGE9S1seB+52C4
	 LOD+tj2fp2A0Jhugn3+egPryzR6SNuRSKtXlospfn5OCen438jJjhmB0HhPh7A2F/K
	 ISZvEksDu9J+A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 3/6] scsi: scsi_debug: Advance the write pointer over the data written
Date: Thu, 17 Sep 2026 14:54:49 +0200
Message-ID: <20260917125445.1376493-11-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2755; i=cassel@kernel.org; h=from:subject; bh=ut/4pCigDMzBiDiWCBvLd0nB6Z5Hb3XlvSZ7vaX/T1c=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWP5a6vm7x+w1Pjy5l8NqgNN+dp8jrbQRrgoRGnBXPx Y8KL2POdpSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiT5kZGf6ffHH6oYDinsMs dcyfa5x8BM7sCM/b8dDWIilb+F2PrivDP+PfD7YItDPI3Pw0s9Pi7Zt3Z3I2P5khFaZzs3f/xJ7 kdQwA
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
do_device_access() does not write a partial physical block, what it
reports is a whole number of physical blocks, so the write pointer is
left on a physical block boundary, which is where a write can end.

resp_write_same() does not need the same treatment, as it writes with
memmove() and cannot fail part way through.

Assisted-by: LLM
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8ed7d5cd0ae0..41c8d958f445 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5163,9 +5163,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
+	/* If ZBC zone then bump its write pointer over the data written */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret / sdebug_sector_size);
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
@@ -5329,9 +5329,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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


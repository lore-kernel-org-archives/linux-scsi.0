Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D853387590
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248901; cv=none; b=GB0yze3YfrAl7WwIvTZ2y/c8zLQTdJwCtweYV67+mVK3ZHZj5qxqKjwOt9Ilw220XjvNQfSQs9VCupL0BfIf1RlHwrDt7y38FPKH79J4rnwB3LQ6a4am5F8ChcGFeylgc18cyGDxfUqd3sriJLRypt+sNqdefZdej+4xZJ0S8HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248901; c=relaxed/simple;
	bh=reK2AlJwCxLkvphede22VBn/3V63hAP7ZJhNZuRmZXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o73xQUArZsKQVAGm1hlsT93qqOXVajuWVvoPAgqtAclfjqs4Xcgt1wjX237BxW2tvFh+OytnTcUvigjWo23/ucXnSn94+fEo1rGS9DsFZP+Yq/WP0hfmYoJ+uNdVlXs/gfUr+2MV1p0MMtzu3w0ko//F+maKe8s6Sy4R4kAP0xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwACpyrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwACpyrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6E01F000FF;
	Thu, 24 Sep 2026 11:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248900;
	bh=Yf/i+r7smpzxCJ8klGVRyL8HfGgiq0RjRVzFbCvwF90=;
	h=From:To:Cc:Subject:Date;
	b=jwACpyrGrv30fgcJZn5eD04AyImgLRCuk2DbWZz+qeL2Rlw4sRfSlIWcoVmen5MMM
	 PuWoSGHul2QmQphSKPSDlHWzV3fTnvRjXyIrBm0Tx91LkcA9fhaRLGKKI6Z42uWOyO
	 RcczKqYC5LUX3itKoSgtzaS52vJuD44jIGAdW8uUuJuymvF01I3xe3ftf9fJYPn+HP
	 0E5tYGB1g8ItycjP1NJmgsPfuvjaMPsKhXGeq+zFicTlkKPPGBJJcolJ+pr/EdwI2H
	 wk3Zc2oL1J57GMIhyP9PUb6jxYGoA58ihAWnRemqbl+Vt8TvOe9AY8CpwJ+0nI+o7j
	 NOVfg8ucTkFoA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 00/11] scsi: scsi_debug: fix zoned write validation
Date: Thu, 24 Sep 2026 13:21:28 +0200
Message-ID: <20260924112127.3815255-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2818; i=cassel@kernel.org; h=from:subject; bh=reK2AlJwCxLkvphede22VBn/3V63hAP7ZJhNZuRmZXg=; b=kA0DAAoWyWQxo5nGTXIByyZiAGq1B7egLn+Ed/TORQWlA/+sL7bI0EfmOB2HKuo9U8T6dHpEr Ih1BAAWCgAdFiEETfhEv3OLR5THIdw8yWQxo5nGTXIFAmq1B7cACgkQyWQxo5nGTXKRmAD+LtLm r4IRKZEXcHMc74CJGD2S0V+F3cZteReQH926oLkA/jmvqfcPCK+L7XigTvZtgOmm0Fm9fncDsh1 d0a5ZTUgL
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

This series fixes scsi_debug with regards to writes to a ZBC drive, and
to WRITE ATOMIC (16). Each patch describes the problem that it fixes.

Two configurations are refused rather than emulated, and those two
patches come first, as the rest of the series relies on what they
exclude: a zoned device whose lowest aligned LBA is not zero, which no
host writing in units of the reported zone write granularity could ever
write, and atomic writes on a zoned device, which no drive supports.

Little of this is reachable in a default configuration. Most of it needs
physblk_exp, atomic_wr or logical block provisioning to be set, or an
initiator that does not provide a data buffer matching the transfer
length of the command.

The series is based on 7.4/scsi-staging rather than 7.3/scsi-fixes (as
Damien suggested on v1) to avoid a build failure that would have
happened if this series was simply merged with linux-next:

  error: too many arguments to function 'mk_sense_buffer'

Tested on a zoned scsi_debug device with 512 byte logical blocks and a
4096 byte physical block, and on a device that is not zoned for the
WRITE ATOMIC (16) patches. The notes below each patch describe what was
observed before and after it.

Changes since v5:
- Patch 4 joins three conditions that now fit on one line, as John and
  Johannes suggested.
- Patch 9 is new. A short WRITE ATOMIC (16) failed, but only after
  writing the blocks that its buffer held, while SBC-6 4.28 requires an
  atomic write to write either all of its data or none of it.
- Patch 10 folds the duplicated if (lbp) blocks into one, as John suggested.
  It still maps the region whatever the outcome, like resp_write_dt0(),
  as SBC-6 4.7.4.6.2 allows an LBA to be mapped at any time.
- Picked up John's Reviewed-by on patch 4.

Niklas Cassel (11):
  scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned
    LBA
  scsi: scsi_debug: Make atomic writes and ZBC emulation mutually
    exclusive
  scsi: scsi_debug: Take the zone metadata lock before the data lock
  scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
  scsi: scsi_debug: Report the residual of a write
  scsi: scsi_debug: Enforce physical block alignment of zoned writes
  scsi: scsi_debug: Do not write a partial physical block to a zoned
    device
  scsi: scsi_debug: Advance the write pointer over the data written
  scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 109 +++++++++++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 20 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.55.0


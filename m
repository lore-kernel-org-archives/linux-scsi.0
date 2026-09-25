Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A951DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320667; cv=none; b=dQVgAQL9DsLMqXxNIsz4mZCEA8bvyfy4a/v1frnx1l3s0zvL5tRE3CQTifCZHet2wlZIhk/OynHRZV85wk0o5VotL9wEBqEjHsTuAe4KFfBhatJGm2Vg443gH1/zYCJsOoUQu05pYipBy1cwKVPK9Uun/GPFStBpOcYhDzGeeE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320667; c=relaxed/simple;
	bh=6q8y0upTJXwcwbt2cN/zt123p+Cyic6dr/Ch4MoN7Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqDm7ag+MvqaXFnLM+iYBkYd75CTpAGXZ/FDKzYTRydAB9qXPVgxWRa1MDzmHgJVQJd9cPm1aNg7uAo+6ciED6zy+yrOpb1munnq8mMBL3MDlgyli6bKj/O4cnqVhBGDAd3UlIqxL3uSxHqpKEColYBrYjsD+bf5YQO8MWnGqHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOaofqYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOaofqYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049431F000FF;
	Fri, 25 Sep 2026 07:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320665;
	bh=0LozgI3Vh0smC3EtFoTSmpICdOttB0/IYFY4Ka19ppE=;
	h=From:To:Cc:Subject:Date;
	b=GOaofqYwhftx2R5ZrPwpn3iA3NNP/Nt7sJ7zKXbekKB+dffSXd/TZsxSIzotG5582
	 fSnw2oFtdnEsicSQD6jiwmHvauxefxQdm5mphDD3MxxFL3r9oIsnH57r8dWmkXx/68
	 SGor5jFCpgqzzBswhPF/pg9mp8YRmzrrfqnM6FOlhj8a3/H8q5JKeCGVYun5miMr95
	 RJeLGIlhCUokTKJaahahfyS3zQOK47lfAFa4vy9bh4UIv+Cyx6J4pX0l9ide46ceAc
	 8/pn0XUoYG40E5a02LatuJFErMYG3QFTtS5cvR3GudIpe2xOMr4hMv0MBAnyxegz8z
	 606CrytBDzM0Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 00/11] scsi: scsi_debug: fix zoned write validation
Date: Fri, 25 Sep 2026 09:17:27 +0200
Message-ID: <20260925071726.140915-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2631; i=cassel@kernel.org; h=from:subject; bh=6q8y0upTJXwcwbt2cN/zt123p+Cyic6dr/Ch4MoN7Kk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KbDdUAj8r+cgtNvy8VHFB/HmLX0tGwONVq14dO/+7 Xm7qx9v7ChlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBE3Bcy/LM4/S+w7lGLpk3g o7ueKU+F+/oWP7/XeOjvkrtrP1y+9Hk5w1/pNyndwWXWljnTzqqkn2wOK+2YFVe5Y/22NX/c7ng I7WcEAA==
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

Changes since v6:
- Patch 5 now also reports the residual when WRITE SCATTERED (16) transfers
  nothing, because it has no LBA range descriptors or a buffer transfer
  length of zero, and when an injected error ends it after a range has
  been written, as Sashiko pointed out.
- Patch 9 rewords the comment above the new check, as suggested by Damien.
  Picked up his Reviewed-by.

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

 drivers/scsi/scsi_debug.c | 116 +++++++++++++++++++++++++++++++-------
 1 file changed, 95 insertions(+), 21 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.55.0


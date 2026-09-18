Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A9E48593D
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712972; cv=none; b=Hd+4foW6t/hACPu9Dgum0XB3b+b70mS8l0H1JKIfP/HJhPZHkQmqEcBLTuPAw37Ppzvsuv7I70QfXekOpxNZIkKHaTq7RKAGEiOFUauISk2BvpPo5omH4uxmn11Nq4cggMniKtXoheD7leHTYvqPgZ0CTAOwYL0UhT4XNaj1Ls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712972; c=relaxed/simple;
	bh=a9v5JOpifZwtRkG9EcY6qCnwfJaLULTRnxg1Obtl09Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CX28HQ9tuvSR53JqS0GMcCyrNZinSxQP5L3w7BL9R8Z3im8l6qv0KKKU0VAsnKjpcKNhYjJVhwd/eC3IFdyQRcWsSsQFpPiEJSv8tQPfdjeKznc6asUnIFYcUXdW6eEptUbNkKN91zsVCTHU1NjaSDPwzOepfuXl9waw+W231zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mW+myBrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mW+myBrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B181F00893;
	Fri, 18 Sep 2026 06:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712970;
	bh=UScsUwuxQkxwzm8ekfY7CCx+EjC042qwsKhzV7zOrGs=;
	h=From:To:Cc:Subject:Date;
	b=mW+myBrvSg9bPhjXEmbb1iJkWe1hCAnz8H8Ubewxhb4maEOQrMj8a8iVa2wA1NbIM
	 priw5bGBjayQ5EEgcVIltDXk+fVM54XwrOpx/mM0hC9bAIFDWHE6S6HxSr0o2Bw3BD
	 Clc7rcfZnMQyYAZNnPuAtGviLZnEu+vezrKJfsX4N4BePmEuKgQedHWR8DZ1wqm5Ay
	 pGD+P/4yah01fLfTt3zoCCk2RALYSSq0lzTQrtdlMjLmgNP5fVXr8MaDsXe53R7uWt
	 x9694a99oVPX3p07ai10aZ8WZSloJ1egcBA/ebF7DOxvwqCavzbBXnCZYtATc+4YUC
	 1I9J/9/zXxDSA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 00/10] scsi: scsi_debug: fix zoned write validation
Date: Fri, 18 Sep 2026 08:29:11 +0200
Message-ID: <20260918062910.1709791-12-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3090; i=cassel@kernel.org; h=from:subject; bh=a9v5JOpifZwtRkG9EcY6qCnwfJaLULTRnxg1Obtl09Q=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3DL7tdHOy5I9UaWaeZ6b6hvjSM29h0O3likmrFEwS bwU0sjXUcrCIMbFICumyOL7w2V/cbf7lOOKd2xg5rAygQxh4OIUgInIqDP8T/+ZnujWEmsy89jz aM8NXZ/PL+P+qcWisc/0SDT/4W3uLxgZTvMs26kR9FWp8fm7r+pG+zPcJr8Ue/rpS+J6Q5mV0Vp 1/AA=
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

Changes since v3:
- Patch 1 is new, so that the physical block boundary which patch 6
  checks is the one that the device reports.
- Patch 2 is new and replaces v3 patch 6, which taught WRITE ATOMIC (16)
  about zones instead of refusing the combination.
- Patches 3 and 4 are new. They are the two problems that the review of
  v3 patch 5 found, both of which are older than this series.
- Patch 5 guards against sg_off exceeding the length of the buffer in
  resp_write_scat(), which would have reported a residual of nearly 4G.
- Patch 7 applies only to sequential write required zones now, as
  physical block unaligned writes are fine everywhere else.
- Patch 10 is new. It keeps the part of v3 patch 6 that has nothing to
  do with zones, without which WRITE ATOMIC (16) would go back to
  writing past the end of the device and ignoring wp.
- Picked up Damien's Reviewed-by on patches 5, 8 and 9.

Niklas Cassel (10):
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
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 103 ++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 16 deletions(-)


base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E72F1A239A
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634784; cv=none; b=cB+Hr0O85jTXBqzywJIi6E+3eywiz3vxesbxxBHBp8jOoxCRYdSj/4lvCvL0H5jvBm6Pu6pRjHKNSkQdqVDUT9E0ZHjQN6dJQoJ8nW5e80yqkMizzqX21R1kV6ls/fQIBz2A80mZJCzJQ+lKPFZSr1PoemKiP8C1whwWWvYBhaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634784; c=relaxed/simple;
	bh=i+0L9C5f5Xl1h6C8xoDfE26DWfOxO+L2T3o0FAxoU9k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YP6P4lKxexSYLJ8PIHFmJ/rA758xFwQpYj7CE2WDCdOdM0tbidmkLmrKa5UGghDUqzxhXWi+oZWfRS2pI+ET68Ja4UbOx4TEH+sLUHiH4LK0M7JNSl/ODN8jcL7mLEYtmhiTrEE96QwUU35SmgZfl1OKQfk/Czt4v4PZSml1pPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSQly2KG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSQly2KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3D61F000FF;
	Thu, 17 Sep 2026 08:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789634759;
	bh=FKQf3vRuqV5ixVNhI7e81Ebj7K3eRg2+1AxEvutmadk=;
	h=From:To:Cc:Subject:Date;
	b=bSQly2KGajBIK1i1plSdftDqFIxNUvys6Is7i68OKuz/fL7eu1hsTqTn28NrB2916
	 qyLe7NZwlst36osaLAIcYWQp1nzjL3ZvbjMdR9rTfrSE96/5sWuWGtFElnXIwNXhpv
	 vyYwlHa52pF+uuIx4KULgtoSf+XWfP321opoGTEKtpIZVpvnx6CDEx3yyFw6jsYKst
	 VbylQUoNh5JQfz6zCi8ZkZWp24+cl2NG16+egGgz43QOSR7yqA3m+k4mbAiipPFmre
	 FRuCup/7i2hnKie2OWx69ydHPD7/qr0Yyk/3s8ogRz3Uv25762dsDpGeWyev4XUEPl
	 t8VjAFCblZMTQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 0/2] scsi: scsi_debug: fix zoned write validation
Date: Thu, 17 Sep 2026 10:45:54 +0200
Message-ID: <20260917084553.559765-4-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2648; i=cassel@kernel.org; h=from:subject; bh=i+0L9C5f5Xl1h6C8xoDfE26DWfOxO+L2T3o0FAxoU9k=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWrzjoHvW3Ulu/jUXMnulzvlHsx1fTErSiVX0OLqtWj jAXzy3uKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwEQcLjD8M37549VBz13BzqaN K05NM0xxEzjfPbGOobSlbtfOjENPljIydHpPVF9t9MdQ0F8tK4n5GZvt1xyLW0/lvrOmf9sb557 JCAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_debug does not enforce all of the requirements that ZBC places on a
write to a sequential write required zone, and one command bypasses the
zone checks altogether. Both let the emulation accept a write that a
conforming device would terminate, and leave the zone in a state that
the kernel cannot work with.

Patch 1 adds the missing check that the ending LBA of a write falls on a
physical block boundary. Without it, a single logical block write at the
write pointer of a sequential zone is accepted on a device whose
physical block size is larger, and leaves a write pointer that is not a
multiple of the zone_write_granularity reported for the device. Nothing
can then write at that position at the granularity the kernel
advertises, and the zone can only be used again after being reset.

Patch 2 makes WRITE ATOMIC (16) go through the same zone validation as
every other write. resp_atomic_write() calls do_device_access()
directly, so an atomic write is accepted anywhere in a sequential zone
regardless of the write pointer, and the write pointer is never
advanced, which leaves REPORT ZONES describing something other than what
is on the medium.

The two are independent, but the order matters slightly: once patch 2
routes atomic writes through check_zbc_access_params(), the check added
by patch 1 applies to them as well.

Neither defect is reachable in a default configuration. Patch 1's check
is a no-op with the default physblk_exp=0, where the physical block size
equals the logical block size, and patch 2's path needs atomic_wr=1,
which defaults to off. That is presumably why both have gone unnoticed.

Tested on a zoned scsi_debug device with 512 byte logical blocks and a
4096 byte physical block:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2 atomic_wr=1

Before the series, a one block WRITE(16) at a sequential zone's write
pointer completes with GOOD status and leaves the write pointer at LBA
0x18001, and a WRITE ATOMIC (16) is accepted both at and past the write
pointer without advancing it. After it, all three are terminated with
ILLEGAL REQUEST / UNALIGNED WRITE COMMAND, while an aligned eight block
WRITE ATOMIC (16) at the write pointer advances the write pointer by
eight blocks. Writes to conventional zones are unaffected.

Niklas Cassel (2):
  scsi: scsi_debug: Enforce physical block alignment of zoned writes
  scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

-- 
2.55.0


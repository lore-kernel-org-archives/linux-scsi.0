Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0E412BF7;
	Wed, 16 Sep 2026 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567130; cv=none; b=D/ITmpVZ2Wmr4nVKRyMT+boduW0jmD4m6cfsFztGXwWuBDzTcIXkmUPPFtPS6rjjykPJApNu77JUD2Qv415/5qple5+3rJs8UzoG7DhhXRigszOwDr5P7FaM/L2qsBHsEzzSnjZveiMbAU6ezYJ+WRCnTdJ1/UV0VpwUkBu687U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567130; c=relaxed/simple;
	bh=bacHj4Ljo5wgx3jxLc89lUriRG718sEaPoBZQFfff5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OqcTPHQiKVS78ZjGenJ5FSx9ffYJUivldMFLo8HoDSrA8C/uyNI1HU/A3Q8Cqi17EIzDSipwPGYKIXkln5jyuYvYpeVoPovsJol9y/2ily/HYwZWtkSx2ToWY1RnKU6lkmntqvLGHel8jZJ+EM3jJFdNin9Nh2ki+MTsZHX5Adc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fxti.xyz; spf=none smtp.mailfrom=fxti.xyz; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fxti.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fxti.xyz
X-QQ-mid: esmtpsz11t1789567104t1c27ab10
X-QQ-Originating-IP: IB8q4vqnv5ztokBlKQ3nJpa3QSNMUH/iEMpuHTM4yaA=
Received: from fxti.xyz ( [14.153.126.83])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 16 Sep 2026 21:58:22 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 14368425603253614372
From: ZHOU Jiaxiang <me@fxti.xyz>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 0/2] block/scsi: fix zones_cond out-of-bounds write on zone report
Date: Wed, 16 Sep 2026 21:58:20 +0800
Message-ID: <35F6EBCB456F395A+20260916135822.32584-1-me@fxti.xyz>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:fxti.xyz:qybglogicsvrgz:qybglogicsvrgz3a-1
X-QQ-XMAILINFO: MYNcaOm1VPp0avTYiEIqOe32V4pochVpQDGB9dkasgur6gT+0AGe9j7I
	rwSk5H7kNRfBsTGBDzAS9xsyttu6LBZMr2yR+QpcjCQXZglPnpo2pTEcj1PcGmUqNRjdzE6
	uuMLLjRkJNcWmuHfhTkf7TrhZuQ3JFoRf8Qf712bn+GEEkVHWj/fW1mg2nWg0MdroyMZfWi
	NblAQqMsp5WNMWrgCJs2wbJev0Hx7idnD7t6lOYJHyL7BQwepguBizIxeU0LBZ6Bp8H6nUi
	fhXDqKF5+pbdWvZKZY7HOg4JKVDLnCHF7PeiQwRL5H7oWe1mxnz8Y8AqZLSS9Ch1hpST++N
	0eOrhSC+dbvvAs52HzyKHKacaflvWQdbm+2QFS+pbzNKym0pyesJ/aQHA9VYMsRqIkDljsz
	br938c+U7mvc3ZPFHFvtZe/Kt/UZ2uqi7EJ98lexdsmHoJYkALId0yGm/Zb42ZLizMZx+02
	Ay+H0/zNh1IvzifshFzwkiycMGNKaDpdsIQSAeLZd1a8ar/b6nFRgN5wdI/wooAbyBXwghh
	KlupAWKjcRHyMCSAPKT5eDMDfcuP05ELcZNqsURu4WJl2ZlkVbkPhxF+3dcVOec0z9Uksx2
	NU+tFcpicwImuB4s0m2lDQrtgq9BubKSN63+SahrawPGgVfxpEO2BNdoUo1OSIopRIvA0lF
	LFiEz4zCDPLyvVwWkHouGIT1myvMCwJLTaK9z9nUBRQ6kFTmBEXLYyuJDY+Ikn6yXVczGHf
	U7q303bKiJalH0wLMHIw0sqFSXJarIY7x+oaijnOWm5G8JR2eLtz7+hXF9uQClu69k/irPX
	o+iYp4EKgcZZ06bLlK4QnOMtarcUaiJSmZBjyfaUUWrgiLI5AIhHf185G99sWm1sDgOutOu
	NSj5q0qQ/f3wMR1Y7HbAeMihPk7+6wHEH0+oDD4PHCaVz7KlWs2wSgpjC09Akwl0q3BGiaO
	c0MxHEo479DlO3XlU9QnSUESEgPOamc/sFKnTMqz71wygW4SzKVnkwwHsgX0L9aUKzCY3H8
	lxKgfe9qYARVyxfp/0WKuAiAPzPPm50mR7GXIb9mKvz5eHUSZXj0rKXNJlWeP5iMILx9dK9
	Q==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

blk_revalidate_disk_zones() sizes the zones_cond array from the disk
capacity and zone size, but the per-zone index used by
blk_revalidate_zone_cond() comes from the device-driven report_zones()
walk and is never checked against the array size. A device that reports
more zones than the array holds makes blk_zone_set_cond() write out of
bounds, one byte per extra zone.

A concrete way to reach it is a zone count that does not fit 32 bits:
both struct blk_revalidate_zone_args.nr_zones and struct
zoned_disk_info.nr_zones are unsigned int, so a disk advertising
2^32 + 1024 zones of one 512-byte logical block gets its count
truncated to 1024; the array is allocated for 1024 zones while the
report walk proceeds past index 1024.

This is structurally analogous to CVE-2025-40345 (a device-reported
value exceeding a capacity-derived table corrupts kernel heap) and,
like CVE-2024-47682, it is fed by target-supplied data in the sd
revalidation path. As in that report, note that sd also sits on network
transports (iSCSI/SRP/FCoE), so the malformed geometry can arrive from a
remote target, not only from a physically attached device.

Verified on commit 50d05c7c76c9 ("Merge tag 'landlock-7.3-rc3'
of git://git.kernel.org/pub/scm/linux/kernel/git/mic/linux"), which
is v7.3-rc2, using KASAN builds on x86_64 and arm64:

  BUG: KASAN: slab-out-of-bounds in blk_revalidate_zone_cb
  Write of size 1 ... 0 bytes to the right of allocated 1024-byte region
  sd_probe -> sd_revalidate_disk -> sd_zbc_revalidate_zones
    -> blk_revalidate_disk_zones -> sd_zbc_report_zones
    -> blk_revalidate_zone_cb

I have a working reproducer (dummy_hcd + raw-gadget ZBC device and a
minimal initramfs) as well as a full privilege-escalation demonstration
built on the primitive. As this report is the product of AI-assisted
analysis I am treating it as public per
Documentation/process/security-bugs.rst; both are available privately on
request.

Patch 1/2 fixes the write site and the block-layer truncation, which
covers every blk_revalidate_disk_zones() caller (sd, nvme, virtio-blk,
dm, null_blk, ublk, zloop). Patch 2/2 makes the SCSI path reject such
devices cleanly at scan time, before the truncated count reaches the
block layer.

Before the series the reproducer triggers the KASAN report above and the
escalation demonstration reaches a root shell from uid 1000. After the
series the device is rejected ("Too many zones"), there is no KASAN
report, and the demonstration no longer progresses. Each layer was also
verified independently (block-layer guard alone, and the write-site
check alone).

Changes in v4:
- patch 2/2: use INT_MAX instead of UINT_MAX, because
  sd_zbc_report_zones() counts zones with a signed int zone_idx that
  would overflow past INT_MAX (Martin). No functional change for the
  demonstrated vector.
- resent via a clean channel; the earlier versions had their whitespace
  mangled by the sender's mail gateway and did not apply.

Changes in v3:
- patch 2/2: add the Fixes tag requested by Damien and his Reviewed-by.

Changes in v2:
- patch 2/2: keep the single nr_zones variable, now u64, instead of
  adding a separate nr_zones64 temporary, as suggested by Damien.
  No functional change.
- patch 1/2: unchanged; carried Damien's Reviewed-by.

ZHOU Jiaxiang (2):
  block: fix zones_cond out-of-bounds write on zone report
  scsi: sd_zbc: reject disks with too many zones

 block/blk-zoned.c     | 15 +++++++++++++--
 drivers/scsi/sd_zbc.c |  8 +++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

-- 
2.50.1 (Apple Git-155)


Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2737F3B2FD6
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359317; cv=none; b=keH01lJSRZ7q043hg8nX6DjVIpa0XQjyOk52I5X2NqiwfBSogogwfMc8OcMqT/14pDKaZbTjAF4IiBtqy6wKTiYQUaI4K5JB+xyfZek5o+cjY03bC+SkHaw5MBrneGP/9gXASD9meIyKA0sp6rT973vy4ICo1lUBSo0NIzp8W60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359317; c=relaxed/simple;
	bh=+HRh2MEGbkZEMFG8TjholYuDQ56tX2UP6q0DM4a6fXo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CHBF0bnutJnmM7h90PNxU8V60lPOKrpYWed52lRfYGlli1307uzfIgExot1fdo2ZYAQb0VSmvFMOXKTJwpJ9ogL90Tkfrj+3DKEXr2L7q7I3Vxd6XHPIzV447wgZ8hqJGkpwwBBf8Y6JkDVsqMOyTptNRSUsq8DS1+Woj5iF8TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=qfOV13lM; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="qfOV13lM"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 666GjYEa2082342
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2026 10:35:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=1H2HP6RKvs4g8z8IZw
	wsEAnQdOLbNcQwOGCHefDA7/8=; b=qfOV13lMLanSGeV9QPsglcvo0kqiWu+J7m
	HcHEH2tVp7DdlpfyAER8un4H15LVZ/6kAlwcUmptLgIUuIs2xn5B15ApLjZLx9bo
	8Yn8eYmcn/hHa1M9fOb8FaKXydzsePlCe+Fo7FrI0kdgwvahMB228mRI5lHv5uCY
	if/O9S1cFN3Rct3u+RX66dAP4Q1UcnlIaiJt0lw+XgkunvGq2v76BByTDW+AZzs0
	FZCGfxHK5xYn6M/njRGDk8ExyKjBVyimKC7wZlJZ1LpMOlvJAcqD8c3k0YmK98PH
	Ph5/RlIn41+SF58HjjNFoQrWQit4cSnE+unJ0/5QF3F38rUrANnw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4f6wuac7ex-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 10:35:15 -0700 (PDT)
Received: from twshared5491.04.frc1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 6 Jul 2026 17:35:12 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id CE038249DC6D1; Mon,  6 Jul 2026 10:34:54 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <bvanassche@acm.org>, <sumit.saxena@broadcom.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RFC PATCH 0/6] sbitmap enforced fairness for blk-mq
Date: Mon, 6 Jul 2026 10:34:32 -0700
Message-ID: <20260706173438.3537347-1-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX4U34vRzlZNe0
 fFppsHs3MWPg4P8YiTZiJcG5dpEdv77Z/5+U3iguIKUP/RJoyr7iQqxTRy3o7txuxjNognwkIr8
 DupPX4qKV3Pf/rcSrAPuJI28Lm75Thc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX8BLa4UNy0hRy
 WraFCdBMqvVeU7BNsQgcwahr6dKrtQaxJDGHSHphh6SpI3X/HqFeEzPJ9QNkiAHN9CExpR0MRRb
 FNgit0Qp9rVZriKNXIFfnUTC53VDJFYJk2LO7yh5+PNJhy00vEJG+DR3YOy29/Ic01ff75RjGvb
 lxxo6aL60IwmLLuog/hy7eqhDHd+mqvbhM12y9fCVTd2DtD8ygFa0EhM7y6EOXxTCxX4UbpnEPG
 C+61stDdVHJ5lwvBhw71eRZf+Q2KLvo/8X7PAeksMkOIWtjdKK2BGPxoWU9UBhJ+pvkFQtLhC/F
 LDL8M2e6xS+ae1pJvrcq+RCBh7HqQ/n+1AEk1ZLSIuNLhnPRYrKANM3YOL98hUxsbxlusW/tXC4
 KD+OGupbipqVgyTmV/xoz6iAUINSoC7ksek+i0xzaz2RfuDBOAb4pV8GoDuGQA0NqVygiwqOwOh
 yzku+DWscywQP8UvMxg==
X-Proofpoint-GUID: AU0nu2Qkzc1MhSFJzez45Ti8rlUbKxGM
X-Proofpoint-ORIG-GUID: AU0nu2Qkzc1MhSFJzez45Ti8rlUbKxGM
X-Authority-Analysis: v=2.4 cv=AsDeGu9P c=1 sm=1 tr=0 ts=6a4be753 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8 a=Q-fNiiVtAAAA:8
 a=tc82prY50tpmNED4I0kA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

There have been a few proposals to remove the blk-mq tag fairness
algorithm:

 https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@=
acm.org/
 https://lore.kernel.org/linux-block/20260609121806.2121755-1-sumit.saxen=
a@broadcom.com/

Both abandon blk-mq's attempt to enforce tag allocation limits on the
per-queue/per-hctx users that share tag space. This can harm resource
allocation for lesser devices sharing the space, potentially starving,
them from fair progress by a highly utilized device.

This series proposes an entirely different fairness mechanism that
doesn't require per-IO atomic accounting:

  First, the sbitmap API is augmented with a ranged allocator. This
  allows a client to carve the depth into exclusive ranges for specific
  users.
 =20
  Second, you can optionally declare a percentage of that pool to be
  fair game for anyone to allocate from. This provides a way to
  guarantee minimum tag space for each client while allowing a user to
  over-allocate its fair budget on demand into the shared zone.

For testing, I used scsi_debug for the TAG_HCTX_SHARED case and a nvme
multi-namespace device for TAG_QUEUE_SHARED. Workloads emphasized greedy
vs. passive jobs. No performance regressions were observed.

There's a couple difficult things to deal with here:

  After a completion releases a tag, there isn't an easy way to wake up
  specific waiters for a range with that tag. This series handles that
  by introducing a bounded wakeup relay: a waiter that was woken but
  couldn't use the freed bit (it fell outside its allowed window)
  forwards the wakeup to another waiter. The relay is bounded by a
  credit budget refilled only by genuine completions, so it cannot cycle
  indefinitely. I think this overhead is acceptable as we're already in
  the slower path after exhausting the tag space.
 =20
  The degenerate case when the number of users sharing the tag space
  exceeds the number of tags is not specially handled. If that happens,
  those users compete for the full tag space without fairness. The
  existing implementation lets each user get any 4 tags in this
  scenario, which is arbitrary. Duplicating that behavior would require
  re-introducing atomic counting, which this series aims to remove.

The 5th patch is a performance optimization to avoid recalculating the
windows on every I/O (division + bitmap_weight). It computes the window
only when the active set changes and caches it per queue/hctx, packed
into a single u64 for a lockless fast-path read. It removes much of the
infrastructure introduced in patches 1-3, but the series is presented as
a 1:1 replacement first, then the optimization for easier review.

I am aware there are race windows with the purposefully lockless updates,
but those are temporary and harmless. Windows are recomputed on every
busy/idle transition and settle once the active set stabilizes. A torn
u64 read on 32-bit is possible but results in a temporarily mis-sized
window that self-corrects as tags get recycled.

The last patch enables scsi_debug to test the new fairness framework for
various shared vs. private splits, and exposes `shared_pct` for
host_tagset drivers where sharing may be harmful to performance. I
understand based on the previous proposals there is use for such
mechanisms for UFS.

Keith Busch (6):
  lib/sbitmap: add ranged allocation, bounded wakeup relay, and ranged
    weight
  blk-mq: replace shared-tag fairness counter with allocation windows
  blk-mq: factor out a per-hctx tag busy iterator
  blk-mq: add a shared zone to tag fairness
  blk-mq: cache shared-tag fairness windows
  scsi: add shared-tag fairness to host_tagset drivers

 block/blk-core.c          |   2 +-
 block/blk-mq-debugfs.c    |   2 +-
 block/blk-mq-tag.c        | 179 ++++++++++++++++++++++++++++++----
 block/blk-mq.c            |  24 ++---
 block/blk-mq.h            | 102 +------------------
 drivers/scsi/scsi_debug.c |   8 +-
 drivers/scsi/scsi_lib.c   |   4 +-
 include/linux/blk-mq.h    |  12 ++-
 include/linux/blkdev.h    |  19 +++-
 include/linux/sbitmap.h   |  53 ++++++++++
 include/scsi/scsi_host.h  |   8 ++
 lib/sbitmap.c             | 200 ++++++++++++++++++++++++++++++++++++++
 12 files changed, 470 insertions(+), 143 deletions(-)

--=20
2.52.0


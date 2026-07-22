Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5572AD3C;
	Wed, 22 Jul 2026 11:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784718064; cv=none; b=KaPx34KKTchNEdsBaDT7syaNIpdXnbL9yQooRuTIQMM3fs5Ly9aqWyX3TFRiXEf510caX15pARa/7rLerkj8Q9UgdHLebXVre+HTm/xRL2UKXWLL8dVVT/jbOhFTuT6yuoINoOm0Wb2b+fNOv4UeKjF6St/fFH5qC0obPVnVeQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784718064; c=relaxed/simple;
	bh=J4//k8F4CKWCeCkVZTCfcqspAs0oy2D95UO839DycsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I0yarx79WlMNsE35ANSTiLdCjsaXHtO076mHHI2aCj/Hg2fqcNh/i0+BWTjXp/R86NsqFcxFHYx9KE6RzJGoUqtg7wovb3iKH+8dR8Fc+sk+jciYRLqi/lPRq3Y7Ylyw9+NnI3hZZZJWia/goE4KRn69X0ZW4a5Q3qY7Lfo/0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lM60eQgA; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lM60eQgA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=XnmlT92hOs66o6RQdjF+BmjHjTM+urZmrZEBSz9w3VU=;
	b=lM60eQgA9OzLcosbGfoVOBNJjLLdcO/CNP4fEp8BCqfmOIVKgVScs/UOduHNkv
	aKdFzDH2nC5IkEgI4xP5EDMw3eb0mvBWKfDeO1ONqI4sdSN5Qdz11DVVKezKzmm1
	WsJOXi9fMC0kX0X7/aGULSL3Z04YgWtnK3HExJ9z+ZuDk=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCntOrNomBqcjHiIQ--.3460S2;
	Wed, 22 Jul 2026 19:00:30 +0800 (CST)
From: "rom.wang" <r4o5m6e8o@163.com>
To: mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com
Cc: virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	kvm@vger.kernel.org,
	Yufeng Wang <wangyufeng@kylinos.cn>
Subject: Re: [RFC PATCH 0/4] virtio: SQ/CQ doorbell polling for vhost-scsi
Date: Wed, 22 Jul 2026 19:00:29 +0800
Message-Id: <20260722110029.88909-1-r4o5m6e8o@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAJaqyWe_nhVOvfA03So_edVO_+1UeHCC6RGnHRQB9dq7CWS4LQ@mail.gmail.com>
References: <CAJaqyWe_nhVOvfA03So_edVO_+1UeHCC6RGnHRQB9dq7CWS4LQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCntOrNomBqcjHiIQ--.3460S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GrW3tr48KF1ftw1DGF4rZrb_yoWfJryxpr
	W3Gr1ayr1DAFykWw1UAr4UXw1xXrZ5Xanxtr18KrW8ua45Ar1jqF4UtF4rWrWUX398Kw47
	Xr1jqF45uFWDA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U3b15UUUUU=
X-CM-SenderInfo: 3uurkzkwhy0qqrwthudrp/xtbC7w+OBGpgos9UOAAA3h

From: Yufeng Wang <wangyufeng@kylinos.cn>

Thank you for the detailed feedback. We've completed benchmark
testing comparing the existing notification mechanisms against the
proposed SQ/CQ polling. The results are informative.


Test Modes Explained
--------------------

To answer your second question with data, we tested four modes:

1. **baseline**: Default vhost-scsi with event_idx auto-negotiated.
   I/O engine: libaio. Submission uses MMIO kick (VM exit), completion
   uses MSI-X interrupt (VM exit). The guest driver dynamically toggles
   NO_NOTIFY/NO_INTERRUPT during completion processing, but these are
   short windows — most I/O still incurs VM exits on both paths.

2. **poll-queue**: This mode combines the existing notification features
   you mentioned:
   - VIRTIO_RING_F_EVENT_IDX: auto-negotiated (same as baseline)
   - VIRTQ_AVAIL_F_NO_INTERRUPT: effectively permanent — poll queue
     VQs have callback=NULL and no MSI-X vector, so the guest never
     receives completion interrupts regardless of the flag state
   - VIRTQ_USED_F_NO_NOTIFY: vhost dynamically toggles this during
     active processing (vhost_disable_notify/enable_notify)
   - VIRTIO_F_NOTIFICATION_DATA: negotiated but vhost kernel does not
     process notification data, so no practical effect
   
   Implemented via virtio-scsi poll queues (virtscsi_poll_queues=16,
   callback=NULL, no MSI-X vector) + io_uring IOPOLL mode (--hipri).
   blk-mq polls the used ring for completions via virtscsi_mq_poll().
   This eliminates completion-side VM exits. However, submission still
   uses MMIO kick (VM exit). Note: libaio cannot use this mode because
   aio.c strips IOCB_HIPRI ("no one is going to poll for this I/O").

3. **sqcq-poll**: The proposed SQ/CQ doorbell polling (this RFC) with
   libaio. Guest writes sq->idx instead of MMIO kick (no VM exit).
   Guest poll thread checks used ring via more_used() (no interrupt).
   NEED_WAKEUP protocol enables adaptive sleep when idle. Eliminates
   VM exits on BOTH submission and completion paths.

4. **sqcq-uring**: Same SQ/CQ polling but with io_uring + --hipri.
   Included to isolate the I/O engine variable from the polling
   mechanism.


Results
-------

Test configuration:
  x86_64: Intel Xeon E5-2680 v4 @ 2.40GHz, 16 vCPUs
          NVMe SAMSUNG MZ1LB960HAJQ-000MV (960GB)
  arm64:  Kunpeng 920 (2.6GHz), 16 vCPUs
          NVMe INTEL SSDPED1K375GA (375GB)
  Backend: vhost-scsi with TCM loopback to NVMe

arm64 IOPS (best of 3 runs, fio 4K random I/O):

  Test              baseline   poll-queue    sqcq-poll   sqcq-uring
  ─────────────     ────────   ──────────    ─────────   ──────────
  randread QD1       23,751      29,892       29,680      26,427
  randread QD32 NJ1  93,221     162,849 *     84,967      70,271
  randread QD32 NJ4 184,939     186,859      340,780     235,310
  randread QD32 NJ8 190,562     188,382      520,946     518,197
  randwrite QD1      24,131          —        25,520      25,485
  randwrite QD32 NJ1 84,725          —        70,652      68,518
  randwrite QD32 NJ4 204,745          —       323,449     312,204
  randwrite QD32 NJ8 193,802          —       522,322     516,448

  * poll-queue NJ1 read shows high IOPS but hangs at NJ≥4 (see below)

x86_64 IOPS (best of 3 runs):

  Test              baseline   poll-queue    sqcq-poll   sqcq-uring
  ─────────────     ────────   ──────────    ─────────   ──────────
  randread QD1        8,316       9,022        9,533       9,489
  randread QD32 NJ1 124,909     146,744      165,761     165,929
  randread QD32 NJ4 305,951     332,139      378,305     379,546
  randread QD32 NJ8 344,223     356,328      374,932     374,976
  randwrite QD1      20,106      24,464       27,265      27,768
  randwrite QD32 NJ1 131,836    153,203      162,145     161,402
  randwrite QD32 NJ4 232,908    234,559      232,976     231,336
  randwrite QD32 NJ8 231,242    229,858      231,828     231,465


Key Findings
------------

1. **poll-queue excels at NJ=1 (arm64)**: On arm64 4K randread QD32
   NJ1, poll-queue achieved 163K IOPS — significantly higher than
   baseline (93K, +75%) and SQ/CQ polling (85K). io_uring IOPOLL
   mode is very efficient for single-queue workloads because the
   submitting task polls for completion directly, avoiding both
   interrupt latency and poll thread scheduling overhead.

2. **SQ/CQ dramatically outperforms poll-queue at NJ≥4 (arm64)**:
   At 4K randread QD32, poll-queue and SQ/CQ diverge sharply:
   - NJ4: poll-queue 187K vs SQ/CQ 341K (+82% over poll-queue)
   - NJ8: poll-queue 188K vs SQ/CQ 521K (+177% over poll-queue)
   SQ/CQ also outperforms baseline by +84% (NJ4) and +173% (NJ8).

3. **libaio incompatibility**: The existing poll queue mechanism
   requires io_uring IOPOLL mode. libaio explicitly strips IOCB_HIPRI
   (fs/aio.c: "no one is going to poll for this I/O"), so poll queues
   are inaccessible to libaio users. SQ/CQ works with any I/O engine
   because the poll thread is independent of the submitting task.


Development Insights
--------------------

Beyond eliminating VM exits, two engineering decisions were critical
to achieving the performance shown above:

1. **TCM completion CPU steering**: Our initial goal was 5-10% IOPS
   improvement at 4K random I/O QD1 NJ1. After implementing the basic
   polling and NEED_WAKEUP protocol, this target was not met. The
   bottleneck was that TCM completions were being scheduled on the same
   CPU as the busy poll thread, starving the completion workqueue. We
   added vhost_sqcq_pick_completion_cpu() to steer TCM completions to
   a free CPU (avoiding busy poll cores), with fallback to next-CPU
   when all cores are occupied. This closed the gap and achieved the
   QD1 target.

2. **Adaptive idle policy with EMA**: After QD1 targets were met,
   we tested higher concurrency (QD32 NJ4/NJ8) and found that
   aggressive polling caused performance degradation under
   multi-queue workloads — likely due to the poll thread consuming
   excessive CPU cycles that competing vCPUs needed. We solved this
   by implementing an EMA-based adaptive spin budget: the poll thread
   spins within a time window derived from recent I/O latency, then
   yields. Combined with the NEED_WAKEUP protocol, this allows the
   poll thread to busy-spin when active but sleep when idle, avoiding
   CPU contention with other vCPUs.


On the vDPA Question
--------------------

The generic vDPA device approach you suggested is indeed a better
direction. The QEMU-side zero-code advantage (leveraging existing
vdpa-dev.c) is very attractive. Our concern is that vhost-scsi's
TCM integration (SCSI CDB, ALUA, persistent reservations) would
need to be wrapped as a vDPA backend. This feels like a 0-to-1
engineering effort, and we're uncertain about the actual scope of
work involved. If there are additional guidelines or examples
available, we'd be very willing to explore this direction.


One More Thing: SQ/CQ + poll-queue Combined
--------------------------------------------

During arm64 testing, we accidentally ran the poll-queue benchmark
(--hipri, io_uring, virtscsi_poll_queues=16) on a kernel that also
had VIRTIO_F_SQCQ_POLL negotiated. This "poll-sqcq" mode combines
both mechanisms simultaneously:

  - Submission: SQ/CQ doorbell (sq->idx write, no VM exit)
  - Completion: both SQ/CQ poll thread AND blk-mq poll via io_uring

The results were surprisingly strong (arm64, 4K random I/O):

  Test              baseline   poll-queue   poll-sqcq   sqcq-poll
  ─────────────     ────────   ──────────   ─────────   ─────────
  randread QD1       23,751      29,892      41,683      29,680
  randread QD32 NJ1  93,221     162,849     193,029      84,967
  randread QD32 NJ4 184,939     186,859     585,445     340,780
  randread QD32 NJ8 190,562     188,382     560,727     520,946
  randwrite QD1      24,131          —       38,591      25,520
  randwrite QD32 NJ1 84,725          —      187,421      70,652
  randwrite QD32 NJ4 204,745          —      598,419     323,449
  randwrite QD32 NJ8 193,802          —      569,890     522,322

poll-sqcq outperforms both individual mechanisms across all test
cases. We haven't fully analyzed why, but suspect the combination
benefits from:
  - SQ/CQ eliminating submission VM exits
  - io_uring IOPOLL providing low-latency completion detection via
    blk-mq (directly in submitting task context)
  - SQ/CQ poll thread as a secondary completion poller covering VQs
    that blk-mq doesn't reach

This is preliminary and accidental data, but we think it's worth
sharing as it suggests the two mechanisms are complementary rather
than mutually exclusive.

Benchmark scripts and raw fio JSON data are available and can be
sent as a follow-up upon request.


Best regards,
Yufeng

Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>


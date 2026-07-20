Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C8A426EB3;
	Mon, 20 Jul 2026 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556731; cv=none; b=VBB4pqv3Qv+hQ3tvCcGC9h8l2EiEKxKbZ9exny460LKHTJhkHTuUo/duVIXR0vMO7sDxrKgDrLJGWeoifa5sE54J4QbYc6lsVeo5AoPKRjNx1HnW0vnPiCQm9ZpqzdtXxU3/EAEFqJP3zGBJhTVm0ZpDCzAa75F5HNqYIa5UggY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556731; c=relaxed/simple;
	bh=Iv1ZzGl4nDQtZYyFQUhh6++u+LomotAUmN5LcBhRxMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=aH+T50jzaifLoAmmbLiOaUwuLSY+T4Y4GDmwNJz7KmzwYUxt39mXKY/rYSZFiqPC1V490FKcSfzk0eMDFXkhjLV14xCENnluH54tPtg8hAsDx2cJ7xyuMm2LxX0vtBox+wuW/CgrHIO5D3rCr+dTKJzBq+ljWyP0LukvsqSk4F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BcD0C2Uh; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BcD0C2Uh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=PbGwBRW9wW2xSalNs+v2BcPcDxmJ1owbuxV0zExiqSc=;
	b=BcD0C2UhXdLLne6R/C+wh/DRduOn2oOllSelS3pHSGBsQJ77ZlbIDCcmHv7ju/
	51um22nlNO+Ff5R4CJKRjEx493YuArV2kwLINDR/vaxT6/8Sx5gaHlG7MmspYCQ1
	ADjCB0sUtK6RLT+d3c1rUMbRSNatBNCU0fYEGbEME8iws=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3Xw9gLF5qWUvpIg--.12525S2;
	Mon, 20 Jul 2026 22:10:40 +0800 (CST)
From: "rom.wang" <r4o5m6e8o@163.com>
To: mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Yufeng Wang <wangyufeng@kylinos.cn>
Subject: [RFC PATCH 0/4] virtio: SQ/CQ doorbell polling for vhost-scsi
Date: Mon, 20 Jul 2026 22:10:36 +0800
Message-Id: <20260720141040.181946-1-r4o5m6e8o@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3Xw9gLF5qWUvpIg--.12525S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr1UWF18ZFW3XrW3JFWUArb_yoWfWFy8pF
	W3G3y3Kr1xJF1UCF4kJF48Wry8Ww4kJa13GF1UG340gFn0vFyYyF98KF4rtFWUGrZ3C34U
	XF1jqF1rCa1DA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUkucUUUUU=
X-CM-SenderInfo: 3uurkzkwhy0qqrwthudrp/xtbC7wNVympeLGMvXAAA37

From: Yufeng Wang <wangyufeng@kylinos.cn>

This RFC proposes a new virtio transport feature, VIRTIO_F_SQCQ_POLL,
that eliminates VM exits on both submission and completion paths for
vhost-scsi by using shared-memory doorbells and kernel polling
threads, following the io_uring SQPOLL model.

This is an early RFC to gather design feedback. The implementation is
functional and has been tested on arm64 and x86_64. We are not
requesting merge at this time.


Problem
-------

vhost-scsi uses MMIO writes (Guest -> Host) and MSI-X interrupts
(Host -> Guest) for notification. Each notification involves a VM exit,
which becomes a bottleneck at high IOPS:

  - 4K random read, QD32, 8 jobs: 341K IOPS baseline
  - With ~340K VM exits/second, the exit overhead dominates

Existing mitigations (vhost-net's tx polling, blk-mq iopoll) only
address one direction or require the submitting task to poll. Neither
eliminates VM exits on both paths simultaneously.


Solution
--------

Introduce two cache-line-aligned doorbell structures, SQ (Submission
Queue) and CQ (Completion Queue), placed alongside the standard split
virtqueue:

  - Guest writes sq->idx instead of MMIO kick; Host poll thread
    detects the change and processes submissions.
  - Host writes cq->idx instead of MSI-X interrupt; Guest poll
    thread detects the change and invokes completion callbacks.

A NEED_WAKEUP protocol (mirroring io_uring's SQ_NEED_WAKEUP) allows
either side to sleep when idle, with the other side responsible for
waking it via eventfd.

Feature negotiation via VIRTIO_F_SQCQ_POLL (bit 42) ensures zero
overhead when not negotiated — the driver falls back to traditional
MMIO kick + MSI-X interrupt.


Performance
-----------

Benchmark: fio, 4K random I/O

Test configuration:

  arm64:
    CPU:   Kunpeng 920 (2.6GHz), 8 vCPUs
    Disk:  NVMe INTEL SSDPED1K375GA (375GB)

  x86_64:
    CPU:   Intel Xeon E5-2680 v4 @ 2.40GHz, 8 vCPUs
    Disk:  NVMe SAMSUNG MZ1LB960HAJQ-000MV (960GB)

  Backend: vhost-scsi with TCM loopback to NVMe device
  QEMU:    vhost-scsi-pci with VIRTIO_F_SQCQ_POLL negotiated

arm64 results:

  Test              Baseline     SQ/CQ Poll   Change
  -----------       ----------   ----------   -------
  randread QD1      22,427       28,289       +26%
  randread QD32 NJ1 89,910       75,665       -16%
  randread QD32 NJ4 186,763      379,549      +103%
  randread QD32 NJ8 199,967      550,633      +175%
  randwrite QD1     21,912       27,261       +24%
  randwrite QD32 NJ1 85,349      81,389       -5%
  randwrite QD32 NJ4 190,443     355,811      +87%
  randwrite QD32 NJ8 196,552     566,640      +188%

x86_64 results:

  Test              Baseline     SQ/CQ Poll   Change
  -----------       ----------   ----------   -------
  randread QD1      8,263        9,552        +16%
  randread QD32 NJ1 127,412      162,805      +28%
  randread QD32 NJ4 303,208      375,056      +24%
  randread QD32 NJ8 341,625      371,193      +9%
  randwrite QD1     20,773       30,332       +46%
  randwrite QD32 NJ1 133,316      159,207      +19%
  randwrite QD32 NJ4 233,373      229,224      -2%
  randwrite QD32 NJ8 231,442      231,676      +0%

Multi-queue workloads (NJ4/NJ8) see significant improvement on arm64
(87-188%) and moderate improvement on x86_64 (9-24%). Single-VQ
high-queue-depth workloads show a minor regression on arm64 due to
polling overhead vs. VM-exit savings trade-off, while x86_64 shows
improvement across most configurations (16-46% for QD1, 19-28%
for QD32-NJ1) due to lower per-VM-exit cost on x86.


Why Not vDPA?
-------------

vhost-vDPA already provides doorbell mmap and polling. A reasonable
reviewer would ask: why not extend vhost-vDPA instead?

Three reasons:

1. No vdpa-scsi device exists. The vDPA framework
   (drivers/vdpa/) currently has hardware devices for net (mlx5,
   ifcvf, etc.) and software devices for net and blk (vdpa_sim).
   There is no virtio-scsi vDPA device, hardware or software.
   Building one means re-implementing vhost-scsi's TCM integration
   (SCSI CDB processing, ALUA, persistent reservations) under the
   vDPA device abstraction — 3-5x the work of extending vhost-scsi.

2. vhost-scsi is a deployed interface. libvirt, QEMU, and
   OpenStack have vhost-scsi configuration APIs and operational
   tooling. Switching to vhost-vdpa requires a new backend, user
   migration, and toolchain updates. SQ/CQ poll as a vhost-scsi
   feature is fully backward-compatible — no existing deployments
   break.

3. The protocol is transport-agnostic. The SQ/CQ doorbell design
   (struct vring_sq, struct vring_cq, NEED_WAKEUP handshake) is
   orthogonal to vhost vs. vDPA. The same UAPI can be consumed by
   vhost-scsi today and a future vdpa-scsi device. Implementing in
   vhost-scsi first does not block future vDPA integration.

We acknowledge that vDPA is the long-term direction for virtio
backends. If this SQ/CQ poll protocol is accepted, it can be ported
to the vDPA framework; a vdpa-scsi device is independent work.


Patch Structure
---------------

  Patch 1: UAPI definitions (virtio_config.h, virtio_ring.h,
           virtio_pci.h) — shared interface for all components
  Patch 2: vhost kernel support (vhost.c, vhost.h, scsi.c,
           vhost.h UAPI, vhost_types.h UAPI) — Host poll thread
  Patch 3: virtio guest driver (virtio_ring.c, virtio_sqcq_poll.c,
           virtio_pci_modern.c, virtio.c, virtio_scsi.c) — Guest
           poll thread and submission path
  Patch 4: QEMU support (virtio-pci.c, vhost.c) — PCI config
           forwarding and vhost ioctl bridge

Patches 1-3 apply to the Linux kernel tree. Patch 4 applies to
the QEMU tree separately.


Spec Status
-----------

A virtio-spec format document has been prepared and will be submitted
to the OASIS virtio TC as a proposal. This RFC stage seeks design
feedback before initiating the formal spec process.


Known Limitations (Future Work)
-------------------------------

  - CPU hotplug: no notifier registered; poll thread may be
    migrated when its CPU goes offline. Planned: kthread_park +
    dynamic rebind.
  - Live migration: no explicit stop/flush coordination during
    migration. Planned: VHOST_BACKEND_F_SUSPEND/RESUME integration.
  - SMAP overhead: Host uses get_user/put_user for doorbell access.
    Future optimization: GUP + kmap to map pages into kernel space.
  - Backpressure: no "slow down" signal from device to driver.
    Future: CQ throttle flag or avail_event reuse.
  - Packed ring: not supported; explicitly rejected at feature
    negotiation. Future: add packed ring doorbell support.


RFC Goals
---------

  1. Validate the overall design direction (doorbell + polling
     model, NEED_WAKEUP protocol)
  2. Get feedback on the feature bit allocation (42) and UAPI
     structure design
  3. Understand whether vDPA concern is a blocker or can be
     addressed with the transport-agnostic argument
  4. Collect guidance on prioritizing future work items
     (hotplug, migration, spec process)

We welcome all feedback, especially on:
  - Whether the NEED_WAKEUP protocol design is sound
  - Whether the per-device Guest poll thread model (vs per-VQ)
    is acceptable
  - Whether feature bit 42 is appropriate or if a different
    allocation is needed
  - Any concerns about the SMAP overhead in the Host poll path


How to Test
-----------

Patch usage:
  Guest Kernel: apply patch 1 (UAPI) + patch 3 (guest driver)
  Host Kernel:  apply patch 1 (UAPI) + patch 2 (vhost support)
  QEMU:        apply patch 4 (vhost-scsi bridge)

1. Set up vhost-scsi target on the host (see:
   https://wiki.libvirt.org/Vhost-scsi_target.html#Host_Setup)
   using targetcli to create a TCM loopback device, e.g.:
   targetcli /backstores/loopback create dev=/dev/sda
   targetcli /vhost create naa.5001405376e34400
   targetcli /vhost/naa.5001405376e34400/lun create \
     /backstores/loopback/dev,/dev/sda

2. Boot VM with vhost-scsi using patched QEMU:
   qemu-system-aarch64 ... \
     -device vhost-scsi-pci,wwpn=naa.5001405376e34400

3. Verify SQ/CQ poll mode is active on the host:
   dmesg | grep "vhost-sqcq"
   # Expected: "vhost-sqcq: vq[N] poll thread bound to cpuN"
   # and 10s stats: "vhost-sqcq: vq[N] cq=... ema_lat=... interval=..."

4. Verify feature negotiated in guest:
   dmesg | grep "VIRTIO_F_SQCQ_POLL"
   # Expected: "VIRTIO_F_SQCQ_POLL negotiated, starting poll thread"
   # and 10s stats: "io_stats: cq=... avg_lat=... interval=..."

5. Run fio benchmark (compare with unpatched QEMU/kernel baseline):
   fio --name=randread --rw=randread --bs=4k --iodepth=32 \
       --numjobs=4 --runtime=60 --time_based --direct=1 \
       --filename=/dev/sda

Test scripts (run-sqcq-compare.sh, compare-sqcq-results.sh) are
available and will be sent as a follow-up to this RFC.


Thank you for your time.

---
Yufeng Wang (4):
  common: add UAPI for SQ/CQ doorbell polling
  vhost: host kernel support for SQ/CQ polling
  virtio: guest driver support for SQ/CQ polling
  qemu: add SQ/CQ polling mode support for vhost-scsi

Patch 1 (UAPI, 3 files): +41 -1
Patch 2 (vhost, 5 files): +794 -20
Patch 3 (virtio guest, 10 files): +840 -3
Patch 4 (QEMU, 14 files): +179 -3

Total: 32 files changed, 1854 insertions(+), 27 deletions(-)

-- 
2.34.1


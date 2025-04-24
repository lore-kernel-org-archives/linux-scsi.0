Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432AE28B514;
	Thu, 24 Apr 2025 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518786; cv=none; b=WvYF03yr7/EYmr4y+8bHEsEpWg3Mlk1OutVPwUK/AkC52hosLjMO5SWTZg877+I8TZU77FTIlkD1nIUerXE7iLVvHkob9nZdNv0dxfh3b+S4V8C1bcntBZJcQzo2byHh+B2P/axtSGBpSCcypcchdJ7WYNHiirXvxw+auAUKfHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518786; c=relaxed/simple;
	bh=VqAYPuJ5J0/bH4w7gmZOsvSTqkaJVps+Ly/tB5vJwcM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CwYKqcrUIDsUfwqRje5IoSo6sEWlcd7uGr9f8y0mhm8qSpPdOQ2DQ4Uwc3OcnvRjWqnur5/2fu8KSy5DlLh7bO4STtmUSVvm+dYpOm+ztNdhHVIR1Wktg/izFAIjzFeIS6a+mMtCTWI1GmuUQFvphTAWCqPaUqq9jhzhnqSqgeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AWURydop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AWURydop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20898C4CEE3;
	Thu, 24 Apr 2025 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745518785;
	bh=VqAYPuJ5J0/bH4w7gmZOsvSTqkaJVps+Ly/tB5vJwcM=;
	h=From:Subject:Date:To:Cc:From;
	b=AWURydopIE0CiWhfMynMTkk/xIOsRAI4gEiAhNjnW9IOpXUFlvExiNsFwsMKx46fo
	 mRta86ddHbXGsHNv+r5KX4CL7EoksB2R9lPfiJ/9/+pF5Dc8IUMLndYdsauvWaQ+Uw
	 MT0nnWDrli9MQRWztcflmba/+vc05WO13hi1BnhJeL15QQg2atxJUep4yZP6mXBQha
	 i2lb0ygiNqbEcUD0WqSmK2oLjhToqeSw45uYyQpe8Xrpb3EpevIu6TaRRPoq02jwZy
	 cpehhNPlmACv4VSYCfTNlEsgjwoXPbwmyGXKrrYNbsjc7cbX+V2DrL1WoNqHTOcUlU
	 hXnnGhBPdtWvA==
From: Daniel Wagner <wagi@kernel.org>
Subject: [PATCH v6 0/9] blk: honor isolcpus configuration
Date: Thu, 24 Apr 2025 20:19:39 +0200
Message-Id: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALuACmgC/23RTW7CMBAF4Ksgr2s047+4rLhH1UWcjMEqisHGE
 Qjl7jVQ2kbK8o3kz+PnG8uUAmW2Wd1YojHkEIcazNuKdft22BEPfc1MgFBgBPCQ46E7lsxD5Kd
 ChTLH1lpyqvHeOlYPHhP5cHmgH58170M+x3R93DHiffricIkbkQO3Ds278wrBym0umdY9sTs2i
 v9AswiICgjTSkGyU77Rc0D+ARbMIiAr0LdA1Hlq66vmgPoFUODyBqoCupdae+eQUG2/KA10WMe
 0exr6ZWhAXGx11NUAUh7RGgsOZsb07DnRqdQ/O/+UPU3fQtAZNtEBAAA=
X-Change-ID: 20240620-isolcpus-io-queues-1a88eb47ff8b
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

I've added back the isolcpus io_queue agrument. This avoids any semantic
changes of managed_irq. I don't like it but I haven't found a
better way to deal with it. Ming clearly stated managed_irq should not
change.

Another change is to prevent offlining a housekeeping CPU which is still
serving an isolated CPU instead just warning. Seem way saner way to
handle this situation. Thanks Mathieu!

Here details what's the difference is between managed_irq and io_queue.

* nr cpus <= nr hardware queue

(e.g. 8 CPUs, 8 hardware queues)

managed_irq is working nicely for situation where there hardware has at
least as many hardware queues as CPUs, e.g. enterprise nvme-pci devices.

managed_irq will assign each CPU its own hardware queue and ensures that
non unbound IO is scheduled to a isolated CPU. As long the isolated CPU
is not issuing any IO there will be no block layer 'noise' on the
isolated CPU.

  - irqaffinity=0 isolcpus=managed_ird,2-3,6-7

	queue mapping for /dev/nvme0n1
	        hctx0: default 0
	        hctx1: default 1
	        hctx2: default 2
	        hctx3: default 3
	        hctx4: default 4
	        hctx5: default 5
	        hctx6: default 6
	        hctx7: default 7

	IRQ mapping for nvme0n1
	        irq 40 affinity 0 effective 0  nvme0q0
	        irq 41 affinity 0 effective 0  nvme0q1
	        irq 42 affinity 1 effective 1  nvme0q2
	        irq 43 affinity 2 effective 2  nvme0q3
	        irq 44 affinity 3 effective 3  nvme0q4
	        irq 45 affinity 4 effective 4  nvme0q5
	        irq 46 affinity 5 effective 5  nvme0q6
	        irq 47 affinity 6 effective 6  nvme0q7
	        irq 48 affinity 7 effective 7  nvme0q8

With this configuration io_queue will create four hctx for the four
housekeeping CPUs:

  - irqaffinity=0 isolcpus=io_queue,2-3,6-7

	queue mapping for /dev/nvme0n1
	        hctx0: default 0 2
	        hctx1: default 1 3
	        hctx2: default 4 6
	        hctx3: default 5 7

	IRQ mapping for /dev/nvme0n1
	        irq 36 affinity 0 effective 0  nvme0q0
	        irq 37 affinity 0 effective 0  nvme0q1
	        irq 38 affinity 1 effective 1  nvme0q2
	        irq 39 affinity 4 effective 4  nvme0q3
	        irq 40 affinity 5 effective 5  nvme0q4

* nr cpus > nr hardware queue

(e.g. 8 CPUs, 2 hardware queues)

managed_irq is creating two hctx and all CPUs could handle IRQs. In this
case an isolated CPU is selected to handle all IRQs for a given hctx:

  - irqaffinity=0 isolcpus=managed_ird,2-3,6-7

	queue mapping for /dev/nvme0n1
	        hctx0: default 0 1 2 3
	        hctx1: default 4 5 6 7

	IRQ mapping for /dev/nvme0n1
	        irq 40 affinity 0 effective 0  nvme0q0
	        irq 41 affinity 0-3 effective 3  nvme0q1
	        irq 42 affinity 4-7 effective 7  nvme0q2

io_queue also creates also two hctxs but only assigns housekeeping CPUs
to handle the IRQs:

  - irqaffinity=0 isolcpus=io_queue,2-3,6-7

	queue mapping for /dev/nvme0n1
	        hctx0: default 0 1 2 6
	        hctx1: default 3 4 5 7

	IRQ mapping for /dev/nvme0n1
	        irq 36 affinity 0 effective 0  nvme0q0
	        irq 37 affinity 0-1 effective 1  nvme0q1
	        irq 38 affinity 4-5 effective 5  nvme0q2

The case that there are less hardware queues than CPUs is more common
with the SCSI HBAs so with the io_queue approach not just nvme-pci are
supported.

Something completely different: we got several bug reports for kdump and
SCSI HBAs. The issue is that the SCSI drivers are allocating too many
resources when it's a kdump kernel. This series will fix this as well,
because the number of queues will be limitted by
blk_mq_num_possible_queues() instead of num_possible_cpus(). This will
avoid sprinkling is_kdump_kernel() around.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
Changes in v6:
- added io_queue isolcpus type back
- prevent offlining hk cpu if a isol cpu is still present isntead just warning
- Link to v5: https://lore.kernel.org/r/20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org

Changes in v5:
- rebased on latest for-6.14/block
- udpated documetation on managed_irq
- updated commit message "blk-mq: issue warning when offlining hctx with online isolcpus"
- split input/output parameter in "lib/group_cpus: let group_cpu_evenly return number of groups"
- dropped "sched/isolation: document HK_TYPE housekeeping option"
- Link to v4: https://lore.kernel.org/r/20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org

Changes in v4:
- added "blk-mq: issue warning when offlining hctx with online isolcpus"
- fixed check in cgroup_cpus_evenly, the if condition needs to use
  housekeeping_enabled() and not cpusmask_weight(housekeeping_masks),
  because the later will always return a valid mask.
- dropped fixed tag from "lib/group_cpus.c: honor housekeeping config when
  grouping CPUs"
- fixed overlong line "scsi: use block layer helpers to calculate num
  of queues"
- dropped "sched/isolation: Add io_queue housekeeping option",
  just document the housekeep enum hk_type
- added "lib/group_cpus: let group_cpu_evenly return number of groups"
- collected tags
- splitted series into a preperation series:
  https://lore.kernel.org/linux-nvme/20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org/
- Link to v3: https://lore.kernel.org/r/20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de

Changes in v3:
- lifted a couple of patches from
  https://lore.kernel.org/all/20210709081005.421340-1-ming.lei@redhat.com/
  "virito: add APIs for retrieving vq affinity"
  "blk-mq: introduce blk_mq_dev_map_queues"
- replaces all users of blk_mq_[pci|virtio]_map_queues with
  blk_mq_dev_map_queues
- updated/extended number of queue calc helpers
- add isolcpus=io_queue CPU-hctx mapping function
- documented enum hk_type and isolcpus=io_queue
- added "scsi: pm8001: do not overwrite PCI queue mapping"
- Link to v2: https://lore.kernel.org/r/20240627-isolcpus-io-queues-v2-0-26a32e3c4f75@suse.de

Changes in v2:
- updated documentation
- splitted blk/nvme-pci patch
- dropped HK_TYPE_IO_QUEUE, use HK_TYPE_MANAGED_IRQ
- Link to v1: https://lore.kernel.org/r/20240621-isolcpus-io-queues-v1-0-8b169bf41083@suse.de

---
Daniel Wagner (9):
      lib/group_cpus: let group_cpu_evenly return number initialized masks
      blk-mq: add number of queue calc helper
      nvme-pci: use block layer helpers to calculate num of queues
      scsi: use block layer helpers to calculate num of queues
      virtio: blk/scsi: use block layer helpers to calculate num of queues
      isolation: introduce io_queue isolcpus type
      lib/group_cpus: honor housekeeping config when grouping CPUs
      blk-mq: use hk cpus only when isolcpus=io_queue is enabled
      blk-mq: prevent offlining hk CPU with associated online isolated CPUs

 block/blk-mq-cpumap.c                     | 116 +++++++++++++++++++++++++++++-
 block/blk-mq.c                            |  46 +++++++++++-
 drivers/block/virtio_blk.c                |   5 +-
 drivers/nvme/host/pci.c                   |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  15 ++--
 drivers/scsi/qla2xxx/qla_isr.c            |  10 +--
 drivers/scsi/smartpqi/smartpqi_init.c     |   5 +-
 drivers/scsi/virtio_scsi.c                |   1 +
 drivers/virtio/virtio_vdpa.c              |   9 +--
 fs/fuse/virtio_fs.c                       |   6 +-
 include/linux/blk-mq.h                    |   2 +
 include/linux/group_cpus.h                |   3 +-
 include/linux/sched/isolation.h           |   1 +
 kernel/irq/affinity.c                     |   9 +--
 kernel/sched/isolation.c                  |   7 ++
 lib/group_cpus.c                          |  90 +++++++++++++++++++++--
 16 files changed, 290 insertions(+), 40 deletions(-)
---
base-commit: 3b607b75a345b1d808031bf1bb1038e4dac8d521
change-id: 20240620-isolcpus-io-queues-1a88eb47ff8b

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>


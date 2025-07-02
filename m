Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9212C9A;
	Wed,  2 Jul 2025 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474043; cv=none; b=bIEhQpxDI/onZerZesyGvmI3LfejfBHRC1FKnwrnj2ZGf2HDlzxJc6vroLLKrw3b84Pc5MNvHlGw8qqcMswLq8BTJ5Iuz2ctKhIffiZTCwcqeIHJjTAeOauHtewpFtFwrkPmVUjZTlDSOReZqvvwa6n9dtmJSjg4/YadujFMk0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474043; c=relaxed/simple;
	bh=d5wJzBqQtQx0cKIyFfj1W46Gw/qt1uYPa5jxo62LV1s=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rSceQSHE1R8HK+IJ8o1fr0lKycgNdrYDa4zsVQyuqIp6RHlB4jWHcRQ6w4YApwe9n2hREJaraiBVrW4CFu1KbAp7u64P7lz4vbEYEXy46o/2uNSGez7fY8m69Q1EWcv6D5v63BqAqrbf1I8kHgjN7Ajf75ox7Ern50MF6oy5LR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJJPuSL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJJPuSL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B50C4CEE7;
	Wed,  2 Jul 2025 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474043;
	bh=d5wJzBqQtQx0cKIyFfj1W46Gw/qt1uYPa5jxo62LV1s=;
	h=From:Subject:Date:To:Cc:From;
	b=YJJPuSL+liifkek72z86Bw/Thf+Gn6uTlB7TSNSl9T7Z6bNz/pRf60X53CheWMd5p
	 zWnwjIif5rcZjq7xRKV7rEp8s22XIeXhyBzW4lOu83YQdafOr8rBpoyTb6IHAQrmoL
	 r7B+xsOTEuLqj+BwzvZ3Ak4WxG0PuzcFu4zRp5uzvVadDx1EHTkfaeD9pf31ZJke+z
	 zHeILJkKQeRLTWih41LpOCj79ahXKVUU07rIV/4r2jIAVFcyJywTw2rZLqS15Hl8vr
	 a6agAZgY83CVQWOIJH6sFieFeSVYTOXR/L+Vn9pJxlsjvzXk6pZo1wBOyn5Vtsl85Q
	 d3dplvyhjNRcw==
From: Daniel Wagner <wagi@kernel.org>
Subject: [PATCH v7 00/10] blk: honor isolcpus configuration
Date: Wed, 02 Jul 2025 18:33:50 +0200
Message-Id: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAG5fZWgC/23RTW7DIBAF4KtErEs0w59JV7lH1QXYQ4Ia2QnEV
 qvIdy9JmqZWWb6R+Bh4F5YpRcrsdXVhiaaY49CX0LysWLt3/Y547EpmAoQCI4DHPBza45h5HPh
 ppJEyR2ctedWEYD0rB4+JQvy8oW/vJe9jPg/p63bHhNfpg8MaNyEHbj2ajQ8KwcptHjOtO2JXb
 BJ/gaYKiAII46Qg2arQ6CUgn4AFUwVkAToHRG0gV161BNQvgALrG6gC6E5qHbxHQrX9oNTTYT2
 k3d3QD0MDYvVXJ10MIBUQrbHg4Z9hnoYSqmqYYmycls420DoMC2O+d5XoNJbezz+FzfM3TyCdU
 hUCAAA=
X-Change-ID: 20240620-isolcpus-io-queues-1a88eb47ff8b
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
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

The first part from v6 is already in linux-next.

One of the changes requested in v6 was to only use group_mask_cpus_evenly
when the caller explicitly asks for it, instead of applying it at a
global level. To support this, I decided to add a cpumask to struct
irq_affinity, which is used when creating CPU groups. During testing, I
realized it was also necessary to provide two additional block layer
helpers to return such masks: blk_mq_{possible|online}_queue_affinity.
These match the existing blk_mq_{possible|online}_queues.

As a result, this version again includes bits and pieces that touch
several subsystems. If the general approach of extending struct
irq_affinity is acceptable but there are additional change requests,
particularly in the isolcpus code, I’m happy to split the first part out
and have it reviewed separately. Let's see how the review goes first,
though. From what I understand, this is the part Aaron is interested in.

Ming requested adding HK_TYPE_MANAGED_IRQ to blk_mq_map_hk_queues, but
it's not really needed. blk_mq_map_hk_queues is only used for
HK_TYPE_IO_QUEUE, the managed irq wants to use the existing mapping code
(don't change the existing behavior). This is why I haven’t added it.

The mapping code is now capable of generating a valid configuration
across various system setups, for example, when the number of online CPUs
is less than the number of possible CPUs, or when the number of requested
queues is fewer than the number of online CPUs. Nevertheless I've added
validation code so the system doesn't hang on boot when it's not possible
to create a valid configuration.

I've started testing the drivers, but I don’t have access to all of them.
So far, nvme-pci, virtio, and qla2xxx are tested. The rest are on my TODO
list. I’m sure not everything is working yet, but I think it’s time to
post an update and collect feedback to see if this is heading in the
right direction.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
Changes in v7:
- send out first part of the series:
  https://lore.kernel.org/all/20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org/
- added command line documentation
- added validation code, so that resulting mapping is operational
- rewrote mapping code for isolcpus so it takes into account active hctx
- added blk_mq_map_hk_irq_queues which uses mask from irq_get_affinity
- refactored blk_mq_map_hk_queues so caller tests for HK_TYPE_MANAGED_IRQ
- Link to v6: https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org

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
Daniel Wagner (10):
      lib/group_cpus: Add group_masks_cpus_evenly()
      genirq/affinity: Add cpumask to struct irq_affinity
      blk-mq: add blk_mq_{online|possible}_queue_affinity
      nvme-pci: use block layer helpers to constrain queue affinity
      scsi: Use block layer helpers to constrain queue affinity
      virtio: blk/scsi: use block layer helpers to constrain queue affinity
      isolation: Introduce io_queue isolcpus type
      blk-mq: use hk cpus only when isolcpus=io_queue is enabled
      blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
      docs: add io_queue flag to isolcpus

 Documentation/admin-guide/kernel-parameters.txt |  19 ++-
 block/blk-mq-cpumap.c                           | 218 +++++++++++++++++++++++-
 block/blk-mq.c                                  |  42 +++++
 drivers/block/virtio_blk.c                      |   4 +-
 drivers/nvme/host/pci.c                         |   1 +
 drivers/scsi/fnic/fnic_isr.c                    |   7 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c          |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c       |   5 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                 |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c             |   5 +-
 drivers/scsi/pm8001/pm8001_init.c               |   1 +
 drivers/scsi/qla2xxx/qla_isr.c                  |   1 +
 drivers/scsi/smartpqi/smartpqi_init.c           |   7 +-
 drivers/scsi/virtio_scsi.c                      |   5 +-
 include/linux/blk-mq.h                          |   2 +
 include/linux/group_cpus.h                      |   3 +
 include/linux/interrupt.h                       |  16 +-
 include/linux/sched/isolation.h                 |   1 +
 kernel/irq/affinity.c                           |  12 +-
 kernel/sched/isolation.c                        |   7 +
 lib/group_cpus.c                                |  64 ++++++-
 21 files changed, 405 insertions(+), 22 deletions(-)
---
base-commit: 32f85e8468ce081d8e73ca3f0d588f1004013037
change-id: 20240620-isolcpus-io-queues-1a88eb47ff8b

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>


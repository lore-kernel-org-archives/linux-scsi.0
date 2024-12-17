Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797591F76C7;
	Tue, 17 Dec 2024 18:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460184; cv=none; b=Lae1+WCX2s0P0DHVi7knpHH5ue2pT1FztFYAHzOjImd5iJwBYJgDiHgLrHk8MJsDT6K+maqoJNbwEGyR4+OtvRg2PzFnwfno8GRwGhUkTYmClBxRWLfq11ZmkVRseAEExBzy9K8VkrQkNUvVEiySVmPL26u8V3Z1kEgVi16gyoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460184; c=relaxed/simple;
	bh=hHu0hy2/wGUImCgXCBSjy1eogHX5z0frXHx8vJgLTRE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lFaUmFVXgHGJousl3RUiSZBEBPMaFZKa75E+P4e5ljI+cP7ofDQJiLdK/wg2ntFmFzddYvbNkwd9WiBkMtkKfjPvTYImVRYlYgSkxMxTuU3jc+nZMhCfBg8i9frD4ssyVD38v+wJfxGlJlshZgBDB2iiqJLjC8XkYAq2zgaBueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QC/x7fZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QC/x7fZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87846C4CED3;
	Tue, 17 Dec 2024 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460184;
	bh=hHu0hy2/wGUImCgXCBSjy1eogHX5z0frXHx8vJgLTRE=;
	h=From:Subject:Date:To:Cc:From;
	b=QC/x7fZ+i5oe1UmVSof5V74FINpBvmWKFO8uH8nqQJ6z2Ha2H8GRrK2X41tMiFk7o
	 tuohweIZmBCTT59Pi0ugOqQ20k35h0M/dYoyutT/6eKRCOIMcWqymJamb4+D6pYMFW
	 hKICvz+RYC+hQAo3FP9ZU1jQOOJ7SwU2Iekp/WrFK3s2255kyiOak44Q9EKmOPGfOw
	 AnhEgt0nqpWQ7FtYlzvHQQaudv30K2pjolfZdswPIToOyP0yzMBPY2LZasYCWA66uA
	 zDWUi+el6qf0e9bAJs3K4ULBi8rRX1Q1iGVz0tJsVqQ9oed58T0WanB2tkgH4t01/J
	 f0u95M8QLKVvQ==
From: Daniel Wagner <wagi@kernel.org>
Subject: [PATCH v4 0/9] blk: honor isolcpus configuration
Date: Tue, 17 Dec 2024 19:29:34 +0100
Message-Id: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA7DYWcC/23QwY6DIBAG4FcxnHcaQKu0p75HswfEoZK6Yhk12
 zR99x1tNt1NvJD8JHzDPw9BmAKSOGYPkXAOFGLPofjIhGttf0EIDWehpS5kqSUEip0bJoIQ4Tb
 hhATKGoN1UXlvasEPh4Q+fK/o+ZNzG2iM6b7OmNVy+8upLW5WIMHUqjzUvlDS5CeaCHcNigWb9
 V+g2gQ0A7q0ucbcFb7a/wfyN2BkuQnkDDRWIjqPllu9geerX8LbxLsaXyXFFxLZdVfHbIEVH8B
 bsI6LQ91dwXof+jDeocVuwMQzyuWTlVYKD067Zn+6Yuqx28V04THPH7ytWCGaAQAA
X-Change-ID: 20240620-isolcpus-io-queues-1a88eb47ff8b
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Thomas Gleixner <tglx@linutronix.de>
Cc: Costa Shulyupin <costa.shul@redhat.com>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The first part of the v3 of this series when in [3], so here is the
rebased, retested and slightly extended second halve.

During testing I run into the situation that group_cpu_evenly returned a
masks array which had less groups then requested; KASAN was unhappy and
the kernel also crashed. After starring for a long time on the code and
also reading Ming's comment in alloc_nodes_groups, this is something
which can happen, depending on the online/offline and with this series
isolated CPU configuration.

Second big discussion point in v3 is how to handle the situation when we
have an hardware context with a mapped housekeeping and and isolated CPU
and the housekeeping CPU goes offline. In this case there is nothing
handling IOs for the given context and when the isolated online CPUs is
issuing IO those will just hang.

I've experimented for a while and all solutions I came up were horrible
hacks (the hotpath needs to be touched) and I don't want to slow down all
other users (which are almost everyone). IMO, it's just not worth trying
to fix this corner case. If the user is using isolcpus and does CPU
hotplug, we can expect that the user can also first offline the isolated
CPUs. I've discussed this topic during ALPSS and the room came to the
same conclusion. Thus I just added a patch which issues a warning that
IOs are likely to hang.

Furthermore, I started to work getting the nvme-fabrics honoring the
isolcpu configuration as well but I decied to leave it away for now. No
need to make this series bigger again.

Daniel

ps: CCed a few more who were involved the isolcpu discussion during
plumbers.

Initial cover letter:

The nvme-pci driver is ignoring the isolcpus configuration. There were
several attempts to fix this in the past [1][2]. This is another attempt
but this time trying to address the feedback and solve it in the core
code.

The first patch introduces a new option for isolcpus 'io_queue', but I'm
not really sure if this is needed and we could just use the managed_irq
option instead. I guess depends if there is an use case which depens on
queues on the isolated CPUs.

The second patch introduces a new block layer helper which returns the
number of possible queues. I suspect it would makes sense also to make
this helper a bit smarter and also consider the number of queues the
hardware supports.

And the last patch updates the group_cpus_evenly function so that it uses
only the housekeeping CPUs when they are defined

Note this series is not addressing the affinity setting of the admin
queue (queue 0). I'd like to address this after we agreed on how to solve
this. Currently, the admin queue affinity can be controlled by the
irq_afffinity command line option, so there is at least a workaround for
it.

Baseline:

available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3
node 0 size: 1536 MB
node 0 free: 1227 MB
node 1 cpus: 4 5 6 7
node 1 size: 1729 MB
node 1 free: 1422 MB
node distances:
node   0   1
  0:  10  20
  1:  20  10

options nvme write_queues=4 poll_queues=4

55: 0 41 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 0-edge nvme0q0 affinity: 0-3
63: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 1-edge nvme0q1 affinity: 4-5
64: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 2-edge nvme0q2 affinity: 6-7
65: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 3-edge nvme0q3 affinity: 0-1
66: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 4-edge nvme0q4 affinity: 2-3
67: 0 0 0 0 24 0 0 0 PCI-MSIX-0000:00:05.0 5-edge nvme0q5 affinity: 4
68: 0 0 0 0 0 1 0 0 PCI-MSIX-0000:00:05.0 6-edge nvme0q6 affinity: 5
69: 0 0 0 0 0 0 41 0 PCI-MSIX-0000:00:05.0 7-edge nvme0q7 affinity: 6
70: 0 0 0 0 0 0 0 3 PCI-MSIX-0000:00:05.0 8-edge nvme0q8 affinity: 7
71: 1 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 9-edge nvme0q9 affinity: 0
72: 0 18 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 10-edge nvme0q10 affinity: 1
73: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 11-edge nvme0q11 affinity: 2
74: 0 0 0 3 0 0 0 0 PCI-MSIX-0000:00:05.0 12-edge nvme0q12 affinity: 3

queue mapping for /dev/nvme0n1
        hctx0: default 4 5
        hctx1: default 6 7
        hctx2: default 0 1
        hctx3: default 2 3
        hctx4: read 4
        hctx5: read 5
        hctx6: read 6
        hctx7: read 7
        hctx8: read 0
        hctx9: read 1
        hctx10: read 2
        hctx11: read 3
        hctx12: poll 4 5
        hctx13: poll 6 7
        hctx14: poll 0 1
        hctx15: poll 2 3

PCI name is 00:05.0: nvme0n1
        irq 55, cpu list 0-3, effective list 1
        irq 63, cpu list 4-5, effective list 5
        irq 64, cpu list 6-7, effective list 7
        irq 65, cpu list 0-1, effective list 1
        irq 66, cpu list 2-3, effective list 3
        irq 67, cpu list 4, effective list 4
        irq 68, cpu list 5, effective list 5
        irq 69, cpu list 6, effective list 6
        irq 70, cpu list 7, effective list 7
        irq 71, cpu list 0, effective list 0
        irq 72, cpu list 1, effective list 1
        irq 73, cpu list 2, effective list 2
        irq 74, cpu list 3, effective list 3

* patched:

48: 0 0 33 0 0 0 0 0 PCI-MSIX-0000:00:05.0 0-edge nvme0q0 affinity: 0-3
58: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 1-edge nvme0q1 affinity: 4
59: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 2-edge nvme0q2 affinity: 5
60: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 3-edge nvme0q3 affinity: 0
61: 0 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 4-edge nvme0q4 affinity: 1
62: 0 0 0 0 45 0 0 0 PCI-MSIX-0000:00:05.0 5-edge nvme0q5 affinity: 4
63: 0 0 0 0 0 12 0 0 PCI-MSIX-0000:00:05.0 6-edge nvme0q6 affinity: 5
64: 2 0 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 7-edge nvme0q7 affinity: 0
65: 0 35 0 0 0 0 0 0 PCI-MSIX-0000:00:05.0 8-edge nvme0q8 affinity: 1

queue mapping for /dev/nvme0n1
        hctx0: default 2 3 4 6 7
        hctx1: default 5
        hctx2: default 0
        hctx3: default 1
        hctx4: read 4
        hctx5: read 5
        hctx6: read 0
        hctx7: read 1
        hctx8: poll 4
        hctx9: poll 5
        hctx10: poll 0
        hctx11: poll 1

PCI name is 00:05.0: nvme0n1
        irq 48, cpu list 0-3, effective list 2
        irq 58, cpu list 4, effective list 4
        irq 59, cpu list 5, effective list 5
        irq 60, cpu list 0, effective list 0
        irq 61, cpu list 1, effective list 1
        irq 62, cpu list 4, effective list 4
        irq 63, cpu list 5, effective list 5
        irq 64, cpu list 0, effective list 0
        irq 65, cpu list 1, effective list 1

[1] https://lore.kernel.org/lkml/20220423054331.GA17823@lst.de/T/#m9939195a465accbf83187caf346167c4242e798d
[2] https://lore.kernel.org/linux-nvme/87fruci5nj.ffs@tglx/
[3] https://lore.kernel.org/linux-nvme/20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org/

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
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
      lib/group_cpus: let group_cpu_evenly return number of groups
      sched/isolation: document HK_TYPE housekeeping option
      blk-mq: add number of queue calc helper
      nvme-pci: use block layer helpers to calculate num of queues
      scsi: use block layer helpers to calculate num of queues
      virtio: blk/scsi: use block layer helpers to calculate num of queues
      lib/group_cpus: honor housekeeping config when grouping CPUs
      blk-mq: use hk cpus only when isolcpus=managed_irq is enabled
      blk-mq: issue warning when offlining hctx with online isolcpus

 block/blk-mq-cpumap.c                     | 118 +++++++++++++++++++++++++++++-
 block/blk-mq.c                            |  43 ++++++++++-
 drivers/block/virtio_blk.c                |   5 +-
 drivers/nvme/host/pci.c                   |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  16 ++--
 drivers/scsi/qla2xxx/qla_isr.c            |  10 +--
 drivers/scsi/smartpqi/smartpqi_init.c     |   5 +-
 drivers/scsi/virtio_scsi.c                |   1 +
 drivers/virtio/virtio_vdpa.c              |   2 +-
 fs/fuse/virtio_fs.c                       |   7 +-
 include/linux/blk-mq.h                    |   2 +
 include/linux/group_cpus.h                |   2 +-
 include/linux/sched/isolation.h           |  13 ++++
 kernel/irq/affinity.c                     |   2 +-
 lib/group_cpus.c                          |  98 ++++++++++++++++++++++---
 15 files changed, 289 insertions(+), 40 deletions(-)
---
base-commit: 737371e839a368007758be329413b3f5ec9e7976
change-id: 20240620-isolcpus-io-queues-1a88eb47ff8b
prerequisite-message-id: 20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org
prerequisite-patch-id: e61d7c94facf2774a03c8c7d900f4c5c074bb7e7
prerequisite-patch-id: ed8d884af9fbc0961ad19e4c039136b6f371850f
prerequisite-patch-id: 639d56c8b9d83e516c652dea5f66ae878cd67bf8
prerequisite-patch-id: 79bc9d9cab5c55e31a8f780410a381d44d9c32eb
prerequisite-patch-id: 1fe870f3017d345011c53b51fefceaef97c29d0c
prerequisite-patch-id: 2612b868389ae9d851eb8b0230339faf17071a19
prerequisite-patch-id: c68b002174e1bfa1b2a7ac37e36ecdeec74e6d80
prerequisite-patch-id: 4d24a54316efce94595c811531ef0db9d94ff1b6

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>


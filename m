Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA722F7AAF;
	Fri,  5 Sep 2025 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084394; cv=none; b=e9Soz8DRqdgSbDObOxYJfSFy8fQ9aTLxg1hJs3aDZZVOvgJLJDkUvamTIUeDfE0mQ+lx1RF3DnoKFYrq3/UlU2CNA7BTVOhvI/Mqv42RI+4+5OaO/as6wI5/GKxF23lQeb936UBM/roNxvKCJsjHisrYxOQQQu2VL3QsBDMHuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084394; c=relaxed/simple;
	bh=yRGd8CiKgE1ucAOdb3yAQkpPBUr0SUK/ISIzXtaBgiI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GkWDciiyubZAmuzZc8f0pRjJVSND0fd4bT+qFT1UDtGmjyBHAyKpBwlGIWNJsB11HYeRez4dfcHzRT1wr7CFREVuYGjKsVyE766g3nRVPqBJFks0uAJkrLBAfJ6isWEZpqQC42DeyJ3yQMT6UcHfjGhhdRKv9x1n4EprB2+PEcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uqw4pg2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uqw4pg2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBF7C4CEF1;
	Fri,  5 Sep 2025 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084394;
	bh=yRGd8CiKgE1ucAOdb3yAQkpPBUr0SUK/ISIzXtaBgiI=;
	h=From:Subject:Date:To:Cc:From;
	b=Uqw4pg2eSLlLqt4hunI8pwNBPebkZH23w6mIKWwrid3DZBSW9P6k3l9R1bd8c3Eq4
	 ODeXarAhghoen+iReDzQ141bSpBWr0/5e9FDUzr01oK/Hos+8cL1sJH2/BD39W6waF
	 J5OJPjM6R/RsjWFZfVfNqMZalxjY+X4LoAzmXQEPGBxMYpXRnOlTB2fPRz1d446C2o
	 e7TypnYlUclmFZRO29sIMlstmZkiXT3fgv6oNibgKaXYgNzO6R5oT2kHvpKrDpvntT
	 PxU1shvpwH0mZ2bJ/MF3fdmM3P1Nyva2QI1+OXKFH/+nX8nfSl3I2Bs6vzzUDU/8U8
	 l7b+USvYsSEtw==
From: Daniel Wagner <wagi@kernel.org>
Subject: [PATCH v8 00/12] blk: honor isolcpus configuration
Date: Fri, 05 Sep 2025 16:59:46 +0200
Message-Id: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAOL6umgC/23SzW4CIRQF4FcxrIvh8q8r36PpApiLkhpHwZm0M
 b57Ga21E1keEj44XC6kYE5YyHpxIRnHVFJ/qMG+LUjYucMWaepqJpxxyTRnNJV+H45DoamnpwE
 HLBScteilidF6UjceM8b0dUPfP2repXLu8/ftjBGm1QcHLW4Eyqj1oFc+SmBWbMpQcNkhmbCR/
 wdME+AV4NoJjiLIaNQcEE/AMt0ERAU6xxBDRFdbzQH5BwCH9g1kBVQnlIreA4LcfGI+4H7Z5+3
 dUA9DMYDmq46qGgxlBLDaMs9eDP00JJdNQ1dj5ZRw1rDgIL4Y5mkYxpuGmboo45xBFwLOu1zv8
 854GurfOf8O/Xr9AeyxlhxZAgAA
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
 Aaron Tomlin <atomlin@atomlin.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The main changes in this version are

  - merged the mapping algorithm into the existing code
  - dropping a bunch of SCSI drivers update

With the merging of the isolcpus-aware mapping code, there is a change in
how the resulting CPU–hctx mapping looks for systems with identical CPUs
(non-hyperthreaded CPUs). My understanding is that it shouldn't matter,
but the devil is in the details.

  Package L#0
    NUMANode L#0 (P#0 3255MB)
    L3 L#0 (16MB)
      L2 L#0 (512KB) + L1d L#0 (64KB) + L1i L#0 (64KB) + Core L#0 + PU L#0 (P#0)
      L2 L#1 (512KB) + L1d L#1 (64KB) + L1i L#1 (64KB) + Core L#1 + PU L#1 (P#1)
      L2 L#2 (512KB) + L1d L#2 (64KB) + L1i L#2 (64KB) + Core L#2 + PU L#2 (P#2)
      L2 L#3 (512KB) + L1d L#3 (64KB) + L1i L#3 (64KB) + Core L#3 + PU L#3 (P#3)
      L2 L#4 (512KB) + L1d L#4 (64KB) + L1i L#4 (64KB) + Core L#4 + PU L#4 (P#4)
      L2 L#5 (512KB) + L1d L#5 (64KB) + L1i L#5 (64KB) + Core L#5 + PU L#5 (P#5)
      L2 L#6 (512KB) + L1d L#6 (64KB) + L1i L#6 (64KB) + Core L#6 + PU L#6 (P#6)
      L2 L#7 (512KB) + L1d L#7 (64KB) + L1i L#7 (64KB) + Core L#7 + PU L#7 (P#7)

base version:
queue mapping for /dev/nvme0n1
        hctx0: default 0 8
        hctx1: default 1 9
        hctx2: default 2 10
        hctx3: default 3 11
        hctx4: default 4 12
        hctx5: default 5 13
        hctx6: default 6 14
        hctx7: default 7 15

patched:
queue mapping for /dev/nvme0n1
        hctx0: default 0 1
        hctx1: default 2 3
        hctx2: default 4 5
        hctx3: default 6 7
        hctx4: default 8 9
        hctx5: default 10 11
        hctx6: default 12 13
        hctx7: default 14 15

  Package L#0 + L3 L#0 (16MB)
    L2 L#0 (512KB) + L1d L#0 (64KB) + L1i L#0 (64KB) + Core L#0
      PU L#0 (P#0)
      PU L#1 (P#1)
    L2 L#1 (512KB) + L1d L#1 (64KB) + L1i L#1 (64KB) + Core L#1
      PU L#2 (P#2)
      PU L#3 (P#3)
    L2 L#2 (512KB) + L1d L#2 (64KB) + L1i L#2 (64KB) + Core L#2
      PU L#4 (P#4)
      PU L#5 (P#5)
    L2 L#3 (512KB) + L1d L#3 (64KB) + L1i L#3 (64KB) + Core L#3
      PU L#6 (P#6)
      PU L#7 (P#7)
  Package L#1 + L3 L#1 (16MB)
    L2 L#4 (512KB) + L1d L#4 (64KB) + L1i L#4 (64KB) + Core L#4
      PU L#8 (P#8)
      PU L#9 (P#9)
    L2 L#5 (512KB) + L1d L#5 (64KB) + L1i L#5 (64KB) + Core L#5
      PU L#10 (P#10)
      PU L#11 (P#11)
    L2 L#6 (512KB) + L1d L#6 (64KB) + L1i L#6 (64KB) + Core L#6
      PU L#12 (P#12)
      PU L#13 (P#13)
    L2 L#7 (512KB) + L1d L#7 (64KB) + L1i L#7 (64KB) + Core L#7
      PU L#14 (P#14)
      PU L#15 (P#15)

base and patched:
queue mapping for /dev/nvme0n1
        hctx0: default 0 1
        hctx1: default 2 3
        hctx2: default 4 5
        hctx3: default 6 7
        hctx4: default 8 9
        hctx5: default 10 11
        hctx6: default 12 13
        hctx7: default 14 15

As mentioned I've decided to update only SCSI drivers which are already
using pci_alloc_irq_vectors_affinity with the PCI_IRQ_AFFINITY. These
drivers are using the auto IRQ affinity managment code, which is what is
the pre-condition for isolcpus to work.

Also missing are the FC drivers which support nvme-fabrics (lpfc,
qla2xxx). The nvme-fabrics code needs to be touched first. I've got the
patches for this, but let's first get the main change in shape.

After that, I can start updating one driver one by one. I think this
reduced the risk of regression significantly.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
Changes in v8:
- added 524f5eea4bbe ("lib/group_cpus: remove !SMP code")
- merged new logic into existing function, avoid special casing
- group_mask_cpus_evenly:
  - /s/group_masks_cpus_evenly/group_mask_cpus_evenly
  - updated comment on group_mask_cpus_evenly
  - renamed argument from cpu_mask to mask
- aacraid: added missing num queue calculcation (new patch)
- only update scsi drivers which support PCI_IRQ_AFFINIT,
  and do not support nvme-fabrics
- don't __free for cpumask_var_t, it seems incompatible
- updated doc to hightlight the CPU offlining limitation
- collected tags
- Link to v7: https://patch.msgid.link/20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org

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
Daniel Wagner (12):
      scsi: aacraid: use block layer helpers to calculate num of queues
      lib/group_cpus: remove dead !SMP code
      lib/group_cpus: Add group_mask_cpus_evenly()
      genirq/affinity: Add cpumask to struct irq_affinity
      blk-mq: add blk_mq_{online|possible}_queue_affinity
      nvme-pci: use block layer helpers to constrain queue affinity
      scsi: Use block layer helpers to constrain queue affinity
      virtio: blk/scsi: use block layer helpers to constrain queue affinity
      isolation: Introduce io_queue isolcpus type
      blk-mq: use hk cpus only when isolcpus=io_queue is enabled
      blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
      docs: add io_queue flag to isolcpus

 Documentation/admin-guide/kernel-parameters.txt |  22 ++-
 block/blk-mq-cpumap.c                           | 201 +++++++++++++++++++++---
 block/blk-mq.c                                  |  42 +++++
 drivers/block/virtio_blk.c                      |   4 +-
 drivers/nvme/host/pci.c                         |   1 +
 drivers/scsi/aacraid/comminit.c                 |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c          |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c       |   5 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                 |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c             |   5 +-
 drivers/scsi/pm8001/pm8001_init.c               |   1 +
 drivers/scsi/virtio_scsi.c                      |   5 +-
 include/linux/blk-mq.h                          |   2 +
 include/linux/group_cpus.h                      |   3 +
 include/linux/interrupt.h                       |  16 +-
 include/linux/sched/isolation.h                 |   1 +
 kernel/irq/affinity.c                           |  12 +-
 kernel/sched/isolation.c                        |   7 +
 lib/group_cpus.c                                |  63 ++++++--
 19 files changed, 353 insertions(+), 47 deletions(-)
---
base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
change-id: 20240620-isolcpus-io-queues-1a88eb47ff8b

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>


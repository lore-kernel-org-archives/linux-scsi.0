Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799A0212D96;
	Fri, 10 Jan 2025 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526406; cv=none; b=HPa00omCphg7jz4iBtNE6irH3eowZPvjm9bU35sjPwRmXfCkUAv68GPesWmh59L/E0/gGCeIGobnXkIK+hlFWmkfRsTIV+cziqxn0DusS4dWuWdyUn8v2fuveKOqL0ov+FYyS4RcWLGX762FLVVxnVZupeeIHX0HoB1TtEYCQfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526406; c=relaxed/simple;
	bh=8+1TkdvqacD8Nc4nf9rT0oLnAayacOVRY3LIe46qmxQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=D0gdzRBGE2LveV6bZJfmaaHHZZcHXFVy7VPol5E0lEW+W1alEGFNr1735JykjNxzFhVSvbi1dXb1dozSppqukkv9vu4XRYSi7yNgRSbTvl+aJYMd0RdMCqxgBHHJL91E4TZPFb6mgJ5BxG5UWqCLMHRpq9BuPXzdaDZKaMyvIZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZDP2TGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZDP2TGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833DEC4CED6;
	Fri, 10 Jan 2025 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526406;
	bh=8+1TkdvqacD8Nc4nf9rT0oLnAayacOVRY3LIe46qmxQ=;
	h=From:Subject:Date:To:Cc:From;
	b=eZDP2TGTbP+zwRmZEq/dbPBkfQp6zEg6QALsII4WFB4nr8ZA+ieVbzhkkuj3BMU60
	 goMqrIXQQ5gWP+qZ98OEl4vJBIYcwR6r+HwHgB65UM0QnEZRlTmwuPur4Xkd+YofLC
	 vVm9Z2EBa3bjXrNJ3oxbtGEwc3wjZtJKiFBWyWandr6JvHvBKqpaJeqvFjPoiHuORr
	 tc9gaND4h6pHX03srLnTxY0FfPKS52PLJ9MYrjmcIIyVClePzxuGgheSlI2EhyjOAO
	 980k/v6C/TpzUaIFJ4MOuvaZMsMOuV7ySL38AmCye8MV6kx81vVhtYMFMdJGKA1fZu
	 4dpjawxEfhIpQ==
From: Daniel Wagner <wagi@kernel.org>
Subject: [PATCH v5 0/9] blk: honor isolcpus configuration
Date: Fri, 10 Jan 2025 17:26:38 +0100
Message-Id: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD5KgWcC/23Q247CIBAG4FcxXC+G4dCye+V7bLyAdlCiKcpIo
 zF9d1H3oEkv/0n4ZvivjDBHJPa1uLKMY6SYhhrMx4J1WzdskMe+ZiaF1KKRgkdK++5QiMfEjwU
 LEgdnLXrdhmA9qw8PGUM8P9Dvdc3bSKeUL48dI9ynvxzMcSNwwa2H5tMHDcKqFRXCZY/sjo3yF
 WhnAVkB2TglUXU6tOYdUP+AFc0soCrQO4HYBXT1V++A/gNAwvwFugKmV8YE7wFBr3aYB9wvU96
 w9fTsKOOx1L5PP0VN0w3ilKOzjQEAAA==
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
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

I've splitted the parameter into input and output variable for
group_cpu_evenly as requested by Hannes.

The commit message on the "lib/group_cpus: honor housekeeping config when
grouping CPUs" is hopefully not missleading anymore. I've took the
liberty to updated the managed_irq documentation with the aim to reduce
confusion. I got some feedback that the text is hard to understand.
Obviously I added the warning on possible IO stalls when doing cpu
hotplug.

Daniel

(trimmed the To/Cc list, it was a bit large.)

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
      lib/group_cpus: honor housekeeping config when grouping CPUs
      blk-mq: use hk cpus only when isolcpus=managed_irq is enabled
      blk-mq: issue warning when offlining hctx with online isolcpus
      doc: update managed_irq documentation

 Documentation/admin-guide/kernel-parameters.txt |  46 +++++-----
 block/blk-mq-cpumap.c                           | 116 +++++++++++++++++++++++-
 block/blk-mq.c                                  |  43 ++++++++-
 drivers/block/virtio_blk.c                      |   5 +-
 drivers/nvme/host/pci.c                         |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  15 +--
 drivers/scsi/qla2xxx/qla_isr.c                  |  10 +-
 drivers/scsi/smartpqi/smartpqi_init.c           |   5 +-
 drivers/scsi/virtio_scsi.c                      |   1 +
 drivers/virtio/virtio_vdpa.c                    |   9 +-
 fs/fuse/virtio_fs.c                             |   6 +-
 include/linux/blk-mq.h                          |   2 +
 include/linux/group_cpus.h                      |   3 +-
 kernel/irq/affinity.c                           |   9 +-
 lib/group_cpus.c                                |  90 +++++++++++++++++-
 15 files changed, 304 insertions(+), 61 deletions(-)
---
base-commit: 844b8cdc681612ff24df62cdefddeab5772fadf1
change-id: 20240620-isolcpus-io-queues-1a88eb47ff8b

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>


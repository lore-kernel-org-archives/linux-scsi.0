Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27961BDA83;
	Tue,  6 Aug 2024 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946044; cv=none; b=qoE/32tgpPsU7wdaMfJWdyqPmmaADcQGfvjzVRS460gS4ZSAjPw3eLyUyag+bCwvIPGONo+ULD002pDro11qgiC4yU63lYEbOgum1DNBUANXYHxE90NtioewKyb7krk4zExc1GVfMfBdjDb/puO7s5bqrEzTOrXY9le0bl8ULm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946044; c=relaxed/simple;
	bh=93AYVZpRrj6lm4O7Qb7k2/uVL0vc/J6wJkb9Us1qvZo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=FD6WaIeWYo8zbD9wiUw4HDb0ysWX6xmsqRd0ODi+HkicGcT5Gv1bms+r6ue6QCOQmtqOl8RSmfXNSmwPpWMQy3bdV6rdKWXPBkG37Q2gYl2d05nEx2v9pURhRUbO34B55yyG3JBn8K0lDn1XWWzZW7AgodSQe2/LJu+mF8ljQWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=bdE6rmyt; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="bdE6rmyt"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B66AFDAD81;
	Tue,  6 Aug 2024 14:07:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946031; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=teO0kk0BCxxiBkmDiwCmJ6i1Z0/9DUe1bmDDcgLGwiU=;
	b=bdE6rmytiVbaYY4E76O8mJLxsXFV1Ev4yJ6M7m2N0Ac8Owil3m6K+uUoIdHA6Z4s6dS3Sk
	8cddqtTV16qosWiJckbw2sb8I7GcgKi87aJrinzDStTD3ixJtOREaodC6B/EFbJ33krdsV
	yRovL3HFU886TlkbjDsUgSq25Ym17nTRF2IkWkFK2EwB0dvIDEl4KoJVY/erzuEgSZCXWW
	z+u7nDKvfY+F+hCFyUA+XGYjXuL/7355ANe9pQqXN+PvEXQmMbS+dk83Z8VA3Anb7nhpyt
	zyWHh3cSoNdO3rB6XBWFE9Io45Zhpx8g+r8HVRwzC3GYTt+naEHBZBDaMUoCPw==
From: Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v3 00/15] honor isolcpus configuration
Date: Tue, 06 Aug 2024 14:06:32 +0200
Message-Id: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMkRsmYC/23NTQ6CMBCG4auQrq3pn1BdeQ/jgsJUJjGAHdtoC
 He3kBhdsHy/ZJ6ZGEFAIHYqJhYgIeHQ59C7gjVd3d+AY5ubKaGMKJXgSMO9GSNxHPgjQgTisrY
 WnKm8t47lwzGAx9eKXq65O6TnEN7rjySX9cvJLS5JLrh1sjw6b6Sw+kyRYN8CW7Ck/oFqE1AZU
 GWtFejG+OrwA+Z5/gD/MmGI8wAAAA==
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-doc@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

After the discussion with Ming on managed_irq, I decided to bring back
the io_queue option because managed_irq is clearly targetting a different
use case and Ming ask not to drop support for his use case.

In an offline discussion with Frederic, I learned what the plans are with
isolcpus. The future is in cpusets but reconfiguration happens only on
offline CPUs. I think this approach will go into this direction.

I've digged up Ming's attempt to replace the
blk_mq_[pci|virtio]_map_queues a more generic blk_mq_dev_map_queues
function which takes callback to ask the driver for an affinity mask for
a hardware queue. With this central function in place, it's also simple
to overwrite affinities in the core and the drivers don't have to be made
aware of isolcpus configurations.

The original attempt was to update the nvme-pci driver only. Hannes asked
me to look into the other multiqueue drivers/devices. Unfortunatly, I
don't have all the hardware to test against. So this is only tested with
nvme-pci, smartpqi, qla2xxx and megaraid. The testing also involved CPU
hotplug events and I was not able to observe any stalls, e.g. with hctx
which have online and offline CPUs. The only stall I was able to trigger
reliable was with qemu's PCI emulation. It looks like when a CPU is
offlined, the PCI affinity is reprogrammed but qemu still routes IRQs to
an offline CPU instead to newly programmed destination CPU. All worked
fine on real hardware.

Finally, I also added a new CPU-hctx mapping function for the isolcpus
case. Initially the blk_mq_map_queues function was used but it turns out
this will map all isol CPUs to the first CPU. The new function first maps
the housekeeping CPUs to the right htcx using the existing mapping logic.
The isol CPUs are then assigned evenly to the hctxs. I suppose this could
be done a bit smarter and also considering NUMA aspects when we agree on
this approach.

This series is based on linux-block/for-6.12/block. If this is the wrong
branch please let me know which one is better suited. Thanks.

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

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
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
Daniel Wagner (13):
      scsi: pm8001: do not overwrite PCI queue mapping
      scsi: replace blk_mq_pci_map_queues with blk_mq_dev_map_queues
      nvme: replace blk_mq_pci_map_queues with blk_mq_dev_map_queues
      virtio: blk/scs: replace blk_mq_virtio_map_queues with blk_mq_dev_map_queues
      blk-mq: remove unused queue mapping helpers
      sched/isolation: Add io_queue housekeeping option
      docs: add io_queue as isolcpus options
      blk-mq: add number of queue calc helper
      nvme-pci: use block layer helpers to calculate num of queues
      scsi: use block layer helpers to calculate num of queues
      virtio: blk/scsi: use block layer helpers to calculate num of queues
      lib/group_cpus.c: honor housekeeping config when grouping CPUs
      blk-mq: use hk cpus only when isolcpus=io_queue is enabled

Ming Lei (2):
      virito: add APIs for retrieving vq affinity
      blk-mq: introduce blk_mq_dev_map_queues

 Documentation/admin-guide/kernel-parameters.txt |   9 ++
 block/blk-mq-cpumap.c                           | 136 ++++++++++++++++++++++++
 block/blk-mq-pci.c                              |  41 ++-----
 block/blk-mq-virtio.c                           |  46 +++-----
 drivers/block/virtio_blk.c                      |   8 +-
 drivers/nvme/host/pci.c                         |   8 +-
 drivers/scsi/fnic/fnic_main.c                   |   3 +-
 drivers/scsi/hisi_sas/hisi_sas.h                |   1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c          |  20 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c          |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  18 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c                 |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |   3 +-
 drivers/scsi/pm8001/pm8001_init.c               |   9 +-
 drivers/scsi/qla2xxx/qla_isr.c                  |  10 +-
 drivers/scsi/qla2xxx/qla_nvme.c                 |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                   |   3 +-
 drivers/scsi/smartpqi/smartpqi_init.c           |  12 +--
 drivers/scsi/virtio_scsi.c                      |   4 +-
 drivers/virtio/virtio.c                         |  10 ++
 include/linux/blk-mq-pci.h                      |   7 +-
 include/linux/blk-mq-virtio.h                   |   8 +-
 include/linux/blk-mq.h                          |   7 ++
 include/linux/sched/isolation.h                 |  15 +++
 include/linux/virtio.h                          |   2 +
 kernel/sched/isolation.c                        |   7 ++
 lib/group_cpus.c                                |  75 ++++++++++++-
 27 files changed, 350 insertions(+), 123 deletions(-)
---
base-commit: f48ada402d2f1e46fa241bcc6725bdde70725e15
change-id: 20240620-isolcpus-io-queues-1a88eb47ff8b

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>


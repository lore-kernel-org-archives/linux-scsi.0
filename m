Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCAF2C08B8;
	Tue, 17 Jun 2025 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167810; cv=none; b=ZKHcMvTO7ZNyyakWgbjpERQY2GJGNpaTYuRAWsBQLOTslfNw/NnVkdPRfB3Ua+Bi/HH25UZ3eP6MeHPX8eBY/EgFxjzys6ntZlBGzcuEfx2X+OZDmLCe+0KDBnp/6YxqzPz/yS7r0o1m4HVfkMttM+ejTV5yKDrKyVOUqFCEfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167810; c=relaxed/simple;
	bh=Tq5rUOpjXriBkipN8jcjoOeGSv4ICYoTA0fxuVN9H94=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VSTv3D0YOrjjGVNYqblO3AMZxhvT25Q/pLiaZDpP6TpS/gYR2ODLeyvMamxDBhqlezpdHuYoYZ8tJzPBNhy45naX+LXCctdvoRCLHnGUc5Qqu5N0yW2POEpNcxcEkNjcYeQ4bqqw45DzwLPh4Ame0ntSG1SpBBi78h78Ld4+WvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2VMXZuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2VMXZuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4E8C4CEE3;
	Tue, 17 Jun 2025 13:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750167809;
	bh=Tq5rUOpjXriBkipN8jcjoOeGSv4ICYoTA0fxuVN9H94=;
	h=From:Subject:Date:To:Cc:From;
	b=H2VMXZuyU6kbuxsnxDZ0TmEkSbKr3URfhjt3ZDdyNXdL6ivkgmgNDPNrOX9KpE8un
	 67xPRwP+Ax/wzJc2Ag4PN0uQU0cP705b5qy8C4qngTFaBEQa1rH+Kzsv8IM6Vn+LEz
	 8CSQ9N0XBnKfvE5wmCJA7G0B8JA8f1RlR0EFVTmL5PUsJkpbPJXpnRcihFHL4WjTOf
	 sh6EN8lf7ZZku7gd9SslC/G2sikDNq5IMhqoNJJBKGmx43LT1noz6/VO4ojstrL4Vc
	 y/uoWybaf86e/LHNiEjgDrNXwLqD6NK2POmZIlEW+001ads1kk7oiwhiuB9jH9oZFZ
	 SdYtNHiRhxS/Q==
From: Daniel Wagner <wagi@kernel.org>
Subject: [PATCH 0/5] blk: introduce block layer helpers to calculate num of
 queues
Date: Tue, 17 Jun 2025 15:43:22 +0200
Message-Id: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPpwUWgC/x3MQQrCMBBG4auUWTuQxGpor1Jc1PirA5KkmUaE0
 rs3uPwW722kKAKlsduo4CsqKTbYU0fhPccXWB7N5Iy7mKv1LJo+IVflpaKCQ6pxRVHu3X02gPf
 nwVCrc8FTfv/zdNv3A/LaqlZpAAAA
X-Change-ID: 20250617-isolcpus-queue-counters-42ba0ee77390
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

I am still working on the change request for the "blk: honor isolcpus
configuration" series [1]. Teaching group_cpus_evenly to use the
housekeeping mask depending on the context is not a trivial change.

The first part of the series has already been reviewed and doesn't
contain any controversial changes, so let's get them processed
independely.

[1] https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
Changes in from https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org
- limit number of allocated masks to the max allocated number of masks
- commit message improvements
- typo fixes
- formatting fixed
- collected tags

---
Daniel Wagner (5):
      lib/group_cpus: Let group_cpu_evenly() return the number of initialized masks
      blk-mq: add number of queue calc helper
      nvme-pci: use block layer helpers to calculate num of queues
      scsi: use block layer helpers to calculate num of queues
      virtio: blk/scsi: use block layer helpers to calculate num of queues

 block/blk-mq-cpumap.c                     | 46 +++++++++++++++++++++++++++++--
 drivers/block/virtio_blk.c                |  5 ++--
 drivers/nvme/host/pci.c                   |  5 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 ++++++----
 drivers/scsi/qla2xxx/qla_isr.c            | 10 +++----
 drivers/scsi/smartpqi/smartpqi_init.c     |  5 ++--
 drivers/scsi/virtio_scsi.c                |  1 +
 drivers/virtio/virtio_vdpa.c              |  9 +++---
 fs/fuse/virtio_fs.c                       |  6 ++--
 include/linux/blk-mq.h                    |  2 ++
 include/linux/group_cpus.h                |  2 +-
 kernel/irq/affinity.c                     | 11 ++++----
 lib/group_cpus.c                          | 16 +++++------
 13 files changed, 89 insertions(+), 44 deletions(-)
---
base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
change-id: 20250617-isolcpus-queue-counters-42ba0ee77390

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>


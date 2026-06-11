Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD022DC78C;
	Thu, 11 Jun 2026 02:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781145844; cv=none; b=u15bOtQK2nW5DXka2DNNlf5b6I7ciPxkILZEiGvBaUjHe4KYJMD8nTFWzZQqd5mnCz22ztIR4LFG7HefT6/jJ4uQ7iAylbLRAptNuJb+S+KdWeMIUnZQCAjjD8EIidQcrhR5RWCFn7nMXR/tc4aW/90hhbCEKdhchGTaaQ3Z0nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781145844; c=relaxed/simple;
	bh=JqTCJN8xWMwtcK4u3aAL9KRShA4ikX+VLLL8qMz6uuE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UY4vyXATDFzU7D19D7/vSqDXm2iBRR6FPgLM6WeATRnItF0JQobv7DO3DrYCcCpUjEO8d6BUX7afHVrU3VAQeb1v26ReqtRYwKX3zzEQpuvrkfmM9ZTTq51SVxV+PWIAxiXsUtMVWb3eTzMHWuUPJIUKvlCkqRrt+L0xA1W4dE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=W4Ivqarw; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="W4Ivqarw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1781145841;
	bh=JqTCJN8xWMwtcK4u3aAL9KRShA4ikX+VLLL8qMz6uuE=;
	h=From:To:Cc:Subject:Date:From;
	b=W4IvqarwhHMVErHxo4ToWsX7Va4fpCz2qCC9VW0C1vHomzeMyFXtZYB2Mz3ckIOVl
	 hwh4cUoxvh/IsZfTGdoMXc+xZdLx8VITnCSyRAxF3GsLsYjU4NhTUziW1Yv2as8isi
	 fdBhPUIC/DLLUMFTrbmQ7g9xoX7XYQTd41oFDTDk=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 4BED7BD70C;
	Thu, 11 Jun 2026 02:44:01 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 020D45FC0E;
	Thu, 11 Jun 2026 03:44:01 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v7 0/6] libata-scsi: multi-LUN ATAPI device support
Date: Thu, 11 Jun 2026 03:43:50 +0100
Message-ID: <20260611024356.2769320-1-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some ATAPI devices expose more than one logical unit behind a single ATA
target: Panasonic/COMPAQ PD/CD combo drives (LUN 0 = CD-ROM, LUN 1 =
PD), and Nakamichi CD changers (one LUN per disc slot, up to 7).

libata has historically hard-coded shost->max_lun = 1, so the SCSI
layer never scans past LUN 0 on any ATA-attached device.  This series
lifts that restriction for ATAPI devices gated by BLIST_FORCELUN.

Changes since v6
================

Addressing review from Hannes Reinecke (v6 review) and automated
analysis (Sashiko):

Patch 1: MODULE_PARM_DESC clarified to describe the parameter as a
count of LUNs (not a maximum LUN number), and the range corrected from
"1..7" to "1..8" (eight LUN slots, values 0..7).

Patch 2:
  - Drop the nr_luns companion field.  The ATAPI_MAX_LUN constant (8)
    is the correct fixed bound for all iterations; nr_luns adds
    complexity without benefit since sdev[] slots not populated are
    always NULL.  Use ATAPI_MAX_LUN throughout (Hannes Reinecke).
  - Fix ata_port_detach UAF window: clear dev->sdev[lun] to NULL before
    the spin_unlock, then pass the saved pointer to scsi_remove_device()
    (Hannes Reinecke).
  - ata_scsi_sdev_destroy: trigger ATA-level detach only when all LUN
    slots are NULL, not only on LUN 0 destruction.
  - ZPODD: iterate all LUN slots in zpodd_enable_run_wake(),
    zpodd_post_poweron(), and zpodd_wake_dev() (Hannes Reinecke).
  - ata_scsi_dev_rescan: snapshot all LUN sdevs under the spinlock
    before releasing it; release remaining refs on early exit paths.

Patch 3:
  - atapi_xlat(): always clear CDB byte 1 bits 7:5 first, then set them
    only for non-zero LUNs.  This avoids silently zeroing those bits on
    every LUN-0 command regardless of LUN, and separates the "zero for
    LUN 0" from the "encode LUN" paths.
  - On WARN_ON_ONCE overflow, set scmd->result = DID_ERROR before
    returning so the SCSI layer does not treat the aborted command as
    a success.

Patch 4:
  - Move the BLIST_NO_LUN_1F -> pdt_1f_for_no_lun assignment from
    scsi_add_lun() to scsi_probe_and_add_lun(), immediately before the
    PDT=0x1f check.  scsi_add_lun() is called after that check, so the
    v6 placement was too late to suppress LUN 0 if it returned
    PDT=0x1f.

Patch 5:
  - Call ata_scsi_assign_ofnode() before scsi_device_put(), so the
    reference to dev->sdev[0] is still held during the OF node
    assignment.

Patches 3/6, 4/6, and 5/6 carry Reviewed-by from Hannes Reinecke
(unchanged from v6).

Series structure
================

  1/6  ata: libata-scsi: add atapi_max_lun module parameter
  2/6  ata: libata-scsi: convert dev->sdev to per-LUN array
  3/6  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  4/6  scsi: add BLIST_NO_LUN_1F blacklist flag
  5/6  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  6/6  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk

Testing
=======

Tested on real hardware (Panasonic/COMPAQ LF-1195C on Intel ICH5 PATA):
  [x] Boot with CD inserted: sr0 attaches, mount and read files
  [x] Boot with PD inserted: sda attaches at correct capacity
      (1298496 x 512 B = 634 MiB)
  [x] All seven LUNs scanned (atapi_max_lun=7); LUNs 2..6 correctly
      report PDT 0x1f and are silently skipped
  [x] Single-LUN ATAPI CD-ROM (LITE-ON iHAS124): no regression,
      only LUN 0 scanned

Known limitations
=================

Media-change events are not propagated across LUNs of a SINGLELUN
multi-LUN device.  The SCSI layer's UA handling is per-sdev.  On the
PD/CD combo, swapping media and then accessing the other LUN may return
stale capacity until a manual rescan:

  echo 1 > /sys/class/scsi_device/H:0:0:1/device/rescan

A follow-up patch to propagate media-change events to sibling LUNs is
deferred to keep this series focused on the LUN-scanning core.

Phil Pemberton (6):
  ata: libata-scsi: add atapi_max_lun module parameter
  ata: libata-scsi: convert dev->sdev to per-LUN array
  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  scsi: add BLIST_NO_LUN_1F blacklist flag
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk

 drivers/ata/libata-acpi.c   |   9 +-
 drivers/ata/libata-core.c   |  16 ++-
 drivers/ata/libata-scsi.c   | 226 ++++++++++++++++++++++++------------
 drivers/ata/libata-zpodd.c  |  27 ++++-
 drivers/ata/libata.h        |   1 +
 drivers/scsi/scsi_devinfo.c |   2 +
 drivers/scsi/scsi_scan.c    |   3 +
 include/linux/libata.h      |  11 +-
 include/scsi/scsi_devinfo.h |   6 +-
 9 files changed, 210 insertions(+), 91 deletions(-)

base-commit: a3f75e5e6b023958c92ad03fa2e68e047b6169c4
--
2.43.0


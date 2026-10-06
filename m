Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A8F4EFFCA;
	Tue,  6 Oct 2026 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330129; cv=none; b=OduTCkseMNSj9f+CzJAD7a1/uWpuWrThjMCJpL7faDv+ZhHiElkHtsn5l0u13rFUPHpSO7xhm8v5umvnC8KXV2Mtd5P5REuH0lUmTxopszXe7z6y/+DlcfF172a+UbpVSj50lSMbPxcSe3YvjVDABn+SJiqG1a+ErXun1gnrlWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330129; c=relaxed/simple;
	bh=tVJFHoguFXpKTgnNN7F+FhxVkgq1eA9ju9K/WHNOqhY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gqeGWtNX31s7UwAFZ3G/3pAtYp/FAisiOC3b5R+tbQcXdySuIFsFBhraNRCkn/ZJI99LhMwchYeKd5lBFDMFWb5ijNyaPQPpVcROVhkgOSdvs6c8xrS7VUAeGNiy2JgXke9sYmI+UiDUzY7cdhYH5+VnJXuG9zsoAAVkQTBKKko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=XgR1HgFp; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="XgR1HgFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330125;
	bh=tVJFHoguFXpKTgnNN7F+FhxVkgq1eA9ju9K/WHNOqhY=;
	h=From:To:Cc:Subject:Date:From;
	b=XgR1HgFpZUFlcUt1Zqc18dcM1/yXQYhzxt5c/zFRv4JLs7cGLJYXcrWzoo7bee2j9
	 ZG3CRCoSbo2pd8MoF5ANypEfF/LYASw/aGgH1DOrjjWFayAhiJRocLyxVcYEjVGIMH
	 nJuucpUBDTkc/ApCr+/lx1t/vqHNRjGrXVKeDJ9E=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 7A423BD57A;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id F10B15FADC;
	Wed,  7 Oct 2026 00:42:04 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v9 00/11] ata: add multi-LUN support for ATAPI devices
Date: Wed,  7 Oct 2026 00:41:50 +0100
Message-ID: <20261006234202.1139018-1-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for multi-LUN ATAPI devices, including the
Panasonic/COMPAQ PD/CD drives. These expose the CD-ROM on LUN 0 and the
PD drive on LUN 1. libata currently scans only LUN 0.

It also fixes stale CD capacity after swapping between PD and CD media.

Patches 1-3 fix existing bugs in device removal, power management and
quirk matching. Patches 4-5 fix sr's initial block size and handling of
media changes. Patches 6-11 add the multi-LUN support.

Set libata.atapi_max_lun=8 to scan LUNs 0-7 on devices with BLIST_FORCELUN.
The default is 1 (LUN 0 only). A manual scan can restore a deleted LUN.

Changes since v8 (Sashiko's reviews and local review):
- Rebased onto mainline and split out the three upstream fixes as 1-3.
- 4: set sr's initial block size when the medium is unavailable. Check
  for ready media first so 512-byte media keep the correct queue limits.
- 5: retry incomplete revalidation on the next open. If the drive reports
  NOT READY / 04 / 01 during revalidation, fail the blocking open and
  leave revalidation pending for the next attempt.
- 7: release rescan references outside the spinlock, continue scanning
  other LUNs when one needs a retry, and reject invalid LUN numbers.
- 7, 10: use the referenced SCSI device when assigning the OF node.
- 8: preserve CDB byte 1 for LUN 0, check the SCSI-2 LUN limit, and request
  sense from the LUN whose command failed. Allow device removal to find
  the ATA device after error handling changes its class.
- 9: separate the scan flag from bitfields updated during I/O.
- 10: support wildcard and targeted user scans of missing secondary LUNs.

Patches 8 and 10 also fix bugs introduced in earlier versions of this
series. I've kept the review tags on 6 and 11 and removed them from the
revised patches 7-10.

Hardware testing on a COMPAQ PD-1 LF-1195C (firmware A110), i686:
- Boot with PD inserted, replace it with a CD, then mount: successful.
- Reinsert a CD and mount immediately during spin-up: the early mount
  reported no medium; a later mount succeeded without ejecting or
  rescanning, with the correct geometry and readable files.
- CD A -> PD -> CD B: mount succeeded and capacity grew from 262704 to
  1311404 512-byte sectors; logical block size remained 2048 bytes.
- CD B's final logical block (LBA 327850) was read successfully, beyond
  CD A's former capacity.
- CD B -> PD -> CD A: reported capacity returned to 262704 sectors with
  2048-byte logical blocks.

Known limitations:
- Capacity and block size are refreshed when the device is opened. The
  sysfs values can remain stale until then.
- READ CAPACITY failures can still leave stale capacity. The existing
  fallback for audio CDs and older drives is unchanged.

The patches carry Assisted-by: LLM.

v8: https://lore.kernel.org/linux-ide/20260731213503.2379771-1-philpem@philpem.me.uk/

Phil Pemberton (11):
  ata: libata-core: pin SCSI devices during port detach
  ata: libata-zpodd: reference SCSI devices in PM callbacks
  scsi: scsi_devinfo: preserve full-width quirk identifiers
  scsi: sr: initialize logical block size before registering the disk
  scsi: sr: retry unfinished media revalidation on the next open
  ata: libata-scsi: add atapi_max_lun module parameter
  ata: libata-scsi: convert dev->sdev to per-LUN array
  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  scsi: add BLIST_NO_LUN_1F blacklist flag
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk

 drivers/ata/libata-acpi.c   |   9 +-
 drivers/ata/libata-core.c   |  20 ++-
 drivers/ata/libata-eh.c     |  10 +-
 drivers/ata/libata-scsi.c   | 247 ++++++++++++++++++++++++------------
 drivers/ata/libata-zpodd.c  |  55 +++++++-
 drivers/ata/libata.h        |   5 +-
 drivers/scsi/scsi_devinfo.c |  13 +-
 drivers/scsi/scsi_scan.c    |   3 +
 drivers/scsi/sr.c           |  39 ++++--
 drivers/scsi/sr.h           |   2 +
 include/linux/libata.h      |  11 +-
 include/scsi/scsi_device.h  |   4 +-
 include/scsi/scsi_devinfo.h |   6 +-
 13 files changed, 300 insertions(+), 124 deletions(-)


base-commit: 22430ae5d90ab288b0ee2ad99ae941f4a666b694
-- 
2.43.0

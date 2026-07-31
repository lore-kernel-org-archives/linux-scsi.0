Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B72431F9BD;
	Fri, 31 Jul 2026 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534759; cv=none; b=Rp6Xli/qQU3PAPpRjxuumGS/+6XKHe/bn1htLiHdNaR8gT+C7vKPs8n9TmS9N852+CNY0om5wHbaNq7FVEjO0MQgDhqBAomSSYSf20hCBC1b5Mp8EgFGwdbgmr/IxX+NxYCg0JOTNodQ0Xc1hul6bwiDhO5ZYGhqYR09oQjKgF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534759; c=relaxed/simple;
	bh=7aYBdA4bV0sDMBkaaaW9nPRAms+/npRBrwp0PQFixlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oci0jp9dWd0Dl1jTnZzPHs/UaIxrRmRiR0Ban1loSFNdk9vKwnusMh9OJFoUhPRgimOcOvSxDPvXjYc1m8KYutudR1jBhzxT4uE2Tb0o+i8NooUbZagO8/kOaDHOed2WI/Q+gmvP5/aBTNeKgtzYGU8lrnIn5EMYuWrjNGMROmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Qv0Amodj; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Qv0Amodj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1785533714;
	bh=7aYBdA4bV0sDMBkaaaW9nPRAms+/npRBrwp0PQFixlQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Qv0Amodj8qrly4d5ie6fS8nUQwbn6jr2sRG4unuMLFdokhRTRrktG24q6J4TXN1tt
	 r4Xsau4Yx+hWmnDyXwrZ9gwHRnaRY/SkG24cJ3/SJZdC/35BTqNkXBWQBTDrYkIOHt
	 ApdaiHKQsKqAL5HUgrdo2XSB7Bg2CmB6tXOxHJ5c=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 8BC6EBD3BB;
	Fri, 31 Jul 2026 21:35:14 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 5763A5F888;
	Fri, 31 Jul 2026 22:35:14 +0100 (BST)
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
Subject: [PATCH v8 0/6] libata-scsi: multi-LUN ATAPI device support
Date: Fri, 31 Jul 2026 22:34:57 +0100
Message-ID: <20260731213503.2379771-1-philpem@philpem.me.uk>
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

Resend at Damien's request.

Changes since v7
================

No code changes.  v8 is v7 rebased onto libata/for-next
(c303c3619a1d) and with previously-given review tags collected.  The
rebase was clean; the per-patch diffs are byte-identical to v7.

Review tags collected
=====================

Several tags given on earlier postings were not carried forward into
v7.  They are restored here, along with the tags given on v7 itself:

  1/6  Reviewed-by: Damien Le Moal        (given on v5 1/6)
  2/6  Reviewed-by: Hannes Reinecke       (given on v7 2/6)
  4/6  Reviewed-by: Martin K. Petersen    (given on v6 4/6)
  6/6  Reviewed-by: Damien Le Moal        (given on v3 6/7)
       Reviewed-by: Hannes Reinecke       (given on v7 6/6)
       Reviewed-by: Martin K. Petersen    (given on v6 6/6)

Patches 3/6 and 5/6 carry the tags Hannes gave on v6; both patches
changed between v6 and v7 in response to his own review comments, and
he did not object when v7 was posted.  Hannes's tag on 1/6 is from v2,
where he signed as <hare@suse.de>; his later tags use <hare@kernel.org>,
and each is transcribed as given.

Damien reviewed both 4/6 and 6/6 on v3, but only the 6/6 tag is carried
here: 6/6 is a one-line scsi_devinfo table entry that has not changed
materially since, whereas 4/6 was reworked afterwards (the
pdt_1f_for_no_lun assignment moved from scsi_add_lun() to
scsi_probe_and_add_lun()), so carrying that one seemed wrong.

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

Hardware testing was done on the v7 code (Panasonic/COMPAQ LF-1195C on
Intel ICH5 PATA); since v8 is the same code rebased, those results
carry over:

  [x] Boot with CD inserted: sr0 attaches, mount and read files
  [x] Boot with PD inserted: sda attaches at correct capacity
      (1298496 x 512 B = 634 MiB)
  [x] All seven LUNs scanned (atapi_max_lun=7); LUNs 2..6 correctly
      report PDT 0x1f and are silently skipped
  [x] Single-LUN ATAPI CD-ROM (LITE-ON iHAS124): no regression,
      only LUN 0 scanned

On the new base, each patch has been compile-tested individually so
the series stays bisectable.

Known limitations
=================

Media-change events are not propagated across LUNs of a SINGLELUN
multi-LUN device.  The SCSI layer's UA handling is per-sdev.  On the
PD/CD combo, swapping media and then accessing the other LUN may return
stale capacity until a manual rescan:

  echo 1 > /sys/class/scsi_device/H:0:0:1/device/rescan

A follow-up series addressing this (sibling-LUN media-change
propagation, gated on a new BLIST flag) is in preparation and will be
posted separately once this series lands.  It is kept out of this
series to avoid gating the LUN-scanning core on a new blacklist flag
and a retry policy that will need their own review.

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


base-commit: c303c3619a1d5cf7d4b457106062d16724724a80
-- 
2.43.0


Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A2F329E55;
	Thu,  9 Apr 2026 21:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775768773; cv=none; b=qw0qaB+UBEGXBhJXGRSfAiGgavz+hqoZsJJcUOI9BofBwXBJVYC7NTJArYI+AuOr+bRVPy1umAQ880k7xUnZS68mO6lJ4mpXDtMvpXdcErF//1oyYtCy3J/tawhuOk3sZNQdpTcoCtdgnj5JtosJFzJEIIUOFfomA9ZhKAFeQdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775768773; c=relaxed/simple;
	bh=LZRSc3ws+hA05ffZ6eP+5ye0375utWSgNdrh2BPpoJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p2Ws9qhORau6gDaAo0c8zZ/7fF5HyjAy7vG/BaWZIU+Kydwiqo3tePsHQRnvLMJZAB0SBA+l8bWZflEDr2+27wwfeoFTHXlbSHlgsR5fYC4sn3YrVBubpthl6hJh6swHEy62HwKduLaA76iJy3Hv+YUFHHaMFNVNvyPvJW1AQis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=iGTExLeU; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="iGTExLeU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1775768768;
	bh=LZRSc3ws+hA05ffZ6eP+5ye0375utWSgNdrh2BPpoJc=;
	h=From:To:Cc:Subject:Date:From;
	b=iGTExLeUZq+A93RNKCI+2BlCNJQtmCzJhV8WlRLaK7iZIiR8MCuMhLStSg5X07fa+
	 8aZyxN4pxkHHgrxIc9pZ3AY9W+xKVswr81/hNCTvfr7RP/ih3q7jzaA89Lg4X6xLMT
	 /hI8iKlY6cwUc+zqiJGIU0erDxjdrKOjOZqfUHI0=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id BA1C0BE5E3;
	Thu,  9 Apr 2026 21:06:08 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 357115F938;
	Thu,  9 Apr 2026 22:06:08 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: dlemoal@kernel.org,
	cassel@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [RFC PATCH 0/3] ata: libata-scsi: add multi-LUN support for ATAPI devices
Date: Thu,  9 Apr 2026 22:05:56 +0100
Message-ID: <20260409210559.155864-1-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series gives libata support for ATAPI devices with multiple LUNs,
such as the Panasonic PD-1 PD/CD combo drive. This exposes both the
CD-ROM and rewritable PD optical interfaces: CD-ROM as LUN 0 and PD
as LUN 1.

libata has never supported multi-LUN ATAPI. This series adds support
by fixing the following limitations:

  1. shost->max_lun is hardcoded to 1 in ata_scsi_add_hosts(), preventing
     the SCSI layer from probing any LUN beyond 0.

  2. __ata_scsi_find_dev() rejects all commands where scsidev->lun != 0,
     returning NULL and resulting in DID_BAD_TARGET.

  3. The SCSI-2 CDB LUN field (byte 1, bits 7:5) is never populated.
     ATAPI tunnels SCSI commands over the ATA PACKET interface, and the
     transport-layer LUN addressing used by SPC-3+ is not available.
     Older multi-LUN ATAPI devices rely on this CDB field to route
     commands to the correct LUN.

  4. ata_scsi_scan_host() only calls __scsi_add_device() for LUN 0,
     never probing additional LUNs even when the SCSI device info table
     would indicate the device supports them.

  5. ata_scsi_dev_config() assigned dev->sdev for every LUN, and
     ata_scsi_sdev_destroy() tore down the entire ATA device whenever
     any sdev was destroyed -- so removing a spurious LUN result during
     scanning would kill the whole port.

The series is split as:

  1/3: scsi_devinfo: add the COMPAQ-branded variant of the PD-1 to the
       device info table.  An entry already exists for the Panasonic
       OEM-branded "MATSHITA PD-1" and the NEC "NEC PD-1 ODX654P".

  2/3: libata-scsi: raise max_lun, route non-zero LUNs to the same
       ata_device for ATAPI, encode the LUN in CDB byte 1, and fix the
       slave_configure/slave_destroy callbacks to track LUN 0 only.

  3/3: libata-scsi: probe additional LUNs in ata_scsi_scan_host() for
       ATAPI devices flagged BLIST_FORCELUN, stopping at PDT 0x1f.

Tested on a Panasonic LF-1195C PD/CD (Compaq branded) attached to an
ata_piix host on i686. The CD-ROM enumerates as an 'sr' device and
the PD side enumerates as an 'sd' block device. Both LUNs work for I/O:
the CD reads correctly, and the PD drive can be partitioned, formatted
and mounted. An iHAS124 DVD writer on the same machine (single-LUN, no
BLIST_FORCELUN entry) is unaffected: it does not enter the multi-LUN
probing path.

If the iHAS124 is scanned regardless, it seems to ignore the LUN
parameter, and enumerates as eight drives. I expect most standard ATAPI
devices would behave this way, hence the BLIST_FORCELUN gate.

The "PDT 0x1f" check is based on the behaviour of the Panasonic PD/CD
drive: when an unrecognised LUN is probed, it responds with SCSI
peripheral device type 0x1F (no device).

All testing was done on kernel 7.0.0-rc7+.

This is marked RFC because:

  - The CDB-byte-1 LUN encoding is a SCSI-2-era convention that may
    affect well-behaved modern devices in unexpected ways.  It is
    currently applied to all non-zero LUN commands on ATAPI devices;
    a more conservative approach would gate it on a quirk flag.

  - The blast radius of changing __ata_scsi_find_dev() and the slave
    callbacks deserves wider review, even though all changes are
    conditional on dev->class == ATA_DEV_ATAPI or sdev->lun == 0.

  - I do not have other multi-LUN ATAPI hardware to test against.

Comments and suggestions welcome.

Phil Pemberton (3):
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
  ata: libata-scsi: enable multi-LUN support for ATAPI devices
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices

 drivers/ata/libata-scsi.c   | 67 ++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_devinfo.c |  1 +
 2 files changed, 64 insertions(+), 4 deletions(-)

--
2.39.5


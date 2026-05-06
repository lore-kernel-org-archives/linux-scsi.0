Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AF462809;
	Wed,  6 May 2026 23:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778111159; cv=none; b=A4DYtKFYNkb5FFzMIwRGYV801qQ3QVY/f/gSO2tJm/0WwcsOUyW3dbPzHTFQzrLQkv8nkH6/HrATXPAth/BONdTLQNTAPxvGUU/UFLg4Tr22vpQ0REsHCP1YKuSu6gyrPa4fX9OnHsUoT4QaXwaWqjmuKi7qvlynERBtAzXQr0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778111159; c=relaxed/simple;
	bh=qJ+np+8O5wz7m1vWjuaQKj1LYUTIbZmMzvAqL317g4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BhQ9Nu4Lt/Z1mulu3r7er66Y3Yxk4FGQ0WKyKrVpGSrJoLTFWdcsSqSr97aGOmNNtaogl2l4kd42u8XzwcVXiP8gMZpXIrZOdAueBnCPIG5T3ejIZZ4HP0WiXeDcqWzRt5EtmOamLaO+4d5zlTjZPCy2bzC/PhI+6y0P5hnszoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=pokDPXzH; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="pokDPXzH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1778111153;
	bh=qJ+np+8O5wz7m1vWjuaQKj1LYUTIbZmMzvAqL317g4w=;
	h=From:To:Cc:Subject:Date:From;
	b=pokDPXzHAe7gdKL6l39L/i4SRtw2BU2oCabO29OcA4/7ofkqE5SjL9hEvNB7xIREt
	 +ADTNtielhpesB8XQgoyVk+hxVBJURujbUzXlOVBoWcSEh2xzm72Si//LfufROHSa7
	 YZG+NcXcphOrTslN7r33HyvzFNzvVnNCoqkttyak=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id D48D9BD55C;
	Wed,  6 May 2026 23:45:53 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 714A25F8AD;
	Thu,  7 May 2026 00:45:53 +0100 (BST)
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
Subject: [PATCH v4 0/7] ata: libata-scsi: multi-LUN ATAPI device support
Date: Thu,  7 May 2026 00:45:41 +0100
Message-ID: <20260506234548.1974603-1-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This is v4, addressing review feedback from Damien Le Moal and Hannes
Reinecke on v3.

This series gives libata support for ATAPI devices with multiple LUNs,
such as the Panasonic PD-1 PD/CD combo drive.  This exposes both the
CD-ROM and rewritable PD optical interfaces: CD-ROM as LUN 0 and PD
as LUN 1.

libata has never supported multi-LUN ATAPI.  This series adds support
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

  5. dev->sdev is a single pointer, but multi-LUN ATAPI puts multiple
     sdevs behind one ata_device.  Every call to ata_scsi_dev_config()
     overwrote the pointer, and ata_scsi_sdev_destroy() tore down the
     entire ATA device whenever any sdev was destroyed -- so removing a
     spurious LUN result during scanning would kill the whole port, and
     the other users of dev->sdev (scsi_remove_device in
     ata_port_detach(), ACPI uevents, zpodd, media-change notify,
     suspend/resume rescan) could only ever see one LUN.

Changes from v3:

  - 1/7 unchanged; carries Hannes' Reviewed-by from v2.

  - 2/7 (sdev array): added a per-device dev->nr_luns field so the
    common single-LUN case iterates one slot rather than ATAPI_MAX_LUN
    (8).  Added an inline ata_dev_scsi_device(dev, lun) helper with a
    WARN_ON_ONCE(lun >= dev->nr_luns) bounds check, and converted the
    hardcoded LUN-0 references in libata-acpi (uevent kobj),
    libata-zpodd (disk events, wake notify), and the door-lock and
    OF-node paths in libata-scsi to use it.  Hannes' v2 Reviewed-by
    has been dropped given the scope of the rework.

  - 3/7 (LUN routing): hoisted the non-zero LUN handling to the top of
    __ata_scsi_find_dev() so the original channel/id rejection logic
    is left structurally unchanged.  Replaced the bare "lun >= 8" gate
    in atapi_xlat() with WARN_ON_ONCE(lun >= dev->nr_luns); the SCSI
    layer caps lun at shost->max_lun (<= ATAPI_MAX_LUN), so this
    should never trigger in practice.

  - 4/7 (BLIST_NO_LUN_1F): use sdev->sdev_bflags (just assigned)
    rather than re-dereferencing *bflags, and dropped a stray blank
    line.  Picked up Reviewed-by tags from Damien and Hannes.

  - 5/7 (probe extra LUNs): dropped the introduced inner { } scope
    around sdev so the declaration sits at its original spot at the
    top of the loop body.  Bump dev->nr_luns to the host's max_lun
    before calling scsi_scan_target() so the probe INQUIRYs to LUN > 0
    are accepted by atapi_xlat().  Stale "see patch X" cross-references
    have been removed from the changelog.

  - 6/7 (COMPAQ PD-1): unchanged; picked up Reviewed-by tags from
    Damien and Hannes.

  - 7/7 (MATSHITA + NEC PD-1): unchanged; picked up Reviewed-by tag
    from Damien.  Kept as a separate patch from 6/7: the variants are
    untested (the author only has the COMPAQ unit), and being a
    standalone patch lets maintainers drop or hold it independently
    from the rest of the series.

The series is split as:

  1/7: libata-scsi: add libata.atapi_max_lun module parameter.

  2/7: libata-scsi: convert dev->sdev to a per-LUN array, add
       dev->nr_luns and the ata_dev_scsi_device() helper, and update
       every caller.

  3/7: libata-scsi: relax __ata_scsi_find_dev() to accept non-zero LUN
       for ATAPI devices, and encode the LUN in CDB byte 1 bits 7:5.

  4/7: scsi: add a BLIST_NO_LUN_1F blacklist flag, which sets
       scsi_target.pdt_1f_for_no_lun for matching devices so that
       PDT 0x1f / PQ 0 INQUIRY responses are treated as "LUN not
       present" and silently skipped.

  5/7: libata-scsi: after adding LUN 0, trigger scsi_scan_target() for
       BLIST_FORCELUN ATAPI devices only.  Single-LUN devices are
       completely unaffected.

  6/7: scsi_devinfo: add the COMPAQ-branded variant of the PD-1 to the
       device info table with BLIST_FORCELUN | BLIST_SINGLELUN |
       BLIST_NO_LUN_1F.

  7/7: scsi_devinfo: extend BLIST_NO_LUN_1F to the MATSHITA and NEC
       PD-1 variants. Untested on those OEM units (the author only
       has the COMPAQ-branded drive), but all three appear to use the
       same Panasonic LF-1095/LF-1195 mechanism and firmware family,
       so the quirk is expected to apply equally. Kept separate so
       it can be dropped independently if confirmation on MATSHITA or
       NEC hardware is preferred.

Tested on a Panasonic LF-1195C PD/CD (Compaq branded) attached to an
ata_piix host on i686, kernel 7.0.0-rc7+, with libata.atapi_max_lun=7.
Both LUNs enumerate correctly: the CD-ROM as sr0 and the PD as sda.
Reads from each device succeed against the appropriate media.
Non-responding LUNs are silently skipped (no spurious "No Device"
entries in dmesg).  An iHAS124 DVD writer on the same machine
(single-LUN, no BLIST_FORCELUN entry) is unaffected: only LUN 0 is
scanned.

Two known limitations around media-change detection on multi-LUN
ATAPI devices with a shared physical media slot (e.g. PD/CD combos
flagged BLIST_SINGLELUN):

1. The block layer disables in-kernel polling by default
   (block.events_dfl_poll_msecs defaults to 0).  Without polling,
   sd_check_events never runs and media insertion on the PD LUN is
   not detected automatically.  sr_mod is unaffected because it
   re-reads the TOC on every open.

   Workaround -- either globally via kernel boot parameter:

       block.events_dfl_poll_msecs=2000

   or per-device via udev rule:

       ACTION=="add", KERNEL=="sd*", \
         ATTRS{vendor}=="COMPAQ  ", ATTRS{model}=="PD-1*", \
         ATTR{events_poll_msecs}="2000"

   Even with polling enabled the sd path does not always pick up
   fresh media on this firmware; `blockdev --rereadpt /dev/sdX`
   reliably forces a revalidate and proves the libata routing
   itself is correct.

2. Media-change sense is not propagated across sibling LUNs.  When
   one LUN reports UNIT ATTENTION (ASC 0x28 or 0x3A), the other LUNs
   are not notified.  With polling enabled, sd_check_events detects
   the change independently on each LUN via TUR, so this is mainly a
   latency issue rather than a functional one.  A follow-up to
   propagate media-change events to sibling LUNs in
   atapi_qc_complete is straightforward but deferred to keep this
   series focused on the LUN-scanning core.

Suspend/resume with multi-LUN ATAPI attached has not yet been tested;
this is on the list.  ata_scsi_dev_rescan iterates all populated LUN
slots, and the SCSI layer's host-level suspend tracking already
serialises port quiesce, so no additional per-LUN suspend counting
is needed in libata.

Comments and suggestions welcome.

Phil Pemberton (7):
  ata: libata-scsi: add atapi_max_lun module parameter
  ata: libata-scsi: convert dev->sdev to per-LUN array
  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  scsi: add BLIST_NO_LUN_1F blacklist flag
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
  scsi: scsi_devinfo: extend BLIST_NO_LUN_1F to MATSHITA and NEC PD-1
    variants

 drivers/ata/libata-acpi.c   |   6 +-
 drivers/ata/libata-core.c   |  16 ++-
 drivers/ata/libata-scsi.c   | 208 +++++++++++++++++++++++-------------
 drivers/ata/libata-zpodd.c  |   6 +-
 drivers/ata/libata.h        |   1 +
 drivers/scsi/scsi_devinfo.c |   8 +-
 drivers/scsi/scsi_scan.c    |   2 +
 include/linux/libata.h      |  12 ++-
 include/scsi/scsi_devinfo.h |   6 +-
 9 files changed, 175 insertions(+), 90 deletions(-)

-- 
2.43.0


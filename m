Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2D837C11A;
	Sun, 26 Apr 2026 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777230578; cv=none; b=FuQBhA+cTbwSL75AykvIG48dpYUE6Rrbj1nGYgFQAy0Ff5kn0bsBEhOU2L+agt3vJ5qMJWM8AWv1R/j6MGPGgsu5VRTHZ2Y90tlD5tRIfLjMJwue7wOOmlqQH7je6jwWR2mCk6XWXHLQSNehscv+B68k9RZ1GFSAxAElYyjdFSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777230578; c=relaxed/simple;
	bh=w7v77urmj9Myt8HPQQMb8jqREmEgbrUy31DNNSLEPgc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RRaaTKMmK9cYAHlC5cEh3vI7/PHyhJEfC5wzx6sVUKfrxm9BSiXbstjKW/9jPxfeUXTAKxKSDZ+YOgCbpzm2SEs/wwqHyY/Ve2KZAof04b0tKspwC5Ih/uRm+ARKFr2YrXo15v5/LxjXfs+d3nlkKlvyDTB7auoqaxRAY6Qdsbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=dQ6woGqF; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="dQ6woGqF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1777230569;
	bh=w7v77urmj9Myt8HPQQMb8jqREmEgbrUy31DNNSLEPgc=;
	h=From:To:Cc:Subject:Date:From;
	b=dQ6woGqFC+GYYiIrwkb+NTdimevxp4N1N/6EDf/CjMX+vSxlStWSC3uYJ+dncBTk/
	 lNJUgwKYZ4gvUpxKmkcicZEVM6GzXUtA/BGhof94VJe/ppOxSIxM26m0d0CzqgtJ0j
	 AEA2mjBEYd20taPeto9xGZ6b+wtX4cR53i2iW6+Y=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 54E09BE5D4;
	Sun, 26 Apr 2026 19:09:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id E0CF75FADA;
	Sun, 26 Apr 2026 20:09:28 +0100 (BST)
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
Subject: [PATCH v3 0/7] ata: libata-scsi: multi-LUN ATAPI device support
Date: Sun, 26 Apr 2026 20:09:13 +0100
Message-ID: <20260426190920.2051289-1-philpem@philpem.me.uk>
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

This is v3, addressing review feedback from Hannes Reinecke on v2.

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

  5. dev->sdev is a single pointer, but multi-LUN ATAPI puts multiple
     sdevs behind one ata_device.  Every call to ata_scsi_dev_config()
     overwrote the pointer, and ata_scsi_sdev_destroy() tore down the
     entire ATA device whenever any sdev was destroyed -- so removing a
     spurious LUN result during scanning would kill the whole port, and
     the other users of dev->sdev (scsi_remove_device in
     ata_port_detach(), ACPI uevents, zpodd, media-change notify,
     suspend/resume rescan) could only ever see one LUN.

Changes from v2:

  - pdt_1f_for_no_lun is no longer set unconditionally for every ATAPI
    target.  Hannes suggested making this opt-in via the SCSI device
    info table, so a new BLIST_NO_LUN_1F flag has been added to
    scsi_devinfo.h, wired in scsi_scan.c, and applied to the COMPAQ
    PD-1 entry.  Targets that legitimately use PDT 0x1f / PQ 0 for
    "LUN not present" can now opt in without affecting other ATAPI
    devices.  This adds two new patches (4/7 and the updated 6/7).

  - Dropped the one-shot dmesg hint that pointed users at
    libata.atapi_max_lun when a BLIST_FORCELUN device was detected.
    Hannes felt the kernel should not be advertising its own knobs;
    the parameter is documented in the relevant patch and that's the
    expected place for users to discover it.

  - atapi_xlat() now rejects scmd->device->lun >= 8 with
    AC_ERR_INVALID instead of silently truncating.  The SCSI-2 CDB
    LUN field is only 3 bits wide, so a request to a LUN outside that
    range is unrepresentable on the wire and must fail.

  - Patches 1/7 and 2/7 carry Hannes' Reviewed-by tags from v2.

  - Added an optional 7/7 that extends BLIST_NO_LUN_1F to the MATSHITA
    and NEC OEM-branded PD-1 variants.  See note below.

The series is split as:

  1/7: libata-scsi: add libata.atapi_max_lun module parameter.

  2/7: libata-scsi: convert dev->sdev to a per-LUN array and update
       every caller.

  3/7: libata-scsi: relax __ata_scsi_find_dev() to accept non-zero LUN
       for ATAPI devices, and encode the LUN in CDB byte 1 bits 7:5.
       Reject LUN >= 8 with AC_ERR_INVALID.

  4/7: scsi: add a BLIST_NO_LUN_1F blacklist flag, which sets
       scsi_target.pdt_1f_for_no_lun for matching devices so that
       PDT 0x1f / PQ 0 INQUIRY responses are treated as "LUN not
       present" and silently skipped.

  5/7: libata-scsi: after adding LUN 0, trigger scsi_scan_target() for
       BLIST_FORCELUN ATAPI devices only.  Single-LUN devices are
       completely unaffected.

  6/7: scsi_devinfo: add the COMPAQ-branded variant of the PD-1 to the
       device info table with BLIST_FORCELUN | BLIST_SINGLELUN |
       BLIST_NO_LUN_1F.  An entry already exists for the Panasonic
       OEM-branded "MATSHITA PD-1" and the NEC "NEC PD-1 ODX654P".

  7/7: scsi_devinfo: extend BLIST_NO_LUN_1F to the MATSHITA and NEC
       PD-1 variants for completeness.  This patch is *optional* --
       it has not been tested on those OEM units (the author only has
       a COMPAQ unit), but the three variants are the same Panasonic
       LF-1095/LF-1195 mechanism with the same firmware family, so
       the quirk is expected to apply equally.  The flag is a no-op
       on devices that do not return PDT 0x1f / PQ 0 for non-existent
       LUNs, so the worst case is that it has no effect.  Drop or
       hold this patch if confirmation on real MATSHITA / NEC
       hardware is preferred first.

Tested on a Panasonic LF-1195C PD/CD (Compaq branded) attached to an
ata_piix host on i686, kernel 7.0.0-rc7+, with libata.atapi_max_lun=7.
Both LUNs enumerate correctly: the CD-ROM as sr0 and the PD as sda.
Reads from each device succeed against the appropriate media.
Non-responding LUNs are silently skipped (no spurious "No Device"
entries in dmesg).  An iHAS124 DVD writer on the same machine
(single-LUN, no BLIST_FORCELUN entry) is unaffected: only LUN 0 is
scanned.

If the iHAS124 is scanned regardless, it seems to ignore the LUN
parameter, and enumerates as eight drives. I expect most standard ATAPI
devices would behave this way, hence the BLIST_FORCELUN gate.

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
   fresh media; `blockdev --rereadpt /dev/sdX` reliably forces a
   revalidate and proves the libata routing itself is correct.

   A follow-up patch could add a BLIST flag (e.g. BLIST_POLL_EVENTS)
   to scsi_devinfo and have sd_probe_async() set the per-disk poll
   interval when the flag is present.  This would be a separate
   submission to the SCSI list since it touches sd.c.

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
serialises port quiesce, so no additional per-LUN suspend counting is
needed in libata.

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

 drivers/ata/libata-acpi.c   |   4 +-
 drivers/ata/libata-core.c   |  15 ++-
 drivers/ata/libata-scsi.c   | 198 +++++++++++++++++++++---------------
 drivers/ata/libata-zpodd.c  |   6 +-
 drivers/ata/libata.h        |   1 +
 drivers/scsi/scsi_devinfo.c |   8 +-
 drivers/scsi/scsi_scan.c    |   3 +
 include/linux/libata.h      |   3 +-
 include/scsi/scsi_devinfo.h |   6 +-
 9 files changed, 147 insertions(+), 97 deletions(-)

-- 
2.43.0


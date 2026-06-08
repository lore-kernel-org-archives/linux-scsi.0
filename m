Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790BA3AFB19;
	Mon,  8 Jun 2026 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955524; cv=none; b=BsIoBnTaTDun/SkmTrQhP1cRobM/3LSj3h9Lc5EspV3JHOlyp/ARTLyTKhjd5Jp7PlLeJfPieSvPiC5+JFuPf3EwdcVDMzYORWTwXppLopQYVSPyd8NnNPlIAoWdUMktvEGo/XvZH6/9FAlY5k/H1xRc+JlpZR0cDNMi/vezqbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955524; c=relaxed/simple;
	bh=V6YgNKq+susbKey9ypxTfubpOI6f1RBHLIQyXHjy4EU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OkC2HnRg6o9xy0V4T6aLNHRD6+hZPFHZeuq8jK+X7uwEd6eZ3VxOzai7nkuXwMSRNZvF+v5tMgHwY9ztAqjPIpQonya1sSWcAyTbuGNx6X6U9MBrEEK7FpyQd2lHUrhx0euShCuti68FhGSSREE8nZTNa59JWhX5y67LCmY8FKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=qHlrWAwC; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="qHlrWAwC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1780954491;
	bh=V6YgNKq+susbKey9ypxTfubpOI6f1RBHLIQyXHjy4EU=;
	h=From:To:Cc:Subject:Date:From;
	b=qHlrWAwCbQo8D0sWnB56mVibCl7q0sKvKbQUPRLTa/HjC9VmzesdEbnVR6TWKLTL1
	 +ar9FNfQTNrFw+iT6X+6O5dgtvYsafUvIBi1nVujRYNahI1upXnr0jva6svxX2J180
	 BALEq67oUaVHyFAx6j1tfcDcCRuQTFigyWelUrPM=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 3AD03BE5AB;
	Mon,  8 Jun 2026 21:34:51 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id C3AB95FBA6;
	Mon,  8 Jun 2026 22:34:50 +0100 (BST)
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
Subject: [PATCH v6 0/6] ata: libata-scsi: multi-LUN ATAPI device support
Date: Mon,  8 Jun 2026 22:34:37 +0100
Message-ID: <20260608213443.2296614-1-philpem@philpem.me.uk>
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

This is v6, addressing review feedback from Hannes Reinecke, Damien Le
Moal, and the Sashiko AI code review on v5.

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

Changes from v5:

  - Drop dev->nr_luns entirely (Hannes Reinecke): nr_luns was an
    unnecessary counter tracking how many dev->sdev[] slots were valid.
    All loop bounds now use ATAPI_MAX_LUN directly, relying on NULL
    checks to skip empty slots.  ata_dev_scsi_device() uses ATAPI_MAX_LUN
    in its WARN_ON_ONCE bound.  The pre-scan assignment
    "dev->nr_luns = ap->scsi_host->max_lun" in ata_scsi_scan_host() is
    also removed (it had been needed to let atapi_xlat() accept INQUIRY
    CDBs during scsi_scan_target(); that hack is no longer necessary).

  - Restructure CDB LUN encoding in atapi_xlat() (Damien Le Moal):
    always clear CDB byte 1 bits 7:5; only set them for nonzero LUNs
    (with unlikely()).  Bounds check uses host->max_lun vs ATAPI_MAX_LUN.
    Also set scmd->result = DID_ERROR << 16 before returning non-zero so
    the error is not silently dropped by the ata_scsi_translate() done
    path (Sashiko AI review).

  - ata_scsi_scan_host: early-continue after LUN 0 failure (Damien Le
    Moal): clear dev->sdev[0] = NULL and continue to the next device
    rather than goto when __scsi_add_device() fails.

  - ata_scsi_dev_rescan: split get-all from resume/rescan (Damien Le
    Moal): reference collection, do_resume initialisation, and the
    resume/rescan loop are now three separate steps, with leftover refs
    released on EWOULDBLOCK and error paths.

  - pdt_1f_for_no_lun set before the PDT=0x1f check (Sashiko AI
    review): in scsi_probe_and_add_lun(), set starget->pdt_1f_for_no_lun
    from bflags before the PDT=0x1f early-return rather than inside
    scsi_add_lun() after it.

  - ata_port_detach: snapshot dev->sdev[lun] under the lock before
    releasing it, then use the snapshot for scsi_remove_device() (Sashiko
    AI review).  Mirrors the existing pattern in ata_scsi_remove_dev().

  - ata_scsi_sdev_destroy: set ATA_DFLAG_DETACH only when all
    ATAPI_MAX_LUN slots are NULL, regardless of LUN removal order
    (Sashiko AI review).

  - ata_scsi_scan_host: move ata_scsi_assign_ofnode() before
    scsi_device_put() to avoid a potential use-after-free (Sashiko AI
    review).

  - MODULE_PARM_DESC for atapi_max_lun clarified (Damien Le Moal).

  - Style: braces on the single-statement else branch in
    ata_acpi_uevent(); braces on the ata_scsi_media_change_notify() loop
    body; store ata_dev_scsi_device() result in a local before
    dereferencing in zpodd_wake_dev() (Damien Le Moal / Sashiko AI
    review).

The series is split as:

  1/6: libata-scsi: add libata.atapi_max_lun module parameter.

  2/6: libata-scsi: convert dev->sdev to a per-LUN array, add the
       ata_dev_scsi_device() helper, and update every caller.

  3/6: libata-scsi: relax __ata_scsi_find_dev() to accept non-zero LUN
       for ATAPI devices, and encode the LUN in CDB byte 1 bits 7:5.

  4/6: scsi: add a BLIST_NO_LUN_1F blacklist flag, which sets
       scsi_target.pdt_1f_for_no_lun for matching devices so that
       PDT 0x1f / PQ 0 INQUIRY responses are treated as "LUN not
       present" and silently skipped.

  5/6: libata-scsi: after adding LUN 0, trigger scsi_scan_target() for
       BLIST_FORCELUN ATAPI devices only.  Single-LUN devices are
       completely unaffected.

  6/6: scsi_devinfo: add the COMPAQ-branded variant of the PD-1 to the
       device info table with BLIST_FORCELUN | BLIST_SINGLELUN |
       BLIST_NO_LUN_1F.

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

v5 collected Reviewed-by from Damien Le Moal and Hannes Reinecke on
patches 4/6 and 6/6, and from Hannes Reinecke on 1/6.  The tags on
1/6 and 6/6 are preserved as those patches are unchanged.  The tags on
4/6 have been dropped as that patch gained a scsi_scan.c change
(moving the pdt_1f_for_no_lun assignment earlier).

Comments and suggestions welcome.

Phil Pemberton (6):
  ata: libata-scsi: add atapi_max_lun module parameter
  ata: libata-scsi: convert dev->sdev to per-LUN array
  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  scsi: add BLIST_NO_LUN_1F blacklist flag
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk

 drivers/ata/libata-acpi.c   |   6 +-
 drivers/ata/libata-core.c   |  16 ++-
 drivers/ata/libata-scsi.c   | 208 +++++++++++++++++++++++-------------
 drivers/ata/libata-zpodd.c  |   6 +-
 drivers/ata/libata.h        |   1 +
 drivers/scsi/scsi_devinfo.c |   2 +
 drivers/scsi/scsi_scan.c    |   2 +
 include/linux/libata.h      |  12 ++-
 include/scsi/scsi_devinfo.h |   6 +-
 9 files changed, 171 insertions(+), 88 deletions(-)


base-commit: a3f75e5e6b023958c92ad03fa2e68e047b6169c4
--
2.43.0


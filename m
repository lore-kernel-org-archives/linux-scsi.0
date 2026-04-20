Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E18139A818;
	Mon, 20 Apr 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776689127; cv=none; b=SluKIGWMqBJYC3sL8S4yhxzHMoRFEDTUwjPknG7ekIadipSXBt/m7FhiR+EimKXQ6c5PkK26KbpV+/5+B7lzJ2kgS3uDS+vHGZlpLZ4uJfD8bJyX/eAFsh3s/vz7Oeucf6iURoC7heUVhH5SIMuRlDYclrOj+gSlREqcChbQkCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776689127; c=relaxed/simple;
	bh=Rf+ogoM9HozUI/TbYwyqCAZAG4IcaJIaj15+DrLChwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=epX3eYeSK95XcMmOwfSb7VUe4sWpHlsOuM1p17Sll6NJlI5CsVifpA86v3VR7avEkZdYN97iBOH87iY9JKzyNYbgN4+IHeFZQFH7sYtOIQftJb1NRP6v6dpbgavcM+ej5nAto5vTAV3ghG5XMNu3oBQ4dXh58zuA0Sqw7n1iaQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=EHrHthQS; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="EHrHthQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1776687809;
	bh=Rf+ogoM9HozUI/TbYwyqCAZAG4IcaJIaj15+DrLChwA=;
	h=From:To:Cc:Subject:Date:From;
	b=EHrHthQS/hJQzbVR19rth8svQB0xdcGqdO0i9XUU2jilVygE2WisoGW8fmQbtH+Jl
	 3TyEfVemq8trMroTbcOd5jVEKCHqglJNJrRK1MlX18KACzGgj6N65lFW7pinCLM1f+
	 4RN/Ca7tSazjujz9MCS8jhFsZno5CptgB2W5kyfw=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 23335BE5E5;
	Mon, 20 Apr 2026 12:23:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 781065FC4E;
	Mon, 20 Apr 2026 13:23:28 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v2 0/5] ata: libata-scsi: multi-LUN ATAPI device support
Date: Mon, 20 Apr 2026 13:23:16 +0100
Message-ID: <20260420122321.4161027-1-philpem@philpem.me.uk>
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

This is v2, reworked based on review feedback from Damien Le Moal and
Hannes Reinecke.

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

Changes from v1:

  - dev->sdev is now a per-LUN array, as suggested by Hannes and Damien.
    v1 used a single-pointer LUN-0 guard with scsi_device_get()
    refcounting; Hannes pointed out that this left higher LUNs invisible
    to code that iterates sdevs, and Damien suggested an array indexed
    by LUN number.  All call sites have been audited.

  - atapi_max_lun is now a libata module parameter, default 1, range
    1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).  Out-of-the-box the kernel
    behaves identically to today.  A one-shot dmesg hint is printed when
    a BLIST_FORCELUN device is detected but atapi_max_lun is still 1,
    pointing the user at the knob.

  - Multi-LUN scanning uses a two-phase approach: __scsi_add_device()
    adds LUN 0 for every ATAPI device, then scsi_scan_target() with
    SCAN_WILD_CARD triggers the SCSI layer's sequential LUN scan only
    for devices flagged BLIST_FORCELUN.  Single-LUN devices are
    completely unaffected.  pdt_1f_for_no_lun is set on the target
    so that non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped.

  - The scsi_devinfo COMPAQ PD-1 quirk now lands last in the series,
    as Damien requested.

The series is split as:

  1/5: libata-scsi: add libata.atapi_max_lun module parameter.

  2/5: libata-scsi: convert dev->sdev to a per-LUN array and update
       every caller.

  3/5: libata-scsi: relax __ata_scsi_find_dev() to accept non-zero LUN
       for ATAPI devices, and encode the LUN in CDB byte 1 bits 7:5.

  4/5: libata-scsi: after adding LUN 0, trigger scsi_scan_target() for
       BLIST_FORCELUN ATAPI devices only.  Set pdt_1f_for_no_lun to
       suppress spurious "No Device" entries from non-responding LUNs.

  5/5: scsi_devinfo: add the COMPAQ-branded variant of the PD-1 to the
       device info table.  An entry already exists for the Panasonic
       OEM-branded "MATSHITA PD-1" and the NEC "NEC PD-1 ODX654P".

Tested on a Panasonic LF-1195C PD/CD (Compaq branded) attached to an
ata_piix host on i686. With libata.atapi_max_lun=7, both LUNs enumerate
correctly: the CD-ROM as sr0 and the PD as sda. Non-responding LUNs are
silently skipped (no spurious "No Device" entries in dmesg).  An iHAS124
DVD writer on the same machine (single-LUN, no BLIST_FORCELUN entry) is
unaffected: only LUN 0 is scanned.

If the iHAS124 is scanned regardless, it seems to ignore the LUN
parameter, and enumerates as eight drives. I expect most standard ATAPI
devices would behave this way, hence the BLIST_FORCELUN gate.

All testing was done on kernel 7.0.0-rc7+.

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

Phil Pemberton (5):
  ata: libata-scsi: add atapi_max_lun module parameter
  ata: libata-scsi: convert dev->sdev to per-LUN array
  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk

 drivers/ata/libata-acpi.c   |   4 +-
 drivers/ata/libata-core.c   |  15 ++-
 drivers/ata/libata-scsi.c   | 214 ++++++++++++++++++++++--------------
 drivers/ata/libata-zpodd.c  |   6 +-
 drivers/ata/libata.h        |   1 +
 drivers/scsi/scsi_devinfo.c |   1 +
 include/linux/libata.h      |   3 +-
 7 files changed, 152 insertions(+), 92 deletions(-)

-- 
2.43.0


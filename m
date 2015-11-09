From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/18] ALUA device handler update, part 1
Date: Mon,  9 Nov 2015 16:08:05 +0100
Message-ID: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbKIPIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here's the first part of my ALUA device handler update.
It's mainly bugfixes and minor improvements; the two important
things are the addition of VPD parsing functions scsi_vpd_lun_id()
and scsi_vpd_tpg_id().
This series has been split off from the original 'Asynchronous ALUA'
patchset, as these bits are pretty uncontroversial and have a good
chance of being merged reasonably soon.

The second part of the ALUA device handler update will be posted
(and, doubtlessly, discussed) once this part is in.

Patch is relative to 4.4/scsi-queue by mkp, and based upon the
'scsi: rescan VPD attributes' patch I send earlier.

As usual, comments and reviews are welcome.

Hannes Reinecke (18):
  scsi_dh: move 'dh_state' sysfs attribute to generic code
  scsi: ignore errors from scsi_dh_add_device()
  scsi_dh_alua: Disable ALUA handling for non-disk devices
  scsi_dh_alua: Use vpd_pg83 information
  scsi_dh_alua: improved logging
  scsi_dh_alua: sanitze sense code handling
  scsi_dh_alua: use standard logging functions
  scsi_dh_alua: return standard SCSI return codes in submit_rtpg
  scsi_dh_alua: fixup description of stpg_endio()
  scsi: remove scsi_show_sense_hdr()
  scsi_dh_alua: use flag for RTPG extended header
  scsi_dh_alua: use unaligned access macros
  scsi_dh_alua: rework alua_check_tpgs() to return the tpgs mode
  scsi_dh_alua: simplify sense code handling
  scsi: Add scsi_vpd_lun_id()
  scsi: export 'device_id' to sysfs
  scsi: Add scsi_vpd_tpg_id()
  scsi_dh_alua: use scsi_vpd_tpg_id()

 drivers/scsi/device_handler/scsi_dh_alua.c | 294 ++++++++++-------------------
 drivers/scsi/scsi_dh.c                     |  68 +------
 drivers/scsi/scsi_lib.c                    | 188 ++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  |  82 +++++++-
 include/scsi/scsi_dbg.h                    |   2 -
 include/scsi/scsi_device.h                 |   2 +
 6 files changed, 373 insertions(+), 263 deletions(-)

-- 
1.8.5.6


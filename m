From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/18] ALUA device handler update, part 1
Date: Tue,  1 Dec 2015 10:16:40 +0100
Message-ID: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbbLAJRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

Patchset is relative to 4.5/scsi-queue by mkp.
The entire tree can be found at

kernel.org:/pub/scm/linux/kernel/git/hare/scsi-devel.git
branch alua.v7

As usual, comments and reviews are welcome.

Changes to v1:
- Update to 4.5/scsi-queue
- Rename 'device_id' to 'wwid'

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
  scsi: export 'wwid' to sysfs
  scsi: Add scsi_vpd_tpg_id()
  scsi_dh_alua: use scsi_vpd_tpg_id()

 drivers/scsi/device_handler/scsi_dh_alua.c | 294 ++++++++++-------------------
 drivers/scsi/scsi_dh.c                     |  72 +------
 drivers/scsi/scsi_lib.c                    | 188 ++++++++++++++++++
 drivers/scsi/scsi_priv.h                   |   3 +-
 drivers/scsi/scsi_sysfs.c                  |  82 +++++++-
 include/scsi/scsi_dbg.h                    |   2 -
 include/scsi/scsi_device.h                 |   2 +
 7 files changed, 374 insertions(+), 269 deletions(-)

-- 
1.8.5.6


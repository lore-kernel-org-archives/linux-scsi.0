From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 00/23] asynchronous ALUA device handler
Date: Thu, 27 Aug 2015 14:40:58 +0200
Message-ID: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbbH0Ml1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here is an update to the ALUA device handler. The main
features are:

- Topology discovery: the device handler creates a separate
  port_group structure, which is used to update all paths to
  the same port group. With that we achieve a significant
  reduction of the number of RTPGs.
- Asynchronous state update: The ALUA state is now updated
  from a workqueue item, so all concurrent RTPG calls are
  coaleasced. The ALUA state update is also triggered by
  sense codes indicating an ALUA state change.
- Use the existing vpd page 0x83 to detect device IDs

The patchset is relative to the V4 version of the scsi_dh update.
The entire tree can be found at

kernel/hare/scsi-devel branch alua.v4

on git.kernel.org

As usual, reviews and comments are welcome.

Changes to v1:
  - Split off rtpg workqueue into separate items
  - User per-port workqueues
  - Incorporate review from Bart
  - Incorporate review from hch
Changes to v2:
  - Fixup patch descriptions
  - Split off 'Improve error handling' patch
Changes to v3:
  - Implement generic 'scsi_vpd_lun_id()' function to parse vpd page 0x83

Hannes Reinecke (23):
  scsi_dh_alua: Disable ALUA handling for non-disk devices
  scsi_dh_alua: Use vpd_pg83 information
  scsi_dh_alua: improved logging
  scsi_dh_alua: use standard logging functions
  scsi_dh_alua: return standard SCSI return codes in submit_rtpg
  scsi_dh_alua: fixup description of stpg_endio()
  scsi: remove scsi_show_sense_hdr()
  scsi_dh_alua: use flag for RTPG extended header
  scsi_dh_alua: use unaligned access macros
  scsi_dh_alua: Pass buffer as function argument
  scsi_dh_alua: Make stpg synchronous
  scsi_dh_alua: switch to scsi_execute_req_flags()
  scsi_dh_alua: Use separate alua_port_group structure
  scsi_dh_alua: allocate RTPG buffer separately
  scsi_dh_alua: simplify sense code handling
  scsi: Add scsi_vpd_lun_id()
  scsi_dh_alua: use unique device id
  revert "scsi_dh_alua: ALUA hander attach should succeed while TPG is
    transitioning"
  scsi_dh_alua: Use workqueue for RTPG
  scsi_dh_alua: Recheck state on unit attention
  scsi_dh_alua: update all port states
  scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
  scsi_dh_alua: Update version to 2.0

 drivers/scsi/device_handler/scsi_dh_alua.c | 1140 +++++++++++++++++-----------
 drivers/scsi/scsi_lib.c                    |  121 +++
 include/scsi/scsi_dbg.h                    |    2 -
 include/scsi/scsi_device.h                 |    1 +
 4 files changed, 838 insertions(+), 426 deletions(-)

-- 
1.8.5.6


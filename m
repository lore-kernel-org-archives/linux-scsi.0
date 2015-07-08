From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/20] asynchronous ALUA device handler
Date: Wed,  8 Jul 2015 11:05:58 +0200
Message-ID: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934485AbbGHJG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

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

The patchset is relative to the V3 version of the scsi_dh update.
The entire tree can be found at

kernel/hare/scsi-devel branch alua.v3

on git.kernel.org

As usual, reviews and comments are welcome.

Changes to v1:
  - Split off rtpg workqueue into separate items
  - User per-port workqueues
  - Incorporate review from Bart
  - Incorporate review from hch

Hannes Reinecke (20):
  scsi_dh_alua: Disable ALUA handling for non-disk devices
  scsi_dh_alua: Use vpd_pg83 information
  scsi_dh_alua: improved logging
  scsi_dh_alua: Improve error handling
  scsi: remove scsi_show_sense_hdr()
  scsi_dh_alua: use flag for RTPG extended header
  scsi_dh_alua: Pass buffer as function argument
  scsi_dh_alua: Make stpg synchronous
  scsi_dh_alua: switch to scsi_execute()
  scsi_dh_alua: put sense buffer on stack
  scsi_dh_alua: Use separate alua_port_group structure
  scsi_dh_alua: allocate RTPG buffer separately
  scsi_dh_alua: simplify sense code handling
  scsi_dh_alua: parse target device id
  revert "scsi_dh_alua: ALUA hander attach should succeed while TPG is
    transitioning"
  scsi_dh_alua: Use workqueue for RTPG
  scsi_dh_alua: Recheck state on unit attention
  scsi_dh_alua: update all port states
  scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
  scsi_dh_alua: Update version to 2.0

 drivers/scsi/device_handler/scsi_dh_alua.c | 1231 ++++++++++++++++++----------
 include/scsi/scsi_dbg.h                    |    2 -
 2 files changed, 809 insertions(+), 424 deletions(-)

-- 
1.8.5.2


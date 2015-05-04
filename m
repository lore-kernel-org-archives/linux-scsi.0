From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/17] asynchronous ALUA device handler
Date: Mon,  4 May 2015 14:42:06 +0200
Message-ID: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbbEDMm2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here is an update to the ALUA device handler. The main
features are:

- Topology discovery: the device handler creates a separate
  port_group structure, which is used to update all paths to
  the same port group. With that we achieve a significant
  reduction of the number of RTPGs.
- Asynchronous state update: The ALUA state is now updated
  from a workqueue item, so all concurrent RTPG calls are
  buffered with that.
- Use the existing vpd page 0x83 to detect device IDs

The patchset is relative to hch's scsi_dh update.

As usual, reviews and comments are welcome.

Hannes Reinecke (17):
  scsi_dh: return individual errors in scsi_dh_activate()
  scsi_dh_alua: Disable ALUA handling for non-disk devices
  scsi_dh_alua: Use vpd_pg83 information
  scsi_dh_alua: Improve error handling
  scsi: remove scsi_show_sense_hdr()
  scsi_dh_alua: use flag for RTPG extended header
  scsi_dh_alua: Pass buffer as function argument
  scsi_dh_alua: Make stpg synchronous
  scsi_dh_alua: switch to scsi_execute()
  scsi_dh_alua: Use separate alua_port_group structure
  scsi_dh_alua: simplify sense code handling
  scsi_dh_alua: parse target device id
  scsi_dh_alua: revert commit a8e5a2d593cbfccf530c3382c2c328d2edaa7b66
  scsi_dh_alua: Use workqueue for RTPG
  scsi_dh_alua: Recheck state on unit attention
  scsi_dh_alua: update all port states
  scsi_dh_alua: Update version to 2.0

 drivers/scsi/device_handler/scsi_dh.c      |    3 +-
 drivers/scsi/device_handler/scsi_dh_alua.c | 1099 +++++++++++++++++-----------
 include/scsi/scsi_dbg.h                    |    2 -
 3 files changed, 693 insertions(+), 411 deletions(-)

-- 
1.8.5.2


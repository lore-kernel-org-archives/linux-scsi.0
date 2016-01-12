From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/22] ALUA device handler update, part II
Date: Tue, 12 Jan 2016 16:40:36 +0100
Message-ID: <1452613258-94084-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbcALPlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 10:41:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

(resending as I failed to include linux-scsi :-( )

Hi all,

as promised here is now the second part of my ALUA device handler update.
This contains a major rework of the ALUA device handler as execution is
moved onto a workqueue. This has the advantage that we avoid having to
do multiple calls to the same LUN (as happens frequently when failing
over a LUN with several paths) and finally retries are handled correctly.
As some arrays are only capable of handling one STPG at a time I've added
a second hardware handler parameter which then uses a singlethreaded
workqueue, thereby effectively synchronize STPG handling.
Thanks to Bart for this suggestion.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from hch
- Switch to hardware handler parameter instead of module option

Hannes Reinecke (22):
  scsi_dh_alua: Pass buffer as function argument
  scsi_dh_alua: separate out alua_stpg()
  scsi_dh_alua: Make stpg synchronous
  scsi_dh_alua: call alua_rtpg() if stpg fails
  scsi_dh_alua: switch to scsi_execute_req_flags()
  scsi_dh_alua: allocate RTPG buffer separately
  scsi_dh_alua: Use separate alua_port_group structure
  scsi_dh_alua: use unique device id
  scsi_dh_alua: simplify alua_initialize()
  revert commit a8e5a2d593cb ("[SCSI] scsi_dh_alua: ALUA handler attach
    should succeed while TPG is transitioning")
  scsi_dh_alua: move optimize_stpg evaluation
  scsi_dh_alua: remove 'rel_port' from alua_dh_data structure
  scsi_dh_alua: Use workqueue for RTPG
  scsi_dh_alua: Allow workqueue to run synchronously
  scsi_dh_alua: Recheck state on unit attention
  scsi_dh_alua: update all port states
  scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
  scsi_dh: add 'rescan' callback
  scsi: Add 'access_state' attribute
  scsi_dh_alua: use common definitions for ALUA state
  scsi_dh_alua: update 'access_state' field
  scsi_dh_alua: Update version to 2.0

 drivers/scsi/device_handler/scsi_dh_alua.c | 983 ++++++++++++++++++++---------
 drivers/scsi/scsi_lib.c                    |   1 +
 drivers/scsi/scsi_scan.c                   |   9 +-
 drivers/scsi/scsi_sysfs.c                  |  49 ++
 include/scsi/scsi_device.h                 |   1 +
 include/scsi/scsi_dh.h                     |   2 +
 include/scsi/scsi_proto.h                  |  13 +
 7 files changed, 747 insertions(+), 311 deletions(-)

-- 
1.8.5.6


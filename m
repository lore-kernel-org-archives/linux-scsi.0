From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/24] ALUA device handler update, part II
Date: Wed, 13 Jan 2016 09:09:35 +0100
Message-ID: <1452672599-9820-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbcAMIKQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 03:10:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

as promised here is now the second part of my ALUA device handler update.
This contains a major rework of the ALUA device handler as execution is
moved onto a workqueue. This has the advantage that we avoid having to
do multiple calls to the same LUN (as happens frequently when failing
over a LUN with several paths) and finally retries are handled correctly.
As some arrays are only capable of handling one STPG at a time I've added
a blacklist flag which then uses a singlethreaded workqueue, thereby
effectively synchronize STPG handling.
Thanks to Bart for this suggestion.

As usual, comments and reviews are welcome.

Changes to v2:
- Use a SCSI blacklist flag instead of a hardware handler parameter
  for switching to synchronous ALUA handling
- Move scsi_get_device_flags{,_keyed} to scsi_devinfo.h
- Move flush_delayed_work() into release_port_group()
- Rename alua_lookup_pg() into alua_find_get_pg()
- Add __rcu annotations to keep sparse happy

Changes to v1:
- Include reviews from hch
- Switch to hardware handler parameter instead of module option

Hannes Reinecke (24):
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
  scsi_devinfo: move scsi_get_device_flags into scsi_devinfo.h
  scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'
  scsi_dh_alua: Recheck state on unit attention
  scsi_dh_alua: update all port states
  scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
  scsi_dh: add 'rescan' callback
  scsi: Add 'access_state' attribute
  scsi_dh_alua: use common definitions for ALUA state
  scsi_dh_alua: update 'access_state' field
  scsi_dh_alua: Update version to 2.0

 drivers/scsi/device_handler/scsi_dh_alua.c | 969 ++++++++++++++++++++---------
 drivers/scsi/scsi_devinfo.c                |  21 -
 drivers/scsi/scsi_lib.c                    |   1 +
 drivers/scsi/scsi_priv.h                   |  12 -
 drivers/scsi/scsi_scan.c                   |   9 +-
 drivers/scsi/scsi_sysfs.c                  |  49 ++
 drivers/scsi/scsi_transport_spi.c          |   1 +
 include/scsi/scsi_device.h                 |   1 +
 include/scsi/scsi_devinfo.h                |  33 +
 include/scsi/scsi_dh.h                     |   2 +
 include/scsi/scsi_proto.h                  |  13 +
 11 files changed, 771 insertions(+), 340 deletions(-)

-- 
1.8.5.6


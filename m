From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] SCSI 'access_state' attribute
Date: Tue,  1 Mar 2016 05:55:37 +0100
Message-ID: <1456808143-88932-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbcCAE4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 23:56:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's the patchset to add an 'access_state' and 'preferred_path'
attribute. It will display the access state of a path if a
hardware handler is attached.
The access_state is given in terms of SCSI ALUA, and
the vendor-specific access state (eg for rdac or alua)
are mapped onto the ALUA values.
Additionally the 'is_visible' callback is updated to
only display the attributes if they are supported.

Hannes Reinecke (6):
  scsi: Add 'access_state' and 'preferred_path' attribute
  scsi_dh_alua: use common definitions for ALUA state
  scsi_dh_alua: update 'access_state' field
  scsi_dh_rdac: update 'access_state' field
  scsi_dh_emc: update 'access_state' field
  scsi_sysfs: call 'device_add' after attaching device handler

 drivers/scsi/device_handler/scsi_dh_alua.c | 106 +++++++++++++++++++----------
 drivers/scsi/device_handler/scsi_dh_emc.c  |   7 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |  38 +++++++++--
 drivers/scsi/scsi_sysfs.c                  |  88 ++++++++++++++++++++++--
 include/scsi/scsi_device.h                 |   1 +
 include/scsi/scsi_proto.h                  |  12 ++++
 6 files changed, 202 insertions(+), 50 deletions(-)

-- 
2.6.2


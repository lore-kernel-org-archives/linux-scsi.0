From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] device handler interface update
Date: Wed,  8 Jul 2015 13:09:43 +0200
Message-ID: <1436353788-104911-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933793AbbGHLJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 07:09:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Hi all,

the current scsi_dh interface is very limited in functionality.
In particular it's not possible to update the internal state
without triggering a failover, and it not possible to figure
out the internal state of the device handler.

This patchset adds the functionality to rescan the device handler
if something has changed and adds a new sysfs attribute 'access_state'
to display the internal state.

To make this work the first patch implements functionality to
rescan the VPD information, as it might have changed, too.

The patchset is relative to my asynchronous ALUA update posted
earlier.

The entire tree can be found on git.kernel.org:

kernel/git/hare/scsi-devel.git branch alua.v3

As usual, reviews and comments are welcome.

Hannes Reinecke (5):
  scsi: rescan VPD attributes
  scsi_dh: add 'rescan' callback
  scsi: Add 'access_state' attribute
  scsi_dh_alua: add 'state' callback function
  scsi_dh_rdac: Add 'state' callback

 drivers/scsi/device_handler/scsi_dh_alua.c | 111 +++++++++++++++++++++++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c |  17 +++++
 drivers/scsi/scsi.c                        |  20 +++++-
 drivers/scsi/scsi_lib.c                    |   1 +
 drivers/scsi/scsi_scan.c                   |  10 +++
 drivers/scsi/scsi_sysfs.c                  |  61 +++++++++++++++-
 drivers/scsi/ses.c                         |   6 +-
 include/scsi/scsi_device.h                 |  14 ++++
 include/scsi/scsi_dh.h                     |   2 +
 9 files changed, 220 insertions(+), 22 deletions(-)

-- 
1.8.5.2


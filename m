From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] sd async probing
Date: Tue, 12 Dec 2017 09:57:48 +0100
Message-ID: <1513069072-32514-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46993 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752247AbdLLI55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:57:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to facilitate full async scsi disk probing.
The current approach has the problem of calling
async_synchronize_full_domain() during sd_remove(), which is required
to wait for _all_ current asynchronous probes to complete.
When running under iSER sd_remove() is called from the RX thread directly,
ie sd_remove() has to complete before RX processing can continue.
But as probing has to issue I/O any response will be stuck in the RX queue,
resulting in a deadlock.

This patchset breaks up the synchronization point into a per-device cookie,
thus removing the global synchronisation and breaking the deadlock.
But during testing some more deficiencies up and down the stack had been
revealed, so we'll need the entire patchset to make it work.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  block: check for GENHD_FL_UP in del_gendisk()
  sd: Check if parent is still present before proceeding with probing
  scsi: add missing get_device() return value checks
  sd: use async_probe cookie to avoid deadlocks

 block/genhd.c            |  3 +++
 drivers/scsi/scsi_scan.c | 14 ++++++++++++--
 drivers/scsi/sd.c        | 19 +++++++++++++------
 drivers/scsi/sd.h        |  3 +++
 4 files changed, 31 insertions(+), 8 deletions(-)

-- 
1.8.5.6

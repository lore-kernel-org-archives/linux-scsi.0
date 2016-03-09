From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/4] Low water mark disk events
Date: Wed,  9 Mar 2016 14:16:28 +0100
Message-ID: <1457529392-53970-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbcCINQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2016 08:16:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Mahoney <jeffm@suse.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here is a patchset to implement 'low water mark' disk events.
This event corresponds to a TP Soft Threshold Reached UA for
SCSI or a 'low watermark' event for dm-thin.
It utilises the existing 'disk event' infrastructure from the
blocklayer to send out the events via udev.
And it also cleans up the ambiguous MEDIA_CHANGE event handling
from libata, where AN (asynchronous notification) events would
be signalled via SCSI events, and polled MEDIA_CHANGE events
would be signalled via disk events.
And I've added thin provisioning support to brd, too, to have
a simple testbed for the new low water mark disk event.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  scsi,block: enable disk event forwarding
  block,scsi: Low water mark disk event
  dm-thin: enable low water mark disk event
  brd: thin provisioning support

 block/genhd.c              |  3 +++
 drivers/block/brd.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-thin.c       |  2 ++
 drivers/md/dm.c            | 26 +++++++++++++++++++++++
 drivers/md/dm.h            |  3 ++-
 drivers/scsi/scsi_lib.c    | 25 +++++++++-------------
 drivers/scsi/sd.c          | 44 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h          |  1 +
 include/linux/genhd.h      |  1 +
 include/scsi/scsi_driver.h |  2 ++
 10 files changed, 144 insertions(+), 16 deletions(-)

-- 
1.8.5.6


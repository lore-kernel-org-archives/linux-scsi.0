From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] New SCSI command timeout handler
Date: Thu,  6 Jun 2013 11:43:51 +0200
Message-ID: <1370511835-50072-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab3FFJoA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 05:44:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Hi all,

this is the first step towards a new non-blocking
error handler. This patch implements a new command
timeout handler which will be sending command aborts
inline without engaging SCSI EH.

In addition the commands will be returned directly
if the command abort succeeded, cutting down recovery
times dramatically.

With the original scsi error recovery I got:
# time dd if=/dev/zero of=/mnt/test.blk bs=512 count=2048 oflag=sync
2048+0 records in
2048+0 records out
1048576 bytes (1.0 MB) copied, 3.72732 s, 281 kB/s

real	2m14.475s
user	0m0.000s
sys	0m0.104s

with this patchset I got:
# time dd if=/dev/zero of=/mnt/test.blk bs=512 count=2048 oflag=sync
2048+0 records in
2048+0 records out
1048576 bytes (1.0 MB) copied, 31.5151 s, 33.3 kB/s

real	0m31.519s
user	0m0.000s
sys	0m0.088s

Test was to disable RSCN on the target port, disable the
target port, and then start the 'dd' command as indicated.

As a proof-of-concept I've also enabled the new timeout
handler for virtio, so that things can be tested out
more easily.

Comments etc are welcome.

Hannes Reinecke (4):
  scsi: move initialization of scmd->eh_entry
  blk-timeout: add BLK_EH_SCHEDULED return code
  scsi: improved eh timeout handler
  virtio_scsi: use improved eh timeout handler

 drivers/scsi/scsi_error.c        | 82 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c          |  4 +-
 drivers/scsi/scsi_scan.c         |  3 ++
 drivers/scsi/scsi_transport_fc.c |  3 +-
 drivers/scsi/virtio_scsi.c       |  8 ++++
 include/linux/blkdev.h           |  1 +
 include/scsi/scsi_cmnd.h         |  1 +
 include/scsi/scsi_device.h       |  2 +
 8 files changed, 101 insertions(+), 3 deletions(-)

-- 
1.7.12.4


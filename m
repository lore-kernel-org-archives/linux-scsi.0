From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] New FC timeout handler
Date: Fri, 24 May 2013 11:50:46 +0200
Message-ID: <1369389050-118628-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3EXJux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 05:50:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this is the first step towards a new FC error handler.
This patch implements a new FC command timeout handler
which will be sending command aborts inline without
engaging SCSI EH.

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
1048576 bytes (1.0 MB) copied, 79.6376 s, 13.2 kB/s

real	1m19.642s
user	0m0.000s
sys	0m0.100s

Test was to disable RSCN on the target port, disable the
target port, and then start the 'dd' command as indicated.

Comments etc are welcome.

Hannes Reinecke (4):
  scsi: move initialization of scmd->eh_entry
  blk-timeout: add BLK_EH_SCHEDULED return code
  scsi: export functions for new fc timeout handler
  scsi_transport_fc: FC timeout handler

 drivers/scsi/scsi_error.c        |  8 ++++-
 drivers/scsi/scsi_lib.c          |  6 ++--
 drivers/scsi/scsi_priv.h         |  2 ++
 drivers/scsi/scsi_transport_fc.c | 63 +++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h           |  1 +
 include/scsi/scsi_transport_fc.h |  2 ++
 6 files changed, 78 insertions(+), 4 deletions(-)

-- 
1.7.12.4


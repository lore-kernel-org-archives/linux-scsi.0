From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/9] New SCSI command timeout handler
Date: Mon, 10 Jun 2013 09:40:49 +0200
Message-ID: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3FJHlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

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
As requested I've also hooked in the new SCSI timeout
handler to SAS.

Changes to the original version:
- Use a private list in scsi_eh_abort_handler to avoid
  list starvation (pointed out by Joern Engel)
- Terminate command aborts when the first abort fails
- Do not attempt command aborts if the host is already in recovery
  or if the device is removed.
- Flush abort workqueue if the device is removed.

Comments etc are welcome.

Hannes Reinecke (9):
  scsi: move initialization of scmd->eh_entry
  blk-timeout: add BLK_EH_SCHEDULED return code
  scsi: improved eh timeout handler
  virtio_scsi: Enable new EH timeout handler
  virtio-scsi: Implement TMF timeout
  libsas: Enable new EH timeout handler
  mptsas: Enable new EH timeout handler
  mpt2sas: Enable new EH timeout handler
  mpt3sas: Enable new EH timeout handler

 drivers/message/fusion/mptsas.c      |   1 +
 drivers/message/fusion/mptscsih.c    |   7 ++
 drivers/message/fusion/mptscsih.h    |   1 +
 drivers/scsi/libsas/sas_scsi_host.c  |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  11 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  11 +++
 drivers/scsi/scsi_error.c            | 126 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_lib.c              |   4 +-
 drivers/scsi/scsi_scan.c             |   3 +
 drivers/scsi/scsi_sysfs.c            |   5 ++
 drivers/scsi/scsi_transport_fc.c     |   2 +-
 drivers/scsi/virtio_scsi.c           |  14 +++-
 include/linux/blkdev.h               |   1 +
 include/scsi/scsi_cmnd.h             |   1 +
 include/scsi/scsi_device.h           |   2 +
 15 files changed, 184 insertions(+), 7 deletions(-)

-- 
1.7.12.4


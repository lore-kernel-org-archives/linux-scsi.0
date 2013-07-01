From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/9] New EH command timeout handler
Date: Mon,  1 Jul 2013 16:24:22 +0200
Message-ID: <1372688671-85639-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3GAOYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 10:24:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

This patchset implements a new SCSI EH command timeout handler
which will be sending command aborts inline without actually
engaging SCSI EH.
SCSI EH will only be invoked if command abort fails.

In addition the commands will be returned directly
if the command abort succeeded, cutting down recovery
times dramatically.

With the original SCSI EH I got:
# time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
4096+0 records in
4096+0 records out
16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s

real	2m22.657s
user	0m0.013s
sys	0m0.145s

With this patchset I got:
# time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
4096+0 records in
4096+0 records out
16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s

real	0m52.163s
user	0m0.012s
sys	0m0.145s

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

Changes to v2:
- Removed eh_entry initialisation
- Convert to per-command workqueue

Comments etc are welcome.


Hannes Reinecke (9):
  scsi: Fix erratic device offline during EH
  blk-timeout: add BLK_EH_SCHEDULED return code
  scsi: improved eh timeout handler
  virtio_scsi: Enable new EH timeout handler
  libsas: Enable new EH timeout handler
  mptsas: Enable new EH timeout handler
  mpt2sas: Enable new EH timeout handler
  mpt3sas: Enable new EH timeout handler
  scsi_transport_fc: Enable new EH timeout handler

 drivers/message/fusion/mptsas.c      |   3 +-
 drivers/message/fusion/mptscsih.c    |   7 ++
 drivers/message/fusion/mptscsih.h    |   1 +
 drivers/scsi/libsas/sas_scsi_host.c  |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  13 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  11 +++
 drivers/scsi/scsi.c                  |   1 +
 drivers/scsi/scsi_error.c            | 171 ++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_priv.h             |   2 +
 drivers/scsi/scsi_transport_fc.c     |   2 +-
 drivers/scsi/virtio_scsi.c           |   8 ++
 include/linux/blkdev.h               |   1 +
 include/scsi/scsi_cmnd.h             |   2 +
 13 files changed, 199 insertions(+), 25 deletions(-)

-- 
1.7.12.4


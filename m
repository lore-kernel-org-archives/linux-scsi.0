From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/14] lpfc multiqueue performance fixes
Date: Thu,  2 Jun 2016 16:39:02 +0200
Message-ID: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161182AbcFBOj0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to improve lpfc multiqueue performance.
They are a reworked version of those which I've used for
the performance tests I've presented at VAULT 2016.

The patches address two issues in the lpfc driver:
- Decouple abort I/O handling.
  Currently the lpfc driver has to synchronize I/O completions
  with pending aborts, which involves taking a spinlock during
  I/O completion. With this patchset aborts can run independent
  of the I/O completion, and the spinlock can be avoided.
- Array-based command allocation.
  The original driver was using a list-based command allocation,
  which required us to take a lock during command submission.
  This patchset implements an array-based command allocation where
  each element is addressed by the command tag. As the blocklayer
  ensures that we'll never see busy tags we can avoid the spinlock.

To decoupling aborts and I/O completion works as the firmware will
always send an I/O completion, even if the command has been aborted.
So we can as well keep the I/O running when an abort is active (ie
the block timeout function will return BLK_EH_RESET_TIMER), and
complete the command _after_ the aborts are finished. This way
we can ensure that no aborts will be running by the time the I/O
completion (ie ->scsi_done()) is called.
As there are potentially other drivers which could benefit from this
I've added a new SCSI host template flag 'abort_completions'.

The patchset is based on linux v4.7, and can be found at

http://git.kernel.org/hare/scsi-devel/h/lpfc.v3

As usual, comments and reviews are welcome.

Hannes Reinecke (14):
  block: don't check request size in blk_cloned_rq_check_limits()
  lpfc: remove unused 'pring' argument
  lpfc: Add config option 'lpfc_enable_stats'
  scsi: add 'abort_completions' host template flag
  lpfc: do not wait for completion when aborting commands
  lpfc: display manual queue assignment
  scsi: modify can_queue after calling mq_allocate()
  blk-mq: add blk_mq_resize_tag_set()
  scsi: Implement scsi_mq_resize_tags()
  lpfc: use bitflag for exch_busy
  lpfc: set LPFC_CMD_ABORTED when a command is put on the aborted list
  lpfc: move to array based command allocation for SLI-4
  lpfc: LPFC_CMD_RRQ_ACTIVE flag to mark commands
  lpfc: Complete scsi commands after RRQ has completed

 block/blk-core.c              |   5 -
 block/blk-mq.c                |  15 +++
 drivers/scsi/lpfc/lpfc.h      |   2 +
 drivers/scsi/lpfc/lpfc_attr.c |  20 +++-
 drivers/scsi/lpfc/lpfc_init.c |  54 +++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c | 222 +++++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_scsi.h |   7 +-
 drivers/scsi/lpfc/lpfc_sli.c  |  77 ++++++++++++---
 drivers/scsi/scsi_error.c     |   7 +-
 drivers/scsi/scsi_lib.c       |  14 ++-
 include/linux/blk-mq.h        |   1 +
 include/scsi/scsi_host.h      |   7 ++
 12 files changed, 337 insertions(+), 94 deletions(-)

-- 
1.8.5.6


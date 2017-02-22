From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 00/12] mpt3sas: lockless command submission
Date: Wed, 22 Feb 2017 11:31:40 +0100
Message-ID: <1487759512-3873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754103AbdBVKb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:31:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this is the first part of my patchset to enable scsi multiqueue for the
mpt3sas driver.
While the HBA only has a single mailbox register for submitting commands,
it does have individual receive queues per MSI-X interrupt and as such
does benefit from converting it to full multiqueue support.

On request from Broadcom the patchset has been split in two parts, one
to enable lockless command submission and a secondary one for exposing
all hardware queues to the OS.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from Christoph
- Use reserved commands for ioctl passthrough commands
- Include reviews from Sreekanth

Changes to v2:
- Rework ioctl code to not use blk_mq_busy_iter
- Open-code mpt3sas_scsi_direct_io_(get,set)

Changes to v3:
- Simplify task management code
- Simplify _wait_for_commands_to_complete
- Use first reserved smid for ioctl passthrough

Hannes Reinecke (12):
  mpt3sas: switch to pci_alloc_irq_vectors
  mpt3sas: set default value for cb_idx
  mpt3sas: use 'list_splice_init()'
  mpt3sas: separate out _base_recovery_check()
  mpt3sas: open-code _scsih_scsi_lookup_get()
  mpt3sas: Introduce mpt3sas_get_st_from_smid()
  mpt3sas: check command status before attempting abort
  mpt3sas: always use first reserved smid for ioctl passthrough
  mpt3sas: simplify task management functions
  mpt3sas: simplify mpt3sas_scsi_issue_tm()
  mpt3sas: simplify _wait_for_commands_to_complete()
  mpt3sas: lockless command submission

 drivers/scsi/mpt3sas/mpt3sas_base.c      | 277 ++++++++++++++---------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  29 ++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  31 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 289 +++++++------------------------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  33 +---
 5 files changed, 220 insertions(+), 439 deletions(-)

-- 
1.8.5.6

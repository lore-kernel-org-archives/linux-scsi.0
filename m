From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/11] mpt3sas: Full mq support, part 1
Date: Fri, 17 Feb 2017 09:22:59 +0100
Message-ID: <1487319790-97340-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34661 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdBQIXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:23:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is the first part of my patchset to enable scsi multiqueue for the
mpt3sas driver.
While the HBA only has a single mailbox register for submitting commands,
it does have individual receive queues per MSI-X interrupt and as such
does benefit from converting it to full multiqueue support.

On request from Broadcom the patchset has been split in two parts, one
to enable lockless command submission and converting to scsi-mq, and
the other one for exposing all hardware queues to the OS.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from Christoph
- Use reserved commands for ioctl passthrough commands
- Include reviews from Sreekanth


Hannes Reinecke (11):
  mpt3sas: switch to pci_alloc_irq_vectors
  mpt3sas: set default value for cb_idx
  mpt3sas: use 'list_splice_init()'
  mpt3sas: separate out _base_recovery_check()
  mpt3sas: open-code _scsih_scsi_lookup_get()
  mpt3sas: Introduce mpt3sas_get_st_from_smid()
  mpt3sas: check command status before attempting abort
  mpt3sas: always use smid 1 for ioctl passthrough
  mpt3sas: lockless command submission for scsi-mq
  scsi: allocate reserved commands
  mpt3sas: register reserved commands

 drivers/scsi/mpt3sas/mpt3sas_base.c      | 277 +++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  17 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  85 ++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 482 ++++++++++++++-----------------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  22 +-
 drivers/scsi/scsi_lib.c                  |   1 +
 include/scsi/scsi_host.h                 |   1 +
 7 files changed, 426 insertions(+), 459 deletions(-)

-- 
1.8.5.6

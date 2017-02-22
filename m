From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 0/3] mpt3sas: exposing all reply queues
Date: Wed, 22 Feb 2017 11:33:32 +0100
Message-ID: <1487759615-3989-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49817 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932093AbdBVKdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:33:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this is the second part of my patchset to enable scsi multiqueue for the
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

Hannes Reinecke (3):
  mpt3sas: Use 'msix_index' as argument for put_smid functions
  block: Add blk_mq_make_unique_tag()
  mpt3sas: scsi-mq interrupt steering

 block/blk-mq-tag.c                       |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 80 +++++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      | 20 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 +++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 59 ++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 ++--
 include/linux/blk-mq.h                   |  5 ++
 8 files changed, 135 insertions(+), 63 deletions(-)

-- 
1.8.5.6

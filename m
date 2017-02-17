From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/3] mpt3sas: Full mq support, part 2
Date: Fri, 17 Feb 2017 09:25:58 +0100
Message-ID: <1487319961-97476-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754108AbdBQI0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:26:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is the second part of my patchset to enable scsi multiqueue for the
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

Hannes Reinecke (3):
  mpt3sas: Use 'msix_index' as argument for put_smid functions
  block: Add blk_mq_make_unique_tag()
  mpt3sas: scsi-mq interrupt steering

 block/blk-mq-tag.c                       |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 76 +++++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      | 18 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 48 +++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 ++--
 include/linux/blk-mq.h                   |  5 +++
 8 files changed, 119 insertions(+), 62 deletions(-)

-- 
1.8.5.6

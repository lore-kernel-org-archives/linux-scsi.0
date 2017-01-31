From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/10]  mpt3sas: full mq support
Date: Tue, 31 Jan 2017 10:25:50 +0100
Message-ID: <1485854760-122683-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbdAaJ0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:26:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>

Hi all,

this is a patchset to enable full multiqueue support for the mpt3sas driver.
While the HBA only has a single mailbox register for submitting commands,
it does have individual receive queues per MSI-X interrupt and as such
does benefit from converting it to full multiqueue support.

As usual, comments and reviews are welcome.

Hannes Reinecke (10):
  mpt3sas: switch to pci_alloc_irq_vectors
  mpt3sas: set default value for cb_idx
  mpt3sas: implement _dechain_st()
  mpt3sas: separate out _base_recovery_check()
  mpt3sas: open-code _scsih_scsi_lookup_get()
  mpt3sas: Introduce mpt3sas_get_st_from_smid()
  mpt3sas: use hi-priority queue for TMFs
  mpt3sas: lockless command submission for scsi-mq
  mpt3sas: Use 'msix_index' as argument for put_smid functions
  mpt3sas: scsi-mq interrupt steering

 drivers/scsi/mpt3sas/mpt3sas_base.c      | 360 ++++++++++++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  24 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 134 ++++++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 303 +++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |   4 +-
 7 files changed, 623 insertions(+), 212 deletions(-)

-- 
1.8.5.6


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] megaraid_sas: scsi-mq support
Date: Fri, 11 Nov 2016 10:44:47 +0100
Message-ID: <1478857492-4581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754704AbcKKJpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 04:45:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's the patcheset to enable scsi-mq support for megaraid_sas.
It's based on hch's irq rework currently pending in tip.
As the overall results have been less then stellar (see the thread
'reduced latency is killing performance') I've also added a module
parameter 'use_blk_mq' to allowing to switch off scsi-mq support
on a per-driver basis.

Hannes Reinecke (5):
  megaraid_sas: switch to pci_alloc_irq_vectors
  megaraid_sas: avoid calling megasas_lookup_instance()
  megaraid_sas: do not crash on invalid completion
  megaraid_sas: scsi-mq support
  megaraid_sas: add mmio barrier after register writes

 drivers/scsi/megaraid/megaraid_sas.h        |   4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 109 ++++++++++++++++------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  63 +++++++++++-----
 3 files changed, 109 insertions(+), 67 deletions(-)

-- 
1.8.5.6


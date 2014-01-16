From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] megaraid_sas: Fix system stall with iommu enabled
Date: Thu, 16 Jan 2014 11:25:30 +0100
Message-ID: <1389867936-118685-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbaAPKZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 05:25:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

recently I've enabled VT-d on one of my systems, which happened to have
one of the latest Megaraid SAS cards (Fury) installed.
And it failed miserably due to invalid DMAR tables.
Which would be okay, if just the HBA failed to initialize.
But the entire system stalled as the megaraid_sas driver
went into an endless loop waiting for the init command to
come back, which it never did.

So I went on to debug this, and found several issues along the way.
With this patchset the initialisation routine for megaraid_sas
correctly aborts and allows the system to boot.

Hannes Reinecke (6):
  megaraid_sas: Do not wait forever
  megaraid_sas_fusion: Fixup fire_cmd syntax
  megaraid_sas_fusion: correctly pass queue info pointer
  megaraid_sas: catch errors from megasas_get_map_info()
  megaraid_sas_fusion: Return correct error value in
    megasas_get_ld_map_info()
  megaraid_sas: check return value for megasas_get_pd_list()

 drivers/scsi/megaraid/megaraid_sas_base.c   | 56 +++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 74 ++++++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  8 +---
 3 files changed, 75 insertions(+), 63 deletions(-)

-- 
1.7.12.4


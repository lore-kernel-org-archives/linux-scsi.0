From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] ZAC host-aware device support
Date: Fri, 31 Jul 2015 15:02:02 +0200
Message-ID: <1438347728-106434-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbbGaNCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:02:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here is a patchset for adding ZAC host-aware device support to libata.
Main bits are translations for ZBC IN and ZBC OUT; others are the
required plumbing like generating the correct VPD pages.
James, do you require a separate patch for adding ZBC IN and ZBC OUT
or is it okay to have it queued here?

As usual, reviews and comments are welcome.

Hannes Reinecke (6):
  libata: Do not retry commands with valid autosense
  libata-scsi: use ata_scsi_set_sense when generating ATA sense
  libata: implement ZBC IN translation
  libata: Implement ZBC OUT translation
  libata: support device-managed ZAC devices
  libata: support host-aware ZAC devices

 drivers/ata/libata-core.c     |  50 +++++++
 drivers/ata/libata-eh.c       |   4 +
 drivers/ata/libata-scsi.c     | 299 +++++++++++++++++++++++++++++++++++-------
 include/linux/ata.h           |  17 +++
 include/linux/libata.h        |   7 +
 include/scsi/scsi_proto.h     |   9 ++
 include/trace/events/libata.h |   2 +
 7 files changed, 344 insertions(+), 44 deletions(-)

-- 
1.8.5.2


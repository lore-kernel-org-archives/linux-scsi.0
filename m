From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] REAC CAPACITY fixes
Date: Wed,  8 Jul 2015 09:41:05 +0200
Message-ID: <1436341268-91432-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934298AbbGHHlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 03:41:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a small patch series as an attempt to fix up the READ CAPACITY
issue on ALUA devices. The problem is that an ALUA device in state
'standby' or 'transitioning' might return the READ CAPACITY command
with a sense code, causing the sd driver to report an error in
sd_read_capacity.
This patchset fixes up this situation  so that these devices will be
reported with a capacity of '0', but marked with a flag
'invalid_capacity'. So whenever we get a sense code indicating that
the ALUA state has changed or if the 'rescan' attribute was triggered
this flag will be reset if the capacity could be successfully read.

Hannes Reinecke (3):
  sd: Fixup capacity for ALUA standby or transitioning ports
  scsi: rescan device if an invalid capacity had been reported
  sd: do not try to spin-up disks for ALUA 'transitioning' state

 drivers/scsi/scsi_lib.c    |  4 ++++
 drivers/scsi/sd.c          | 35 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_device.h |  1 +
 3 files changed, 39 insertions(+), 1 deletion(-)

-- 
1.8.5.2


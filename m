From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/6] First batch of logging cleanup
Date: Wed, 25 Jun 2014 16:39:53 +0200
Message-ID: <1403707199-102664-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbaFYOkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 10:40:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is the first patch of my SCSI logging cleanup.
The basic idea here is to use dev_printk() and friends
throughout the midlayer, so that any logging messages
are attached with the correct device information.

This patchset is relative to the core-for-3.17 git
tree from hch + my 64-bit LUN patchset.

Changes to v1:
- Rebase to apply after 64-bit LUN patchset

Hannes Reinecke (6):
  scsi: Implement sr_printk()
  scsi: Implement sg_printk()
  scsi: Implement ch_printk()
  scsi: Implement st_printk()
  scsi: use dev_printk() variants for ioctl
  scsi: use dev_printk variants where possible

 drivers/scsi/ch.c         |  14 +-
 drivers/scsi/hosts.c      |  15 +-
 drivers/scsi/scsi.c       |  18 +-
 drivers/scsi/scsi_error.c | 179 +++++++-------
 drivers/scsi/scsi_ioctl.c |  17 +-
 drivers/scsi/scsi_lib.c   |  22 +-
 drivers/scsi/scsi_scan.c  |  62 ++---
 drivers/scsi/sg.c         | 163 +++++++------
 drivers/scsi/sr.c         |  61 ++---
 drivers/scsi/sr.h         |   4 +
 drivers/scsi/sr_ioctl.c   |  26 +-
 drivers/scsi/sr_vendor.c  |  36 +--
 drivers/scsi/st.c         | 605 ++++++++++++++++++++++++----------------------
 13 files changed, 653 insertions(+), 569 deletions(-)

-- 
1.7.12.4


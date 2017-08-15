From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/6] hpsa legacy support
Date: Tue, 15 Aug 2017 08:58:03 +0200
Message-ID: <1502780289-127133-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753097AbdHOG6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 02:58:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's now the third attempt to add support for legacy boards, ie
for boards previously supported by cciss only.
With this patchset the hpsa driver should work with all Smart Array
boards if the 'hpsa_allow_any' module option is set, rendering the
cciss driver obsolete.
Consequently I've added a patch to remove the cciss driver and make
'hpsa' an alias to 'cciss' and removed the 'hpsa_allow_any' module
option.

Hannes Reinecke (6):
  hpsa: add support for legacy boards
  hpsa: disable volume status check for legacy boards
  hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
  hpsa: do not print errors for unsupported report luns format
  cciss: Drop obsolete driver
  hpsa: Remove 'hpsa_allow_any' module option

 Documentation/blockdev/cciss.txt |  194 --
 MAINTAINERS                      |   10 -
 drivers/block/Kconfig            |   27 -
 drivers/block/Makefile           |    1 -
 drivers/block/cciss.c            | 5415 --------------------------------------
 drivers/block/cciss.h            |  433 ---
 drivers/block/cciss_cmd.h        |  269 --
 drivers/block/cciss_scsi.c       | 1653 ------------
 drivers/block/cciss_scsi.h       |   79 -
 drivers/scsi/hpsa.c              |  108 +-
 drivers/scsi/hpsa.h              |   81 +-
 11 files changed, 142 insertions(+), 8128 deletions(-)
 delete mode 100644 Documentation/blockdev/cciss.txt
 delete mode 100644 drivers/block/cciss.c
 delete mode 100644 drivers/block/cciss.h
 delete mode 100644 drivers/block/cciss_cmd.h
 delete mode 100644 drivers/block/cciss_scsi.c
 delete mode 100644 drivers/block/cciss_scsi.h

-- 
1.8.5.6

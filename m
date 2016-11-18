From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] hpsa compatility fixes
Date: Fri, 18 Nov 2016 08:32:46 +0100
Message-ID: <1479454369-100281-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50685 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbcKRHcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 02:32:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is a patchset to get hpsa working on older controllers.
Most notably older controller do not support the extended REPORT PHYS
command, so we need to fallback to the legacy version here.
I've also added a new sysfs HBA attribute 'ctlr_num', which displays
the current controller number. With that attribute one can construct
legacy '/dev/ccissX' symlinks to facilitate an update from older
installations using the cciss driver.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  hpsa: use correct DID_NO_CONNECT hostbyte
  hpsa: fallback to use legacy REPORT PHYS command
  hpsa: add 'ctlr_num' sysfs attribute

 drivers/scsi/hpsa.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

-- 
1.8.5.6


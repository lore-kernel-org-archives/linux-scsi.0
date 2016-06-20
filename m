From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v3] Add support for Write Same via SCT
Date: Mon, 20 Jun 2016 10:03:47 -0500
Message-ID: <1466435028-13886-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp81.mediacombb.net ([68.66.77.81]:43874 "EHLO
	dsmdc-mail-smtp.mcomdc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753761AbcFTPFB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 11:05:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>

At some point the method of issuing Write Same for ATA drives changed.
Currently write same is commonly available via SCT so expose the SCT
capabilities and use SCT Write Same if available.

This is useful for zoned based media that prefers to support discard
with lbprz set, aka discard zeroes data by mapping discard operations to 
reset write pointer operations. Conventional zones that do not support 
reset write pointer can still honor the discard zeroes data by issuing
a write same over the zone.

After reviewing the commits around no_write_same heuristics it seems
that decoupling the status quo will cause more harm than good as it 
seems that broken SATL logic around WRITE SAME is quite common and 
perhaps not surprising as the command appears to have been removed
after ATA-2 and essentially deprecated somewhere around 1997.

Here the approach is to flag a secondary code path that uses SCT to
perform WRITE SAME and then infer the proper action based on the
UNMAP flag and the reported capability.

Before this patch the only valid code path is with UNMAP set and 
TRIM available.

With this patch if UNMAP is not set or TRIM is not available then
fall back to SCT WRITE SAME, if it is available.

In this way it would be possible to mimic lbprz for devices that 
support TRIM but fail to zero blocks reliably. For example a
file-system or DM target could issue a write same w/o unmap followed
by an trim.

This patch is also at
https://github.com/stancheff/linux.git
git@github.com:stancheff/linux.git
branch: v4.7-rc2+sct-write-same.v3

v3:
 - Demux UNMAP/TRIM from WRITE SAME
 - Add offset from scatterlist to page address.
v2:
 - Remove fugly ata hacking from sd.c

Shaun Tancheff (1):
  Add support for SCT Write Same

 drivers/ata/libata-scsi.c  | 80 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/sd.c          |  2 +-
 include/linux/ata.h        | 43 +++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 106 insertions(+), 20 deletions(-)

-- 
2.8.1


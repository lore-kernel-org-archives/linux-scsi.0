From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2] Add support for Write Same via SCT
Date: Thu,  9 Jun 2016 01:32:46 -0500
Message-ID: <1465453967-11085-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp81.mediacombb.net ([68.66.77.81]:53889 "EHLO
	dsmdc-mail-smtp.mcomdc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423297AbcFIGdV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2016 02:33:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>

At some point the method of issuing Write Same for ATA drives changed.
Currently write same is commonly available via SCT so expose the SCT
capabilities and use SCT Write Same if available.

This is useful for zoned based media that prefers to support discard
with lbprz set, aka discard zeroes data by mapping discard operations to 
reset write pointer operations. Conventional zones that do not support 
reset write pointer can still honor the discard zeroes data by issuing
a write same over the zone.

v2:
 - Remove fugly ata hacking from sd.c

Shaun Tancheff (1):
  Add support for SCT Write Same

 drivers/ata/libata-scsi.c  | 34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |  2 +-
 include/linux/ata.h        | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 79 insertions(+), 1 deletion(-)

-- 
2.8.1


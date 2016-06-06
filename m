From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH] Add support for Write Same via SCT
Date: Mon,  6 Jun 2016 12:58:09 -0500
Message-ID: <1465235890-15703-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

At some point the method of issuing Write Same for ATA drives changed.
Currently write same is commonly available via SCT so expose the SCT
capabilities and use SCT Write Same if available.

This is useful for zoned based media that prefers to support discard
with lbprz set, aka discard zeroes data by mapping discard operations to 
reset write pointer operations. Conventional zones that do not support 
reset write pointer can still honor the discard zeroes data by issuing
a write same over the zone.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>

Shaun Tancheff (1):
  Add support for SCT Write Same

 drivers/ata/libata-scsi.c  | 32 ++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          | 21 +++++++++++++--------
 include/linux/ata.h        | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 89 insertions(+), 8 deletions(-)

-- 
2.8.1


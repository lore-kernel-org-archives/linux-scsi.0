From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH] Some drives failing on SCT Write Same
Date: Fri,  9 Sep 2016 11:44:19 -0500
Message-ID: <20160909164419.12978-1-shaun@tancheff.com>
References: <CAJ48U8VJDSzQWuNgG1mnBG_6FvSx5Arc=n6YsH-vxKrt=skWqw@mail.gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36023 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbcIIQod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 12:44:33 -0400
In-Reply-To: <CAJ48U8VJDSzQWuNgG1mnBG_6FvSx5Arc=n6YsH-vxKrt=skWqw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Mike Krinkin <krinkin.m.u@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@lst.de, shaun.tancheff@seagate.com

Restrict support SCT Write Same to devices which also support ZAC where 
support is required.

Reported-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/ata/libata-scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2f5487f..9cceb4a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3562,9 +3562,9 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 		supported = 3;
 		break;
 	case WRITE_SAME_16:
-		if (ata_id_sct_write_same(dev->id))
-			supported = 3;
-		break;
+		if (!ata_id_sct_write_same(dev->id))
+			break;
+		/* fallthrough: if SCT ... only enable for ZBC */
 	case ZBC_IN:
 	case ZBC_OUT:
 		if (ata_id_zoned_cap(dev->id) ||
-- 
2.9.3


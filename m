From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 09/14] libata: fixup ZAC device disabling
Date: Mon, 25 Apr 2016 12:45:51 +0200
Message-ID: <1461581156-92581-10-git-send-email-hare@suse.de>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1461581156-92581-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

libata device disabling is ... curious. So add the correct
definitions that we can disable ZAC devices properly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/linux/libata.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 09ddb5a..92297cd 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -192,7 +192,8 @@ enum {
 	ATA_DEV_SEMB		= 7,	/* SEMB */
 	ATA_DEV_SEMB_UNSUP	= 8,	/* SEMB (unsupported) */
 	ATA_DEV_ZAC		= 9,	/* ZAC device */
-	ATA_DEV_NONE		= 10,	/* no device */
+	ATA_DEV_ZAC_UNSUP	= 10,	/* ZAC device (unsupported) */
+	ATA_DEV_NONE		= 11,	/* no device */
 
 	/* struct ata_link flags */
 	ATA_LFLAG_NO_HRST	= (1 << 1), /* avoid hardreset */
@@ -1524,7 +1525,8 @@ static inline unsigned int ata_class_enabled(unsigned int class)
 static inline unsigned int ata_class_disabled(unsigned int class)
 {
 	return class == ATA_DEV_ATA_UNSUP || class == ATA_DEV_ATAPI_UNSUP ||
-		class == ATA_DEV_PMP_UNSUP || class == ATA_DEV_SEMB_UNSUP;
+		class == ATA_DEV_PMP_UNSUP || class == ATA_DEV_SEMB_UNSUP ||
+		class == ATA_DEV_ZAC_UNSUP;
 }
 
 static inline unsigned int ata_class_absent(unsigned int class)
-- 
1.8.5.6


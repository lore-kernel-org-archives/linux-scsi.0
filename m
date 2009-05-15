From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 12/13] libata: Report disk alignment and physical block size
Date: Fri, 15 May 2009 00:40:34 -0400
Message-ID: <1242362435-11953-13-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

For disks with 4KB sectors, report the correct block size and alignment
when filling out the READ CAPACITY(16) response.

This patch is based upon code from Matthew Wilcox' 4KB ATA tree.  I
fixed the bug I reported a while back caused by ATA and SCSI using
different approaches to describing the alignment.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6e4c600..5072003 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2376,7 +2376,23 @@ saving_not_supp:
  */
 static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
-	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
+	struct ata_device *dev = args->dev;
+	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
+	u8 log_per_phys = 0;
+	u16 lowest_aligned = 0;
+	u16 word_106 = dev->id[106];
+	u16 word_209 = dev->id[209];
+
+	if ((word_106 & 0xc000) == 0x4000) {
+		/* Number and offset of logical sectors per physical sector */
+		if (word_106 & (1 << 13))
+			log_per_phys = word_106 & 0xf;
+		if ((word_209 & 0xc000) == 0x4000) {
+			u16 first = dev->id[209] & 0x3fff;
+			if (first > 0)
+				lowest_aligned = (1 << log_per_phys) - first;
+		}
+	}
 
 	VPRINTK("ENTER\n");
 
@@ -2407,6 +2423,11 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		/* sector size */
 		rbuf[10] = ATA_SECT_SIZE >> 8;
 		rbuf[11] = ATA_SECT_SIZE & 0xff;
+
+		rbuf[12] = 0;
+		rbuf[13] = log_per_phys;
+		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
+		rbuf[15] = lowest_aligned;
 	}
 
 	return 0;
-- 
1.6.0.6


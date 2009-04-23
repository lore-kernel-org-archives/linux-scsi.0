From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 8 of 8] libata: Report disk alignment and physical block size
Date: Thu, 23 Apr 2009 01:29:35 -0400
Message-ID: <29bae7aef942a1709bb6.1240464575__47815.5637080365$1240465892$gmane$org@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:54668 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbZDWFtZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 01:49:25 -0400
In-Reply-To: <patchbomb.1240464567@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org

For disks with 4KB sectors, report the correct block size and alignment
when filling out the READ CAPACITY(16) response.

This patch is based upon code from Matthew Wilcox' 4KB ATA tree.  I
fixed the bug I reported a while back caused by ATA and SCSI using
different approaches to describing the alignment.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 20 insertions(+)
drivers/ata/libata-scsi.c |   20 ++++++++++++++++++++



diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2376,7 +2376,22 @@ saving_not_supp:
  */
 static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
+	struct ata_device *dev = args->dev;
 	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
+	u8 log_per_phys = 0;
+	u16 lowest_aligned_lba = 0;
+	u16 word_106 = dev->id[106];
+	u16 word_209 = dev->id[209];
+
+	if ((word_106 & 0xc000) == 0x4000) {
+		/* Number and offset of logical sectors per physical sector */
+		if (word_106 & (1 << 13))
+			log_per_phys = word_106 & 0xf;
+		if ((word_209 & 0xc000) == 0x4000)
+			lowest_aligned_lba =
+				((1 << log_per_phys) - (word_209 & 0x3fff))
+				% (1 << log_per_phys);
+	}
 
 	VPRINTK("ENTER\n");
 
@@ -2407,6 +2422,11 @@ static unsigned int ata_scsiop_read_cap(
 		/* sector size */
 		rbuf[10] = ATA_SECT_SIZE >> 8;
 		rbuf[11] = ATA_SECT_SIZE & 0xff;
+
+		rbuf[12] = 0;
+		rbuf[13] = log_per_phys;
+		rbuf[14] = (lowest_aligned_lba >> 8) & 0x3f;
+		rbuf[15] = lowest_aligned_lba;
 	}
 
 	return 0;



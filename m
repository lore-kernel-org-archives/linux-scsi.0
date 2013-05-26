From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 1/6] scsi_debug: fix invalid address passed to kunmap_atomic()
Date: Sun, 26 May 2013 17:01:17 +0900
Message-ID: <1369555282-17864-2-git-send-email-akinobu.mita@gmail.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34989 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141Ab3EZIBt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 04:01:49 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so5734865pad.8
        for <linux-scsi@vger.kernel.org>; Sun, 26 May 2013 01:01:48 -0700 (PDT)
In-Reply-To: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

In the function prot_verify_write(), the kmap address 'daddr' is
incremented in the loop for each data page.  Finally 'daddr' reaches
the next page boundary in the end of the loop, and the invalid address
is passed to kunmap_atomic().

Fix the issue by not incrementing 'daddr' in the loop and offsetting it
by the loop counter on demand.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---

* Change from v2
- It was not very clear that incrementing 'daddr' in the loop and restoring
  the original value by subtracting the sum of increments.  Instead of
  doing that, fix the issue by not incrementing 'daddr' in the loop and
  offsetting it by the loop counter on demand.

 drivers/scsi/scsi_debug.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0a537a0..d51bddd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1899,7 +1899,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		daddr = kmap_atomic(sg_page(dsgl)) + dsgl->offset;
 
 		/* For each sector-sized chunk in data page */
-		for (j = 0 ; j < dsgl->length ; j += scsi_debug_sector_size) {
+		for (j = 0; j < dsgl->length; j += scsi_debug_sector_size) {
 
 			/* If we're at the end of the current
 			 * protection page advance to the next one
@@ -1917,11 +1917,11 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 			switch (scsi_debug_guard) {
 			case 1:
-				csum = ip_compute_csum(daddr,
+				csum = ip_compute_csum(daddr + j,
 						       scsi_debug_sector_size);
 				break;
 			case 0:
-				csum = cpu_to_be16(crc_t10dif(daddr,
+				csum = cpu_to_be16(crc_t10dif(daddr + j,
 						      scsi_debug_sector_size));
 				break;
 			default:
@@ -1938,7 +1938,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 				       be16_to_cpu(sdt->guard_tag),
 				       be16_to_cpu(csum));
 				ret = 0x01;
-				dump_sector(daddr, scsi_debug_sector_size);
+				dump_sector(daddr + j, scsi_debug_sector_size);
 				goto out;
 			}
 
@@ -1949,7 +1949,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 				       "%s: REF check failed on sector %lu\n",
 				       __func__, (unsigned long)sector);
 				ret = 0x03;
-				dump_sector(daddr, scsi_debug_sector_size);
+				dump_sector(daddr + j, scsi_debug_sector_size);
 				goto out;
 			}
 
@@ -1959,7 +1959,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 				       "%s: REF check failed on sector %lu\n",
 				       __func__, (unsigned long)sector);
 				ret = 0x03;
-				dump_sector(daddr, scsi_debug_sector_size);
+				dump_sector(daddr + j, scsi_debug_sector_size);
 				goto out;
 			}
 
@@ -1977,7 +1977,6 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 			start_sec++;
 			ei_lba++;
-			daddr += scsi_debug_sector_size;
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
 
-- 
1.8.1.4


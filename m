From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: debug: fix type mismatch warning for sg_pcopy_from_buffer
Date: Tue, 19 May 2015 23:22:39 +0200
Message-ID: <6309932.EjHf7uUo1X@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Gordon <david.s.gordon@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com
List-Id: linux-scsi@vger.kernel.org

The recent change to mark the input argument of sg_pcopy_from_buffer
had the unfortunate side-effect to cause a new warning in the
scsi_debug code:

drivers/scsi/scsi_debug.c: In function 'do_device_access':
drivers/scsi/scsi_debug.c:2376:8: warning: assignment from incompatible pointer type [-Wincompatible-pointer-types]
   func = sg_pcopy_from_buffer;

This patch attempts to avoid that warning without adding
evil type casts, but unfortunately makes the do_device_access
function a lot uglier in the process.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 5250326459 ("lib/scatterlist: mark input buffer parameters as 'const'")
---

I can't decide if this is actually a good idea, or if we should rather drop
the sg_pcopy_from_buffer() patch. Maybe someone else sees a better solution.

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f8e2dc9c616..dd9f0d1574ef 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2363,17 +2363,13 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 	u64 block, rest = 0;
 	struct scsi_data_buffer *sdb;
 	enum dma_data_direction dir;
-	size_t (*func)(struct scatterlist *, unsigned int, void *, size_t,
-		       off_t);
 
 	if (do_write) {
 		sdb = scsi_out(scmd);
 		dir = DMA_TO_DEVICE;
-		func = sg_pcopy_to_buffer;
 	} else {
 		sdb = scsi_in(scmd);
 		dir = DMA_FROM_DEVICE;
-		func = sg_pcopy_from_buffer;
 	}
 
 	if (!sdb->length)
@@ -2385,17 +2381,29 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 	if (block + num > sdebug_store_sectors)
 		rest = block + num - sdebug_store_sectors;
 
-	ret = func(sdb->table.sgl, sdb->table.nents,
-		   fake_storep + (block * scsi_debug_sector_size),
-		   (num - rest) * scsi_debug_sector_size, 0);
+	if (do_write)
+		ret = sg_pcopy_to_buffer(sdb->table.sgl, sdb->table.nents,
+				fake_storep + (block * scsi_debug_sector_size),
+				(num - rest) * scsi_debug_sector_size, 0);
+	else
+		ret = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
+				fake_storep + (block * scsi_debug_sector_size),
+				(num - rest) * scsi_debug_sector_size, 0);
+
 	if (ret != (num - rest) * scsi_debug_sector_size)
 		return ret;
 
-	if (rest) {
-		ret += func(sdb->table.sgl, sdb->table.nents,
-			    fake_storep, rest * scsi_debug_sector_size,
-			    (num - rest) * scsi_debug_sector_size);
-	}
+	if (!rest)
+		return ret;
+
+	if (do_write)
+		ret += sg_pcopy_to_buffer(sdb->table.sgl, sdb->table.nents,
+				fake_storep, rest * scsi_debug_sector_size,
+				(num - rest) * scsi_debug_sector_size);
+	else
+		ret += sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
+				fake_storep, rest * scsi_debug_sector_size,
+				(num - rest) * scsi_debug_sector_size);
 
 	return ret;
 }

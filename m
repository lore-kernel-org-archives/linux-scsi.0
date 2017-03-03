From: Joe Perches <joe@perches.com>
Subject: [PATCH] qla2xxx: Fix ql_dump_buffer
Date: Thu,  2 Mar 2017 17:14:47 -0800
Message-ID: <404b1c3a4bfd1f83211482b77b4a9680e755e32a.1488503664.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Recent printk changes for KERN_CONT cause this logging to be
defectively emitted on multiple lines.  Fix it.

Also reduces object size a trivial amount.

$ size drivers/scsi/qla2xxx/qla_dbg.o*
   text	   data	    bss	    dec	    hex	filename
  39125	      0	      0	  39125	   98d5	drivers/scsi/qla2xxx/qla_dbg.o.new
  39164	      0	      0	  39164	   98fc	drivers/scsi/qla2xxx/qla_dbg.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 21d9fb7fc887..51b4179469d1 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2707,13 +2707,9 @@ ql_dump_buffer(uint32_t level, scsi_qla_host_t *vha, int32_t id,
 	    "%-+5d  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n", size);
 	ql_dbg(level, vha, id,
 	    "----- -----------------------------------------------\n");
-	for (cnt = 0; cnt < size; cnt++, buf++) {
-		if (cnt % 16 == 0)
-			ql_dbg(level, vha, id, "%04x:", cnt & ~0xFU);
-		printk(" %02x", *buf);
-		if (cnt % 16 == 15)
-			printk("\n");
+	for (cnt = 0; cnt < size; cnt += 16) {
+		ql_dbg(level, vha, id, "%04x: ", cnt);
+		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
+			       buf + cnt, min(16U, size - cnt), false);
 	}
-	if (cnt % 16 != 0)
-		printk("\n");
 }
-- 
2.10.0.rc2.1.g053435c

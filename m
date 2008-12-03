From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [RFC PATCH-mm] scsi: use unaligned endian helpers rather than
 byteshifting
Date: Wed, 03 Dec 2008 11:37:23 -0800
Message-ID: <1228333043.5412.35.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:54822 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYLCTiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 14:38:52 -0500
Received: by gxk11 with SMTP id 11so776091gxk.13
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2008 11:38:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the unaligned access work in -mm.  Just so you can see what the
transition would look like.  See in particular the READ/WRITE6 bits
as just reading the full 32 bits and masking ends up being better on
lots of arches. (x86/powerpc/SH at least)

 drivers/scsi/aacraid/aachba.c |  126 +++++++++-------------------------------
 1 files changed, 29 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 90d1d08..5cdbc7d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -33,6 +33,7 @@
 #include <linux/blkdev.h>
 #include <asm/uaccess.h>
 #include <linux/highmem.h> /* For flush_kernel_dcache_page */
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1479,29 +1480,18 @@ static void io_callback(void *context, struct fib * fibptr)
 		switch (scsicmd->cmnd[0]) {
 		case WRITE_6:
 		case READ_6:
-			lba = ((scsicmd->cmnd[1] & 0x1F) << 16) |
-			    (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
+			lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[0]) & 0x1fffff;
 			break;
 		case WRITE_16:
 		case READ_16:
-			lba = ((u64)scsicmd->cmnd[2] << 56) |
-			      ((u64)scsicmd->cmnd[3] << 48) |
-			      ((u64)scsicmd->cmnd[4] << 40) |
-			      ((u64)scsicmd->cmnd[5] << 32) |
-			      ((u64)scsicmd->cmnd[6] << 24) |
-			      (scsicmd->cmnd[7] << 16) |
-			      (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+			lba = load_be64_noalign((__be64 *)&scsicmd->cmnd[2]);
 			break;
 		case WRITE_12:
 		case READ_12:
-			lba = ((u64)scsicmd->cmnd[2] << 24) |
-			      (scsicmd->cmnd[3] << 16) |
-			      (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+			lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
 			break;
 		default:
-			lba = ((u64)scsicmd->cmnd[2] << 24) |
-			       (scsicmd->cmnd[3] << 16) |
-			       (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+			lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
 			break;
 		}
 		printk(KERN_DEBUG
@@ -1576,34 +1566,20 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	case READ_16:
 		dprintk((KERN_DEBUG "aachba: received a read(16) command on id %d.\n", scmd_id(scsicmd)));
 
-		lba =	((u64)scsicmd->cmnd[2] << 56) |
-			((u64)scsicmd->cmnd[3] << 48) |
-			((u64)scsicmd->cmnd[4] << 40) |
-			((u64)scsicmd->cmnd[5] << 32) |
-			((u64)scsicmd->cmnd[6] << 24) |
-			(scsicmd->cmnd[7] << 16) |
-			(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
-		count = (scsicmd->cmnd[10] << 24) |
-			(scsicmd->cmnd[11] << 16) |
-			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
+		lba = load_be64_noalign((__be64 *)&scsicmd->cmnd[2]);
+		count = load_be32_noalign((__be32 *)&scsicmd->cmnd[10]);
 		break;
 	case READ_12:
 		dprintk((KERN_DEBUG "aachba: received a read(12) command on id %d.\n", scmd_id(scsicmd)));
 
-		lba = ((u64)scsicmd->cmnd[2] << 24) |
-			(scsicmd->cmnd[3] << 16) |
-			(scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
-		count = (scsicmd->cmnd[6] << 24) |
-			(scsicmd->cmnd[7] << 16) |
-			(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+		lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
+		count = load_be32_noalign((__be32 *)&scsicmd->cmnd[6]);
 		break;
 	default:
 		dprintk((KERN_DEBUG "aachba: received a read(10) command on id %d.\n", scmd_id(scsicmd)));
 
-		lba = ((u64)scsicmd->cmnd[2] << 24) |
-			(scsicmd->cmnd[3] << 16) |
-			(scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
-		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
+		lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
+		count = load_be16_noalign((__be16 *)&scsicmd->cmnd[7]);
 		break;
 	}
 	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
@@ -1661,28 +1637,19 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	} else if (scsicmd->cmnd[0] == WRITE_16) { /* 16 byte command */
 		dprintk((KERN_DEBUG "aachba: received a write(16) command on id %d.\n", scmd_id(scsicmd)));
 
-		lba =	((u64)scsicmd->cmnd[2] << 56) |
-			((u64)scsicmd->cmnd[3] << 48) |
-			((u64)scsicmd->cmnd[4] << 40) |
-			((u64)scsicmd->cmnd[5] << 32) |
-			((u64)scsicmd->cmnd[6] << 24) |
-			(scsicmd->cmnd[7] << 16) |
-			(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
-		count = (scsicmd->cmnd[10] << 24) | (scsicmd->cmnd[11] << 16) |
-			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
+		lba = load_be64_noalign((__be64 *)&scsicmd->cmnd[2]);
+		count = load_be32_noalign((__be32 *)&scsicmd->cmnd[10]);
 		fua = scsicmd->cmnd[1] & 0x8;
 	} else if (scsicmd->cmnd[0] == WRITE_12) { /* 12 byte command */
 		dprintk((KERN_DEBUG "aachba: received a write(12) command on id %d.\n", scmd_id(scsicmd)));
 
-		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16)
-		    | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
-		count = (scsicmd->cmnd[6] << 24) | (scsicmd->cmnd[7] << 16)
-		      | (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+		lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
+		count = load_be32_noalign((__be32 *)&scsicmd->cmnd[6]);
 		fua = scsicmd->cmnd[1] & 0x8;
 	} else {
 		dprintk((KERN_DEBUG "aachba: received a write(10) command on id %d.\n", scmd_id(scsicmd)));
-		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
-		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
+		lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
+		count = load_be16_noalign((__be16 *)&scsicmd->cmnd[7]);
 		fua = scsicmd->cmnd[1] & 0x8;
 	}
 	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %llu, t = %ld.\n",
@@ -1770,9 +1737,8 @@ static int aac_synchronize(struct scsi_cmnd *scsicmd)
 	struct scsi_device *sdev = scsicmd->device;
 	int active = 0;
 	struct aac_dev *aac;
-	u64 lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) |
-		(scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
-	u32 count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
+	u64 lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[2]);
+	u32 count = load_be16_noalign((__be16 *)&scsicmd->cmnd[7]);
 	unsigned long flags;
 
 	/*
@@ -1786,41 +1752,19 @@ static int aac_synchronize(struct scsi_cmnd *scsicmd)
 			u32 cmnd_count;
 
 			if (cmd->cmnd[0] == WRITE_6) {
-				cmnd_lba = ((cmd->cmnd[1] & 0x1F) << 16) |
-					(cmd->cmnd[2] << 8) |
-					cmd->cmnd[3];
+				cmnd_lba = load_be32_noalign((__be32 *)&cmd->cmnd[0]) & 0x1fffff;
 				cmnd_count = cmd->cmnd[4];
 				if (cmnd_count == 0)
 					cmnd_count = 256;
 			} else if (cmd->cmnd[0] == WRITE_16) {
-				cmnd_lba = ((u64)cmd->cmnd[2] << 56) |
-					((u64)cmd->cmnd[3] << 48) |
-					((u64)cmd->cmnd[4] << 40) |
-					((u64)cmd->cmnd[5] << 32) |
-					((u64)cmd->cmnd[6] << 24) |
-					(cmd->cmnd[7] << 16) |
-					(cmd->cmnd[8] << 8) |
-					cmd->cmnd[9];
-				cmnd_count = (cmd->cmnd[10] << 24) |
-					(cmd->cmnd[11] << 16) |
-					(cmd->cmnd[12] << 8) |
-					cmd->cmnd[13];
+				cmnd_lba = load_be64_noalign((__be64 *)&cmd->cmnd[2]);
+				cmnd_count = load_be32_noalign((__be32 *)&cmd->cmnd[10]);
 			} else if (cmd->cmnd[0] == WRITE_12) {
-				cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
-					(cmd->cmnd[3] << 16) |
-					(cmd->cmnd[4] << 8) |
-					cmd->cmnd[5];
-				cmnd_count = (cmd->cmnd[6] << 24) |
-					(cmd->cmnd[7] << 16) |
-					(cmd->cmnd[8] << 8) |
-					cmd->cmnd[9];
+				cmnd_lba = load_be32_noalign((__be32 *)&cmd->cmnd[2]);
+				cmnd_count = load_be32_noalign((__be32 *)&cmd->cmnd[6]);
 			} else if (cmd->cmnd[0] == WRITE_10) {
-				cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
-					(cmd->cmnd[3] << 16) |
-					(cmd->cmnd[4] << 8) |
-					cmd->cmnd[5];
-				cmnd_count = (cmd->cmnd[7] << 8) |
-					cmd->cmnd[8];
+				cmnd_lba = load_be32_noalign((__be32 *)&cmd->cmnd[2]);
+				cmnd_count = load_be16_noalign((__be16 *)&cmd->cmnd[7]);
 			} else
 				continue;
 			if (((cmnd_lba + cmnd_count) < lba) ||
@@ -2136,23 +2080,14 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 
 		dprintk((KERN_DEBUG "READ CAPACITY_16 command.\n"));
 		capacity = fsa_dev_ptr[cid].size - 1;
-		cp[0] = (capacity >> 56) & 0xff;
-		cp[1] = (capacity >> 48) & 0xff;
-		cp[2] = (capacity >> 40) & 0xff;
-		cp[3] = (capacity >> 32) & 0xff;
-		cp[4] = (capacity >> 24) & 0xff;
-		cp[5] = (capacity >> 16) & 0xff;
-		cp[6] = (capacity >> 8) & 0xff;
-		cp[7] = (capacity >> 0) & 0xff;
+		store_be64_noalign((__be64 *)&cp[0], capacity);
 		cp[8] = 0;
 		cp[9] = 0;
 		cp[10] = 2;
 		cp[11] = 0;
 		cp[12] = 0;
 
-		alloc_len = ((scsicmd->cmnd[10] << 24)
-			     + (scsicmd->cmnd[11] << 16)
-			     + (scsicmd->cmnd[12] << 8) + scsicmd->cmnd[13]);
+		alloc_len = load_be32_noalign((__be32 *)&scsicmd->cmnd[10]);
 
 		alloc_len = min_t(size_t, alloc_len, sizeof(cp));
 		scsi_sg_copy_from_buffer(scsicmd, cp, alloc_len);
@@ -2180,10 +2115,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		else
 			capacity = (u32)-1;
 
-		cp[0] = (capacity >> 24) & 0xff;
-		cp[1] = (capacity >> 16) & 0xff;
-		cp[2] = (capacity >> 8) & 0xff;
-		cp[3] = (capacity >> 0) & 0xff;
+		store_be32_noalign((__be32 *)&cp[0], capacity);
 		cp[4] = 0;
 		cp[5] = 0;
 		cp[6] = 2;
-- 
1.6.1.rc1.262.gb6810




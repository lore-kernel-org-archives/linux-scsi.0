From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 13/17] scsi: remove private implementation of
 get_unaligned_be32
Date: Wed, 29 Oct 2008 18:03:04 -0700
Message-ID: <1225328584.5496.7.camel@brick>
References: <200810292124.m9TLOjl1021276@imap1.linux-foundation.org>
	 <1225316894.3257.19.camel@localhost.localdomain>
	 <20081029150702.1a20310a.akpm@linux-foundation.org>
	 <1225318393.3257.24.camel@localhost.localdomain>
	 <1225319368.5496.3.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:13951 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYJ3BDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 21:03:08 -0400
Received: by wf-out-1314.google.com with SMTP id 27so285905wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 18:03:06 -0700 (PDT)
In-Reply-To: <1225319368.5496.3.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Wed, 2008-10-29 at 15:29 -0700, Harvey Harrison wrote:
> Did you ever have some time to think about my suggestion regarding
> defining some common packed structs for the different command formats
> taht could be endian-annotated, then use the unaligned helpers against
> pointers to these structs...so sparse would actually spot endian
> mixups in scsi thereafter?

Here's a small patch to illustrate the kind of thing I'm suggesting in
a less hand-wavy way.

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index afe1de9..451f097 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -40,6 +40,7 @@
 #include <linux/compat.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -753,57 +754,41 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	ldio->start_lba_hi = 0;
 	ldio->access_byte = (scp->cmd_len != 6) ? scp->cmnd[1] : 0;
 
-	/*
-	 * 6-byte READ(0x08) or WRITE(0x0A) cdb
-	 */
 	if (scp->cmd_len == 6) {
+		/*
+		 * 6-byte READ(0x08) or WRITE(0x0A) cdb
+		 */
 		ldio->lba_count = (u32) scp->cmnd[4];
 		ldio->start_lba_lo = ((u32) scp->cmnd[1] << 16) |
 		    ((u32) scp->cmnd[2] << 8) | (u32) scp->cmnd[3];
 
 		ldio->start_lba_lo &= 0x1FFFFF;
-	}
-
-	/*
-	 * 10-byte READ(0x28) or WRITE(0x2A) cdb
-	 */
-	else if (scp->cmd_len == 10) {
-		ldio->lba_count = (u32) scp->cmnd[8] |
-		    ((u32) scp->cmnd[7] << 8);
-		ldio->start_lba_lo = ((u32) scp->cmnd[2] << 24) |
-		    ((u32) scp->cmnd[3] << 16) |
-		    ((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
-	}
-
-	/*
-	 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
-	 */
-	else if (scp->cmd_len == 12) {
-		ldio->lba_count = ((u32) scp->cmnd[6] << 24) |
-		    ((u32) scp->cmnd[7] << 16) |
-		    ((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
-
-		ldio->start_lba_lo = ((u32) scp->cmnd[2] << 24) |
-		    ((u32) scp->cmnd[3] << 16) |
-		    ((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
-	}
-
-	/*
-	 * 16-byte READ(0x88) or WRITE(0x8A) cdb
-	 */
-	else if (scp->cmd_len == 16) {
-		ldio->lba_count = ((u32) scp->cmnd[10] << 24) |
-		    ((u32) scp->cmnd[11] << 16) |
-		    ((u32) scp->cmnd[12] << 8) | (u32) scp->cmnd[13];
+	} else if (scp->cmd_len == 10) {
+		/*
+		 * 10-byte READ(0x28) or WRITE(0x2A) cdb
+		 */
+		struct scsi_read10 *cmd = (struct scsi_read10 *)scp->cmnd;
 
-		ldio->start_lba_lo = ((u32) scp->cmnd[6] << 24) |
-		    ((u32) scp->cmnd[7] << 16) |
-		    ((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
+		ldio->lba_count = get_unaligned_be16(&cmd->length);
+		ldio->start_lba_lo = get_unaligned_be32(&cmd->lba);
+	} else if (scp->cmd_len == 12) {
+		/*
+		 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
+		 */
+		struct scsi_read12 *cmd = (struct scsi_read12 *)scp->cmnd;
 
-		ldio->start_lba_hi = ((u32) scp->cmnd[2] << 24) |
-		    ((u32) scp->cmnd[3] << 16) |
-		    ((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+		ldio->lba_count = get_unaligned_be32(&cmd->length);
+		ldio->start_lba_lo = get_unaligned_be32(&cmd->lba);
+	} else if (scp->cmd_len == 16) {
+		/*
+		 * 16-byte READ(0x88) or WRITE(0x8A) cdb
+		 */
+		struct scsi_read16 *cmd = (struct scsi_read16 *)scp->cmnd;
+		u64 lba = get_unaligned_be64(&cmd->lba);
 
+		ldio->lba_count = get_unaligned_be32(&cmd->length);
+		ldio->start_lba_lo = (u32)lba;
+		ldio->start_lba_hi = (u32)(lba >> 32);
 	}
 
 	/*
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 855bf95..184d83d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -131,6 +131,42 @@ struct scsi_cmnd {
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
+/*
+ * Opcode 0x28
+ */
+struct scsi_read10 {
+	u8 op;
+	u8 flags;
+	__be32 lba;
+	u8 pad; /* reserved */
+	__be16 length;
+	u8 control;
+} __packed;
+
+/*
+ * Opcode 0xa8
+ */
+struct scsi_read12 {
+	u8 op;
+	u8 flags;
+	__be32 lba;
+	__be32 length;
+	u8 pad; /* reserved */
+	u8 control;
+} __packed;
+
+/*
+ * Opcode 0x88
+ */
+struct scsi_read16 {
+	u8 op;
+	u8 flags;
+	__be64 lba;
+	__be32 length;
+	u8 pad; /* MMC4, reserved, group number */
+	u8 control;
+} __packed;
+
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
 extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);



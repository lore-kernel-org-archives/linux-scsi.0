From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: sd: Make protection lookup tables static
Date: Mon, 7 Jan 2019 22:41:51 +0800
Message-ID: <1546872111-5627-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently the protection lookup tables in sd_prot_flag_mask() and
sd_prot_op() are declared non-static. As such, they will be rebuilt for
each respective function call.

Optimise by making them static.

This saves ~100B object code for sd.c:

Before:
   text	   data	    bss	    dec	    hex	filename
  25403	   1024	     16	  26443	   674b	drivers/scsi/sd.o

After:
  text	   data	    bss	    dec	    hex	filename
  25299	   1024	     16	  26339	   66e3	drivers/scsi/sd.o

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 1d63f3a..89e6d42 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -195,15 +195,15 @@ static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sec
 static inline unsigned int sd_prot_op(bool write, bool dix, bool dif)
 {
 	/* Lookup table: bit 2 (write), bit 1 (dix), bit 0 (dif) */
-	const unsigned int ops[] = {	/* wrt dix dif */
-		SCSI_PROT_NORMAL,	/*  0	0   0  */
-		SCSI_PROT_READ_STRIP,	/*  0	0   1  */
-		SCSI_PROT_READ_INSERT,	/*  0	1   0  */
-		SCSI_PROT_READ_PASS,	/*  0	1   1  */
-		SCSI_PROT_NORMAL,	/*  1	0   0  */
-		SCSI_PROT_WRITE_INSERT, /*  1	0   1  */
-		SCSI_PROT_WRITE_STRIP,	/*  1	1   0  */
-		SCSI_PROT_WRITE_PASS,	/*  1	1   1  */
+	static const unsigned int ops[] = {	/* wrt dix dif */
+		SCSI_PROT_NORMAL,		/*  0	0   0  */
+		SCSI_PROT_READ_STRIP,		/*  0	0   1  */
+		SCSI_PROT_READ_INSERT,		/*  0	1   0  */
+		SCSI_PROT_READ_PASS,		/*  0	1   1  */
+		SCSI_PROT_NORMAL,		/*  1	0   0  */
+		SCSI_PROT_WRITE_INSERT,		/*  1	0   1  */
+		SCSI_PROT_WRITE_STRIP,		/*  1	1   0  */
+		SCSI_PROT_WRITE_PASS,		/*  1	1   1  */
 	};
 
 	return ops[write << 2 | dix << 1 | dif];
@@ -215,7 +215,7 @@ static inline unsigned int sd_prot_op(bool write, bool dix, bool dif)
  */
 static inline unsigned int sd_prot_flag_mask(unsigned int prot_op)
 {
-	const unsigned int flag_mask[] = {
+	static const unsigned int flag_mask[] = {
 		[SCSI_PROT_NORMAL]		= 0,
 
 		[SCSI_PROT_READ_STRIP]		= SCSI_PROT_TRANSFER_PI |
-- 
1.9.1

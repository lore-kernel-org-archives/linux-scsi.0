From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2] scsi: sd: Make protection lookup tables static and relocate functions
Date: Tue, 8 Jan 2019 23:14:52 +0800
Message-ID: <1546960492-218420-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently the protection lookup tables in sd_prot_flag_mask() and
sd_prot_op() are declared as non-static. As such, they will be rebuilt
for each respective function call.

Optimise by making them static.

This saves ~100B object code for sd.c:

Before:
   text	   data	    bss	    dec	    hex	filename
  25403	   1024	     16	  26443	   674b	drivers/scsi/sd.o

After:
  text	   data	    bss	    dec	    hex	filename
  25299	   1024	     16	  26339	   66e3	drivers/scsi/sd.o

In addition, since those same functions are declared in sd.h, but each are
only referenced in sd.c, relocate them to that same c file.

The inline specifier is dropped also, since gcc should be able to make the
decision to inline.

Signed-off-by: John Garry <john.garry@huawei.com>
---

Differences v1->v2:
- relocate functions to sd.c and drop inline specifier

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3bb2b33..e7dcc02 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -658,6 +658,68 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 }
 #endif /* CONFIG_BLK_SED_OPAL */
 
+/*
+ * Look up the DIX operation based on whether the command is read or
+ * write and whether dix and dif are enabled.
+ */
+static unsigned int sd_prot_op(bool write, bool dix, bool dif)
+{
+	/* Lookup table: bit 2 (write), bit 1 (dix), bit 0 (dif) */
+	static const unsigned int ops[] = {	/* wrt dix dif */
+		SCSI_PROT_NORMAL,		/*  0	0   0  */
+		SCSI_PROT_READ_STRIP,		/*  0	0   1  */
+		SCSI_PROT_READ_INSERT,		/*  0	1   0  */
+		SCSI_PROT_READ_PASS,		/*  0	1   1  */
+		SCSI_PROT_NORMAL,		/*  1	0   0  */
+		SCSI_PROT_WRITE_INSERT,		/*  1	0   1  */
+		SCSI_PROT_WRITE_STRIP,		/*  1	1   0  */
+		SCSI_PROT_WRITE_PASS,		/*  1	1   1  */
+	};
+
+	return ops[write << 2 | dix << 1 | dif];
+}
+
+/*
+ * Returns a mask of the protection flags that are valid for a given DIX
+ * operation.
+ */
+static unsigned int sd_prot_flag_mask(unsigned int prot_op)
+{
+	static const unsigned int flag_mask[] = {
+		[SCSI_PROT_NORMAL]		= 0,
+
+		[SCSI_PROT_READ_STRIP]		= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT,
+
+		[SCSI_PROT_READ_INSERT]		= SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+
+		[SCSI_PROT_READ_PASS]		= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+
+		[SCSI_PROT_WRITE_INSERT]	= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_REF_INCREMENT,
+
+		[SCSI_PROT_WRITE_STRIP]		= SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+
+		[SCSI_PROT_WRITE_PASS]		= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+	};
+
+	return flag_mask[prot_op];
+}
+
 static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 1d63f3a..6e68baf 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -188,68 +188,6 @@ static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sec
 	return sector >> (ilog2(sdev->sector_size) - 9);
 }
 
-/*
- * Look up the DIX operation based on whether the command is read or
- * write and whether dix and dif are enabled.
- */
-static inline unsigned int sd_prot_op(bool write, bool dix, bool dif)
-{
-	/* Lookup table: bit 2 (write), bit 1 (dix), bit 0 (dif) */
-	const unsigned int ops[] = {	/* wrt dix dif */
-		SCSI_PROT_NORMAL,	/*  0	0   0  */
-		SCSI_PROT_READ_STRIP,	/*  0	0   1  */
-		SCSI_PROT_READ_INSERT,	/*  0	1   0  */
-		SCSI_PROT_READ_PASS,	/*  0	1   1  */
-		SCSI_PROT_NORMAL,	/*  1	0   0  */
-		SCSI_PROT_WRITE_INSERT, /*  1	0   1  */
-		SCSI_PROT_WRITE_STRIP,	/*  1	1   0  */
-		SCSI_PROT_WRITE_PASS,	/*  1	1   1  */
-	};
-
-	return ops[write << 2 | dix << 1 | dif];
-}
-
-/*
- * Returns a mask of the protection flags that are valid for a given DIX
- * operation.
- */
-static inline unsigned int sd_prot_flag_mask(unsigned int prot_op)
-{
-	const unsigned int flag_mask[] = {
-		[SCSI_PROT_NORMAL]		= 0,
-
-		[SCSI_PROT_READ_STRIP]		= SCSI_PROT_TRANSFER_PI |
-						  SCSI_PROT_GUARD_CHECK |
-						  SCSI_PROT_REF_CHECK |
-						  SCSI_PROT_REF_INCREMENT,
-
-		[SCSI_PROT_READ_INSERT]		= SCSI_PROT_REF_INCREMENT |
-						  SCSI_PROT_IP_CHECKSUM,
-
-		[SCSI_PROT_READ_PASS]		= SCSI_PROT_TRANSFER_PI |
-						  SCSI_PROT_GUARD_CHECK |
-						  SCSI_PROT_REF_CHECK |
-						  SCSI_PROT_REF_INCREMENT |
-						  SCSI_PROT_IP_CHECKSUM,
-
-		[SCSI_PROT_WRITE_INSERT]	= SCSI_PROT_TRANSFER_PI |
-						  SCSI_PROT_REF_INCREMENT,
-
-		[SCSI_PROT_WRITE_STRIP]		= SCSI_PROT_GUARD_CHECK |
-						  SCSI_PROT_REF_CHECK |
-						  SCSI_PROT_REF_INCREMENT |
-						  SCSI_PROT_IP_CHECKSUM,
-
-		[SCSI_PROT_WRITE_PASS]		= SCSI_PROT_TRANSFER_PI |
-						  SCSI_PROT_GUARD_CHECK |
-						  SCSI_PROT_REF_CHECK |
-						  SCSI_PROT_REF_INCREMENT |
-						  SCSI_PROT_IP_CHECKSUM,
-	};
-
-	return flag_mask[prot_op];
-}
-
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 extern void sd_dif_config_host(struct scsi_disk *);
-- 
1.9.1

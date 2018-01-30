From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: implement IMMED bit
Date: Tue, 30 Jan 2018 00:54:45 -0500
Message-ID: <20180130055445.20244-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54809 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752325AbeA3Fyu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jan 2018 00:54:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hare@suse.de, bart.vanassche@wdc.com

The start stop unit command takes in the order of a second to complete
on some SAS SSDs and longer on hard disks. Synchronize cache can also
take some time. Both commands have an IMMED bit for those apps that don't
want to wait. This patch introduces a long delay for those commands
when the IMMED bit is clear.

Changes:
  - add the SYNCHRONIZE CACHE(16) command
  - together with the existing START STOP UNIT and SYNCHRONIZE CACHE(10)
    commands process the IMMED bit in their cdbs
  - if the IMMED bit is set, return immediately
  - if the IMMED bit is clear, treat the delay parameter as having
    a unit of one second
  - in the SYNCHRONIZE CACHE processing do a bounds check

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 76 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a5986dae9020..0996fcb8a8d2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6,7 +6,7 @@
  *  anything out of the ordinary is seen.
  * ^^^^^^^^^^^^^^^^^^^^^^^ Original ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  *
- * Copyright (C) 2001 - 2017 Douglas Gilbert
+ * Copyright (C) 2001 - 2018 Douglas Gilbert
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -61,8 +61,8 @@
 #include "scsi_logging.h"
 
 /* make sure inq_product_rev string corresponds to this version */
-#define SDEBUG_VERSION "0187"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20171202";
+#define SDEBUG_VERSION "0188"	/* format to fit INQUIRY revision field */
+static const char *sdebug_version_date = "20180128";
 
 #define MY_NAME "scsi_debug"
 
@@ -234,6 +234,7 @@ static const char *sdebug_version_date = "20171202";
 #define F_INV_OP		0x200
 #define F_FAKE_RW		0x400
 #define F_M_ACCESS		0x800	/* media access */
+#define F_LONG_DELAY		0x1000
 
 #define FF_RESPOND (F_RL_WLUN_OK | F_SKIP_UA | F_DELAY_OVERR)
 #define FF_MEDIA_IO (F_M_ACCESS | F_FAKE_RW)
@@ -349,7 +350,7 @@ enum sdeb_opcode_index {
 	SDEB_I_XDWRITEREAD = 25,	/* 10 only */
 	SDEB_I_WRITE_BUFFER = 26,
 	SDEB_I_WRITE_SAME = 27,		/* 10, 16 */
-	SDEB_I_SYNC_CACHE = 28,		/* 10 only */
+	SDEB_I_SYNC_CACHE = 28,		/* 10, 16 */
 	SDEB_I_COMP_WRITE = 29,
 	SDEB_I_LAST_ELEMENT = 30,	/* keep this last (previous + 1) */
 };
@@ -382,7 +383,7 @@ static const unsigned char opcode_ind_arr[256] = {
 /* 0x80; 0x80->0x9f: 16 byte cdbs */
 	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
 	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0, 0, 0, 0, 0,
-	0, 0, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
+	0, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
@@ -398,6 +399,14 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 };
 
+/*
+ * The following "response" functions return the SCSI mid-level's 4 byte
+ * tuple-in-an-int. To handle commands with an IMMED bit, for a faster
+ * command completion, they can mask their return value with
+ * SDEG_RES_IMMED_MASK .
+ */
+#define SDEG_RES_IMMED_MASK 0x40000000
+
 static int resp_inquiry(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_report_luns(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_requests(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -420,6 +429,7 @@ static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 /*
  * The following are overflow arrays for cdbs that "hit" the same index in
@@ -499,6 +509,12 @@ static const struct opcode_info_t release_iarr[] = {
 	    {6,  0x1f, 0xff, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
 
+static const struct opcode_info_t sync_cache_iarr[] = {
+	{0, 0x91, 0, F_LONG_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
+	    {16,  0x7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* SYNC_CACHE (16) */
+};
+
 
 /* This array is accessed via SDEB_I_* values. Make sure all are mapped,
  * plus the terminating elements for logic that scans this table such as
@@ -536,8 +552,8 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{ARRAY_SIZE(write_iarr), 0x8a, 0, F_D_OUT | FF_MEDIA_IO,
 	    resp_write_dt0, write_iarr,			/* WRITE(16) */
 		{16,  0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-		 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7} },		/* WRITE(16) */
-	{0, 0x1b, 0, 0, resp_start_stop, NULL,		/* START STOP UNIT */
+		 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7} },
+	{0, 0x1b, 0, F_LONG_DELAY, resp_start_stop, NULL,/* START STOP UNIT */
 	    {6,  0x1, 0, 0xf, 0xf7, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{ARRAY_SIZE(sa_in_16_iarr), 0x9e, 0x10, F_SA_LOW | F_D_IN,
 	    resp_readcap16, sa_in_16_iarr, /* SA_IN(16), READ CAPACITY(16) */
@@ -590,9 +606,10 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    resp_write_same_10, write_same_iarr,	/* WRITE SAME(10) */
 		{10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0,
 		 0, 0, 0, 0, 0} },
-	{0, 0x35, 0, F_DELAY_OVERR | FF_MEDIA_IO, NULL, NULL, /* SYNC_CACHE */
+	{ARRAY_SIZE(sync_cache_iarr), 0x35, 0, F_LONG_DELAY | F_M_ACCESS,
+	    resp_sync_cache, sync_cache_iarr,
 	    {10,  0x7, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
-	     0, 0, 0, 0} },
+	     0, 0, 0, 0} },			/* SYNC_CACHE (10) */
 	{0, 0x89, 0, F_D_OUT | FF_MEDIA_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
 	     0, 0xff, 0x3f, 0xc7} },		/* COMPARE AND WRITE */
@@ -1597,7 +1614,7 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 	}
 	stop = !(cmd[4] & 1);
 	atomic_xchg(&devip->stopped, stop);
-	return 0;
+	return (cmd[1] & 0x1) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */
 }
 
 static sector_t get_sdebug_capacity(void)
@@ -3562,6 +3579,27 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
 }
 
+static int resp_sync_cache(struct scsi_cmnd *scp,
+			   struct sdebug_dev_info *devip)
+{
+	u64 lba;
+	u32 num_blocks;
+	u8 *cmd = scp->cmnd;
+
+	if (cmd[0] == SYNCHRONIZE_CACHE) {	/* 10 byte cdb */
+		lba = get_unaligned_be32(cmd + 2);
+		num_blocks = get_unaligned_be16(cmd + 7);
+	} else {				/* SYNCHRONIZE_CACHE(16) */
+		lba = get_unaligned_be64(cmd + 2);
+		num_blocks = get_unaligned_be32(cmd + 10);
+	}
+	if (lba + num_blocks > sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		return check_condition_result;
+	}
+	return (cmd[1] & 0x2) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */
+}
+
 #define RL_BUCKET_ELEMS 8
 
 /* Even though each pseudo target has a REPORT LUNS "well known logical unit"
@@ -5717,11 +5755,27 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		errsts = oip->pfp(scp, devip);	/* calls a resp_* function */
 	else if (r_pfp)	/* if leaf function ptr NULL, try the root's */
 		errsts = r_pfp(scp, devip);
+	if (errsts & SDEG_RES_IMMED_MASK) {
+		errsts &= ~SDEG_RES_IMMED_MASK;
+		flags |= F_DELAY_OVERR;
+		flags &= ~F_LONG_DELAY;
+	}
+
 
 fini:
 	if (F_DELAY_OVERR & flags)
 		return schedule_resp(scp, devip, errsts, 0, 0);
-	else
+	else if ((sdebug_jdelay || sdebug_ndelay) && (flags & F_LONG_DELAY)) {
+		/*
+		 * If any delay is active, want F_LONG_DELAY to be at least 1
+		 * second and if sdebug_jdelay>0 want a long delay of that
+		 * many seconds.
+		 */
+		int jdelay = (sdebug_jdelay < 2) ? 1 : sdebug_jdelay;
+
+		jdelay = mult_frac(USER_HZ * jdelay, HZ, USER_HZ);
+		return schedule_resp(scp, devip, errsts, jdelay, 0);
+	} else
 		return schedule_resp(scp, devip, errsts, sdebug_jdelay,
 				     sdebug_ndelay);
 check_cond:
-- 
2.14.1

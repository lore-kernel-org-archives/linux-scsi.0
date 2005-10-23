From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 1/2] libata: MODE SELECT, strengthen mode sense
Date: Sun, 23 Oct 2005 16:24:20 +1000
Message-ID: <435B2C94.2000700@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020903050000040906020901"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020903050000040906020901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Patch against libata-dev git tree, upstream branch

Changelog:
  - move default mode pages to the front of libata-scsi.c
    so various functions can access them
  - partial annotation of these pages, point out divergence
    from sat-r06
  - replace various mode page magic numbers with defines
  - strengthen MODE SENSE command decoding: handle DBD
    bit in cdb, yield block descriptor (per sat-r06) and
    handle mode sub pages


Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------020903050000040906020901
Content-Type: text/x-patch;
 name="libata-scsi051023ms1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-scsi051023ms1.diff"

--- libata-dev/drivers/scsi/libata-scsi.c	2005-10-23 13:18:05.000000000 +1000
+++ libata-dev/drivers/scsi/libata-scsi.c051023ms1	2005-10-23 14:31:44.000000000 +1000
@@ -48,6 +48,45 @@
 static struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev);
 
+#define RW_RECOVERY_MPAGE 0x1
+#define RW_RECOVERY_MPAGE_LEN 12
+#define CACHE_MPAGE 0x8
+#define CACHE_MPAGE_LEN 20
+#define CONTROL_MPAGE 0xa
+#define CONTROL_MPAGE_LEN 12
+#define ALL_MPAGES 0x3f
+#define ALL_SUB_MPAGES 0xff
+
+
+static const u8 def_rw_recovery_mpage[] = {
+	RW_RECOVERY_MPAGE,
+	RW_RECOVERY_MPAGE_LEN - 2,
+	(1 << 7) |	/* AWRE, sat-r06 say it shall be 0 */
+	    (1 << 6),	/* ARRE (auto read reallocation) */
+	0,		/* read retry count */
+	0, 0, 0, 0,
+	0,		/* write retry count */
+	0, 0, 0
+};
+
+static const u8 def_cache_mpage[CACHE_MPAGE_LEN] = {
+	CACHE_MPAGE,
+	CACHE_MPAGE_LEN - 2,
+	0,		/* contains WCE, needs to be 0 for logic */
+	0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0,		/* contains DRA, needs to be 0 for logic */
+	0, 0, 0, 0, 0, 0, 0
+};
+
+static const u8 def_control_mpage[CONTROL_MPAGE_LEN] = {
+	CONTROL_MPAGE,
+	CONTROL_MPAGE_LEN - 2,
+	2,	/* DSENSE=0, GLTSD=1 */
+	0,	/* [QAM+QERR may be 1, see 05-359r1] */
+	0, 0, 0, 0, 0xff, 0xff,
+	0, 30	/* extended self test time, see 05-359r1 */
+};
+
 
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
@@ -1266,13 +1305,9 @@
 static unsigned int ata_msense_caching(u16 *id, u8 **ptr_io,
 				       const u8 *last)
 {
-	u8 page[] = {
-		0x8,				/* page code */
-		0x12,				/* page length */
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 10 zeroes */
-		0, 0, 0, 0, 0, 0, 0, 0		/* 8 zeroes */
-	};
+	u8 page[CACHE_MPAGE_LEN];
 
+	memcpy(page, def_cache_mpage, sizeof(page));
 	if (ata_id_wcache_enabled(id))
 		page[2] |= (1 << 2);	/* write cache enable */
 	if (!ata_id_rahead_enabled(id))
@@ -1296,15 +1331,9 @@
 
 static unsigned int ata_msense_ctl_mode(u8 **ptr_io, const u8 *last)
 {
-	const u8 page[] = {0xa, 0xa, 6, 0, 0, 0, 0, 0, 0xff, 0xff, 0, 30};
-
-	/* byte 2: set the descriptor format sense data bit (bit 2)
-	 * since we need to support returning this format for SAT
-	 * commands and any SCSI commands against a 48b LBA device.
-	 */
-
-	ata_msense_push(ptr_io, last, page, sizeof(page));
-	return sizeof(page);
+	ata_msense_push(ptr_io, last, def_control_mpage,
+			sizeof(def_control_mpage));
+	return sizeof(def_control_mpage);
 }
 
 /**
@@ -1321,15 +1350,10 @@
 
 static unsigned int ata_msense_rw_recovery(u8 **ptr_io, const u8 *last)
 {
-	const u8 page[] = {
-		0x1,			  /* page code */
-		0xa,			  /* page length */
-		(1 << 7) | (1 << 6),	  /* note auto r/w reallocation */
-		0, 0, 0, 0, 0, 0, 0, 0, 0 /* 9 zeroes */
-	};
 
-	ata_msense_push(ptr_io, last, page, sizeof(page));
-	return sizeof(page);
+	ata_msense_push(ptr_io, last, def_rw_recovery_mpage,
+			sizeof(def_rw_recovery_mpage));
+	return sizeof(def_rw_recovery_mpage);
 }
 
 /**
@@ -1338,7 +1362,9 @@
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
  *	@buflen: Response buffer length.
  *
- *	Simulate MODE SENSE commands.
+ *	Simulate MODE SENSE commands. Assume this is invoked for direct
+ *	access devices (e.g. disks) only. There should be no block
+ *	descriptor for other device types.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -1348,15 +1374,22 @@
 				  unsigned int buflen)
 {
 	u8 *scsicmd = args->cmd->cmnd, *p, *last;
-	unsigned int page_control, six_byte, output_len;
+	const u8 sat_blk_desc[] = {
+		0, 0, 0, 0,	/* number of blocks: sat unspecified */
+		0,
+		0, 0x2, 0x0	/* block length: 512 bytes */
+	};
+	u8 pg, spg;
+	unsigned int ebd, page_control, six_byte, output_len, alloc_len, minlen;
 
 	VPRINTK("ENTER\n");
 
 	six_byte = (scsicmd[0] == MODE_SENSE);
-
-	/* we only support saved and current values (which we treat
-	 * in the same manner)
+	ebd = !(scsicmd[1] & 0x8);      /* dbd bit inverted == edb */
+	/*
+	 * LLBA bit in msense(10) ignored (compliant)
 	 */
+
 	page_control = scsicmd[2] >> 6;
 	switch (page_control) {
 	case 0: /* current */
@@ -1369,29 +1402,42 @@
 		goto invalid_fld;
 	}
 
-	if (six_byte)
-		output_len = 4;
-	else
-		output_len = 8;
+	if (six_byte) {
+		output_len = 4 + (ebd ? 8 : 0);
+		alloc_len = scsicmd[4];
+	} else {
+		output_len = 8 + (ebd ? 8 : 0);
+		alloc_len = (scsicmd[7] << 8) + scsicmd[8];
+	}
+	minlen = (alloc_len < buflen) ? alloc_len : buflen;
 
 	p = rbuf + output_len;
-	last = rbuf + buflen - 1;
+	last = rbuf + minlen - 1;
 
-	switch(scsicmd[2] & 0x3f) {
-	case 0x01:		/* r/w error recovery */
+	pg = scsicmd[2] & 0x3f;
+	spg = scsicmd[3];
+	/*
+	 * No mode subpages supported (yet) but asking for _all_
+	 * subpages may be valid
+	 */
+	if (spg && (spg != ALL_SUB_MPAGES))
+		goto invalid_fld;
+
+	switch(pg) {
+	case RW_RECOVERY_MPAGE:
 		output_len += ata_msense_rw_recovery(&p, last);
 		break;
 
-	case 0x08:		/* caching */
+	case CACHE_MPAGE:
 		output_len += ata_msense_caching(args->id, &p, last);
 		break;
 
-	case 0x0a: {		/* control mode */
+	case CONTROL_MPAGE: {
 		output_len += ata_msense_ctl_mode(&p, last);
 		break;
 		}
 
-	case 0x3f:		/* all pages */
+	case ALL_MPAGES:
 		output_len += ata_msense_rw_recovery(&p, last);
 		output_len += ata_msense_caching(args->id, &p, last);
 		output_len += ata_msense_ctl_mode(&p, last);
@@ -1401,15 +1447,31 @@
 		goto invalid_fld;
 	}
 
+	if (minlen < 1)
+		return 0;
 	if (six_byte) {
 		output_len--;
 		rbuf[0] = output_len;
+		if (ebd) {
+			if (minlen > 3)
+				rbuf[3] = sizeof(sat_blk_desc);
+			if (minlen > 11)
+				memcpy(rbuf + 4, sat_blk_desc,
+				       sizeof(sat_blk_desc));
+		}
 	} else {
 		output_len -= 2;
 		rbuf[0] = output_len >> 8;
-		rbuf[1] = output_len;
+		if (minlen > 1)
+			rbuf[1] = output_len;
+		if (ebd) {
+			if (minlen > 7)
+				rbuf[7] = sizeof(sat_blk_desc);
+			if (minlen > 15)
+				memcpy(rbuf + 8, sat_blk_desc,
+				       sizeof(sat_blk_desc));
+		}
 	}
-
 	return 0;
 
 invalid_fld:

--------------020903050000040906020901--

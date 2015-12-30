From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 30 Dec 2015 19:54:01 +0200 (EET)
Message-ID: <alpine.LSU.2.11.1512301947150.1713@xnv.znxvfnen.cevingr>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com> <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
 <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr> <20151229175859.0c2c9b91@harpe.intellique.com> <8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi> <20151229191347.2e0e5f0e@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:45819 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbbL3RyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2015 12:54:14 -0500
In-Reply-To: <20151229191347.2e0e5f0e@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday 2015-12-29 20:13, Emmanuel Florac wrote:

...
>It works when providing the size :
>
># mt -f /dev/nst0  mkpartition 36764
>
Good.

I think I found out why it did not work with the default format. At the 
end of this message you find a new patch that should correct that. There 
are also other changes:
- some changes when specifying the size in the mode page; needed for the
  IBM 3592 drives but should not change results with LTO
- formatting with one partition is done directly with FORMAT MEDIUM if
  the drive requires that command
- some other bugs fixed

Thanks for testing,
Kai

-----------------------------------8<------------------------------------
--- ref/drivers/scsi/st.c	2015-12-21 18:54:05.068882001 +0200
+++ new/drivers/scsi/st.c	2015-12-30 19:30:37.900152216 +0200
@@ -9,7 +9,7 @@
    Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedinsky,
    Michael Schaefer, J"org Weule, and Eric Youngdale.
 
-   Copyright 1992 - 2010 Kai Makisara
+   Copyright 1992 - 2016 Kai Makisara
    email Kai.Makisara@kolumbus.fi
 
    Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20101219";
+static const char *verstr = "20151230";
 
 #include <linux/module.h>
 
@@ -3296,7 +3296,10 @@
 #define PP_OFF_RESERVED        7
 
 #define PP_BIT_IDP             0x20
+#define PP_BIT_FDP             0x80
 #define PP_MSK_PSUM_MB         0x10
+#define PP_MSK_PSUM_UNITS      0x18
+#define PP_MSK_POFM            0x04
 
 /* Get the number of partitions on the tape. As a side effect reads the
    mode page into the tape buffer. */
@@ -3322,6 +3325,29 @@
 }
 
 
+static int format_medium(struct scsi_tape *STp, int format)
+{
+	int result = 0;
+	int timeout = STp->long_timeout;
+	unsigned char scmd[MAX_COMMAND_SIZE];
+	struct st_request *SRpnt;
+
+	memset(scmd, 0, MAX_COMMAND_SIZE);
+	scmd[0] = FORMAT_UNIT;
+	scmd[2] = format;
+	if (STp->immediate) {
+		scmd[1] |= 1;		/* Don't wait for completion */
+		timeout = STp->device->request_queue->rq_timeout;
+	}
+	DEBC_printk(STp, "Sending FORMAT MEDIUM\n");
+	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
+			   timeout, MAX_RETRIES, 1);
+	if (!SRpnt)
+		result = STp->buffer->syscall_result;
+	return result;
+}
+
+
 /* Partition the tape into two partitions if size > 0 or one partition if
    size == 0.
 
@@ -3340,11 +3366,15 @@
    and 10 when 1 partition is defined (information from Eric Lee Green). This is
    is acceptable also to some other old drives and enforced if the first partition
    size field is used for the first additional partition size.
+
+   For drives that advertize SCSI-3 or newer, use the SSC-3 methods.
  */
 static int partition_tape(struct scsi_tape *STp, int size)
 {
 	int result;
+	bool scsi3 = STp->device->scsi_level >= SCSI_3,  needs_format = false;
 	int pgo, psd_cnt, psdo;
+	int psum = PP_MSK_PSUM_MB, units = 0;
 	unsigned char *bp;
 
 	result = read_mode_page(STp, PART_PAGE, 0);
@@ -3357,11 +3387,54 @@
 	pgo = MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
 	DEBC_printk(STp, "Partition page length is %d bytes.\n",
 		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2);
+	DEBC_printk(STp, "PP: max %u, add %u, xdp %u, psum %02x, pofmetc %u, "
+		    "rec %02x, units %02x, sizes: %u %u\n",
+		    bp[pgo + PP_OFF_MAX_ADD_PARTS],
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS],
+		    (bp[pgo + PP_OFF_FLAGS] & 0xe0) >> 5,
+		    (bp[pgo + PP_OFF_FLAGS] & 0x18) >> 3,
+		    bp[pgo + PP_OFF_FLAGS] & 0x07,
+		    bp[pgo + 5],
+		    bp[pgo + PP_OFF_PART_UNITS],
+		    bp[pgo + 8] * 256 + bp[pgo + 9],
+		    bp[pgo + 10] * 256 + bp[pgo + 11]);
+
+	if (scsi3) {
+		needs_format = (bp[pgo + PP_OFF_FLAGS] & PP_MSK_POFM) != 0;
+		if (needs_format && size == 0) {
+			result = format_medium(STp, 0);
+			goto out;
+		}
+
+		psd_cnt = size > 0 ? 2 : 1;
+		if ((bp[pgo + PP_OFF_FLAGS] & PP_MSK_PSUM_UNITS) == PP_MSK_PSUM_UNITS) {
+			/* Use units scaling for large partitions if the device suggests
+			   it and no precision lost. Required for IBM TS1140/50 drives
+			   that don't support MB units. */
+			if (size >= 1000 && (size % 1000) == 0) {
+				size /= 1000;
+				psum = PP_MSK_PSUM_UNITS;
+				units = 9; /* GB */
+			}
+		}
+		/* Try it anyway if too large to specify in MB */
+		if (psum == PP_MSK_PSUM_MB && size >= 65534) {
+				size /= 1000;
+				psum = PP_MSK_PSUM_UNITS;
+				units = 9;  /* GB */
+		}
+	} else
+		psd_cnt = (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 -
+			   PART_PAGE_FIXED_LENGTH) / 2;
+
+	if (size >= 65534) { /* Does not fit into two bytes */
+		result = -EINVAL;
+		goto out;
+	}
 
-	psd_cnt = (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGTH) / 2;
 	psdo = pgo + PART_PAGE_FIXED_LENGTH;
-	if (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
-		bp[psdo] = bp[psdo + 1] = 0xff;  /* Rest of the tape */
+	if (scsi3 || psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
+		bp[psdo] = bp[psdo + 1] = 0xff;  /* Rest of the tape to partition 0 */
 		psdo += 2;
 	}
 	memset(bp + psdo, 0, bp[pgo + PP_OFF_NBR_ADD_PARTS] * 2);
@@ -3375,6 +3448,11 @@
 		if (psd_cnt <= bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] = 6;
 		DEBC_printk(STp, "Formatting tape with one partition.\n");
+	} else if (size == 1 && units == 0) {
+		bp[pgo + PP_OFF_NBR_ADD_PARTS] = 1;
+		if (psd_cnt <= bp[pgo + PP_OFF_MAX_ADD_PARTS])
+		    bp[pgo + MP_OFF_PAGE_LENGTH] = 6;
+		DEBC_printk(STp, "Formatting tape with two partitions (FDP).\n");
 	} else {
 		bp[psdo] = (size >> 8) & 0xff;
 		bp[psdo + 1] = size & 0xff;
@@ -3382,18 +3460,45 @@
 		if (bp[pgo + MP_OFF_PAGE_LENGTH] < 8)
 		    bp[pgo + MP_OFF_PAGE_LENGTH] = 8;
 		DEBC_printk(STp, "Formatting tape with two partitions "
-			    "(1 = %d MB).\n", size);
+			    "(1 = %d MB).\n",
+			    units > 0 ? size * 1000 : size);
 	}
 	bp[pgo + PP_OFF_PART_UNITS] = 0;
 	bp[pgo + PP_OFF_RESERVED] = 0;
-	bp[pgo + PP_OFF_FLAGS] = PP_BIT_IDP | PP_MSK_PSUM_MB;
+	if (size != 1 || units != 0) {
+		bp[pgo + PP_OFF_FLAGS] = PP_BIT_IDP | psum |
+			(bp[pgo + PP_OFF_FLAGS] & 0x07);
+		bp[pgo + PP_OFF_PART_UNITS] = units;
+	} else
+		bp[pgo + PP_OFF_FLAGS] = PP_BIT_FDP |
+			(bp[pgo + PP_OFF_FLAGS] & 0x07);
+	bp[pgo + MP_OFF_PAGE_LENGTH] = 6 + psd_cnt * 2;
+
+	DEBC_printk(STp, "Sent partition page length is %d bytes. needs_format: %d\n",
+		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2, needs_format);
+	DEBC_printk(STp, "PP: max %u, add %u, xdp %u, psum %02x, pofmetc %u, "
+		    "rec %02x, units %02x, sizes: %u %u\n",
+		    bp[pgo + PP_OFF_MAX_ADD_PARTS],
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS],
+		    (bp[pgo + PP_OFF_FLAGS] & 0xe0) >> 5,
+		    (bp[pgo + PP_OFF_FLAGS] & 0x18) >> 3,
+		    bp[pgo + PP_OFF_FLAGS] & 0x07,
+		    bp[pgo + 5],
+		    bp[pgo + PP_OFF_PART_UNITS],
+		    bp[pgo + 8] * 256 + bp[pgo + 9],
+		    bp[pgo + 10] * 256 + bp[pgo + 11]);
 
 	result = write_mode_page(STp, PART_PAGE, 1);
+
+	if (!result && needs_format)
+		result = format_medium(STp, 1);
+
 	if (result) {
 		st_printk(KERN_INFO, STp, "Partitioning of tape failed.\n");
 		result = (-EIO);
 	}
 
+out:
 	return result;
 }
 


From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Wed, 3 Feb 2016 20:36:18 +0200 (EET)
Message-ID: <alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr>
References: <20151218170644.24167419@harpe.intellique.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com>
 <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601291915010.22105@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:48959 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbcBCSgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 13:36:32 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wednesday 2016-02-03 04:18, Seymour, Shane M wrote:

...>
># mt -f /dev/st2 mkpartition 200G
>
>Fails and doesn't print all of the messages related for partitioning:
>
>[ 3514.306582] st 8:0:0:0: [st2] Block limits 1 - 16777215 bytes.
>[ 3514.307126] st 8:0:0:0: [st2] Mode sense. Length 11, medium 0, WBS 10, BLL 8
>[ 3514.307129] st 8:0:0:0: [st2] Density 5a, tape length: 0, drv buffer: 1
>[ 3514.307132] st 8:0:0:0: [st2] Block size: 0, buffer size: 4096 (1 blocks).
>[ 3514.307133] st 8:0:0:0: [st2] Updating partition number in status.
>[ 3514.308133] st 8:0:0:0: [st2] Got tape pos. blk 0 part 0.
>[ 3514.308159] st 8:0:0:0: [st2] Loading tape.
>[ 3514.323173] st 8:0:0:0: [st2] Block limits 1 - 16777215 bytes.
>[ 3514.323624] st 8:0:0:0: [st2] Mode sense. Length 11, medium 0, WBS 10, BLL 8
>[ 3514.323628] st 8:0:0:0: [st2] Density 5a, tape length: 0, drv buffer: 1
>[ 3514.323632] st 8:0:0:0: [st2] Block size: 0, buffer size: 4096 (1 blocks).
>[ 3514.324507] st 8:0:0:0: [st2] Partition page length is 16 bytes.
>[ 3514.324513] st 8:0:0:0: [st2] PP: max 3, add 0, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2620 0
>[ 3514.324518] st 8:0:0:0: [st2] MP: 11 0e 03 00 3c 03 09 00 0a 3c 00 00
>[ 3514.324521] st 8:0:0:0: [st2] Sending FORMAT MEDIUM
>[ 3519.097142] st 8:0:0:0: [st2] Rewinding tape.
>
>The only way that can happen is if it thinks it should be clearing the partitions in this code:
>
>        if (scsi3) {
>                needs_format = (bp[pgo + PP_OFF_FLAGS] & PP_MSK_POFM) != 0;
>                if (needs_format && size == 0) {
>                        /* No need to write the mode page when clearing partitioning */
>                        result = format_medium(STp, 0);
>                        goto out;
>                }
>
Yes. This is a mt bug. The ioctl argument is zero. Note that the mt 
definition may also be a bit misleading: appending G means that the 
number is multiplied by 1024^3. For mkpart the unit is already MB, 
so you tried to make a very big partition :-)

>Since we can format and exit by juming to out here we probably need this in there as well before the goto:
>
>		DEBC_printk(STp, "Formatting tape with one partition.\n");
>
>Something appears to have dropped the size to be zero. Should the mt command in mt-st reject anything that could become zero with an error? I haven't looked at the command to see why it dropped the value to 0 (I am assuming that's where it happened). There should probably be an error or something printed otherwise someone will assume that the partitioning worked successfully when in fact the partitions were cleared.
>
>If instead I ask for 200 instead of 200G I get the following:
>
>[ 3875.588006] st 8:0:0:0: [st2] Block limits 1 - 16777215 bytes.
>[ 3875.588617] st 8:0:0:0: [st2] Mode sense. Length 11, medium 0, WBS 10, BLL 8
>[ 3875.588620] st 8:0:0:0: [st2] Density 5a, tape length: 0, drv buffer: 1
>[ 3875.588622] st 8:0:0:0: [st2] Block size: 0, buffer size: 4096 (1 blocks).
>[ 3875.588638] st 8:0:0:0: [st2] Loading tape.
>[ 3875.603659] st 8:0:0:0: [st2] Block limits 1 - 16777215 bytes.
>[ 3875.604113] st 8:0:0:0: [st2] Mode sense. Length 11, medium 0, WBS 10, BLL 8
>[ 3875.604117] st 8:0:0:0: [st2] Density 5a, tape length: 0, drv buffer: 1
>[ 3875.604121] st 8:0:0:0: [st2] Block size: 0, buffer size: 4096 (1 blocks).
>[ 3875.605052] st 8:0:0:0: [st2] Partition page length is 16 bytes.
>[ 3875.605058] st 8:0:0:0: [st2] PP: max 3, add 0, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2620 0
>[ 3875.605063] st 8:0:0:0: [st2] MP: 11 0e 03 00 3c 03 09 00 0a 3c 00 00
>[ 3875.605066] st 8:0:0:0: [st2] psd_cnt 2, max.parts 3, nbr_parts 0
>[ 3875.605069] st 8:0:0:0: [st2] Formatting tape with two partitions (1 = 200 MB).
>[ 3875.605072] st 8:0:0:0: [st2] Sent partition page length is 12 bytes. needs_format: 1
>[ 3875.605076] st 8:0:0:0: [st2] PP: max 3, add 1, xdp 1, psum 02, pofmetc 4, rec 03, units 00, sizes: 200 0
>[ 3875.605080] st 8:0:0:0: [st2] MP: 11 0a 03 01 34 03 00 00 00 c8 00 00
>[ 3875.605952] st 8:0:0:0: [st2] Error: 8000002, cmd: 15 10 0 0 18 0
>[ 3875.605957] st 8:0:0:0: [st2] Sense Key : Illegal Request [current]
>[ 3875.605961] st 8:0:0:0: [st2] Add. Sense: Invalid field in parameter list
>[ 3875.605964] st 8:0:0:0: [st2] Partitioning of tape failed.
>[ 3875.606087] st 8:0:0:0: [st2] Rewinding tape.
>
>Since a positive number sets the size of the second partition I would have expected the sizes to be 0xffff and 200 not 200 and 0.
> 
># mt -f /dev/st2 mkpartition 2000
>
>[ 3957.373197] st 8:0:0:0: [st2] Block limits 1 - 16777215 bytes.
>[ 3957.373729] st 8:0:0:0: [st2] Mode sense. Length 11, medium 0, WBS 10, BLL 8
>[ 3957.373732] st 8:0:0:0: [st2] Density 5a, tape length: 0, drv buffer: 1
>[ 3957.373734] st 8:0:0:0: [st2] Block size: 0, buffer size: 4096 (1 blocks).
>[ 3957.373750] st 8:0:0:0: [st2] Loading tape.
>[ 3957.388599] st 8:0:0:0: [st2] Block limits 1 - 16777215 bytes.
>[ 3957.389100] st 8:0:0:0: [st2] Mode sense. Length 11, medium 0, WBS 10, BLL 8
>[ 3957.389104] st 8:0:0:0: [st2] Density 5a, tape length: 0, drv buffer: 1
>[ 3957.389108] st 8:0:0:0: [st2] Block size: 0, buffer size: 4096 (1 blocks).
>[ 3957.390012] st 8:0:0:0: [st2] Partition page length is 16 bytes.
>[ 3957.390015] st 8:0:0:0: [st2] PP: max 3, add 0, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2620 0
>[ 3957.390018] st 8:0:0:0: [st2] MP: 11 0e 03 00 3c 03 09 00 0a 3c 00 00
>[ 3957.390024] st 8:0:0:0: [st2] psd_cnt 2, max.parts 3, nbr_parts 0
>[ 3957.390027] st 8:0:0:0: [st2] Formatting tape with two partitions (1 = 2000 MB).
>[ 3957.390030] st 8:0:0:0: [st2] Sent partition page length is 12 bytes. needs_format: 1
>[ 3957.390035] st 8:0:0:0: [st2] PP: max 3, add 1, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2 0
>[ 3957.390039] st 8:0:0:0: [st2] MP: 11 0a 03 01 3c 03 09 00 00 02 00 00
>[ 3957.391184] st 8:0:0:0: [st2] Sending FORMAT MEDIUM
>[ 3957.398667] st 8:0:0:0: [st2] Error: 8000002, cmd: 4 0 1 0 0 0
>[ 3957.398672] st 8:0:0:0: [st2] Sense Key : Illegal Request [current]
>[ 3957.398676] st 8:0:0:0: [st2] Add. Sense: Parameter value invalid
>[ 3957.398684] st 8:0:0:0: [st2] Rewinding tape.
>
>Again I would have expected 0xffff and 2 not 2 and 0.
>
>If I ask for -2000 then it works:
>
...
>
>This code appears to be wrong:
>
>                bp[psdo] = (size >> 8) & 0xff;
>                bp[psdo + 1] = size & 0xff;
>                if (target_partition == 0)
>                        bp[psdo + 2] = bp[psdo + 3] = 0xff;
>
The problem is not here. This code just adds the contents to the second 
psd. The problem is in this condition and only if maximum number of 
partitions exceeds one (as it does for LTO-6):

        if (target_partition > 0 && psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
                bp[psdo] = bp[psdo + 1] = 0xff;  /* Rest of the tape to partition 0 */
                psdo += 2;
        }

At the end of this message is a new patch where I have modified this 
condition slightly. The new version seems to make correct mode pages 
when I tested it by inserting code that modified the mode page returned 
by my drive to mimic other drives.

...
>For posterity in case anyone reads this at a later point just to 
>explain the size values for DDS - while the DDS sizes may look wrong 
>they are not. The second size value is not sent to the tape drive only 
>the first size is since most (all?) DDS drives only support setting an 
>explicit size for the second partition only and partition 0 
>automatically gets the rest of the tape.
>
The Sony DDS-2 drive did use two psds. In addition to the DDS drives, 
partitioning did work for several other drive types in the last century.

>If the changes are correct and needed and you want to add those two 
>changes please do so. I've been looking very carefully at the code 
>changes as part of the testing effort and happy to add any combination 
>of reviewed-by and tested-by to the patch. If required feel free to 
>change it as needed. I'll retest a consolidated version of the patch if 
>you add the changes and send it out.

I added the two debug printk changes you suggested.

>
>Laurence, when you get your LTO drive test without my changes in to 
>make sure you see the same issue and then if you do test with the 
>changes I added above. That's just to double check that there's nothing 
>wrong with my setup and the code changes are required.

Thanks,
Kai

-----------------------------------8<------------------------------------
--- ref/drivers/scsi/st.c	2015-12-21 18:54:05.068882001 +0200
+++ new/drivers/scsi/st.c	2016-02-03 20:31:33.709018742 +0200
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
+static const char *verstr = "20160203";
 
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
 
@@ -3340,11 +3366,16 @@
    and 10 when 1 partition is defined (information from Eric Lee Green). This is
    is acceptable also to some other old drives and enforced if the first partition
    size field is used for the first additional partition size.
+
+   For drives that advertize SCSI-3 or newer, use the SSC-3 methods.
  */
 static int partition_tape(struct scsi_tape *STp, int size)
 {
 	int result;
+	int target_partition;
+	bool scsi3 = STp->device->scsi_level >= SCSI_3, needs_format = false;
 	int pgo, psd_cnt, psdo;
+	int psum = PP_MSK_PSUM_MB, units = 0;
 	unsigned char *bp;
 
 	result = read_mode_page(STp, PART_PAGE, 0);
@@ -3352,16 +3383,76 @@
 		DEBC_printk(STp, "Can't read partition mode page.\n");
 		return result;
 	}
+	target_partition = 1;
+	if (size < 0) {
+		target_partition = 0;
+		size = -size;
+	}
+
 	/* The mode page is in the buffer. Let's modify it and write it. */
 	bp = (STp->buffer)->b_data;
 	pgo = MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
+
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
+	DEBC_printk(STp, "MP: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
+		    bp[pgo], bp[pgo+1], bp[pgo+2], bp[pgo+3], bp[pgo+4], bp[pgo+5],
+		    bp[pgo+6], bp[pgo+7], bp[pgo+8], bp[pgo+9], bp[pgo+10], bp[pgo+11]);
 
 	psd_cnt = (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGTH) / 2;
+
+	if (scsi3) {
+		needs_format = (bp[pgo + PP_OFF_FLAGS] & PP_MSK_POFM) != 0;
+		if (needs_format && size == 0) {
+			/* No need to write the mode page when clearing partitioning */
+			DEBC_printk(STp, "Formatting tape with one partition.\n");
+			result = format_medium(STp, 0);
+			goto out;
+		}
+		if (needs_format)  /* Leave the old value for HP DATs claiming SCSI_3 */
+			psd_cnt = 2;
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
+	}
+
+	if (size >= 65535 ||  /* Does not fit into two bytes */
+	    (target_partition == 0 && psd_cnt < 2)) {
+		result = -EINVAL;
+		goto out;
+	}
+
 	psdo = pgo + PART_PAGE_FIXED_LENGTH;
-	if (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
-		bp[psdo] = bp[psdo + 1] = 0xff;  /* Rest of the tape */
+	/* The second condition is for HP DDS which use only one partition size
+	   descriptor */
+	if (target_partition > 0 &&
+	    (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS] ||
+	     bp[pgo + PP_OFF_MAX_ADD_PARTS] != 1) ) {
+		bp[psdo] = bp[psdo + 1] = 0xff;  /* Rest of the tape to partition 0 */
 		psdo += 2;
 	}
 	memset(bp + psdo, 0, bp[pgo + PP_OFF_NBR_ADD_PARTS] * 2);
@@ -3370,7 +3461,7 @@
 		    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
 		    bp[pgo + PP_OFF_NBR_ADD_PARTS]);
 
-	if (size <= 0) {
+	if (size == 0) {
 		bp[pgo + PP_OFF_NBR_ADD_PARTS] = 0;
 		if (psd_cnt <= bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] = 6;
@@ -3378,22 +3469,54 @@
 	} else {
 		bp[psdo] = (size >> 8) & 0xff;
 		bp[psdo + 1] = size & 0xff;
+		if (target_partition == 0)
+			bp[psdo + 2] = bp[psdo + 3] = 0xff;
 		bp[pgo + 3] = 1;
 		if (bp[pgo + MP_OFF_PAGE_LENGTH] < 8)
 		    bp[pgo + MP_OFF_PAGE_LENGTH] = 8;
 		DEBC_printk(STp, "Formatting tape with two partitions "
-			    "(1 = %d MB).\n", size);
+			    "(%i = %d MB).\n", target_partition,
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
+			(bp[pgo + PP_OFF_FLAGS] & 0x1f);
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
+	DEBC_printk(STp, "MP: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
+		    bp[pgo], bp[pgo+1], bp[pgo+2], bp[pgo+3], bp[pgo+4], bp[pgo+5],
+		    bp[pgo+6], bp[pgo+7], bp[pgo+8], bp[pgo+9], bp[pgo+10], bp[pgo+11]);
 
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
 

@@ -3570,7 +3693,7 @@
 				retval = (-EINVAL);
 				goto out;
 			}
-			if ((i = st_int_ioctl(STp, MTREW, 0)) < 0 ||
+			if ((i = do_load_unload(STp, file, 1)) < 0 ||
 			    (i = partition_tape(STp, mtc.mt_count)) < 0) {
 				retval = i;
 				goto out;
@@ -3581,7 +3704,7 @@
 				STp->ps[i].last_block_valid = 0;
 			}
 			STp->partition = STp->new_partition = 0;
-			STp->nbr_partitions = 1;	/* Bad guess ?-) */
+			STp->nbr_partitions = mtc.mt_count > 0 ? 2 : 1;
 			STps->drv_block = STps->drv_file = 0;
 			retval = 0;
 			goto out;

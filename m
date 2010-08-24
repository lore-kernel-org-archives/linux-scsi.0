From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: add TPRZ support
Date: Mon, 23 Aug 2010 21:06:16 -0400
Message-ID: <4C731B08.1060100@interlog.com>
References: <4C72CAF7.8020601@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050902020203010209090805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:42782 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab0HXBGw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 21:06:52 -0400
In-Reply-To: <4C72CAF7.8020601@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, mkp@mkp.net
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050902020203010209090805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric,
Now for a really serious issue: in sbc3r24
TPRZ == "thin provisioning read zeros".
SBC-3 uses the shorter variant of the plural of
zero. [ACS-2 uses both zeros and zeroes :-)]

The reason I point that out (apart from trying to
distract James B. from another dispute) is that
you are introducing a new module option called
"unmap_zeroes". I prefer the shorter form.


When I tried to combine your patch on top of Martin's
I needed to do a hand merge (since I'm "gitless") onto
lk 2.6.35 . Both of you picked almost the same lines
to change. Attached is the result of my patch merge
against lk 2.6.35 . It may not be tab clean.

With that combined patch I checked a real SSD that
does TPRZ against the scsi_debug virtual SSD and it
looked okay with my utilities.


SCSI WRITE SAME does have one interesting quirk that
Martin may like to consider. If the "number of
logical blocks" field is zero, then that implies write
to the end of the LU!! Madness when you think about it.
libata's SCSI WRITE SAME translation takes the zero
number of LBs literally and does nothing I guess
(when the UNMAP bit is given).

Doug Gilbert



On 10-08-23 03:24 PM, Eric Sandeen wrote:
> Add TPRZ support to scsi_debug; i.e. return zero for
> unmapped blocks.
>
> Rather than checking for unmapped blocks at
> read time, this just zeroes them on the backing store
> at unmap time so it behaves the same way.
>
> This also adds a module parameter to disable it, since
> some SSDs have this behavior.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

--------------050902020203010209090805
Content-Type: text/x-patch;
 name="sdebug_mp1es1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug_mp1es1.patch"

--- linux/drivers/scsi/scsi_debug.c	2010-08-03 18:04:12.643766243 -0400
+++ linux/drivers/scsi/scsi_debug.c2635mp1es1	2010-08-23 20:20:15.764513006 -0400
@@ -109,10 +109,13 @@ static const char * scsi_debug_version_d
 #define DEF_PHYSBLK_EXP 0
 #define DEF_LOWEST_ALIGNED 0
 #define DEF_OPT_BLKS 64
-#define DEF_UNMAP_MAX_BLOCKS 0
-#define DEF_UNMAP_MAX_DESC 0
-#define DEF_UNMAP_GRANULARITY 0
+#define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
+#define DEF_UNMAP_MAX_DESC 256
+#define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_ALIGNMENT 0
+#define DEF_TPWS 0
+#define DEF_TPU 0
+#define DEF_UNMAP_ZEROES 1
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -177,10 +180,13 @@ static int scsi_debug_ato = DEF_ATO;
 static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_opt_blks = DEF_OPT_BLKS;
-static int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
-static int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
-static int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
-static int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
+static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
+static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
+static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
+static unsigned int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
+static unsigned int scsi_debug_tpws = DEF_TPWS;
+static unsigned int scsi_debug_tpu = DEF_TPU;
+static int scsi_debug_unmap_zeroes = DEF_UNMAP_ZEROES;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -723,16 +729,9 @@ static int inquiry_evpd_b0(unsigned char
 	/* Optimal Transfer Length */
 	put_unaligned_be32(scsi_debug_opt_blks, &arr[8]);
 
-	if (scsi_debug_unmap_max_desc) {
-		unsigned int blocks;
-
-		if (scsi_debug_unmap_max_blocks)
-			blocks = scsi_debug_unmap_max_blocks;
-		else
-			blocks = 0xffffffff;
-
+	if (scsi_debug_tpu) {
 		/* Maximum Unmap LBA Count */
-		put_unaligned_be32(blocks, &arr[16]);
+		put_unaligned_be32(scsi_debug_unmap_max_blocks, &arr[16]);
 
 		/* Maximum Unmap Block Descriptor Count */
 		put_unaligned_be32(scsi_debug_unmap_max_desc, &arr[20]);
@@ -745,10 +744,9 @@ static int inquiry_evpd_b0(unsigned char
 	}
 
 	/* Optimal Unmap Granularity */
-	if (scsi_debug_unmap_granularity) {
-		put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
-		return 0x3c; /* Mandatory page length for thin provisioning */
-	}
+	put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
+
+	return 0x3c; /* Mandatory page length for thin provisioning */
 
 	return sizeof(vpdb0_data);
 }
@@ -765,6 +763,21 @@ static int inquiry_evpd_b1(unsigned char
 	return 0x3c;
 }
 
+/* Thin provisioning VPD page (SBC-3) */
+static int inquiry_evpd_b2(unsigned char *arr)
+{
+	memset(arr, 0, 0x8);
+	arr[0] = 0;			/* threshold exponent */
+
+	if (scsi_debug_tpu)
+		arr[1] = 1 << 7;
+
+	if (scsi_debug_tpws)
+		arr[1] |= 1 << 6;
+
+	return 0x8;
+}
+
 #define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 584
 
@@ -820,6 +833,7 @@ static int resp_inquiry(struct scsi_cmnd
 			arr[n++] = 0x89;  /* ATA information */
 			arr[n++] = 0xb0;  /* Block limits (SBC) */
 			arr[n++] = 0xb1;  /* Block characteristics (SBC) */
+			arr[n++] = 0xb2;  /* Thin provisioning (SBC) */
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
 			arr[1] = cmd[2];	/*sanity */
@@ -867,6 +881,9 @@ static int resp_inquiry(struct scsi_cmnd
 		} else if (0xb1 == cmd[2]) { /* Block characteristics (SBC) */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_evpd_b1(&arr[4]);
+		} else if (0xb2 == cmd[2]) { /* Thin provisioning (SBC) */
+			arr[1] = cmd[2];        /*sanity */
+			arr[3] = inquiry_evpd_b2(&arr[4]);
 		} else {
 			/* Illegal request, invalid field in cdb */
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
@@ -1038,8 +1055,11 @@ static int resp_readcap16(struct scsi_cm
 	arr[13] = scsi_debug_physblk_exp & 0xf;
 	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
 
-	if (scsi_debug_unmap_granularity)
+	if (scsi_debug_tpu || scsi_debug_tpws) {
 		arr[14] |= 0x80; /* TPE */
+		if (scsi_debug_unmap_zeroes)
+			arr[14] |= 0x40; /* TPRZ */
+	}
 
 	arr[15] = scsi_debug_lowest_aligned & 0xff;
 
@@ -2011,8 +2031,13 @@ static void unmap_region(sector_t lba, u
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end)
+		if (rem == 0 && lba + granularity <= end && block < map_size) {
 			clear_bit(block, map_storep);
+                        if (scsi_debug_unmap_zeroes)
+                                memset(fake_storep + 
+                                       block * scsi_debug_sector_size, 0,
+                                       scsi_debug_sector_size);
+                }
 
 		lba += granularity - rem;
 	}
@@ -2706,6 +2731,9 @@ module_param_named(unmap_max_blocks, scs
 module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
 module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
+module_param_named(tpu, scsi_debug_tpu, int, S_IRUGO);
+module_param_named(tpws, scsi_debug_tpws, int, S_IRUGO);
+module_param_named(unmap_zeroes, scsi_debug_unmap_zeroes, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2737,10 +2765,13 @@ MODULE_PARM_DESC(dix, "data integrity ex
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
-MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0)");
-MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=0)");
-MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=0)");
+MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
+MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
+MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
+MODULE_PARM_DESC(tpu, "enable TP, support UNMAP command (def=0)");
+MODULE_PARM_DESC(tpws, "enable TP, support WRITE SAME(16) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(unmap_zeroes, "unmapped blocks return 0 on read (def=1)");
 
 static char sdebug_info[256];
 
@@ -3128,7 +3159,7 @@ static ssize_t sdebug_map_show(struct de
 {
 	ssize_t count;
 
-	if (scsi_debug_unmap_granularity == 0)
+	if (scsi_debug_tpu == 0 && scsi_debug_tpws == 0)
 		return scnprintf(buf, PAGE_SIZE, "0-%u\n",
 				 sdebug_store_sectors);
 
@@ -3320,10 +3351,21 @@ static int __init scsi_debug_init(void)
 		memset(dif_storep, 0xff, dif_size);
 	}
 
-	if (scsi_debug_unmap_granularity) {
+	/* Thin Provisioning */
+	if (scsi_debug_tpu || scsi_debug_tpws) {
 		unsigned int map_bytes;
 
-		if (scsi_debug_unmap_granularity < scsi_debug_unmap_alignment) {
+		scsi_debug_unmap_max_blocks =
+			clamp(scsi_debug_unmap_max_blocks, 0U, 0xffffffffU);
+
+		scsi_debug_unmap_max_desc =
+			clamp(scsi_debug_unmap_max_desc, 0U, 256U);
+
+		scsi_debug_unmap_granularity =
+			clamp(scsi_debug_unmap_granularity, 1U, 0xffffffffU);
+
+		if (scsi_debug_unmap_alignment &&
+		    scsi_debug_unmap_granularity < scsi_debug_unmap_alignment) {
 			printk(KERN_ERR
 			       "%s: ERR: unmap_granularity < unmap_alignment\n",
 			       __func__);
@@ -3349,6 +3391,13 @@ static int __init scsi_debug_init(void)
 		if (scsi_debug_num_parts)
 			map_region(0, 2);
 	}
+	if (scsi_debug_unmap_zeroes && (0 == scsi_debug_unmap_granularity)) {
+                printk(KERN_ERR
+                       "%s: ERR: unmap_zeroes set without unmap_granularity\n",
+                       __func__);
+                ret = -EINVAL;
+                goto free_vm;
+        }
 
 	ret = device_register(&pseudo_primary);
 	if (ret < 0) {
@@ -3640,7 +3689,7 @@ int scsi_debug_queuecommand(struct scsi_
 			errsts = resp_readcap16(SCpnt, devip);
 		else if (cmd[1] == SAI_GET_LBA_STATUS) {
 
-			if (scsi_debug_unmap_max_desc == 0) {
+			if (scsi_debug_tpu == 0 && scsi_debug_tpws == 0) {
 				mk_sense_buffer(devip, ILLEGAL_REQUEST,
 						INVALID_COMMAND_OPCODE, 0);
 				errsts = check_condition_result;
@@ -3751,8 +3800,16 @@ write:
 		}
 		break;
 	case WRITE_SAME_16:
-		if (cmd[1] & 0x8)
-			unmap = 1;
+		if (cmd[1] & 0x8) {
+			if (scsi_debug_tpws == 0) {
+				mk_sense_buffer(devip, ILLEGAL_REQUEST,
+						INVALID_FIELD_IN_CDB, 0);
+				errsts = check_condition_result;
+			} else
+				unmap = 1;
+		}
+		if (errsts)
+			break;
 		/* fall through */
 	case WRITE_SAME:
 		errsts = check_readiness(SCpnt, 0, devip);
@@ -3766,7 +3823,7 @@ write:
 		if (errsts)
 			break;
 
-		if (scsi_debug_unmap_max_desc == 0) {
+		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_tpu == 0) {
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_COMMAND_OPCODE, 0);
 			errsts = check_condition_result;

--------------050902020203010209090805--

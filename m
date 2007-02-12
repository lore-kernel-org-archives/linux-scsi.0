From: peter fuerst <post@pfrst.de>
Subject: [PATCH][SCSI] wd33c93.c: Fast SCSI with WD33C93B
Date: Mon, 12 Feb 2007 15:20:15 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0702121514080.433@Indigo2.Peter>
Reply-To: post@pfrst.de
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.pearl-online.net ([62.159.194.147]:17818 "EHLO
	mail1.pearl-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942AbXBLOtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 09:49:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Kumba <kumba@gentoo.org>, Thiemo Seufer <ths@networkno.de>, Tim Yamin <plasmaroo@gentoo.org>



Attached are patches, which help to utilize more of the WD33C93B SCSI
controller's capabilities.

1st Stage:

1) Added/changed all the necessary code to enable Burst Mode DMA. Only
   Single Byte DMA was used before.

2) Added/changed all the necessary code to enable Fast-10 SCSI transfers.

3) The original driver inadvertently used a transfer period of 1000-800ns
   (the lowest possible transfer rate) for asynchronous data transfers,
   instead of the (configurable) default period intended for this purpose,
   if the target responded to a SDTR not with a Reject-message, but with
   a zero-SDTR. This issue was fixed.
   Moreover, in case of a Reject the driver used the default-period's
   initialization-value instead of its (maybe smaller) current value. The
   missing assignment was added.

4) The driver's commandline- and proc-file-interface was augmented to
   handle the new options properly.

2nd Stage:

The original driver used to rely on a fixed table (sx_table) to select
transfer periods and map them to register values. This table contained
periods for (only) the lower limits of the respective input-clock-frequency
ranges (8-10/12-15/16-20 MHz). Although it seems, that no problems ocurred
with this setting so far, it seemed desirable to adjust the transfer periods
closer to the really attached, possibly 25% higher, input-clock, since

a) the wd33c93 may really use a significant shorter period, than it has
   negotiated (eg. thrashing the target, which expects 4/8MHz, with 5/10MHz
   instead).
b) the wd33c93 may ask the target for a lower transfer rate, than the target
   is capable of (eg. negotiating for an assumed minimum of 252ns instead of
   possible 200ns).
   And indeed, this issue shows up as an approx. 10% lower transfer rate.

I'd preferred to fix this by simply replacing the lower-limit period-values
(252,376,500,624,752,876,1000) by upper-limit values (200,300,400,500,600,
700,800). IMHO these would do no harm, if used with actually lower input-
clock frequencies, and automatically provide best performance.

But for to keep the driver's former state available, to keep it as the default
state, so that there's no difference, when the driver is used by existing,
unchanged platform-drivers, i choose the more complicated approach of always
calculating an appropriate table for the respective clock-parameter.

The disadvantage is, that a platform-driver, that can and wishes to benefit
from the higher input-clock-frequency on its system, must be changed (e.g.)
from calling wd33c93_init(... WD33C93_FS_16_20) to calling
wd33c93_init(... WD33C93_FS_MHZ(20)).


Performance figures:

This modified driver was tested, and is in use, on a SiliconGraphics Indigo2
with Quantum Atlas V Disk(s) and Pioneer DVD305S attached.
Read performance was measured by copying a disk-partition (resp. a CDROM)
to /dev/null, write performance by copying 1GB from /dev/zero to a disk
file.
"external transfer rate" is meant according to the "real" time spent in
the "time dd ..." command, while
"internal transfer rate" is meant according to the cpu-cycles spent from
calling dma_setup to the return from dma_stop.

Disk reads (synchronous) on average:
           original    burst       burst+fast
external   2.87        3.63        5.71        MB/s
internal   3.05        3.84        6.14        MB/s

Disk writes (synchronous) on average:
           original    burst       burst+fast
external   3.01        3.97        6.42        MB/s
internal   3.21        4.26        7.03        MB/s

Asynchronous reads on average:
                       burst+fast  burst+fast
           original    init.def.p. optimum default_per
external   1.09        2.02        3.44        MB/s
internal   1.15        2.13        3.63        MB/s

"fast" without "burst" had no effect.
Figures for the new driver were at least 10% lower, if 2nd Stage was
not applied.

So, these patches applied, together with
"echo 'burst:1 fast:1 period:200'>/proc/scsi/SGIWD93/0" (and "...93/1")
should provide a much more enjoyable system :-)

The WD33C93 manual, found at
http://www.datasheet.in/datasheet-html/W/D/3/WD33C93B_WesternDigital.pdf.html,
was very helpfull.

with kind regards


Signed-off-by: peter fuerst <post@pfrst.de>

=== 1st Stage ==========================================================
--- 6ab3d5624e172c553004ecc862bfeac16d9d68b7/drivers/scsi/wd33c93.h	Sat Jul  1 00:00:00 2006
+++ stage1/drivers/scsi/wd33c93.h	Sun Feb 11 20:05:53 2007
@@ -253,6 +253,8 @@
     uchar            sync_stat[8];     /* status of sync negotiation per target */
     uchar            no_sync;          /* bitmask: don't do sync on these targets */
     uchar            no_dma;           /* set this flag to disable DMA */
+    uchar            dma_mode;         /* DMA Burst Mode or Single Byte DMA */
+    uchar            fast;             /* set this flag to enable Fast SCSI */
 #ifdef PROC_INTERFACE
     uchar            proc;             /* bitmask: what's in proc output */
 #ifdef PROC_STATISTICS
--- 79bd3f8563a275d1d068bbb9189a746dc6e96f3e/drivers/scsi/wd33c93.c	Sat Jul 15 00:00:00 2006
+++ stage1/drivers/scsi/wd33c93.c	Sun Feb 11 22:01:17 2007
@@ -69,6 +69,10 @@
  * Added support for pre -A chips, which don't have advanced features
  * and will generate CSR_RESEL rather than CSR_RESEL_AM.
  *	Richard Hirst <richard@sleepie.demon.co.uk>  August 2000
+ *
+ * Added support for Burst Mode DMA and Fast SCSI. Enabled the use of
+ * default_sx_per for asynchronous data transfers.
+ *  peter fuerst <post@pfrst.de>  February 2007
  */

 #include <linux/module.h>
@@ -88,8 +92,8 @@
 #include "wd33c93.h"


-#define WD33C93_VERSION    "1.26"
-#define WD33C93_DATE       "22/Feb/2003"
+#define WD33C93_VERSION    "1.26++"
+#define WD33C93_DATE       "10/Feb/2007"

 MODULE_AUTHOR("John Shifflett");
 MODULE_DESCRIPTION("Generic WD33C93 SCSI driver");
@@ -123,6 +127,13 @@ MODULE_LICENSE("GPL");
  *                    defines in wd33c93.h
  * -  clock:x        -x = clock input in MHz for WD33c93 chip. Normal values
  *                    would be from 8 through 20. Default is 8.
+ * -  burst:x        -x = 1 to use Burst Mode (or Demand-Mode) DMA, x = 0 to use
+ *                    Single Byte DMA, which is the default. Argument is
+ *                    optional - if not present, same as "burst:1".
+ * -  fast:x         -x = 1 to enable Fast SCSI, which is only effective with
+ *                    input-clock divisor 4 (WD33C93_FS_16_20), x = 0 to disable
+ *                    it, which is the default.  Argument is optional - if not
+ *                    present, same as "fast:1".
  * -  next           -No argument. Used to separate blocks of keywords when
  *                    there's more than one host adapter in the system.
  *
@@ -149,7 +160,7 @@ MODULE_LICENSE("GPL");
  */

 /* Normally, no defaults are specified */
-static char *setup_args[] = { "", "", "", "", "", "", "", "", "" };
+static char *setup_args[] = { "", "", "", "", "", "", "", "", "", "" };

 static char *setup_strings;
 module_param(setup_strings, charp, 0);
@@ -325,17 +336,48 @@ round_period(unsigned int period)
 	return 7;
 }

+/*
+ * Calculate Synchronous Transfer Register value from SDTR code.
+ */
 static uchar
-calc_sync_xfer(unsigned int period, unsigned int offset)
+calc_sync_xfer(unsigned int period, unsigned int offset, unsigned int fast)
 {
+	/* When doing Fast SCSI synchronous data transfers, the corresponding
+	 * value in 'sx_table' is two times the actually used transfer period.
+	 */
 	uchar result;

+	if (offset && fast) {
+		fast = STR_FSS;
+		period *= 2;
+	} else {
+		fast = 0;
+	}
 	period *= 4;		/* convert SDTR code to ns */
 	result = sx_table[round_period(period)].reg_value;
 	result |= (offset < OPTIMUM_SX_OFF) ? offset : OPTIMUM_SX_OFF;
+	result |= fast;
 	return result;
 }

+/*
+ * Calculate SDTR code bytes [3],[4] from period and offset.
+ */
+static inline void
+calc_sync_msg(unsigned int period, unsigned int offset, unsigned int fast,
+                uchar  msg[2])
+{
+	/* 'period' is a "normal"-mode value, like the ones in 'sx_table'. The
+	 * actually used transfer period for Fast SCSI synchronous data
+	 * transfers is half that value.
+	 */
+	period /= 4;
+	if (offset && fast)
+		period /= 2;
+	msg[0] = period;
+	msg[1] = offset;
+}
+
 int
 wd33c93_queuecommand(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
@@ -633,7 +675,7 @@ wd33c93_execute(struct Scsi_Host *instan
 				write_wd33c93_count(regs,
 						    cmd->SCp.this_residual);
 				write_wd33c93(regs, WD_CONTROL,
-					      CTRL_IDI | CTRL_EDI | CTRL_DMA);
+					      CTRL_IDI | CTRL_EDI | hostdata->dma_mode);
 				hostdata->dma = D_DMA_RUNNING;
 			}
 		} else
@@ -713,6 +755,8 @@ transfer_bytes(const wd33c93_regs regs,
 		cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) +
 		    cmd->SCp.buffer->offset;
 	}
+	if (!cmd->SCp.this_residual) /* avoid bogus setups */
+		return;

 	write_wd33c93(regs, WD_SYNCHRONOUS_TRANSFER,
 		      hostdata->sync_xfer[cmd->device->id]);
@@ -745,7 +789,7 @@ transfer_bytes(const wd33c93_regs regs,
 #ifdef PROC_STATISTICS
 		hostdata->dma_cnt++;
 #endif
-		write_wd33c93(regs, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_DMA);
+		write_wd33c93(regs, WD_CONTROL, CTRL_IDI | CTRL_EDI | hostdata->dma_mode);
 		write_wd33c93_count(regs, cmd->SCp.this_residual);

 		if ((hostdata->level2 >= L2_DATA) ||
@@ -863,9 +907,6 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->outgoing_msg[0] |= 0x40;

 		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {
-#ifdef SYNC_DEBUG
-			printk(" sending SDTR ");
-#endif

 			hostdata->sync_stat[cmd->device->id] = SS_WAITING;

@@ -879,14 +920,19 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->outgoing_msg[2] = 3;
 			hostdata->outgoing_msg[3] = EXTENDED_SDTR;
 			if (hostdata->no_sync & (1 << cmd->device->id)) {
-				hostdata->outgoing_msg[4] =
-				    hostdata->default_sx_per / 4;
-				hostdata->outgoing_msg[5] = 0;
+				calc_sync_msg(hostdata->default_sx_per, 0,
+						0, hostdata->outgoing_msg + 4);
 			} else {
-				hostdata->outgoing_msg[4] = OPTIMUM_SX_PER / 4;
-				hostdata->outgoing_msg[5] = OPTIMUM_SX_OFF;
+				calc_sync_msg(OPTIMUM_SX_PER, OPTIMUM_SX_OFF,
+						hostdata->fast,
+						hostdata->outgoing_msg + 4);
 			}
 			hostdata->outgoing_len = 6;
+#ifdef SYNC_DEBUG
+			ucp = hostdata->outgoing_msg + 1;
+			printk(" sending SDTR %02x03%02x%02x%02x ",
+				ucp[0], ucp[2], ucp[3], ucp[4]);
+#endif
 		} else
 			hostdata->outgoing_len = 1;

@@ -1002,8 +1048,13 @@ wd33c93_intr(struct Scsi_Host *instance)
 #ifdef SYNC_DEBUG
 			    printk("-REJ-");
 #endif
-			if (hostdata->sync_stat[cmd->device->id] == SS_WAITING)
+			if (hostdata->sync_stat[cmd->device->id] == SS_WAITING) {
 				hostdata->sync_stat[cmd->device->id] = SS_SET;
+				/* we want default_sx_per, not DEFAULT_SX_PER */
+				hostdata->sync_xfer[cmd->device->id] =
+					calc_sync_xfer(hostdata->default_sx_per
+						/ 4, 0, 0);
+			}
 			write_wd33c93_cmd(regs, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_CONNECTED;
 			break;
@@ -1023,7 +1074,10 @@ wd33c93_intr(struct Scsi_Host *instance)

 				switch (ucp[2]) {	/* what's the EXTENDED code? */
 				case EXTENDED_SDTR:
-					id = calc_sync_xfer(ucp[3], ucp[4]);
+					/* default to default async period */
+					id = calc_sync_xfer(hostdata->
+							default_sx_per / 4, 0,
+							0);
 					if (hostdata->sync_stat[cmd->device->id] !=
 					    SS_WAITING) {

@@ -1042,20 +1096,21 @@ wd33c93_intr(struct Scsi_Host *instance)
 						hostdata->outgoing_msg[1] = 3;
 						hostdata->outgoing_msg[2] =
 						    EXTENDED_SDTR;
-						hostdata->outgoing_msg[3] =
-						    hostdata->default_sx_per /
-						    4;
-						hostdata->outgoing_msg[4] = 0;
+						calc_sync_msg(hostdata->
+							default_sx_per, 0,
+							0, hostdata->outgoing_msg + 3);
 						hostdata->outgoing_len = 5;
-						hostdata->sync_xfer[cmd->device->id] =
-						    calc_sync_xfer(hostdata->
-								   default_sx_per
-								   / 4, 0);
 					} else {
-						hostdata->sync_xfer[cmd->device->id] = id;
+						if (ucp[4]) /* well, sync transfer */
+							id = calc_sync_xfer(ucp[3], ucp[4],
+									hostdata->fast);
+						else if (ucp[3]) /* very unlikely... */
+							id = calc_sync_xfer(ucp[3], ucp[4],
+									0);
 					}
+					hostdata->sync_xfer[cmd->device->id] = id;
 #ifdef SYNC_DEBUG
-					printk("sync_xfer=%02x",
+					printk(" sync_xfer=%02x\n",
 					       hostdata->sync_xfer[cmd->device->id]);
 #endif
 					hostdata->sync_stat[cmd->device->id] =
@@ -1487,7 +1542,7 @@ reset_wd33c93(struct Scsi_Host *instance
 	write_wd33c93(regs, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_POLLED);
 	write_wd33c93(regs, WD_SYNCHRONOUS_TRANSFER,
 		      calc_sync_xfer(hostdata->default_sx_per / 4,
-				     DEFAULT_SX_OFF));
+				     DEFAULT_SX_OFF, 0));
 	write_wd33c93(regs, WD_COMMAND, WD_CMD_RESET);


@@ -1513,6 +1568,9 @@ reset_wd33c93(struct Scsi_Host *instance
 	} else
 		hostdata->chip = C_UNKNOWN_CHIP;

+	if (hostdata->chip != C_WD33C93B)	/* Fast SCSI unavailable */
+		hostdata->fast = 0;
+
 	write_wd33c93(regs, WD_TIMEOUT_PERIOD, TIMEOUT_PERIOD_VALUE);
 	write_wd33c93(regs, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_POLLED);
 }
@@ -1534,7 +1592,7 @@ wd33c93_host_reset(struct scsi_cmnd * SC
 	for (i = 0; i < 8; i++) {
 		hostdata->busy[i] = 0;
 		hostdata->sync_xfer[i] =
-		    calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF);
+			calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF, 0);
 		hostdata->sync_stat[i] = SS_UNSET;	/* using default sync values */
 	}
 	hostdata->input_Q = NULL;
@@ -1783,6 +1841,38 @@ check_setup_args(char *key, int *flags,
 	return ++x;
 }

+/*
+ * check and, maybe, map an init- or "clock:"- argument.
+ */
+static uchar
+set_clk_freq(int freq)
+{
+	if (freq != WD33C93_FS_8_10 &&
+	    freq != WD33C93_FS_12_15 &&
+	    freq != WD33C93_FS_16_20)
+		if (freq > 7 && freq < 11)
+			freq = WD33C93_FS_8_10;
+		else if (freq > 11 && freq < 16)
+			freq = WD33C93_FS_12_15;
+		else if (freq > 15 && freq < 21)
+			freq = WD33C93_FS_16_20;
+		else
+			/* Hmm, wouldn't it be safer to assume highest freq here? */
+			freq = WD33C93_FS_8_10;
+	return freq;
+}
+
+/*
+ * to be used with the resync: fast: ... options
+ */
+static inline void set_resync ( struct WD33C93_hostdata *hd, int mask )
+{
+	int i;
+	for (i = 0; i < 8; i++)
+		if (mask & (1 << i))
+			hd->sync_stat[i] = SS_UNSET;
+}
+
 void
 wd33c93_init(struct Scsi_Host *instance, const wd33c93_regs regs,
 	     dma_setup_t setup, dma_stop_t stop, int clock_freq)
@@ -1799,7 +1889,7 @@ wd33c93_init(struct Scsi_Host *instance,
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;

 	hostdata->regs = regs;
-	hostdata->clock_freq = clock_freq;
+	hostdata->clock_freq = set_clk_freq(clock_freq);
 	hostdata->dma_setup = setup;
 	hostdata->dma_stop = stop;
 	hostdata->dma_bounce_buffer = NULL;
@@ -1807,7 +1897,7 @@ wd33c93_init(struct Scsi_Host *instance,
 	for (i = 0; i < 8; i++) {
 		hostdata->busy[i] = 0;
 		hostdata->sync_xfer[i] =
-		    calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF);
+			calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF, 0);
 		hostdata->sync_stat[i] = SS_UNSET;	/* using default sync values */
 #ifdef PROC_STATISTICS
 		hostdata->cmd_cnt[i] = 0;
@@ -1829,6 +1919,8 @@ wd33c93_init(struct Scsi_Host *instance,
 	hostdata->default_sx_per = DEFAULT_SX_PER;
 	hostdata->no_sync = 0xff;	/* sync defaults to off */
 	hostdata->no_dma = 0;	/* default is DMA enabled */
+	hostdata->fast = 0;	/* default is Fast SCSI transfers disabled */
+	hostdata->dma_mode = CTRL_DMA;	/* default is Single Byte DMA */

 #ifdef PROC_INTERFACE
 	hostdata->proc = PR_VERSION | PR_INFO | PR_STATISTICS |
@@ -1840,6 +1932,9 @@ wd33c93_init(struct Scsi_Host *instance,
 #endif
 #endif

+	if (check_setup_args("clock", &flags, &val, buf))
+		hostdata->clock_freq = set_clk_freq(val);
+
 	if (check_setup_args("nosync", &flags, &val, buf))
 		hostdata->no_sync = val;

@@ -1863,17 +1958,12 @@ wd33c93_init(struct Scsi_Host *instance,
 	if (check_setup_args("debug", &flags, &val, buf))
 		hostdata->args = val & DB_MASK;

-	if (check_setup_args("clock", &flags, &val, buf)) {
-		if (val > 7 && val < 11)
-			val = WD33C93_FS_8_10;
-		else if (val > 11 && val < 16)
-			val = WD33C93_FS_12_15;
-		else if (val > 15 && val < 21)
-			val = WD33C93_FS_16_20;
-		else
-			val = WD33C93_FS_8_10;
-		hostdata->clock_freq = val;
-	}
+	if (check_setup_args("burst", &flags, &val, buf))
+		hostdata->dma_mode = val ? CTRL_BURST:CTRL_DMA;
+
+	if (WD33C93_FS_16_20 == hostdata->clock_freq /* divisor 4 */
+		&& check_setup_args("fast", &flags, &val, buf))
+		hostdata->fast = !!val;

 	if ((i = check_setup_args("next", &flags, &val, buf))) {
 		while (i)
@@ -1924,47 +2014,58 @@ wd33c93_proc_info(struct Scsi_Host *inst
 	hd = (struct WD33C93_hostdata *) instance->hostdata;

 /* If 'in' is TRUE we need to _read_ the proc file. We accept the following
- * keywords (same format as command-line, but only ONE per read):
+ * keywords (same format as command-line, but arguments are not optional):
  *    debug
  *    disconnect
  *    period
  *    resync
  *    proc
  *    nodma
+ *    level2
+ *    burst
+ *    fast
+ *    nosync
  */

 	if (in) {
 		buf[len] = '\0';
-		bp = buf;
+		for (bp = buf; *bp; ) {
+			while (',' == *bp || ' ' == *bp)
+				++bp;
 		if (!strncmp(bp, "debug:", 6)) {
-			bp += 6;
-			hd->args = simple_strtoul(bp, NULL, 0) & DB_MASK;
+				hd->args = simple_strtoul(bp+6, &bp, 0) & DB_MASK;
 		} else if (!strncmp(bp, "disconnect:", 11)) {
-			bp += 11;
-			x = simple_strtoul(bp, NULL, 0);
+				x = simple_strtoul(bp+11, &bp, 0);
 			if (x < DIS_NEVER || x > DIS_ALWAYS)
 				x = DIS_ADAPTIVE;
 			hd->disconnect = x;
 		} else if (!strncmp(bp, "period:", 7)) {
-			bp += 7;
-			x = simple_strtoul(bp, NULL, 0);
+				x = simple_strtoul(bp+7, &bp, 0);
 			hd->default_sx_per =
 			    sx_table[round_period((unsigned int) x)].period_ns;
 		} else if (!strncmp(bp, "resync:", 7)) {
-			bp += 7;
-			x = simple_strtoul(bp, NULL, 0);
-			for (i = 0; i < 7; i++)
-				if (x & (1 << i))
-					hd->sync_stat[i] = SS_UNSET;
+				set_resync(hd, (int)simple_strtoul(bp+7, &bp, 0));
 		} else if (!strncmp(bp, "proc:", 5)) {
-			bp += 5;
-			hd->proc = simple_strtoul(bp, NULL, 0);
+				hd->proc = simple_strtoul(bp+5, &bp, 0);
 		} else if (!strncmp(bp, "nodma:", 6)) {
-			bp += 6;
-			hd->no_dma = simple_strtoul(bp, NULL, 0);
+				hd->no_dma = simple_strtoul(bp+6, &bp, 0);
 		} else if (!strncmp(bp, "level2:", 7)) {
-			bp += 7;
-			hd->level2 = simple_strtoul(bp, NULL, 0);
+				hd->level2 = simple_strtoul(bp+7, &bp, 0);
+			} else if (!strncmp(bp, "burst:", 6)) {
+				hd->dma_mode =
+					simple_strtol(bp+6, &bp, 0) ? CTRL_BURST:CTRL_DMA;
+			} else if (!strncmp(bp, "fast:", 5)) {
+				x = !!simple_strtol(bp+5, &bp, 0);
+				if (x != hd->fast)
+					set_resync(hd, 0xff);
+				hd->fast = x;
+			} else if (!strncmp(bp, "nosync:", 7)) {
+				x = simple_strtoul(bp+7, &bp, 0);
+				set_resync(hd, x ^ hd->no_sync);
+				hd->no_sync = x;
+			} else {
+				break; /* unknown keyword,syntax-error,... */
+			}
 		}
 		return len;
 	}
@@ -1978,8 +2079,9 @@ wd33c93_proc_info(struct Scsi_Host *inst
 		strcat(bp, tbuf);
 	}
 	if (hd->proc & PR_INFO) {
-		sprintf(tbuf, "\nclock_freq=%02x no_sync=%02x no_dma=%d",
-			hd->clock_freq, hd->no_sync, hd->no_dma);
+		sprintf(tbuf, "\nclock_freq=%02x no_sync=%02x no_dma=%d"
+			" dma_mode=%02x fast=%d",
+			hd->clock_freq, hd->no_sync, hd->no_dma, hd->dma_mode, hd->fast);
 		strcat(bp, tbuf);
 		strcat(bp, "\nsync_xfer[] =       ");
 		for (x = 0; x < 7; x++) {
========================================================================


=== 2nd Stage ==========================================================
--- stage1/drivers/scsi/wd33c93.h	Sun Feb 11 20:05:53 2007
+++ stage2/drivers/scsi/wd33c93.h	Sun Feb 11 20:05:53 2007
@@ -155,6 +155,9 @@
 #define WD33C93_FS_12_15 OWNID_FS_12
 #define WD33C93_FS_16_20 OWNID_FS_16

+   /* pass input-clock explicitely. accepted mhz values are 8-10,12-20 */
+#define WD33C93_FS_MHZ(mhz) (mhz)
+
    /* Control register */
 #define CTRL_HSP     0x01
 #define CTRL_HA      0x02
@@ -255,6 +258,7 @@
     uchar            no_dma;           /* set this flag to disable DMA */
     uchar            dma_mode;         /* DMA Burst Mode or Single Byte DMA */
     uchar            fast;             /* set this flag to enable Fast SCSI */
+    struct sx_period sx_table[9];      /* transfer periods for actual DTC-setting */
 #ifdef PROC_INTERFACE
     uchar            proc;             /* bitmask: what's in proc output */
 #ifdef PROC_STATISTICS
--- stage1/drivers/scsi/wd33c93.c	Sun Feb 11 22:01:17 2007
+++ stage2/drivers/scsi/wd33c93.c	Sun Feb 11 22:01:17 2007
@@ -71,7 +71,8 @@
  *	Richard Hirst <richard@sleepie.demon.co.uk>  August 2000
  *
  * Added support for Burst Mode DMA and Fast SCSI. Enabled the use of
- * default_sx_per for asynchronous data transfers.
+ * default_sx_per for asynchronous data transfers. Added adjustment
+ * of transfer periods in sx_table to the actual input-clock.
  *  peter fuerst <post@pfrst.de>  February 2007
  */

@@ -91,6 +92,8 @@

 #include "wd33c93.h"

+#define optimum_sx_per(hostdata) (hostdata)->sx_table[1].period_ns
+

 #define WD33C93_VERSION    "1.26++"
 #define WD33C93_DATE       "10/Feb/2007"
@@ -310,20 +313,8 @@ read_1_byte(const wd33c93_regs regs)
 	return x;
 }

-static struct sx_period sx_table[] = {
-	{1, 0x20},
-	{252, 0x20},
-	{376, 0x30},
-	{500, 0x40},
-	{624, 0x50},
-	{752, 0x60},
-	{876, 0x70},
-	{1000, 0x00},
-	{0, 0}
-};
-
 static int
-round_period(unsigned int period)
+round_period(unsigned int period, const struct sx_period *sx_table)
 {
 	int x;

@@ -340,7 +331,8 @@ round_period(unsigned int period)
  * Calculate Synchronous Transfer Register value from SDTR code.
  */
 static uchar
-calc_sync_xfer(unsigned int period, unsigned int offset, unsigned int fast)
+calc_sync_xfer(unsigned int period, unsigned int offset, unsigned int fast,
+               const struct sx_period *sx_table)
 {
 	/* When doing Fast SCSI synchronous data transfers, the corresponding
 	 * value in 'sx_table' is two times the actually used transfer period.
@@ -354,7 +346,7 @@ calc_sync_xfer(unsigned int period, unsi
 		fast = 0;
 	}
 	period *= 4;		/* convert SDTR code to ns */
-	result = sx_table[round_period(period)].reg_value;
+	result = sx_table[round_period(period,sx_table)].reg_value;
 	result |= (offset < OPTIMUM_SX_OFF) ? offset : OPTIMUM_SX_OFF;
 	result |= fast;
 	return result;
@@ -923,7 +915,8 @@ wd33c93_intr(struct Scsi_Host *instance)
 				calc_sync_msg(hostdata->default_sx_per, 0,
 						0, hostdata->outgoing_msg + 4);
 			} else {
-				calc_sync_msg(OPTIMUM_SX_PER, OPTIMUM_SX_OFF,
+				calc_sync_msg(optimum_sx_per(hostdata),
+						OPTIMUM_SX_OFF,
 						hostdata->fast,
 						hostdata->outgoing_msg + 4);
 			}
@@ -1053,7 +1046,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 				/* we want default_sx_per, not DEFAULT_SX_PER */
 				hostdata->sync_xfer[cmd->device->id] =
 					calc_sync_xfer(hostdata->default_sx_per
-						/ 4, 0, 0);
+						/ 4, 0, 0, hostdata->sx_table);
 			}
 			write_wd33c93_cmd(regs, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_CONNECTED;
@@ -1077,7 +1070,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 					/* default to default async period */
 					id = calc_sync_xfer(hostdata->
 							default_sx_per / 4, 0,
-							0);
+							0, hostdata->sx_table);
 					if (hostdata->sync_stat[cmd->device->id] !=
 					    SS_WAITING) {

@@ -1103,10 +1096,11 @@ wd33c93_intr(struct Scsi_Host *instance)
 					} else {
 						if (ucp[4]) /* well, sync transfer */
 							id = calc_sync_xfer(ucp[3], ucp[4],
-									hostdata->fast);
+									hostdata->fast,
+									hostdata->sx_table);
 						else if (ucp[3]) /* very unlikely... */
 							id = calc_sync_xfer(ucp[3], ucp[4],
-									0);
+									0, hostdata->sx_table);
 					}
 					hostdata->sync_xfer[cmd->device->id] = id;
 #ifdef SYNC_DEBUG
@@ -1542,7 +1536,7 @@ reset_wd33c93(struct Scsi_Host *instance
 	write_wd33c93(regs, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_POLLED);
 	write_wd33c93(regs, WD_SYNCHRONOUS_TRANSFER,
 		      calc_sync_xfer(hostdata->default_sx_per / 4,
-				     DEFAULT_SX_OFF, 0));
+				     DEFAULT_SX_OFF, 0, hostdata->sx_table));
 	write_wd33c93(regs, WD_COMMAND, WD_CMD_RESET);


@@ -1592,7 +1586,8 @@ wd33c93_host_reset(struct scsi_cmnd * SC
 	for (i = 0; i < 8; i++) {
 		hostdata->busy[i] = 0;
 		hostdata->sync_xfer[i] =
-			calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF, 0);
+			calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF,
+					0, hostdata->sx_table);
 		hostdata->sync_stat[i] = SS_UNSET;	/* using default sync values */
 	}
 	hostdata->input_Q = NULL;
@@ -1842,24 +1837,84 @@ check_setup_args(char *key, int *flags,
 }

 /*
+ * Calculate internal data-transfer-clock cycle from input-clock
+ * frequency (/MHz) and fill 'sx_table'.
+ *
+ * The original driver used to rely on a fixed sx_table, containing periods
+ * for (only) the lower limits of the respective input-clock-frequency ranges
+ * (8-10/12-15/16-20 MHz). Although it seems, that no problems ocurred with
+ * this setting so far, it might be desirable to adjust the transfer periods
+ * closer to the really attached, possibly 25% higher, input-clock, since
+ * - the wd33c93 may really use a significant shorter period, than it has
+ *   negotiated (eg. thrashing the target, which expects 4/8MHz, with 5/10MHz
+ *   instead).
+ * - the wd33c93 may ask the target for a lower transfer rate, than the target
+ *   is capable of (eg. negotiating for an assumed minimum of 252ns instead of
+ *   possible 200ns, which indeed shows up in tests as an approx. 10% lower
+ *   transfer rate).
+ */
+static inline unsigned int
+round_4(unsigned int x)
+{
+	switch (x & 3) {
+		case 1: --x;
+			break;
+		case 2: ++x;
+		case 3: ++x;
+	}
+	return x;
+}
+
+static void
+calc_sx_table(unsigned int mhz, struct sx_period sx_table[9])
+{
+	unsigned int d, i;
+	if (mhz < 11)
+		d = 2;	/* divisor for  8-10 MHz input-clock */
+	else if (mhz < 16)
+		d = 3;	/* divisor for 12-15 MHz input-clock */
+	else
+		d = 4;	/* divisor for 16-20 MHz input-clock */
+
+	d = (100000 * d) / 2 / mhz; /* 100 x DTCC / nanosec */
+
+	sx_table[0].period_ns = 1;
+	sx_table[0].reg_value = 0x20;
+	for (i = 1; i < 8; i++) {
+		sx_table[i].period_ns = round_4((i+1)*d / 100);
+		sx_table[i].reg_value = (i+1)*0x10;
+	}
+	sx_table[7].reg_value = 0;
+	sx_table[8].period_ns = 0;
+	sx_table[8].reg_value = 0;
+}
+
+/*
  * check and, maybe, map an init- or "clock:"- argument.
  */
 static uchar
-set_clk_freq(int freq)
+set_clk_freq(int freq, int *mhz)
 {
-	if (freq != WD33C93_FS_8_10 &&
-	    freq != WD33C93_FS_12_15 &&
-	    freq != WD33C93_FS_16_20)
-		if (freq > 7 && freq < 11)
-			freq = WD33C93_FS_8_10;
+	int x = freq;
+	if (WD33C93_FS_8_10 == freq)
+		freq = 8;
+	else if (WD33C93_FS_12_15 == freq)
+		freq = 12;
+	else if (WD33C93_FS_16_20 == freq)
+		freq = 16;
+	else if (freq > 7 && freq < 11)
+		x = WD33C93_FS_8_10;
 		else if (freq > 11 && freq < 16)
-			freq = WD33C93_FS_12_15;
+		x = WD33C93_FS_12_15;
 		else if (freq > 15 && freq < 21)
-			freq = WD33C93_FS_16_20;
-		else
+		x = WD33C93_FS_16_20;
+	else {
 			/* Hmm, wouldn't it be safer to assume highest freq here? */
-			freq = WD33C93_FS_8_10;
-	return freq;
+		x = WD33C93_FS_8_10;
+		freq = 8;
+	}
+	*mhz = freq;
+	return x;
 }

 /*
@@ -1889,7 +1944,8 @@ wd33c93_init(struct Scsi_Host *instance,
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;

 	hostdata->regs = regs;
-	hostdata->clock_freq = set_clk_freq(clock_freq);
+	hostdata->clock_freq = set_clk_freq(clock_freq, &i);
+	calc_sx_table(i, hostdata->sx_table);
 	hostdata->dma_setup = setup;
 	hostdata->dma_stop = stop;
 	hostdata->dma_bounce_buffer = NULL;
@@ -1897,7 +1953,8 @@ wd33c93_init(struct Scsi_Host *instance,
 	for (i = 0; i < 8; i++) {
 		hostdata->busy[i] = 0;
 		hostdata->sync_xfer[i] =
-			calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF, 0);
+			calc_sync_xfer(DEFAULT_SX_PER / 4, DEFAULT_SX_OFF,
+					0, hostdata->sx_table);
 		hostdata->sync_stat[i] = SS_UNSET;	/* using default sync values */
 #ifdef PROC_STATISTICS
 		hostdata->cmd_cnt[i] = 0;
@@ -1932,8 +1989,10 @@ wd33c93_init(struct Scsi_Host *instance,
 #endif
 #endif

-	if (check_setup_args("clock", &flags, &val, buf))
-		hostdata->clock_freq = set_clk_freq(val);
+	if (check_setup_args("clock", &flags, &val, buf)) {
+		hostdata->clock_freq = set_clk_freq(val, &val);
+		calc_sx_table(val, hostdata->sx_table);
+	}

 	if (check_setup_args("nosync", &flags, &val, buf))
 		hostdata->no_sync = val;
@@ -1943,7 +2002,8 @@ wd33c93_init(struct Scsi_Host *instance,

 	if (check_setup_args("period", &flags, &val, buf))
 		hostdata->default_sx_per =
-		    sx_table[round_period((unsigned int) val)].period_ns;
+		    hostdata->sx_table[round_period((unsigned int) val,
+		                                    hostdata->sx_table)].period_ns;

 	if (check_setup_args("disconnect", &flags, &val, buf)) {
 		if ((val >= DIS_NEVER) && (val <= DIS_ALWAYS))
@@ -2042,7 +2102,8 @@ wd33c93_proc_info(struct Scsi_Host *inst
 			} else if (!strncmp(bp, "period:", 7)) {
 				x = simple_strtoul(bp+7, &bp, 0);
 				hd->default_sx_per =
-				    sx_table[round_period((unsigned int) x)].period_ns;
+				    hd->sx_table[round_period((unsigned int) x,
+				                              hd->sx_table)].period_ns;
 			} else if (!strncmp(bp, "resync:", 7)) {
 				set_resync(hd, (int)simple_strtoul(bp+7, &bp, 0));
 			} else if (!strncmp(bp, "proc:", 5)) {
========================================================================

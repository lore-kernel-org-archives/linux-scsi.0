From: Mike Brown <mbrown@emc.com>
Subject: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 12:03:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031170337.GO574@lapi0061>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: bferjul@emc.com, jkrasner@emc.com, gibbs@FreeBSD.org
Cc: conway_heather@emc.com, linux-scsi@vger.kernel.org

Hi,

It seems the kernel reintroduced a bug that I fixed a year ago
regarding phantom devices being reported by the aic7xxx driver.
The problem is that the AIC driver defines the maximum LUs it
supports as 64 (aic7xxx.h:#define AHC_NUM_LUNS 64).  Symmetrix
reports SCSI_2 devices which according to the spec means no
target supports more than 8 LUs (LUN 0-7) per target id.  However,
since the Symmetrix can be configured to support more than 8 LUs per
target id, its tagged in the blacklist with the BLIST_LARGELUN flag,
which trips the scanning code into treating the Symmetrix as a
SCSI_3 device:

drivers/scsi/scsi_scan.c:

	{"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},

..........

	/* don't probe further for luns > 7 for targets <= SCSI_2 */
	if ((lun0_sl < SCSI_3) && (lun > 7))
		break;

	if (!scan_scsis_single(channel, order_dev, lun, lun0_sl,
			       &max_dev_lun, &sparse_lun, &SDpnt, shpnt,
			       scsi_result) && !sparse_lun)
		break;	/* break means don't probe further for luns!=0 */
	if (SDpnt && (0 == lun)) {
		int bflags = get_device_flags (scsi_result);
		if (bflags & BLIST_LARGELUN)
			lun0_sl = SCSI_3; /* treat as SCSI 3 */
		else
			lun0_sl = SDpnt->scsi_level;


This isn't a problem so far until we start scanning LUN > 31.  The
SCSI_3 IDENTIFY Message Format defines 6 bits for LUN, but since
Symmetrix reports its devices as SCSI_2, we follow the SCSI_2 IDENTIFY
Message Format which defines 3 bits for the LUNTRN, and we also
use the 2 reserved bits which gives us 5 bits or 32 LUs.  So, when
the SCSI subsystem begins scanning for LUNs > 31, the aic7xxx driver
reports devices that are actually (LUN & 0x0000001f) and LUNs that
have already been reported are re-reported, hence the phantom device
problem.

Justin can you change AHC_NUM_LUNS to 32 or suggest an alternative fix?

Alternatively a new BLIST_FLAG could be defined.  This also has its
problems because Fibre attached Symm's work with LUN > 31 without
problems since the IDENTIFY Message is unique to Parallel.  Perhaps another
option is to add a "ahc_num_luns=xxx" module parameter allowing
the decision to be made at runtime.

Please cc: me on linux replies as I'm not currently subscribed.

--------CUT HERE---------
--- linux-2.4.19/drivers/scsi/aic7xxx/aic7xxx.h.orig	Wed Aug  7 09:31:30 2002
+++ linux-2.4.19/drivers/scsi/aic7xxx/aic7xxx.h	Thu Oct 31 12:12:26 2002
@@ -122,7 +122,7 @@
  * You can have 2^64 luns when information unit transfers are enabled,
  * but it is doubtful this driver will ever support IUTs.
  */
-#define AHC_NUM_LUNS 64
+#define AHC_NUM_LUNS 32
 
 /*
  * The maximum transfer per S/G segment.
--------CUT HERE---------

-Michael F. Brown, EMC Corp.

Email:            mbrown@emc.com
EMC Tie Line:             x43416
External Line:    (508) 249-3416

"5 years from now everyone will be running free
 GNU on their 200 MIPS, 64M SPARCstation-5."      -Andrew Tanenbaum '92

(In late 1997 I installed Linux for the first time on my 200Mhz, 128M
 AMD x86 clone)

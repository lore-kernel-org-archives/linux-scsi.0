From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: raise default transfer size limit
Date: Sun, 16 Dec 2007 17:31:26 +0100 (CET)
Message-ID: <tkrat.0751d80793eb2892@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45974 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378AbXLPQbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Dec 2007 11:31:37 -0500
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

This patch speeds up sbp2 a little bit --- but more importantly, it
brings the behavior of sbp2 and fw-sbp2 closer to each other.  Like
fw-sbp2, sbp2 now does not limit the size of single transfers to 255
sectors anymore, unless told so by a blacklist flag or by module load
parameters.

Only very old bridge chips have been known to need the 255 sectors
limit, and we have got one such chip in our hardwired blacklist.  There
certainly is a danger that more bridges need that limit; but I prefer to
have this issue present in both fw-sbp2 and sbp2 rather than just one of
them.

An OXUF922 with 400GB 7200RPM disk on an S400 controller is sped up by
this patch from 22.9 to 23.5 MB/s according to hdparm.  The same effect
could be achieved before by setting a higher max_sectors module
parameter.  On buses which use 1394b beta mode, sbp2 and fw-sbp2 will
now achieve virtually the same bandwidth.  Fw-sbp2 only remains faster
on 1394a buses due to fw-core's gap count optimization.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   26 +++++++++++++++-----------
 drivers/ieee1394/sbp2.h |    1 -
 2 files changed, 15 insertions(+), 12 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -51,6 +51,7 @@
  * Grep for inline FIXME comments below.
  */
 
+#include <linux/blkdev.h>
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -127,17 +128,21 @@ MODULE_PARM_DESC(serialize_io, "Serializ
 		 "(default = Y, faster but buggy = N)");
 
 /*
- * Bump up max_sectors if you'd like to support very large sized
- * transfers. Please note that some older sbp2 bridge chips are broken for
- * transfers greater or equal to 128KB.  Default is a value of 255
- * sectors, or just under 128KB (at 512 byte sector size). I can note that
- * the Oxsemi sbp2 chipsets have no problems supporting very large
- * transfer sizes.
+ * Adjust max_sectors if you'd like to influence how many sectors each SCSI
+ * command can transfer at most. Please note that some older SBP-2 bridge
+ * chips are broken for transfers greater or equal to 128KB, therefore
+ * max_sectors used to be a safe 255 sectors for many years. We now have a
+ * default of 0 here which means that we let the SCSI stack choose a limit.
+ *
+ * The SBP2_WORKAROUND_128K_MAX_TRANS flag, if set either in the workarounds
+ * module parameter or in the sbp2_workarounds_table[], will override the
+ * value of max_sectors. We should use sbp2_workarounds_table[] to cover any
+ * bridge chip which becomes known to need the 255 sectors limit.
  */
-static int sbp2_max_sectors = SBP2_MAX_SECTORS;
+static int sbp2_max_sectors;
 module_param_named(max_sectors, sbp2_max_sectors, int, 0444);
 MODULE_PARM_DESC(max_sectors, "Change max sectors per I/O supported "
-		 "(default = " __stringify(SBP2_MAX_SECTORS) ")");
+		 "(default = 0 = use SCSI stack's default)");
 
 /*
  * Exclusive login to sbp2 device? In most cases, the sbp2 driver should
@@ -1980,6 +1985,8 @@ static int sbp2scsi_slave_configure(stru
 		sdev->skip_ms_page_8 = 1;
 	if (lu->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
+	if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
+		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
 	return 0;
 }
 
@@ -2086,9 +2093,6 @@ static int sbp2_module_init(void)
 		sbp2_shost_template.cmd_per_lun = 1;
 	}
 
-	if (sbp2_default_workarounds & SBP2_WORKAROUND_128K_MAX_TRANS &&
-	    (sbp2_max_sectors * 512) > (128 * 1024))
-		sbp2_max_sectors = 128 * 1024 / 512;
 	sbp2_shost_template.max_sectors = sbp2_max_sectors;
 
 	hpsb_register_highlevel(&sbp2_highlevel);
Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -222,7 +222,6 @@ struct sbp2_status_block {
  */
 
 #define SBP2_MAX_SG_ELEMENT_LENGTH		0xf000
-#define SBP2_MAX_SECTORS			255
 /* There is no real limitation of the queue depth (i.e. length of the linked
  * list of command ORBs) at the target. The chosen depth is merely an
  * implementation detail of the sbp2 driver. */

-- 
Stefan Richter
-=====-=-=== ==-- =----
http://arcgraph.de/sr/


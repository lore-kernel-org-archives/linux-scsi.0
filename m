From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/5] firewire: fw-sbp2: fix spindown for PL-3507 and TSB42AA9
	firmwares
Date: Sun, 11 May 2008 00:35:04 +0200 (CEST)
Message-ID: <tkrat.9874e625d2b0a007@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
	<481874BD.5010807@s5r6.in-berlin.de>
	<20080507180042.GA32629@dose.home.local>
	<tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
	<tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
	<tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
	<tkrat.939c665f57d83cd4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.939c665f57d83cd4@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Reported by Tino Keitel:  PL-3507 with firmware from Prolific does not
spin down the disk on START STOP UNIT with power condition = 0 and start
= 0.  It does however work with power condition = 2 or 3.

Also found while investigating this:  DViCO Momobay CX-1 and FX-3A (TI
TSB42AA9/A based) become unresponsive after START STOP UNIT with power
condition = 0 and start = 0.  They stay responsive if power condition is
set when stopping the motor.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -86,6 +86,11 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
  * - delay inquiry
  *   Wait extra SBP2_INQUIRY_DELAY seconds after login before SCSI inquiry.
  *
+ * - power condition
+ *   Set the power condition field in the START STOP UNIT commands sent by
+ *   sd_mod on suspend, resume, and shutdown (if manage_start_stop is on).
+ *   Some disks need this to spin down or to resume properly.
+ *
  * - override internal blacklist
  *   Instead of adding to the built-in blacklist, use only the workarounds
  *   specified in the module load parameter.
@@ -97,6 +102,7 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
 #define SBP2_WORKAROUND_FIX_CAPACITY	0x8
 #define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
 #define SBP2_INQUIRY_DELAY		12
+#define SBP2_WORKAROUND_POWER_CONDITION	0x20
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 static int sbp2_param_workarounds;
@@ -107,6 +113,8 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
 	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
 	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
+	", set power condition in start stop unit = "
+				  __stringify(SBP2_WORKAROUND_POWER_CONDITION)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -310,18 +318,25 @@ static const struct {
 		.firmware_revision	= 0x002800,
 		.model			= 0x001010,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
-					  SBP2_WORKAROUND_MODE_SENSE_8,
+					  SBP2_WORKAROUND_MODE_SENSE_8 |
+					  SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
 		.firmware_revision	= 0x002800,
 		.model			= 0x000000,
-		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY,
+		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY |
+					  SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
 		.model			= ~0,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36,
 	},
+	/* PL-3507 bridge with Prolific firmware */ {
+		.firmware_revision	= 0x012800,
+		.model			= ~0,
+		.workarounds		= SBP2_WORKAROUND_POWER_CONDITION,
+	},
 	/* Symbios bridge */ {
 		.firmware_revision	= 0xa0b800,
 		.model			= ~0,
@@ -1539,6 +1554,9 @@ static int sbp2_scsi_slave_configure(str
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
 
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_POWER_CONDITION)
+		sdev->start_stop_pwr_cond = 1;
+
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
 

-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone

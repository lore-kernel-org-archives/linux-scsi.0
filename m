From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC PATCH 2.6.17.y] ieee1394: sbp2: workaround for write protect bit
	of Initio firmware
Date: Sat, 5 Aug 2006 12:41:47 +0200 (CEST)
Message-ID: <tkrat.446e64c1e07cff3b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: piergiorgio.sartor@nexgo.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ieee1394: sbp2: workaround for write protect bit of Initio firmware

Yet another mode pages related bug of Initio firmwares was seen.
INIC-1530 with a firmware by Initio responded with garbage to MODE SENSE
(10).  Some HDDs were therefore incorrectly marked as write protected:
http://bugzilla.kernel.org/show_bug.cgi?id=6947

Sbp2 now tells scsi_lib to use MODE SENSE (6) for the one known
defective model.  The workaround could be expanded to other or perhaps
even all model IDs of Initio firmwares if necessary.  At least it worked
OK with an INIC-2430 with different model ID and without the MS(10) bug.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   18 +++++++++++++++---
 drivers/ieee1394/sbp2.h |    3 ++-
 2 files changed, 17 insertions(+), 4 deletions(-)

A rediff of this patch against latest ieee1394 drivers as found in -mm
or git-ieee1394 is available at
http://me.in-berlin.de/~s5r6/linux1394/pending/133-ieee1394-sbp2-workaround-for-write-protect-bit-of-initio-firmware.patch

Index: linux-2.6.17.7/drivers/ieee1394/sbp2.h
===================================================================
--- linux-2.6.17.7.orig/drivers/ieee1394/sbp2.h	2006-08-05 10:59:15.000000000 +0200
+++ linux-2.6.17.7/drivers/ieee1394/sbp2.h	2006-08-05 11:34:31.000000000 +0200
@@ -237,8 +237,9 @@ struct sbp2_status_block {
 /* Flags for detected oddities and brokeness */
 #define SBP2_WORKAROUND_128K_MAX_TRANS	0x1
 #define SBP2_WORKAROUND_INQUIRY_36	0x2
-#define SBP2_WORKAROUND_MODE_SENSE_8	0x4
+#define SBP2_WORKAROUND_SKIP_PAGE_08	0x4
 #define SBP2_WORKAROUND_FIX_CAPACITY	0x8
+#define SBP2_WORKAROUND_MODE_SENSE_6	0x10
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 /* This is the two dma types we use for cmd_dma below */
Index: linux-2.6.17.7/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.17.7.orig/drivers/ieee1394/sbp2.c	2006-08-05 10:59:16.000000000 +0200
+++ linux-2.6.17.7/drivers/ieee1394/sbp2.c	2006-08-05 11:35:31.000000000 +0200
@@ -167,8 +167,9 @@ module_param_named(workarounds, sbp2_def
 MODULE_PARM_DESC(workarounds, "Work around device bugs (default = 0"
 	", 128kB max transfer = " __stringify(SBP2_WORKAROUND_128K_MAX_TRANS)
 	", 36 byte inquiry = "    __stringify(SBP2_WORKAROUND_INQUIRY_36)
-	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
+	", skip mode page 08 = "  __stringify(SBP2_WORKAROUND_SKIP_PAGE_08)
 	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
+	", use mode sense 6 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_6)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -300,6 +301,10 @@ static struct hpsb_protocol_driver sbp2_
  * The firmware_revision field, masked with 0xffff00, is the best indicator
  * for the type of bridge chip of a device.  It yields a few false positives
  * but this did not break correctly behaving devices so far.
+ *
+ * The order of table entries is from special to general, like for example
+ * the Initio entries.  This order is necessary because once an entry matches,
+ * the rest of the table is skipped.
  */
 static const struct {
 	u32 firmware_revision;
@@ -309,7 +314,12 @@ static const struct {
 	/* TSB42AA9 */ {
 		.firmware_revision	= 0x002800,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
-					  SBP2_WORKAROUND_MODE_SENSE_8,
+					  SBP2_WORKAROUND_SKIP_PAGE_08,
+	},
+	/* Initio INIC1530 with a firmware from Initio */ {
+		.firmware_revision	= 0x000200,
+		.model_id		= 0x000540,
+		.workarounds		= SBP2_WORKAROUND_MODE_SENSE_6,
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
@@ -2537,10 +2547,12 @@ static int sbp2scsi_slave_configure(stru
 	sdev->use_10_for_ms = 1;
 
 	if (sdev->type == TYPE_DISK &&
-	    scsi_id->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
+	    scsi_id->workarounds & SBP2_WORKAROUND_SKIP_PAGE_08)
 		sdev->skip_ms_page_8 = 1;
 	if (scsi_id->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
+	if (scsi_id->workarounds & SBP2_WORKAROUND_MODE_SENSE_6)
+		sdev->use_10_for_ms = 0;
 	return 0;
 }
 


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys -- and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV

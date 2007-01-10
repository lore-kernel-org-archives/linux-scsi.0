From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix probing of some DVD-ROM/RWs
Date: Wed, 10 Jan 2007 20:17:15 +0100 (CET)
Message-ID: <tkrat.f2ec979ea3f2a616@s5r6.in-berlin.de>
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
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Since commit 98e238cd42be6c0852da519303cf0182690f8d9f in Linux 2.6.19,
"ieee1394: sbp2: don't prefer MODE SENSE 10", some FireWire DVD-ROMs and
DVD-RWs were mistaken as CD-ROM because sr_mod now sent MODE SENSE 6.
The MMC command set includes only MODE SENSE 10.
http://bugzilla.kernel.org/show_bug.cgi?id=7800

This fix lets sbp2 switch scsi_device.use_10_for_rw on for MMC LUs.
This should rather be done in the command set driver sr_mod, not in the
sbp2 transport driver, and an according patch will follow for a next
Linux release.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -2016,6 +2016,8 @@ static int sbp2scsi_slave_configure(stru
 	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
 	sdev->use_10_for_rw = 1;
 
+	if (sdev->type == TYPE_ROM)
+		sdev->use_10_for_ms = 1;
 	if (sdev->type == TYPE_DISK &&
 	    lu->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
 		sdev->skip_ms_page_8 = 1;

-- 
Stefan Richter
-=====-=-=== ---= -=-=-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV

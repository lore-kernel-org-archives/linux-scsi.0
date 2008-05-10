From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/5] ieee1394: sbp2: spin disks down on suspend and shutdown
Date: Sun, 11 May 2008 00:37:14 +0200 (CEST)
Message-ID: <tkrat.e552004d557b31e2@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
	<481874BD.5010807@s5r6.in-berlin.de>
	<20080507180042.GA32629@dose.home.local>
	<tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
	<tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
	<tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
	<tkrat.939c665f57d83cd4@s5r6.in-berlin.de>
	<tkrat.9874e625d2b0a007@s5r6.in-berlin.de>
	<tkrat.fbd2e673d8db52fc@s5r6.in-berlin.de>
	<tkrat.68352f1ac714c0c1@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.68352f1ac714c0c1@s5r6.in-berlin.de>
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
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This instructs sd_mod to send START STOP UNIT on suspend and resume,
and on driver unbinding or unloading (including when the system is shut
down).

We don't do this though if multiple initiators may log in to the target.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -2009,6 +2009,8 @@ static int sbp2scsi_slave_configure(stru
 
 	sdev->use_10_for_rw = 1;
 
+	if (sbp2_exclusive_login)
+		sdev->manage_start_stop = 1;
 	if (sdev->type == TYPE_ROM)
 		sdev->use_10_for_ms = 1;
 	if (sdev->type == TYPE_DISK &&

-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone

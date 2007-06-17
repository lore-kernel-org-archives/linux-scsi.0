From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/5] firewire: fw-sbp2: implement max sectors limit for some
	old bridges
Date: Sun, 17 Jun 2007 23:52:08 +0200 (CEST)
Message-ID: <tkrat.acaff48948adeab0@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
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
Cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This currently only affects one bridge in the hardwired blacklist.
I don't own one of those, hence haven't tested it.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -34,6 +34,7 @@
 #include <linux/device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/blkdev.h>
 #include <linux/timer.h>
 
 #include <scsi/scsi.h>
@@ -1080,7 +1081,8 @@ static int sbp2_scsi_slave_configure(str
 		fw_notify("setting fix_capacity for %s\n", unit->device.bus_id);
 		sdev->fix_capacity = 1;
 	}
-
+	if (sd->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
+		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
 	return 0;
 }
 

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/

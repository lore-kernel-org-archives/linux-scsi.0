From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 26] drivers/scsi/gdth.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:46:10 +0200
Message-ID: <200707311946.10699.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4815 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbXGaRqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 13:46:13 -0400
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, achim_leubner@adaptec.com, boji.t.kannanthanam@intel.com, johannes_dinner@adaptec.com

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/gdth.c | 189401 -> 189342 (-59 bytes)
 drivers/scsi/gdth.o | 331028 -> 330324 (-704 bytes)

 drivers/scsi/gdth.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/gdth.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/gdth.c	2007-07-31 14:08:37.000000000 +0200
@@ -458,10 +458,10 @@ int __gdth_execute(struct scsi_device *s
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;

-    scp = kmalloc(sizeof(*scp), GFP_KERNEL);
+    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
-    memset(scp, 0, sizeof(*scp));
+
     scp->device = sdev;
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
@@ -5273,10 +5273,10 @@ static int gdth_ioctl(struct inode *inod
         hanum = res.ionode;
         ha = gdth_find_ha(hanum);

-        scp  = kmalloc(sizeof(*scp), GFP_KERNEL);
+        scp = kzalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
             return -ENOMEM;
-        memset(scp, 0, sizeof(*scp));
+
         scp->device = ha->sdev;
         scp->cmd_len = 12;
         scp->use_sg = 0;

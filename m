From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 13/16] gdth: Make one abuse of scsi_cmnd less obvious
Date: Sun, 30 Sep 2007 22:13:27 +0200
Message-ID: <47000367.6090402@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:58228 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXI3UNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 16:13:31 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  Rather than having internal commands abuse scsi_done to call
  gdth_scsi_done, have all the places that use to call scsi_done directly
  call gdth_scsi_done, which now checks whether the command was internal,
  and calls scsi_done if not.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 0ae330d..01155f8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -408,10 +408,12 @@ static void gdth_delay(int milliseconds)
 
 static void gdth_scsi_done(struct scsi_cmnd *scp)
 {
-    TRACE2(("gdth_scsi_done()\n"));
+	TRACE2(("gdth_scsi_done()\n"));
 
-    if (scp->request)
-        complete((struct completion *)scp->request);
+	if (scp->done == gdth_scsi_done)
+		complete((struct completion *)scp->request);
+	else
+		scp->scsi_done(scp);
 }
 
 int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
@@ -433,8 +435,8 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->done = gdth_scsi_done; /* some fn. test this */
-    gdth_queuecommand(scp, gdth_scsi_done);
+    scp->done = gdth_scsi_done;
+    gdth_queuecommand(scp, NULL);
     wait_for_completion(&wait);
 
     rval = scp->SCp.Status;
@@ -2122,7 +2124,7 @@ static void gdth_next(gdth_ha_str *ha)
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
                 else
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
             }
         } else if (nscp->done == gdth_scsi_done) {
             if (!(cmd_index=gdth_special_cmd(ha, nscp)))
@@ -2141,7 +2143,7 @@ static void gdth_next(gdth_ha_str *ha)
             if (!nscp->SCp.have_data_in)
                 nscp->SCp.have_data_in++;
             else
-                nscp->scsi_done(nscp);
+                gdth_scsi_done(nscp);
         } else {
             switch (nscp->cmnd[0]) {
               case TEST_UNIT_READY:
@@ -2167,9 +2169,9 @@ static void gdth_next(gdth_ha_str *ha)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else if (gdth_internal_cache_cmd(ha, nscp))
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
                 break;
 
               case ALLOW_MEDIUM_REMOVAL:
@@ -2183,7 +2185,7 @@ static void gdth_next(gdth_ha_str *ha)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else {
                     nscp->cmnd[3] = (ha->hdr[t].devtype&1) ? 1:0;
                     TRACE(("Prevent/allow r. %d rem. drive %d\n",
@@ -2219,7 +2221,7 @@ static void gdth_next(gdth_ha_str *ha)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else if (!(cmd_index=gdth_fill_cache_cmd(ha, nscp, t)))
                     this_cmd = FALSE;
                 break;
@@ -2234,7 +2236,7 @@ static void gdth_next(gdth_ha_str *ha)
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
                 else
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
                 break;
             }
         }
@@ -3230,7 +3232,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (rval == 2) {
             gdth_putq(ha, scp,scp->SCp.this_residual);
         } else if (rval == 1) {
-            scp->scsi_done(scp);
+            gdth_scsi_done(scp);
         }
 
 #ifdef INT_COAL
@@ -3988,14 +3990,15 @@ static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,se
 }
 
 
-static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
+static int gdth_queuecommand(struct scsi_cmnd *scp,
+				void (*done)(struct scsi_cmnd *))
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
     int priority;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
     
-    scp->scsi_done = (void *)done;
+    scp->scsi_done = done;
     scp->SCp.have_data_in = 1;
     scp->SCp.phase = -1;
     scp->SCp.sent_command = -1;
-- 
1.5.3.1



From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 01/16] gdth: Make one abuse of scsi_cmnd less obvious
Date: Tue, 02 Oct 2007 22:40:22 +0200
Message-ID: <4702ACB6.6010904@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17110 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753756AbXJBUkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 16:40:36 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kerne>

From: Matthew Wilcox <willy@linux.intel.com>

  Rather than having internal commands abuse scsi_done to call
  gdth_scsi_done, have all the places that use to call scsi_done directly
  call gdth_scsi_done, which now checks whether the command was internal,
  and calls scsi_done if not.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b20c188..77c607e 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -713,10 +713,12 @@ static void gdth_delay(int milliseconds)
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
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
@@ -738,8 +740,8 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->done = gdth_scsi_done; /* some fn. test this */
-    gdth_queuecommand(scp, gdth_scsi_done);
+    scp->done = gdth_scsi_done;
+    gdth_queuecommand(scp, NULL);
     wait_for_completion(&wait);
 
     rval = scp->SCp.Status;
@@ -2505,7 +2507,7 @@ static void gdth_next(int hanum)
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
                 else
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
             }
         } else if (nscp->done == gdth_scsi_done) {
             if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
@@ -2524,7 +2526,7 @@ static void gdth_next(int hanum)
             if (!nscp->SCp.have_data_in)
                 nscp->SCp.have_data_in++;
             else
-                nscp->scsi_done(nscp);
+                gdth_scsi_done(nscp);
         } else {
             switch (nscp->cmnd[0]) {
               case TEST_UNIT_READY:
@@ -2550,9 +2552,9 @@ static void gdth_next(int hanum)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
-                } else if (gdth_internal_cache_cmd(hanum,nscp))
-                    nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
+                } else if (gdth_internal_cache_cmd(hanum, nscp))
+                    gdth_scsi_done(nscp);
                 break;
 
               case ALLOW_MEDIUM_REMOVAL:
@@ -2566,7 +2568,7 @@ static void gdth_next(int hanum)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else {
                     nscp->cmnd[3] = (ha->hdr[t].devtype&1) ? 1:0;
                     TRACE(("Prevent/allow r. %d rem. drive %d\n",
@@ -2602,8 +2604,8 @@ static void gdth_next(int hanum)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
-                } else if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
+                        gdth_scsi_done(nscp);
+                } else if (!(cmd_index=gdth_fill_cache_cmd(hanum, nscp, t)))
                     this_cmd = FALSE;
                 break;
 
@@ -2617,7 +2619,7 @@ static void gdth_next(int hanum)
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
                 else
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
                 break;
             }
         }
@@ -3630,7 +3632,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (rval == 2) {
             gdth_putq(hanum,scp,scp->SCp.this_residual);
         } else if (rval == 1) {
-            scp->scsi_done(scp);
+            gdth_scsi_done(scp);
         }
 
 #ifdef INT_COAL
@@ -4925,14 +4927,15 @@ static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
 }
 
 
-static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
+static int gdth_queuecommand(struct scsi_cmnd *scp,
+				void (*done)(struct scsi_cmnd *))
 {
     int hanum;
     int priority;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
     
-    scp->scsi_done = (void *)done;
+    scp->scsi_done = done;
     scp->SCp.have_data_in = 1;
     scp->SCp.phase = -1;
     scp->SCp.sent_command = -1;
-- 
1.5.3.1



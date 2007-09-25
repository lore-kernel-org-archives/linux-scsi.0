From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Tue, 25 Sep 2007 05:56:09 -0600
Message-ID: <20070925115608.GR10625@parisc-linux.org>
References: <20070721203410.GA1004@havoc.gtf.org> <1189865576.3339.0.camel@localhost.localdomain> <46F85578.70503@garzik.org> <20070925082027.GA9587@infradead.org> <46F8DA11.6030103@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40964 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbXIYL4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 07:56:11 -0400
Content-Disposition: inline
In-Reply-To: <46F8DA11.6030103@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Tue, Sep 25, 2007 at 11:51:13AM +0200, Boaz Harrosh wrote:
> On top of that I have my own agenda of cleaning the !use_sg code paths and getting
> rid of scsi_cmnd abuse, so there is also that.

This seems like a good time to post my own patch that removes the use of
->scsi_done from gdth.  I have a plan to remove the ->scsi_done() callback
(drivers will simply call the scsi_done() function directly), and fixing
the half-dozen drivers that override it is part of that.

I haven't looked at Christoph's, Jeff's or your patches yet, so this
patch may be entirely worthless.  My goal with it was not to clean up
the driver (though it does a little), but to get gdth out of the way of
cleaning up scsi_cmnd.

commit 06142e2394d83929b8b25feab70caab47ddfb791
Author: Matthew Wilcox <willy@linux.intel.com>
Date:   Sat Sep 22 22:57:06 2007 -0400

    gdth: Make one abuse of scsi_cmnd less obvious
    
    Rather than having internal commands abuse scsi_done to call
    gdth_scsi_done, have all the places that use to call scsi_done directly
    call gdth_scsi_done, which now checks whether the command was internal,
    and calls scsi_done if not.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b20c188..8a6a5f8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -475,7 +475,6 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
 static void gdth_flush(int hanum);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
-static void gdth_scsi_done(struct scsi_cmnd *scp);
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -710,13 +709,14 @@ static void gdth_delay(int milliseconds)
     }
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
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
@@ -738,8 +738,8 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->done = gdth_scsi_done; /* some fn. test this */
-    gdth_queuecommand(scp, gdth_scsi_done);
+    scp->done = gdth_scsi_done;
+    gdth_queuecommand(scp, NULL);
     wait_for_completion(&wait);
 
     rval = scp->SCp.Status;
@@ -748,42 +748,6 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     kfree(scp);
     return rval;
 }
-#else
-static void gdth_scsi_done(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_scsi_done()\n"));
-
-    scp->request.rq_status = RQ_SCSI_DONE;
-    if (scp->request.waiting)
-        complete(scp->request.waiting);
-}
-
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-                   int timeout, u32 *info)
-{
-    Scsi_Cmnd *scp = scsi_allocate_device(sdev, 1, FALSE);
-    unsigned bufflen = gdtcmd ? sizeof(gdth_cmd_str) : 0;
-    DECLARE_COMPLETION_ONSTACK(wait);
-    int rval;
-
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-    scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->request.rq_status = RQ_SCSI_BUSY;
-    scp->request.waiting = &wait;
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    wait_for_completion(&wait);
-
-    rval = scp->SCp.Status;
-    if (info)
-        *info = scp->SCp.Message;
-
-    scsi_release_command(scp);
-    return rval;
-}
-#endif
 
 int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info)
@@ -2505,7 +2469,7 @@ static void gdth_next(int hanum)
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
                 else
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
             }
         } else if (nscp->done == gdth_scsi_done) {
             if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
@@ -2524,7 +2488,7 @@ static void gdth_next(int hanum)
             if (!nscp->SCp.have_data_in)
                 nscp->SCp.have_data_in++;
             else
-                nscp->scsi_done(nscp);
+                gdth_scsi_done(nscp);
         } else {
             switch (nscp->cmnd[0]) {
               case TEST_UNIT_READY:
@@ -2550,9 +2514,9 @@ static void gdth_next(int hanum)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else if (gdth_internal_cache_cmd(hanum,nscp))
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
                 break;
 
               case ALLOW_MEDIUM_REMOVAL:
@@ -2566,7 +2530,7 @@ static void gdth_next(int hanum)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else {
                     nscp->cmnd[3] = (ha->hdr[t].devtype&1) ? 1:0;
                     TRACE(("Prevent/allow r. %d rem. drive %d\n",
@@ -2602,7 +2566,7 @@ static void gdth_next(int hanum)
                     if (!nscp->SCp.have_data_in)
                         nscp->SCp.have_data_in++;
                     else
-                        nscp->scsi_done(nscp);
+                        gdth_scsi_done(nscp);
                 } else if (!(cmd_index=gdth_fill_cache_cmd(hanum,nscp,t)))
                     this_cmd = FALSE;
                 break;
@@ -2617,7 +2581,7 @@ static void gdth_next(int hanum)
                 if (!nscp->SCp.have_data_in)
                     nscp->SCp.have_data_in++;
                 else
-                    nscp->scsi_done(nscp);
+                    gdth_scsi_done(nscp);
                 break;
             }
         }
@@ -3630,7 +3594,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (rval == 2) {
             gdth_putq(hanum,scp,scp->SCp.this_residual);
         } else if (rval == 1) {
-            scp->scsi_done(scp);
+            gdth_scsi_done(scp);
         }
 
 #ifdef INT_COAL
@@ -4925,14 +4889,15 @@ static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
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
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

From: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: Fri, 14 Mar 2003 09:05:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200303140709.h2E79Ju06461@Port.imtp.ilyichevsk.odessa.ua>
References: <20030228133037.GB7473@jiffies.dk> <1047517604.23902.39.camel@irongate.swansea.linux.org.uk> <20030313005046.GB14373@beaverton.ibm.com>
Reply-To: vda@port.imtp.ilyichevsk.odessa.ua
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030313005046.GB14373@beaverton.ibm.com>
To: Mike Anderson <andmike@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dougg@torque.net, Mark Haverkamp <markh@osdl.org>, Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

On 13 March 2003 02:50, Mike Anderson wrote:
> The patch below is something Patrick and I where discussing though I
> believe he indicated that I should print out the value we where
> setting the queue_depth to. It was only compiled and not tested on
> any devices.
>
> -andmike

--- 1.96/drivers/scsi/scsi.c    Fri Feb 21 13:46:58 2003
+++ edited/drivers/scsi/scsi.c  Wed Mar 12 16:05:42 2003
@@ -926,15 +926,28 @@
        /*
         * refuse to set tagged depth to an unworkable size
         */
-       if(tags <= 0)
-               return;
+       if(tags <= 0) {
+                       printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
+                               "%s, tag value to small\n"
+                               "disabled\n", SDpnt->host->host_no,

Please do not split message into several lines.
There are several reasons why you shouldn't do it.

+                               SDpnt->channel, SDpnt->id, SDpnt->lun,
+                               __FUNCTION__); 
+
+               SDpnt->queue_depth = 1;
+       }
        /*
-        * Limit max queue depth on a single lun to 256 for now.  Remember,
-        * we allocate a struct scsi_command for each of these and keep it
-        * around forever.  Too deep of a depth just wastes memory.
+        * Limit max queue depth on a single lun to 256 for now.
+        * Too deep of a depth just wastes memory.
         */
-       if(tags > 256)
-               return;
+       if(tags > 256) {
+                       printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
+                               "%s, tag value to big\n"
+                               "disabled\n", SDpnt->host->host_no,

Same here.

+                               SDpnt->channel, SDpnt->id, SDpnt->lun,
+                               __FUNCTION__); 
+
+               SDpnt->queue_depth = 256;
+       }
 
        spin_lock_irqsave(&device_request_lock, flags);
        SDpnt->queue_depth = tags;
@@ -949,9 +962,10 @@
                        break;
                default:
                        printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
-                               "scsi_adjust_queue_depth, bad queue type, "
+                               "%s, bad queue type, "
                                "disabled\n", SDpnt->host->host_no,
-                               SDpnt->channel, SDpnt->id, SDpnt->lun); 
+                               SDpnt->channel, SDpnt->id, SDpnt->lun,
+                               __FUNCTION__); 
                case 0:
                        SDpnt->ordered_tags = SDpnt->simple_tags = 0;
                        SDpnt->queue_depth = tags;

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 08/08] scsi: fix hot unplug sequence
Date: Thu, 24 Mar 2005 23:02:45 -0600
Message-ID: <1111726965.5612.62.camel@mulgrave>
References: <20050323021335.960F95F8@htj.dyndns.org>
	 <20050323021335.4682C732@htj.dyndns.org>
	 <1111550882.5520.93.camel@mulgrave> <4240F5A9.80205@gmail.com>
	 <20050323071920.GJ24105@suse.de> <1111591213.5441.19.camel@mulgrave>
	 <20050323152550.GB16149@suse.de> <1111711558.5612.52.camel@mulgrave>
	 <20050325031511.GA22114@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:23965 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261289AbVCYFCx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 00:02:53 -0500
In-Reply-To: <20050325031511.GA22114@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, 2005-03-25 at 12:15 +0900, Tejun Heo wrote:
>  I think I found the cause.  Special requests submitted using
> scsi_do_req() never initializes ->end_io().  Normally, SCSI midlayer
> terminates special requests inside the SCSI midlayer without passing
> through the blkdev layer.  However, if a device is going away or taken
> offline, blkdev layer gets to terminate special requests and, as
> ->end_io() is never set-up, nothing happens and the completion gets
> lost.

The analysis is exactly correct, well done!  I think your patch is a bit
overly complex, though.  We can achieve the same effect simply by
executing the completion without changing the rq_status like the patch
below.

Jens,  To go back to the original problem, except when I hit the usb-
storage error handling oops, I can plug and unplug to my hearts content
and everything works.

James

===== drivers/scsi/scsi_lib.c 1.152 vs edited =====
--- 1.152/drivers/scsi/scsi_lib.c	2005-03-18 05:33:09 -06:00
+++ edited/drivers/scsi/scsi_lib.c	2005-03-24 22:59:18 -06:00
@@ -252,6 +252,16 @@
 		complete(req->waiting);
 }
 
+/* This is the end routine we get to if a command was never attached
+ * to the request.  Simply complete the request without changing
+ * rq_status; this will cause a DRIVER_ERROR. */
+static void scsi_wait_req_end_io(struct request *req)
+{
+	BUG_ON(!req->waiting);
+
+	complete(req->waiting);
+}
+
 void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
 		   unsigned bufflen, int timeout, int retries)
 {
@@ -259,6 +269,7 @@
 	
 	sreq->sr_request->waiting = &wait;
 	sreq->sr_request->rq_status = RQ_SCSI_BUSY;
+	sreq->sr_request->end_io = scsi_wait_req_end_io;
 	scsi_do_req(sreq, cmnd, buffer, bufflen, scsi_wait_done,
 			timeout, retries);
 	wait_for_completion(&wait);



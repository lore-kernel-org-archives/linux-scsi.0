From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [BK PATCH] SCSI Bugfixes for 2.6.0-test9
Date: Thu, 20 Nov 2003 09:09:05 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FBBF811.3030207@torque.net>
References: <1069270260.1664.8.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030707030609080207070709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:6163 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264182AbTKSXJ2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 18:09:28 -0500
In-Reply-To: <1069270260.1664.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030707030609080207070709
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> This contains the current slew of bug fixes harvested from the scsi
> mailing lists.  I think we could still do with getting our
> slave_alloc/destroy bug sorted out, and finally getting our mid layer
> refcounting up to the level where were robust against surprise ejection,
> but those could also wait for 2.6.1
> 
> You can pull the changes from:
> 
> bk://linux-scsi.bkbits.net/scsi-bugfixes-2.6
> 
> The short changelogs are:
> 
> Alan Stern:
>   o Off-by-one bug in user page calculations for Direct I/O
> 
> Andrew Morton:
>   o fix scsi_report_lun_scan bug
> 
> Christoph Hellwig:
>   o scsi_device refcounting and list lockdown
> 
> James Bottomley:
>   o Add missing .module initialisation to lasi700 and sim710
>   o lasi700: Fix missed variable name change causing module load error

James,
You might like to add this one that OSDL found
(if they haven't already submitted a fix):

Changelog:
   When detecting a locked sg device (O_EXCL) return
   -EBUSY (rather than 0) from sg_open()

Doug Gilbert



--------------030707030609080207070709
Content-Type: text/plain;
 name="sg290t9ma.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg290t9ma.diff"

--- linux/drivers/scsi/sg.c	2003-10-28 09:18:32.000000000 +1000
+++ linux/drivers/scsi/sg.c260t9ma	2003-11-14 20:15:20.000000000 +1000
@@ -243,7 +243,7 @@
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	int res;
-	int retval = -EBUSY;
+	int retval;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
@@ -270,8 +270,10 @@
 			retval = -EPERM; /* Can't lock it with read only access */
 			goto error_out;
 		}
-		if (sdp->headfp && (flags & O_NONBLOCK))
+		if (sdp->headfp && (flags & O_NONBLOCK)) {
+			retval = -EBUSY;
 			goto error_out;
+		}
 		res = 0;
 		__wait_event_interruptible(sdp->o_excl_wait,
 			((sdp->headfp || sdp->exclude) ? 0 : (sdp->exclude = 1)), res);
@@ -280,8 +282,10 @@
 			goto error_out;
 		}
 	} else if (sdp->exclude) {	/* some other fd has an exclusive lock on dev */
-		if (flags & O_NONBLOCK)
+		if (flags & O_NONBLOCK) {
+			retval = -EBUSY;
 			goto error_out;
+		}
 		res = 0;
 		__wait_event_interruptible(sdp->o_excl_wait, (!sdp->exclude),
 					   res);

--------------030707030609080207070709--


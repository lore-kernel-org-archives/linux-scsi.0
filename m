From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Sym53c8xx_2
Date: Sun, 15 Aug 2004 00:16:36 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
References: <1092366037.28144.202254467@webmail.messagingengine.com>  
 <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
 <1092432298.18813.202307545@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:61371 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265701AbUHNWRT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2004 18:17:19 -0400
In-Reply-To: <1092432298.18813.202307545@webmail.messagingengine.com>
List-Id: linux-scsi@vger.kernel.org
To: Kai OM <epimetreus@fastmail.fm>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org

Hi

On Fri, 13 Aug 2004, Kai OM wrote:

> There was one entry in the 2.6.6 changelog, though, that said something
> about modifying the driver in question; adding generic domain validation
> and such -- and it's during domain validation that the driver stops.

I looked through the diffs between 2.6.5 and 2.6.7 versions of sym53c8xx_2 
- there are not so many of them, so, we'll have to able to find the guilty 
one. In fact, I think, there are only 2 lines of code that can be 
essential. But before you test them, one question: in your original posts 
you quoted dmesg with 2.6.7 and 2.6.7 with replaced sym53c8xx_2 directory. 
However, the output of the working version with the older driver is 
missing 2 lines:

sym0:0:0: Tagged command queue enabled, command queue depth 16
scsi(0:0:0:0): Beginning Domain Validation

which are present in the non-working version. Why are they missing from 
the working version - did you use a different configuration or different 
command-line parameters?

And the patches you could try, to revert the changes I suspect, are:

1)

diff -u a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	19 May 2004 16:07:46
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	14 Aug 2004 21:13:03
@@ -390,7 +390,7 @@
  			 * condition otherwise the device will always return
  			 * BUSY.  Use a big stick.
  			 */
-			sym_reset_scsi_target(np, csio->device->id);
+//			sym_reset_scsi_target(np, csio->device->id);
  			cam_status = DID_ERROR;
  		}
  	} else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */


and 2)

diff -u a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	19 May 2004 16:07:46
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	14 Aug 2004 22:12:32
@@ -931,6 +931,7 @@
  	switch(to_do) {
  	default:
  	case SYM_EH_DO_IGNORE:
+		goto finish;
  		break;
  	case SYM_EH_DO_WAIT:
  		init_MUTEX_LOCKED(&ep->sem);

Try them to stock 2.6.7 and see if any / both of them fix your problem.

Regards
Guennadi
---
Guennadi Liakhovetski


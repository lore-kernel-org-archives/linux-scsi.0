From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: grsec problem in scsi_ioctl
Date: Fri, 07 Jan 2005 15:54:24 -0500
Message-ID: <1105131264.4151.19.camel@mulgrave>
References: <20050107194903.GB27371@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5562 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261589AbVAGUyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 15:54:46 -0500
In-Reply-To: <20050107194903.GB27371@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-01-07 at 19:49 +0000, Matthew Wilcox wrote:
> What a pleasant way to find out about a vulnerability ...
> 
> much snipped, I'm sure you can find the whole thing if you care to.

Not really .. the fix looks simple enough. I wonder what it would take
to train these people how actually to report a bug, sigh ...

James

===== drivers/block/scsi_ioctl.c 1.63 vs edited =====
--- 1.63/drivers/block/scsi_ioctl.c	2004-12-26 12:27:51 -05:00
+++ edited/drivers/block/scsi_ioctl.c	2005-01-07 15:46:36 -05:00
@@ -339,7 +339,8 @@
 			 struct gendisk *bd_disk, Scsi_Ioctl_Command __user *sic)
 {
 	struct request *rq;
-	int err, in_len, out_len, bytes, opcode, cmdlen;
+	int err;
+	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
 
 	/*



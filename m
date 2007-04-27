From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Fri, 27 Apr 2007 17:21:39 -0500
Message-ID: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
References: <20070427214709.DC44BDBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33917 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757487AbXD0WVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 18:21:48 -0400
In-Reply-To: <20070427214709.DC44BDBA2@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2007-04-27 at 16:47 -0500, Bob Tracy wrote:
> I previously reported an ISA DMA issue for the 2.6.12 kernel.  The issue
> persists through at least 2.6.18.  SCSI controller is an Adaptec
> AHA-1542B (ISA).
> 
> The action "mount -t iso9660 /dev/scd0 /mnt/cdrom -r"
> 
> produces
> 
> (cdrom detection messages as various modules autoload, then...)

Knowing what these messages are is would be helpful; it tells me what
point in the initialisation it got to. 

> sgpnt[0:1] page c1ee5af0/0x1ee5af0 length 32
> Kernel panic - not syncing: Buffer at physical address > 16 Mb used for aha1542
> 
> As before, no problems using the sda hard disk (which is the boot drive):
> everything works reliably until I touch the cdrom drive.
> 
> I'll be happy to assist with the debugging, but the system with the
> aha1542 has no development facilities, i.e., I'll have to build test
> kernels on a different system, and turnaround is going to be slow :-(.

I'm interested.

This is clearly a use_sg==1 path that has failed to bounce the buffer
for some reason ... and I was contemplating eliminating the GFP_DMA from
our sr driver because I thought the block bouncing had it covered.

It might also be helpful to apply this patch.  It should give a stack
trace of the problem command and not immediately panic the box.

Thanks,

James

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 1d239f6..4ee7d99 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -75,7 +75,7 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
 	/*
 	 * Not safe to continue.
 	 */
-	panic("Buffer at physical address > 16Mb used for aha1542");
+	WARN_ON(1);
 }
 
 #include<linux/stat.h>
@@ -725,8 +725,12 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 				panic("Foooooooood fight!");
 			};
 			any2scsi(cptr[i].dataptr, SCSI_SG_PA(&sgpnt[i]));
-			if (SCSI_SG_PA(&sgpnt[i]) + sgpnt[i].length - 1 > ISA_DMA_THRESHOLD)
+			if (SCSI_SG_PA(&sgpnt[i]) + sgpnt[i].length - 1 > ISA_DMA_THRESHOLD) {
 				BAD_SG_DMA(SCpnt, sgpnt, SCpnt->use_sg, i);
+				SCpnt->result = DID_ERROR << 16;
+				done(SCpnt);
+				return 0;
+			}
 			any2scsi(cptr[i].datalen, sgpnt[i].length);
 		};
 		any2scsi(ccb[mbo].datalen, SCpnt->use_sg * sizeof(struct chain));





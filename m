From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] mac_scsi boot crash fix
Date: Wed, 9 Mar 2005 23:00:09 +1100 (EST)
Message-ID: <Pine.LNX.4.61.0503092224160.4800@loopy.telegraphics.com.au>
References: <20050213063225.GA17415@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au>
 <20050213075506.GA18622@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au>
 <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au>
 <20050307063719.GA12478@infradead.org> <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au>
 <20050307175322.GA12907@pants.nu> <20050307234233.GA6240@excalibur.research.wombat.ie>
 <Pine.LNX.4.61.0503090156380.1135@loopy.telegraphics.com.au>
 <20050308173939.GA17983@pants.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from loopy.telegraphics.com.au ([202.45.126.152]:22488 "EHLO
	loopy.telegraphics.com.au") by vger.kernel.org with ESMTP
	id S262318AbVCIMAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 07:00:13 -0500
In-Reply-To: <20050308173939.GA17983@pants.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Cc: Kenn Humborg <kenn@linux.ie>, Geert Uytterhoeven <geert@linux-m68k.org>, linux scsi <linux-scsi@vger.kernel.org>, linux m68k <linux-m68k@vger.kernel.org>


I found the bus error, the trivial fix is below.

I don't know if this patch will work for others quite yet, since my kernel 
has had some work done to slow interrupt handling. I intend to post that 
patch soon.

On Tue, 8 Mar 2005, Brad Boyer wrote:

> I notice it got through all the device identify stuff. It dies as soon
> as it actually tries to tranfer a real block of data (the partition map)
> and do something useful with it. Could you see if disabling PDMA helps?

I tested both: my Daystar Mac II now works great with or without PDMA, so 
hopefully the IIfx will work too.

Kenn, my macs like your patch :-) Did it make it upstream?

-f


Signed-off-by: Finn Thain <fthain@telegraphics.com.au>


--- a/drivers/scsi/mac_scsi.c	2005-03-09 22:21:01.369397570 +1100
+++ b/drivers/scsi/mac_scsi.c	2005-03-09 22:02:12.594082086 +1100
@@ -302,7 +302,7 @@ int macscsi_detect(Scsi_Host_Template * 
 
     if (instance->irq != SCSI_IRQ_NONE)
 	if (request_irq(instance->irq, NCR5380_intr, IRQ_FLG_SLOW, 
-		"ncr5380", NCR5380_intr)) {
+		"ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
 		   instance->host_no, instance->irq);
 	    instance->irq = SCSI_IRQ_NONE;

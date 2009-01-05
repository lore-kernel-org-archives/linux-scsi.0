From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] aha152x_cs: Fix regression that keeps driver from using
 shared interrupts
Date: Mon, 5 Jan 2009 09:03:47 -0800
Message-ID: <20090105090347.1d292c6a.randy.dunlap@oracle.com>
References: <4932D7B5.4070500@lwfinger.net>
	<13477999.16371231031572178.komurojun-mbn@nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:31084 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZAEREQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 12:04:16 -0500
In-Reply-To: <13477999.16371231031572178.komurojun-mbn@nifty.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Komuro <komurojun-mbn@nifty.com>, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@hansenpartnership.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-pcmcia@lists.infradead.org, Dominik Brodowski <linux@dominikbrodowski.net>

On Sun, 4 Jan 2009 10:12:52 +0900 (JST) Komuro wrote:

> 
> No response from Dominik.
> 
> It should be sent to linux-scsi?

Yes, I'll cc linux-scsi now...


> 
> ----- Original Message -----
> >Date: Sun, 30 Nov 2008 12:13:09 -0600
> >From: Larry Finger <Larry.Finger@lwfinger.net>
> >To: Dominik Brodowski <linux@dominikbrodowski.net>
> >Subject: [PATCH] aha152x_cs: Fix regression that keeps driver from using shar
> ed
> >	interrupts
> >Cc: linux-pcmcia@lists.infradead.org
> >
> >
> >At some point since 2.6.22, the aha152x_cs driver stopped working and started
> >erring on load with the following messages:
> >
> >kernel: pcmcia: request for exclusive IRQ could not be fulfilled.
> >kernel: pcmcia: the driver needs updating to supported shared IRQ lines.
> >
> >With the following change, the driver works with shared IRQs.
> >
> >Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >Cc: Stable <stable@kernel.org>		[2.6.27], [2.6.26]
> >---
> >
> >
> >Index: wireless-testing/drivers/scsi/pcmcia/aha152x_stub.c
> >===================================================================
> >--- wireless-testing.orig/drivers/scsi/pcmcia/aha152x_stub.c
> >+++ wireless-testing/drivers/scsi/pcmcia/aha152x_stub.c
> >@@ -114,7 +114,7 @@ static int aha152x_probe(struct pcmcia_d
> >     link->io.NumPorts1 = 0x20;
> >     link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
> >     link->io.IOAddrLines = 10;
> >-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
> >+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
> >     link->irq.IRQInfo1 = IRQ_LEVEL_ID;
> >     link->conf.Attributes = CONF_ENABLE_IRQ;
> >     link->conf.IntType = INT_MEMORY_AND_IO;
> >
> >_______________________________________________
> >Linux PCMCIA reimplementation list
> >http://lists.infradead.org/mailman/listinfo/linux-pcmcia
> 
> 
> 


---
~Randy

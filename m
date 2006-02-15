From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Wed, 15 Feb 2006 23:33:09 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602152322190.5682@poirot.grange>
References: <20060211011457.GA1839@igloo.df.lth.se>
 <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <Pine.LNX.4.60.0602130043540.19775@poirot.grange>
 <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
 <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
 <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange>
 <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:16331 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751344AbWBOWcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2006 17:32:53 -0500
In-Reply-To: <20060215214349.GA7947@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

Thanks for the dump.

On Wed, 15 Feb 2006, Fredrik Roubert wrote:

> This is the output from dmesg, from boot until second failed scan:

...

> [  344.852017] dc395x: reselect: w/o disconnected cmds <02-0>
> [  344.852038] dc395x: disconnect: Unexpected reselection <02-0>
> [  464.630090] dc395x: eh_abort: (pid#2002) target=<02-0> cmd=ffff8100743c04c0
> [  464.630096] dc395x: eh_abort: Command in progress<6>dc395x: eh_bus_reset: (pid#2002) target=<02-0> cmd=ffff8100743c04c0
> [  464.630623] dc395x: doing_srb_done: pids G:2002(02-0)
> [  528.066303] dc395x: reselect: w/o disconnected cmds <02-0>
> [  528.066324] dc395x: disconnect: Unexpected reselection <02-0>
> [  647.842343] dc395x: eh_abort: (pid#2130) target=<02-0> cmd=ffff81007cc1b5c0
> [  647.842350] dc395x: eh_abort: Command in progress<6>dc395x: eh_abort: (pid#2131) target=<02-0> cmd=ffff81007cc1b780
> [  647.842356] dc395x: eh_abort: Command was waiting
> [  657.823181] dc395x: eh_abort: (pid#2131) target=<02-0> cmd=ffff81007cc1b780
> [  657.823188] dc395x: eh_abort: Command was waiting
> [  657.823196] dc395x: eh_bus_reset: (pid#2130) target=<02-0> cmd=ffff81007cc1b5c0
> [  657.823717] dc395x: doing_srb_done: pids G:2130(02-0)

Ok, I will assume that this dump includes the KERN_DEBUG messages too now. 
Still, could you, please, just verify that you don't have anything else 
from dc395x in your /var/log/kern.log (if you have one)? If there's 
nothing new there you don't have to send it.

This means, PIO is not entered now any more, although the same "reselect 
without disconnect" events happen. The only reason for this I can think 
about is my addition of dma_mask to drivers/scsi/dc395x.c:

@@ -4834,6 +4904,9 @@
 	irq = dev->irq;
 	dprintkdbg(DBG_0, "IO_PORT=0x%04lx, IRQ=0x%x\n", io_port_base, dev->irq);
 
+	if ((ret = pci_set_dma_mask(dev, DMA_32BIT_MASK)))
+		goto fail;
+
 	/* allocate scsi host information (includes out adapter) */
 	scsi_host = scsi_host_alloc(&dc395x_driver_template,
 				    sizeof(struct AdapterCtlBlk));

Could you, please, remove / comment out these 2 lines and try again? If 
then PIO comes back, I would first try to verify / debug / fix it, and 
then, as it sems not to be the main problem, we'll study the 2nd problem.

Thanks
Guennadi
---
Guennadi Liakhovetski

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: Report
Date: Sun, 13 Aug 2006 21:47:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0608132129120.3508@poirot.grange>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
 <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
 <44D0BC2F.3030700@annessi.at> <Pine.LNX.4.60.0608022348570.12263@poirot.grange>
 <44D13418.2000005@annessi.at> <Pine.LNX.4.60.0608092315060.3728@poirot.grange>
 <44DF70D4.7030504@annessi.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:24451 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751388AbWHMTr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 15:47:28 -0400
In-Reply-To: <44DF70D4.7030504@annessi.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Annessi <robert@annessi.at>
Cc: linux-scsi@vger.kernel.org

On Sun, 13 Aug 2006, Robert Annessi wrote:

> On 08/12/06 20:06, Guennadi Liakhovetski wrote:
> > Great, maybe you still could test the patch below (applied on the top of 
> > all my patches until now)?
> 
> Sure.
> 
> The warning still occurs (I used 2.6.18-rc4):
> 
> dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> PCI: setting IRQ 11 as level-triggered
> PCI: Found IRQ 11 for device 0000:00:02.0
> dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x37
> dc395x:                AdaptMode=0x4e, Tags=0(01), DelayReset=1s
> dc395x: (Wide) Connectors: int68  Termination: Auto Low High
> dc395x: Performing initial SCSI bus reset
> scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
>   Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
> dc395x: inconsistent counters: FIFOCNT 64, left 16777215, wide

Emn, sorry, I have to ask - are you sure this is the correct output 
(applied the patch, recompiled and reloaded the driver)? The output looks 
EXACTLY the same as last time, and this is pretty strange. Well, there is 
still one semi-logical explanation I can come up with:

at first FIFOCNT = 1 and SCSICNT = 0xfffffe, therefore d_left_counter = 
0xfffffe + (1 << 1) = 0x1000000. Then after one loop iteration 
d_left_counter = 0xffffff, and now FIFOCNT = 0x40. So we break out of the 
loop with the above funny value of d_left_counter. If this is the case, 
well, I don't know what this value of SCSICNT means and what to do with 
it (in the absence of a datasheet).

To verify this could you, please, replace the printk at line 2335 with 
this one:

					printk(KERN_WARNING "dc395x: inconsistent counters: "
					       "FIFOCNT %u, SCSICNT %u, left %u, %s\n", fc, sc, d_left_counter,
					       srb->dcb->sync_period & WIDE_SYNC ?
					       "wide" : "narrow");

Thanks
Guennadi
---
Guennadi Liakhovetski

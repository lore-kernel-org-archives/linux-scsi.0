From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: can't write to tape
Date: Tue, 11 Jan 2005 23:16:33 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0501112252560.11812@poirot.grange>
References: <200501060518.25782.andrex@alumni.utexas.net>
 <200501070552.57607.andrex@alumni.utexas.net> <Pine.LNX.4.60.0501072057500.6238@poirot.grange>
 <200501111019.06281.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:41936 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262876AbVAKWn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 17:43:58 -0500
In-Reply-To: <200501111019.06281.andrex@alumni.utexas.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

On Tue, 11 Jan 2005, Andrew Schulman wrote:

> > > > > Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt
> > > > > failed
> >
> > Could you try disabling highmem either try a kernel without highmem
> > support, or boot with mem=900M, or remove a part of your RAM (if you
> > don't have to saw your RAMs for that:-)), maybe, booting with highmem=0,
> > or with nohighio.
> 
> Okay, I finally got to this.  Rebooted with mem=900M.  Unfortunately tar fails 
> as before:
> 
> tar: /dev/st0: Wrote only 0 of 10240 bytes
> tar: Error is not recoverable: exiting now

I didn't expect disabling highmem to fix _this_ error. But do you still 
see the "dc395x: sg_update_list: sg_to_virt failed" message with 900M? 
Perhaps, the most interesting test would be with my patch...

> I had rebuilt dc395x with 
> 
> #define DEBUG_MASK (DBG_0|DBG_1|DBG_SG|DBG_FIFO|DBG_PIO) 
> 
> uncommented in dc395x.c.  Here's what I got:
> 
> # tail -40 /var/log/kern.log
> Jan 11 06:29:18 helium kernel: dc395x: srb_done: (pid#4596449) <02-0>
> Jan 11 06:29:18 helium kernel: dc395x: srb_done: srb=f6aa2eec sg=0(0/1) 
> buf=e7c64000 addr=e7c64000
> Jan 11 06:29:18 helium kernel: dc395x: srb_done: AUTO_REQSENSE1
> Jan 11 06:29:18 helium kernel: dc395x: pci_unmap_srb_sense: buffer=12a69452
> Jan 11 06:29:18 helium kernel: dc395x: ReqSense: MEDIUM_ERROR cmnd=0x10 <02-0> 
> stat=0 scan=1 sense=0x03 ASC=0x0c ASCQ=0x00 (0x00000000 0x00000000)

...well, could you just keep the log for now, maybe we'll have a look at 
it later, I'd just first try to fix the highmem problem, before trying to 
figure out what's going on with your tape drive. BTW, when it worked, you 
already had 1G RAM in the PC, right?

> I have your other suggestions and will get to them as soon as I have time.

Thanks
Guennadi

P.S. Please, don't trim the CC list.
---
Guennadi Liakhovetski


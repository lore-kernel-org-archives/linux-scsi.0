From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 66/77] ncr5380: Fix soft lockups
Date: Wed, 23 Dec 2015 00:47:36 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512222347310.23505@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au> <20151222011755.965510468@telegraphics.com.au> <20151222113903.06422dbe@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222113903.06422dbe@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 22 Dec 2015, One Thousand Gnomes wrote:

> On Tue, 22 Dec 2015 12:18:44 +1100 Finn Thain 
> <fthain@telegraphics.com.au> wrote:
> 
> > Because of the rudimentary design of the chip, it is necessary to poll 
> > the SCSI bus signals during PIO and this tends to hog the CPU. The 
> > driver will accept new commands while others execute, and this causes 
> > a soft lockup because the workqueue item will not terminate until the 
> > issue queue is emptied.
> > 
> > When exercising dmx3191d using sequential IO from dd, the driver is 
> > sent 512 KiB WRITE commands and 128 KiB READs. For a PIO transfer, the 
> > rate is is only about 300 KiB/s, so these are long-running commands. 
> > And although PDMA may run at several MiB/s, interrupts are disabled 
> > for the duration of the transfer.
> > 
> > Fix the unresponsiveness and soft lockup issues by calling 
> > cond_resched() after each command is completed and by limiting 
> > max_sectors for drivers that don't implement real DMA.
> 
> Is there a reason for not doing some limiting in the DMA case too. A 
> 512K write command even with DMA on a low end 68K box introduces a 
> second of latency before another I/O can be scheduled ?

The DMA case is the atari_scsi case. I'd like to think that atari_scsi 
would have only the latency issues that might be expected from any SCSI-2 
host adapter driver.

Unlike PDMA, interrupts are not disabled for these DMA transfers. Note 
that this patch isn't really relevant to DMA, because the main loop 
iterates only when done == 0, that is, !hostdata->dmalen.

-- 

> 
> Alan

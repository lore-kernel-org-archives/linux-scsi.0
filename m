From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Sat, 24 Jun 2017 12:50:20 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706241210140.2213@nippy.intranet>
References: <cover.1497528687.git.fthain@telegraphics.com.au> <alpine.LNX.2.00.1706231101230.2417@nippy.intranet> <alpine.LNX.2.00.1706232058220.10492@nippy.intranet> <201706232214.00362.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201706232214.00362.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 23 Jun 2017, Ondrej Zary wrote:

> On Friday 23 June 2017 13:01:53 Finn Thain wrote:
> > On Fri, 23 Jun 2017, I wrote:
> > > Does this patch help? It should be applied on top of this series of 4.
> >
> > Sorry, I sent the wrong diff. Please try this patch instead.
> 
> Thanks, much better now: both HDD and CD-ROM seem to work on DTC and non-DTC 
> chips. I get many of these messages with CD-ROM:
> [  912.397076] generic_NCR5380_pread: No end dma signal (4096/4096)
> [  913.141225] generic_NCR5380_pread: No end dma signal (4096/4096)
> 
> Maybe just remove this error message as in my original patch?
> 

The "data loop" algorithm in the datasheet syas that if End of DMA doesn't 
become asserted after a transfer, this is an error condition.

Your log (above) shows 4096/4096 bytes so I think that End of DMA is 
tested too soon: the datasheet says that End of DMA takes 100 ns to become 
asserted even after all of the relevant signals reach their final state.

I'll re-do the series to account for this.

Thanks for testing.

-- 

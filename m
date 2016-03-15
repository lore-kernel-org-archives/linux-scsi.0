From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 09/22] ncr5380: Adopt uniform DMA setup convention
Date: Tue, 15 Mar 2016 14:19:58 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603151313510.9662@nippy.intranet>
References: <20160314042700.596192247@telegraphics.com.au> <20160314042702.976019738@telegraphics.com.au> <56E669F6.8070407@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56E669F6.8070407@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org


On Mon, 14 Mar 2016, Hannes Reinecke wrote:

> > @@ -1555,8 +1555,7 @@ static int NCR5380_transfer_dma(struct S
> >  	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> >  	*data = d + c;
> >  	*count = 0;
> > -	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
> > -	return foo;
> > +	return result;
> >  }
> >  
> >  /*
> 
> Don't you miss a phase update here?

I guess I missed explaining the change in the commit log.

The *phase assignment is redundant because after NCR5380_transfer_dma() 
returns control to NCR5380_information_transfer(), the latter routine then 
also returns, and so *phase is dead.

-- 

> 
> Cheers,
> 
> Hannes
> 

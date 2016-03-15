From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 14/22] ncr5380: Add MAX_LUN limit
Date: Tue, 15 Mar 2016 14:20:55 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603151341080.9662@nippy.intranet>
References: <20160314042700.596192247@telegraphics.com.au> <20160314042704.285983735@telegraphics.com.au> <20160314075112.GA19372@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314075112.GA19372@infradead.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org


On Mon, 14 Mar 2016, Christoph Hellwig wrote:

> On Mon, Mar 14, 2016 at 03:27:14PM +1100, Finn Thain wrote:
> > The driver has a limit of eight LUs because of the byte-sized bitfield
> > that is used for busy flags. Reject commands with LUN > 7.
> 
> Please just set the max_lun parameter in the host template, which will 
> take care of this.

The reason I didn't do that initially was that I could not convince myself 
that all command submission paths would enforce the shost->max_lun limit. 
But I'll take your word for it.

I don't think the host template is the right place for this (there are 
about ten of these that would need to be changed anyway) because 
scsi_host_alloc() assigns shost->max_lun = 8. So I'll add the 
instance->max_lun = 7 assignment to NCR5380_init().

-- 

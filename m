From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Tue, 27 Jun 2017 22:54:14 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706272253470.25239@nippy.intranet>
References: <cover.1498461406.git.fthain@telegraphics.com.au> <201706262127.03911.linux@rainbow-software.org> <201706270828.40336.linux@rainbow-software.org> <416a16e1-bbf0-87e0-3960-27a9a867e781@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <416a16e1-bbf0-87e0-3960-27a9a867e781@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 27 Jun 2017, Michael Schmitz wrote:

> Ondrej,
> 
> could this be a partial write (target did not transfer the last byte)?
> 

We do wait for TCR_LAST_BYTE_SENT, but only when there is no residual.

Perhaps we should wait for TCR_LAST_BYTE_SENT whenever the 53c400 asserts 
/EOP. That is, whenever BASR_END_DMA_TRANSFER is set.

-- 

> One would suppose the chip posts a phase mismatch in that case ...
> 
> Cheers,
> 
> 	Michael
> 

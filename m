From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: fix reporting of scsi status again.
Date: Fri, 18 Dec 2009 09:15:39 -0600
Message-ID: <20091218151539.GI8515@beardog.cce.hp.com>
References: <20091217142253.10824.4149.stgit@beardog.cce.hp.com> <20091218114137.GP4489@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754244AbZLRPNr@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091218114137.GP4489@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 18, 2009 at 12:41:37PM +0100, Jens Axboe wrote:
> On Thu, Dec 17 2009, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > cciss: fix reporting of scsi status again.  This reverts an earlier
> > attempt to fix the status byte reporting.  The status byte does
> > not need to be shifted << 1.  Code like "scp-result |= CHECK_CONDITION << 1"
> > in other drivers works because CHECK_CONDITION is 0x01, not 0x02 --
> > CHECK_CONDITION is pre-shifted to the right 1 bit for some reason.
> 
> What's this against? Current -git (2.6.33-rc1) already looks correct.

Oh, hmm.  Well, I guess that's good.

I had sent up a patch previously which "fixed" this (botched it).
Maybe my botched patch was recognized as crap and not picked up.

-- steve

> 
> > 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> >  drivers/block/cciss_scsi.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> > index 75a9ca9..0634ec7 100644
> > --- a/drivers/block/cciss_scsi.c
> > +++ b/drivers/block/cciss_scsi.c
> > @@ -728,7 +728,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
> >  
> >  	cmd->result = (DID_OK << 16); 		/* host byte */
> >  	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
> > -	cmd->result |= (ei->ScsiStatus << 1);
> > +	cmd->result |= ei->ScsiStatus;
> >  	/* printk("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
> >  
> >  	/* copy the sense data whether we need to or not. */
> > 
> 
> -- 
> Jens Axboe

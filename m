From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Q: aborting commands
Date: Tue, 15 Oct 2002 17:20:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016002007.GK1049@beaverton.ibm.com>
References: <3DAC7F2F.AA9348F7@splentec.com> <20021015222511.GG1049@beaverton.ibm.com> <3DACACAC.9AA42D85@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DACACAC.9AA42D85@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov [luben@splentec.com] wrote:
> Mike Anderson wrote:
> > 
> > Luben Tuikov [luben@splentec.com] wrote:
> > > I've been meaning to ask this for some time now:
> > > What is the consensus on the meaning of an aborted command?
> > >
> > > Most notably in the SCSI LLP standards, a successfully aborted command
> > > will NOT return status as non-aborted commands would (normally) do.
> > >
> > > 1. Should successfully aborted commands call scsi_done()?
> > >    (of course with result=DID_ABORT)
> >
> > The new eh on calling eh_abort_handler on a cmd believes that it is the
> > owner of the command again.
> 
> Yes, we know. That's why the ability to sleep on eh, else
> there's no way out...

Ok so is the question should "all" io complete through scsi_done? 

When I looked at faster recovery of a timed out commands I was trying to
determine if it would be simpler for the abort io to call scsi_done. I
thought it would be because ownership would be cleaner.

It would also be good to start the abort ASAP on a timeout but the
context is wrong if the LLDD needs to sleep.

-andmike
--
Michael Anderson
andmike@us.ibm.com


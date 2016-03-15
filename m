From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 20/22] atari_scsi: Set a reasonable default for
 cmd_per_lun
Date: Tue, 15 Mar 2016 07:34:01 -0700
Message-ID: <1458052441.2375.18.camel@HansenPartnership.com>
References: <20160314042700.596192247@telegraphics.com.au>
	 <20160314042705.846189331@telegraphics.com.au> <56E66CF5.2070200@suse.de>
	 <alpine.LNX.2.00.1603151403150.20294@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43452 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbcCOOeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 10:34:05 -0400
In-Reply-To: <alpine.LNX.2.00.1603151403150.20294@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On Tue, 2016-03-15 at 14:27 +1100, Finn Thain wrote:
> On Mon, 14 Mar 2016, Hannes Reinecke wrote:
> 
> > On 03/14/2016 05:27 AM, Finn Thain wrote:
> > > This setting does not need to be conditional on Atari ST or TT.
> > > 
> > > Without TCQ support, cmd_per_lun == 2 is probably reasonable...
> > > 
> > > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > > 
> > > ---
> > >  drivers/scsi/atari_scsi.c |    3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > Index: linux/drivers/scsi/atari_scsi.c
> > >
> ===================================================================
> > > --- linux.orig/drivers/scsi/atari_scsi.c    2016-03-14
> 15:26:45.000000000 +1100
> > > +++ linux/drivers/scsi/atari_scsi.c 2016-03-14 15:26:55.000000000
> +1100
> > > @@ -750,6 +750,7 @@ static struct scsi_host_template atari_s
> > >     .eh_abort_handler       = atari_scsi_abort,
> > >     .eh_bus_reset_handler   = atari_scsi_bus_reset,
> > >     .this_id                = 7,
> > > +   .cmd_per_lun            = 2,
> > >     .use_clustering         = DISABLE_CLUSTERING,
> > >     .cmd_size               = NCR5380_CMD_SIZE,
> > >  };
> > _2_ ? Are you being overly cheeky here?
> > I sincerely doubt the driver is capable of submitting two
> > simultaneous commands ...
> 
> Right. The LLD has LU busy flags to prevent a LU from being issued 
> more than one command.
> 
> > Care to explain?
> 
> It seemed harmless and it is consistent with the all of the other 
> 5380 drivers.
> 
> I don't know why it was done that way. Perhaps it was done to create 
> a pipeline. That is, to keep a small number of commands in the LLD
> issue queue so that the NCR5380_main() work item does not have to 
> terminate and then get requeued needlessly.

You youngsters nowadays have no grasp of history.

It was done this way so that a fully prepared command was waiting on
the queue rather than having to prepare it in what was then
elv_next_request().  The theory was it was a sort of NAPI because as
soon as the driver called the done() function, block would send us the
next request and we could poke it into the card with the minimum CPU
expenditure (it was all done at softirq level).

Of course, block doesn't function remotely like this today, but
historically that's why most old SCSI drivers set this parameter to one
more than the number of commands they can take.

James


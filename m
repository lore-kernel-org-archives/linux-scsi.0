From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 20/22] atari_scsi: Set a reasonable default for
 cmd_per_lun
Date: Tue, 15 Mar 2016 19:27:49 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603151809090.28691@nippy.intranet>
References: <20160314042700.596192247@telegraphics.com.au> <20160314042705.846189331@telegraphics.com.au> <56E66CF5.2070200@suse.de> <alpine.LNX.2.00.1603151403150.20294@nippy.intranet> <56E7B14D.4070704@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <56E7B14D.4070704@suse.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org


On Tue, 15 Mar 2016, Hannes Reinecke wrote:

> On 03/15/2016 04:27 AM, Finn Thain wrote:
> > 
> > On Mon, 14 Mar 2016, Hannes Reinecke wrote:
> > 
> >> On 03/14/2016 05:27 AM, Finn Thain wrote:
> >>> This setting does not need to be conditional on Atari ST or TT.
> >>>
> >>> Without TCQ support, cmd_per_lun == 2 is probably reasonable...
> >>>
> >>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> >>>
> >>> ---
> >>>  drivers/scsi/atari_scsi.c |    3 +--
> >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> Index: linux/drivers/scsi/atari_scsi.c
> >>> ===================================================================
> >>> --- linux.orig/drivers/scsi/atari_scsi.c	2016-03-14 15:26:45.000000000 +1100
> >>> +++ linux/drivers/scsi/atari_scsi.c	2016-03-14 15:26:55.000000000 +1100
> >>> @@ -750,6 +750,7 @@ static struct scsi_host_template atari_s
> >>>  	.eh_abort_handler	= atari_scsi_abort,
> >>>  	.eh_bus_reset_handler	= atari_scsi_bus_reset,
> >>>  	.this_id		= 7,
> >>> +	.cmd_per_lun		= 2,
> >>>  	.use_clustering		= DISABLE_CLUSTERING,
> >>>  	.cmd_size		= NCR5380_CMD_SIZE,
> >>>  };
> >> _2_ ? Are you being overly cheeky here?
> >> I sincerely doubt the driver is capable of submitting two 
> >> simultaneous commands ...
> > 
> > Right. The LLD has LU busy flags to prevent a LU from being issued 
> > more than one command.
> > 
> >> Care to explain?
> > 
> > It seemed harmless and it is consistent with the all of the other 5380 
> > drivers.
> > 
> > I don't know why it was done that way. Perhaps it was done to create a 
> > pipeline. That is, to keep a small number of commands in the LLD issue 
> > queue so that the NCR5380_main() work item does not have to terminate 
> > and then get requeued needlessly.
> > 
> Like I suspected.
> While I'm aware of the reasoning, I sincerely doubt whether it makes any 
> difference in real life.
> After all, a 'BUSY' return value still relies on someone kicking the 
> queue so that the next command can be submitted.

Well, it is not queuecommand returning SCSI_MLQUEUE_HOST_BUSY. I assume it 
is scsi_request_fn() bailing out when !scsi_dev_queue_ready().

> So it's not much different from using a queuedepth of '1' and use the 
> 'official' way.
> 
> Have you done any benchmarking here?

I have now.

> Would be very interesting to check if it makes a difference in real
> life ...

It seems that the work item startup and shutdown overhead does make a 
difference on machines where cycles are scarce.

Using mac_scsi on a 25 MHz 68030 I made some test runs of
# dd if=/dev/sda of=/dev/null count=4096
and the difference is measurable (effect size is 9+ standard deviations).

cmd_per_lun = 2 is about 3.0% faster than cmd_per_lun = 1.
cmd_per_lun = 4 is about 3.7% faster than cmd_per_lun = 1.

Increasing cmd_per_lun to 16 (which equals can_queue) doesn't improve the 
timing.

I think the 'official' way (the default cmd_per_lun) would not hurt if the 
CPU was a bit faster.

Now that you've got me to test it I think 4 is probably the best for 
mac_scsi and atari_scsi. When I send v2 I will change patch 20 and 22 
accordingly.

-- 

> 
> Cheers,
> 
> Hannes
> 

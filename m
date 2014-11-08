From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 22/36] atari_scsi: Fix atari_scsi deadlocks on
 Falcon
Date: Sat, 8 Nov 2014 11:37:48 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411081112580.27924@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052612.445434791@telegraphics.com.au> <545D0A95.3000105@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <545D0A95.3000105@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org


On Sat, 8 Nov 2014, Michael Schmitz wrote:

> > Index: linux/drivers/scsi/atari_NCR5380.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:36.000000000
> > +1100
> > +++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:45.000000000
> > +1100
> > @@ -879,10 +879,10 @@ static void NCR5380_exit(struct Scsi_Hos
> >    *
> >    */
> >   -static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd,
> > -                                     void (*done)(struct scsi_cmnd *))
> > +static int NCR5380_queue_command(struct Scsi_Host *instance,
> > +                                 struct scsi_cmnd *cmd)
> >   {
> > -	SETUP_HOSTDATA(cmd->device->host);
> > +	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> >    struct scsi_cmnd *tmp;
> >    unsigned long flags;
> 
> Nitpick - why did this change set go into this particular patch? Because you
> are converting from NCR5380_queue_command_lck to NCR5380_queue_command?

That's right.

The SETUP_HOSTDATA macro does not appear in NCR5380.c, it is peculiar to 
atari_NCR5380.c. Like so much pre-processor abuse in these drivers, this 
example is undesirable as it harms readability, whereas the shost_priv() 
convention is common and readily understood.

So the uniform adoption of,
	struct NCR5380_hostdata *hostdata = shost_priv(instance);
is the purpose of a different patch (unsent). I have more unsent patches 
to fix up other weird macros in atari_NCR5380.c like HOSTDATA, H_NO, etc.

It's instructive to compare this change with the use of the 
NCR5380_local_declare() macro in NCR5380.c, which was long ago dropped 
from atari_NCR5380.c (and quite rightly so).


> 
> >   @@ -893,7 +893,7 @@ static int NCR5380_queue_command_lck(str
> >     printk(KERN_NOTICE "scsi%d: WRITE attempted with NO_WRITE debugging flag
> >     set\n",
> >            H_NO(cmd));
> >   		cmd->result = (DID_ERROR << 16);
> > -		done(cmd);
> > +		cmd->scsi_done(cmd);
> >    	return 0;
> >   	}
> >   #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
> > @@ -904,8 +904,6 @@ static int NCR5380_queue_command_lck(str
> >     */
> >   
> >   	SET_NEXT(cmd, NULL);
> > -	cmd->scsi_done = done;
> > -
> >    cmd->result = 0;
> >   
> >    /*
> 
> Ditto for these two.

Again, it follows from the differences in the formal parameters between 
NCR5380_queue_command_lck() and NCR5380_queue_command().

> 
> > @@ -915,7 +913,6 @@ static int NCR5380_queue_command_lck(str
> >     * sense data is only guaranteed to be valid while the condition exists.
> >     */
> >   -	local_irq_save(flags);
> >    /* ++guenther: now that the issue queue is being set up, we can lock
> >    ST-DMA.
> >     * Otherwise a running NCR5380_main may steal the lock.
> >     * Lock before actually inserting due to fairness reasons explained in
> > @@ -928,11 +925,13 @@ static int NCR5380_queue_command_lck(str
> >     * because also a timer int can trigger an abort or reset, which would
> >     * alter queues and touch the lock.
> >     */
> > -	if (!IS_A_TT()) {
> > -		/* perhaps stop command timer here */
> > -		falcon_get_lock();
> > -		/* perhaps restart command timer here */
> > -	}
> > +	/* perhaps stop command timer here */
> > +	if (!falcon_get_lock())
> > +		return SCSI_MLQUEUE_HOST_BUSY;
> > +	/* perhaps restart command timer here */
> > +
> 
> The comments about stopping and restarting the command timer can be 
> removed. In 2.4 kernels, the driver would tweak the timers and wait on 
> the lock unconditionally, Can't ne done anymore, for so many reasons.

Well, you sent an acked-by for this patch, so I'm a bit confused. Do you 
want me to re-spin it?

-- 

From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 18/77] ncr5380: Eliminate USLEEP_WAITLONG delay
Date: Tue, 22 Dec 2015 23:38:11 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512222201220.19799@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au> <20151222011742.905471269@telegraphics.com.au> <5678F61E.4050905@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5678F61E.4050905@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


On Tue, 22 Dec 2015, Hannes Reinecke wrote:

> On 12/22/2015 02:17 AM, Finn Thain wrote:
> > Linux 2.1.105 introduced the USLEEP_WAITLONG delay, apparently "needed for
> > Mustek scanners". It is intended to stall the issue queue for 5 seconds.
> > There are a number of problems with this.
> >
> > 1. Only g_NCR5380 enables the delay, which implies that the other five
> >     drivers using the NCR5380.c core driver remain incompatible with
> >     Mustek scanners.
> >
> > 2. The delay is not implemented by atari_NCR5380.c, which is problematic
> >     for re-unifying the two core driver forks.
> >
> > 3. The delay is implemented using NCR5380_set_timer() which makes it
> >     unreliable. A new command queued by the mid-layer cancels the delay.
> >
> > 4. The delay is applied indiscriminately in several situations in which
> >     NCR5380_select() returns -1. These are-- reselection by the target,
> >     failure of the target to assert BSY, and failure of the target to
> >     assert REQ. It's clear from the comments that USLEEP_WAITLONG is not
> >     relevant to the reselection case. And reportedly, these scanners do
> >     not disconnect.
> >
> > 5. atari_NCR5380.c was forked before Linux 2.1.105, so it was spared some
> >     of the damage done to NCR5380.c. In this case, the atari_NCR5380.c core
> >     driver was more standard-compliant and may not have needed any
> >     workaround like the USLEEP_WAITLONG kludge. The compliance issue was
> >     addressed in the previous patch.
> >
> > If these scanners still don't work, we need a better solution. Retrying
> > selection until EH aborts a command offers equivalent robustness. Bugs in
> > the existing driver prevent EH working correctly but this is addressed in
> > a subsequent patch. Remove USLEEP_WAITLONG.
> >
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> >
> > ---
> >   drivers/scsi/NCR5380.c   |   19 +++++--------------
> >   drivers/scsi/g_NCR5380.c |    1 -
> >   2 files changed, 5 insertions(+), 15 deletions(-)
> >
> > Index: linux/drivers/scsi/NCR5380.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:15:51.000000000 +1100
> > +++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:15:52.000000000 +1100
> > @@ -468,10 +468,6 @@ static void NCR5380_print_phase(struct S
> >   #ifndef USLEEP_POLL
> >   #define USLEEP_POLL msecs_to_jiffies(200)
> >   #endif
> > -#ifndef USLEEP_WAITLONG
> > -/* RvC: (reasonable time to wait on select error) */
> > -#define USLEEP_WAITLONG USLEEP_SLEEP
> > -#endif
> >
> >   /*
> >    * Function : int should_disconnect (unsigned char cmd)
> > @@ -619,8 +615,8 @@ static void prepare_info(struct Scsi_Hos
> >             "can_queue %d, cmd_per_lun %d, "
> >             "sg_tablesize %d, this_id %d, "
> >             "flags { %s%s%s%s}, "
> > -#if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
> > -		 "USLEEP_POLL %lu, USLEEP_WAITLONG %lu, "
> > +#if defined(USLEEP_POLL) && defined(USLEEP_SLEEP)
> > +		 "USLEEP_POLL %lu, USLEEP_SLEEP %lu, "
> >   #endif
> >             "options { %s} ",
> >             instance->hostt->name, instance->io_port, instance->n_io_port,
> > @@ -631,8 +627,8 @@ static void prepare_info(struct Scsi_Hos
> >             hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
> >             hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
> >             hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
> > -#if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
> > -	         USLEEP_POLL, USLEEP_WAITLONG,
> > +#if defined(USLEEP_POLL) && defined(USLEEP_SLEEP)
> > +	         USLEEP_POLL, USLEEP_SLEEP,
> >   #endif
> >   #ifdef AUTOPROBE_IRQ
> >             "AUTOPROBE_IRQ "
> Wouldn't it make more sense to remove the USLEEP_WAITLONG completely?
> From what I can see it is meant to indicate that WAITLONG is enabled,
> but we've just removed that functionality...

Actually, this patch does remove USLEEP_WAITLONG completely. It does not 
remove USLEEP_POLL and USLEEP_SLEEP. In patch 25, the USLEEP_POLL and 
USLEEP_SLEEP stuff is replaced by an algorithm that sleeps while polling.

You are right that adding USLEEP_SLEEP to this snprintf() is a change that 
doesn't really belong here. But since I was changing those lines anyway, 
it seemed like a good time to fix a mistake I made when I first added the 
snprintf() and wrote "USLEEP_POLL, USLEEP_WAITLONG" instead of 
"USLEEP_POLL, USLEEP_SLEEP".

Shall I revise this patch? That will affect patch 25. Or perhaps I should 
add the snprintf() change in the commit log?

Thanks for your review.

-- 

> 
> Cheers,
> 
> Hannes
> 

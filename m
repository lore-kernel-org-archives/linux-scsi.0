From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 20/77] ncr5380: Introduce unbound workqueue
Date: Tue, 22 Dec 2015 23:44:21 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512222238240.19799@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au> <20151222011743.455500361@telegraphics.com.au> <5678F776.8080305@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <5678F776.8080305@suse.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 22 Dec 2015, Hannes Reinecke wrote:

> On 12/22/2015 02:17 AM, Finn Thain wrote:
> > Allocate a work queue that will permit busy waiting and sleeping. This
> > means NCR5380_init() can potentially fail, so add this error path.
> >
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> >
> > ---
> >
> > In subsequent patches, the work function adopts this work queue so it
> > can sleep while polling, which allows the removal of some flawed and
> > complicated code in NCR5380_select() in NCR5380.c.
> >
> > Changed since v1:
> > - Dropped WQ_CPU_INTENSIVE flag because Documentation/workqueue.txt says it
> >    "is meaningless for unbound wq".
> >
> > ---
> >   drivers/scsi/NCR5380.c       |   15 +++++++++++----
> >   drivers/scsi/NCR5380.h       |    1 +
> >   drivers/scsi/arm/cumana_1.c  |    8 ++++++--
> >   drivers/scsi/arm/oak.c       |    8 ++++++--
> >   drivers/scsi/atari_NCR5380.c |    8 +++++++-
> >   drivers/scsi/atari_scsi.c    |    5 ++++-
> >   drivers/scsi/dmx3191d.c      |   17 +++++++++++------
> >   drivers/scsi/dtc.c           |   11 +++++++++--
> >   drivers/scsi/g_NCR5380.c     |   31 +++++++++++++++----------------
> >   drivers/scsi/mac_scsi.c      |    5 ++++-
> >   drivers/scsi/pas16.c         |   10 ++++++++--
> >   drivers/scsi/sun3_scsi.c     |    5 ++++-
> >   drivers/scsi/t128.c          |   13 ++++++++++---
> >   13 files changed, 96 insertions(+), 41 deletions(-)
> >
> > Index: linux/drivers/scsi/NCR5380.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:15:52.000000000 +1100
> > +++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:15:56.000000000 +1100
> > @@ -514,7 +514,7 @@ static int should_disconnect(unsigned ch
> >   static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, unsigned
> >   long timeout)
> >   {
> >   	hostdata->time_expires = jiffies + timeout;
> > -	schedule_delayed_work(&hostdata->coroutine, timeout);
> > +	queue_delayed_work(hostdata->work_q, &hostdata->coroutine, timeout);
> >   }
> >
> >
> > @@ -791,7 +791,12 @@ static int NCR5380_init(struct Scsi_Host
> >    hostdata->disconnected_queue = NULL;
> >    
> >    INIT_DELAYED_WORK(&hostdata->coroutine, NCR5380_main);
> > -	
> > +	hostdata->work_q = alloc_workqueue("ncr5380_%d",
> > +	                        WQ_UNBOUND | WQ_MEM_RECLAIM,
> > +	                        1, instance->host_no);
> > +	if (!hostdata->work_q)
> > +		return -ENOMEM;
> > +
> >    /* The CHECK code seems to break the 53C400. Will check it later maybe */
> >    if (flags & FLAG_NCR53C400)
> >     hostdata->flags = FLAG_HAS_LAST_BYTE_SENT | flags;
> 
> Wouldn't it be better to use a normal (ie bound) workqueue here?

The polling algorithm I've used requires that the workqueue item is free 
to busy-wait and sleep. Perhaps a kthread_worker would be better?

> SCSI-2 is pretty much single-threaded, so shifting things onto arbitrary 
> CPUs don't sound very appealing.

Most of these drivers only run on UP systems. For the x86 drivers, I 
suspect that the cache miss penalty would be insignificant compared to 
some of the other overheads. The 5380 chip requires that the CPU is 
involved in SCSI bus signalling and merely accessing a chip register 
takes over a microsecond.

-- 

> 
> Cheers,
> 
> Hannes
> 

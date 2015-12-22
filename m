From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 20/77] ncr5380: Introduce unbound workqueue
Date: Tue, 22 Dec 2015 08:10:46 +0100
Message-ID: <5678F776.8080305@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011743.455500361@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011743.455500361@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:17 AM, Finn Thain wrote:
> Allocate a work queue that will permit busy waiting and sleeping. Thi=
s
> means NCR5380_init() can potentially fail, so add this error path.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>
> In subsequent patches, the work function adopts this work queue so it
> can sleep while polling, which allows the removal of some flawed and
> complicated code in NCR5380_select() in NCR5380.c.
>
> Changed since v1:
> - Dropped WQ_CPU_INTENSIVE flag because Documentation/workqueue.txt s=
ays it
>    "is meaningless for unbound wq".
>
> ---
>   drivers/scsi/NCR5380.c       |   15 +++++++++++----
>   drivers/scsi/NCR5380.h       |    1 +
>   drivers/scsi/arm/cumana_1.c  |    8 ++++++--
>   drivers/scsi/arm/oak.c       |    8 ++++++--
>   drivers/scsi/atari_NCR5380.c |    8 +++++++-
>   drivers/scsi/atari_scsi.c    |    5 ++++-
>   drivers/scsi/dmx3191d.c      |   17 +++++++++++------
>   drivers/scsi/dtc.c           |   11 +++++++++--
>   drivers/scsi/g_NCR5380.c     |   31 +++++++++++++++----------------
>   drivers/scsi/mac_scsi.c      |    5 ++++-
>   drivers/scsi/pas16.c         |   10 ++++++++--
>   drivers/scsi/sun3_scsi.c     |    5 ++++-
>   drivers/scsi/t128.c          |   13 ++++++++++---
>   13 files changed, 96 insertions(+), 41 deletions(-)
>
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:15:52.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:15:56.000000000 +1100
> @@ -514,7 +514,7 @@ static int should_disconnect(unsigned ch
>   static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, un=
signed long timeout)
>   {
>   	hostdata->time_expires =3D jiffies + timeout;
> -	schedule_delayed_work(&hostdata->coroutine, timeout);
> +	queue_delayed_work(hostdata->work_q, &hostdata->coroutine, timeout)=
;
>   }
>
>
> @@ -791,7 +791,12 @@ static int NCR5380_init(struct Scsi_Host
>   	hostdata->disconnected_queue =3D NULL;
>   =09
>   	INIT_DELAYED_WORK(&hostdata->coroutine, NCR5380_main);
> -=09
> +	hostdata->work_q =3D alloc_workqueue("ncr5380_%d",
> +	                        WQ_UNBOUND | WQ_MEM_RECLAIM,
> +	                        1, instance->host_no);
> +	if (!hostdata->work_q)
> +		return -ENOMEM;
> +
>   	/* The CHECK code seems to break the 53C400. Will check it later m=
aybe */
>   	if (flags & FLAG_NCR53C400)
>   		hostdata->flags =3D FLAG_HAS_LAST_BYTE_SENT | flags;

Wouldn't it be better to use a normal (ie bound) workqueue here?
SCSI-2 is pretty much single-threaded, so shifting things onto arbitrar=
y=20
CPUs don't sound very appealing.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

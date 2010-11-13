From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v4] SCSI host lock push-down
Date: Sat, 13 Nov 2010 01:01:38 -0500
Message-ID: <4CDE29C2.5040206@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113051635.GA11613@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101113051635.GA11613@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/13/2010 12:16 AM, Jeff Garzik wrote:
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 9e71ac6..f9581a3 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2198,7 +2198,7 @@ no_command:
>    * Returns: 0 on success, else error.
>    * Notes: io_request_lock is held, interrupts are disabled.
>    */
> -int fas216_queue_command(struct scsi_cmnd *SCpnt,
> +static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
>   			 void (*done)(struct scsi_cmnd *))
>   {
>   	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> @@ -2240,6 +2240,8 @@ int fas216_queue_command(struct scsi_cmnd *SCpnt,
>   	return result;
>   }
>
> +DEF_SCSI_QCMD(fas216_queue_command)
> +
>   /**
>    * fas216_internal_done - trigger restart of a waiting thread in fas216_noqueue_command
>    * @SCpnt: Command to wake
> @@ -2263,7 +2265,7 @@ static void fas216_internal_done(struct scsi_cmnd *SCpnt)
>    * Returns: scsi result code.
>    * Notes: io_request_lock is held, interrupts are disabled.
>    */
> -int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
> +static int fas216_noqueue_command_lck(struct scsi_cmnd *SCpnt,
>   			   void (*done)(struct scsi_cmnd *))
>   {
>   	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> @@ -2277,7 +2279,7 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
>   	BUG_ON(info->scsi.irq != NO_IRQ);
>
>   	info->internal_done = 0;
> -	fas216_queue_command(SCpnt, fas216_internal_done);
> +	fas216_queue_command(SCpnt->device->host, SCpnt, fas216_internal_done);
>
>   	/*
>   	 * This wastes time, since we can't return until the command is


hmmmm.

Linus's suggestion to add Scsi_Host to queuecommand seems to have had a 
helpful side effect, exposing a minor bug present in nab's (v1), Andi's 
(v2), my v3 and v4 push-down patches:

A few odd ducks, such as fas16 or ancient megaraid, call their own 
->queuecommand directly.  None of the major SCSI drivers do this, 
thankfully.

The host lock push-down patch should be calling the _lck function in 
those rare cases, otherwise we've created a deadlock.

Time for v5...

	Jeff

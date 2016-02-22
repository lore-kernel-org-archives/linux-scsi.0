From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] ncr5380: Don't re-enter NCR5380_select() when aborting
 a command
Date: Tue, 23 Feb 2016 10:01:41 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1602230959560.24636@nippy.intranet>
References: <20160126023113.571639451@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160126023113.571639451@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Please ignore this patch. It isn't sufficient to fix the problem. I'll 
send another patch that does fix it.

On Tue, 26 Jan 2016, Finn Thain wrote:

> Fixes: 707d62b37fbb ("ncr5380: Fix EH during arbitration and selection")
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> 
> ---
>  drivers/scsi/NCR5380.c       |    2 +-
>  drivers/scsi/atari_NCR5380.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/scsi/NCR5380.c
> ===================================================================
> --- linux.orig/drivers/scsi/NCR5380.c	2016-01-26 13:31:10.000000000 +1100
> +++ linux/drivers/scsi/NCR5380.c	2016-01-26 13:31:10.000000000 +1100
> @@ -2337,7 +2337,7 @@ static int NCR5380_abort(struct scsi_cmn
>  		dsprintk(NDEBUG_ABORT, instance,
>  		         "abort: removed %p from disconnected list\n", cmd);
>  		cmd->result = DID_ERROR << 16;
> -		if (!hostdata->connected)
> +		if (!hostdata->connected && !hostdata->selecting)
>  			NCR5380_select(instance, cmd);
>  		if (hostdata->connected != cmd) {
>  			complete_cmd(instance, cmd);
> Index: linux/drivers/scsi/atari_NCR5380.c
> ===================================================================
> --- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-26 13:31:10.000000000 +1100
> +++ linux/drivers/scsi/atari_NCR5380.c	2016-01-26 13:31:10.000000000 +1100
> @@ -2532,7 +2532,7 @@ static int NCR5380_abort(struct scsi_cmn
>  		dsprintk(NDEBUG_ABORT, instance,
>  		         "abort: removed %p from disconnected list\n", cmd);
>  		cmd->result = DID_ERROR << 16;
> -		if (!hostdata->connected)
> +		if (!hostdata->connected && !hostdata->selecting)
>  			NCR5380_select(instance, cmd);
>  		if (hostdata->connected != cmd) {
>  			complete_cmd(instance, cmd);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

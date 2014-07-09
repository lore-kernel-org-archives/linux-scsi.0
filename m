From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/14] scsi: set ->scsi_done before calling scsi_dispatch_cmd
Date: Wed, 09 Jul 2014 13:14:02 +0200
Message-ID: <53BD23FA.2090600@suse.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-5-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> The blk-mq code path will set this to a different function, so make t=
he
> code simpler by setting it up in a legacy-request specific place.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi.c     |   23 +----------------------
>   drivers/scsi/scsi_lib.c |   20 ++++++++++++++++++++
>   2 files changed, 21 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index dcc43fd..d3bd6cf 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -72,8 +72,6 @@
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/scsi.h>
>
> -static void scsi_done(struct scsi_cmnd *cmd);
> -
>   /*
>    * Definitions and constants.
>    */
> @@ -696,8 +694,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   	}
>
>   	trace_scsi_dispatch_cmd_start(cmd);
> -
> -	cmd->scsi_done =3D scsi_done;
>   	rtn =3D host->hostt->queuecommand(host, cmd);
>   	if (rtn) {
>   		trace_scsi_dispatch_cmd_error(cmd, rtn);
> @@ -711,28 +707,11 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>
>   	return rtn;
>    done:
> -	scsi_done(cmd);
> +	cmd->scsi_done(cmd);
>   	return 0;
>   }
>
>   /**
> - * scsi_done - Invoke completion on finished SCSI command.
> - * @cmd: The SCSI Command for which a low-level device driver (LLDD)=
 gives
> - * ownership back to SCSI Core -- i.e. the LLDD has finished with it=
=2E
> - *
> - * Description: This function is the mid-level's (SCSI Core) interru=
pt routine,
> - * which regains ownership of the SCSI command (de facto) from a LLD=
D, and
> - * calls blk_complete_request() for further processing.
> - *
> - * This function is interrupt context safe.
> - */
> -static void scsi_done(struct scsi_cmnd *cmd)
> -{
> -	trace_scsi_dispatch_cmd_done(cmd);
> -	blk_complete_request(cmd->request);
> -}
> -
> -/**
>    * scsi_finish_command - cleanup and pass command back to upper lay=
er
>    * @cmd: the command
>    *
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 63bf844..6989b6f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -29,6 +29,8 @@
>   #include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
>
> +#include <trace/events/scsi.h>
> +
>   #include "scsi_priv.h"
>   #include "scsi_logging.h"
>
> @@ -1480,6 +1482,23 @@ static void scsi_softirq_done(struct request *=
rq)
>   	}
>   }
>
> +/**
> + * scsi_done - Invoke completion on finished SCSI command.
> + * @cmd: The SCSI Command for which a low-level device driver (LLDD)=
 gives
> + * ownership back to SCSI Core -- i.e. the LLDD has finished with it=
=2E
> + *
> + * Description: This function is the mid-level's (SCSI Core) interru=
pt routine,
> + * which regains ownership of the SCSI command (de facto) from a LLD=
D, and
> + * calls blk_complete_request() for further processing.
> + *
> + * This function is interrupt context safe.
> + */
> +static void scsi_done(struct scsi_cmnd *cmd)
> +{
> +	trace_scsi_dispatch_cmd_done(cmd);
> +	blk_complete_request(cmd->request);
> +}
> +
>   /*
>    * Function:    scsi_request_fn()
>    *
> @@ -1582,6 +1601,7 @@ static void scsi_request_fn(struct request_queu=
e *q)
>   		/*
>   		 * Dispatch the command to the low-level driver.
>   		 */
> +		cmd->scsi_done =3D scsi_done;
>   		rtn =3D scsi_dispatch_cmd(cmd);
>   		if (rtn) {
>   			scsi_queue_insert(cmd, rtn);
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

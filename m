From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: remove useless variable assignment
Date: Wed, 17 May 2017 21:39:58 -0700
Message-ID: <1495082398.2840.14.camel@linux.vnet.ibm.com>
References: <20170518003043.GA5664@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170518003043.GA5664@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-17 at 19:30 -0500, Gustavo A. R. Silva wrote:
> Remove this assignment once the value stored in variable _k_ is
> overwritten after a few lines.
> 
> Addresses-Coverity-ID: 1226927
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/scsi/qlogicfas408.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/qlogicfas408.c
> b/drivers/scsi/qlogicfas408.c
> index c3a9151..269440a 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -329,7 +329,6 @@ static unsigned int ql_pcmd(struct scsi_cmnd
> *cmd)
>  		 */
>  		if ((k = ql_wai(priv)))
>  			return (k << 16);
> -		k = inb(qbase + 5);	/* should be 0x10, bus
> service */

That doesn't look right to me.  inb() is a statement which has an
effect on the I/O device regardless of whether the returned value is
used or discarded.  In this case I think it's being used to clear
pending interrupts, so removing it will likely cause a phase error.

James

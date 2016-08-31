From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH v2 3/3] scsi/ncr5380: Improve interrupt latency during
 PIO tranfers
Date: Wed, 31 Aug 2016 10:07:38 -0400 (EDT)
Message-ID: <1064826087.3700254.1472652458320.JavaMail.zimbra@redhat.com>
References: <20160827022959.303563262@telegraphics.com.au> <20160831044453.413698369@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160831044453.413698369@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Finn Thain" <fthain@telegraphics.com.au>
> To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Geert
> Uytterhoeven" <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
> linux-kernel@vger.kernel.org, "Michael Schmitz" <schmitzmic@gmail.com>
> Sent: Wednesday, August 31, 2016 12:44:56 AM
> Subject: [PATCH v2 3/3] scsi/ncr5380: Improve interrupt latency during PIO tranfers
> 
> Large PIO transfers are broken up into chunks to try to avoid disabling
> local IRQs for long periods. But IRQs are still disabled for too long
> and this causes SCC FIFO overruns during serial port transfers.
> 
> This patch reduces the PIO chunk size to reduce interrupt latency to
> something on the order of milliseconds, at the expense of additional CPU
> overhead from extra iterations of the NCR5380_main() loop.
> 
> That CPU overhead is a problem for slow machines (e.g. mac_scsi on 25 MHz
> 68030) but these machines generally use PDMA not PIO. This patch doesn't
> make the overhead any worse on my Mac LC III (because it only gets about
> 510 accesses per ms).
> 
> This patch decreases disk performance by a fraction of one percent for
> dmx3191d on my 333 MHz PowerPC 750. Other affected hardware (such as
> g_NCR5380 on x86) was not tested but 5380 ISA cards generally use PDMA
> and not PIO.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> 
> ---
> Changed since v1:
> - PIO transfer chunk size is now hard-coded for simplicity.
> 
> ---
>  drivers/scsi/NCR5380.c |    8 ++++----
>  drivers/scsi/NCR5380.h |    2 ++
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> Index: linux/drivers/scsi/NCR5380.c
> ===================================================================
> --- linux.orig/drivers/scsi/NCR5380.c	2016-08-31 14:44:51.000000000 +1000
> +++ linux/drivers/scsi/NCR5380.c	2016-08-31 14:44:52.000000000 +1000
> @@ -1849,11 +1849,11 @@ static void NCR5380_information_transfer
>  						/* XXX - need to source or sink data here, as appropriate */
>  					}
>  				} else {
> -					/* Break up transfer into 3 ms chunks,
> -					 * presuming 6 accesses per handshake.
> +					/* Transfer a small chunk so that the
> +					 * irq mode lock is not held too long.
>  					 */
> -					transfersize = min((unsigned long)cmd->SCp.this_residual,
> -					                   hostdata->accesses_per_ms / 2);
> +					transfersize = min(cmd->SCp.this_residual,
> +					                   NCR5380_PIO_CHUNK_SIZE);
>  					len = transfersize;
>  					NCR5380_transfer_pio(instance, &phase, &len,
>  					                     (unsigned char **)&cmd->SCp.ptr);
> Index: linux/drivers/scsi/NCR5380.h
> ===================================================================
> --- linux.orig/drivers/scsi/NCR5380.h	2016-08-31 14:44:51.000000000 +1000
> +++ linux/drivers/scsi/NCR5380.h	2016-08-31 14:44:52.000000000 +1000
> @@ -250,6 +250,8 @@ struct NCR5380_cmd {
>  
>  #define NCR5380_CMD_SIZE		(sizeof(struct NCR5380_cmd))
>  
> +#define NCR5380_PIO_CHUNK_SIZE		256
> +
>  static inline struct scsi_cmnd *NCR5380_to_scmd(struct NCR5380_cmd
>  *ncmd_ptr)
>  {
>  	return ((struct scsi_cmnd *)ncmd_ptr) - 1;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Patch makes sense, look good to me.

Reviwed-by: Laurence Oberman <loberman@redhat.com>

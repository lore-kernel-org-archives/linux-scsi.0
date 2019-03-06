From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: NCR5380: Mark expected switch fall-through
Date: Wed, 06 Mar 2019 12:39:40 -0500
Message-ID: <yq1imwvzyub.fsf@oracle.com>
References: <20190228202759.GA5883@embeddedor>
        <alpine.LNX.2.21.1903011143550.8@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1903011143550.8@nippy.intranet> (Finn Thain's
        message of "Fri, 1 Mar 2019 12:16:57 +1100 (AEDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Hi Finn,

Please submit this as a formal patch. Thanks!

> Here's an alternative patch, which has the virtue that a simple heuristic 
> will work. This patch does not require that other static analysis tools 
> will follow gcc's weird rules about hyphens. (I assume they don't but I 
> didn't check.)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 7fed9bb72784..fe0535affc14 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1932,13 +1932,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					if (!hostdata->connected)
>  						return;
>  
> -					/* Fall through to reject message */
> -
> +					/* Reject message */
> +					/* Fall through */
> +				default:
>  					/*
>  					 * If we get something weird that we aren't expecting,
> -					 * reject it.
> +					 * log it.
>  					 */
> -				default:
>  					if (tmp == EXTENDED_MESSAGE)
>  						scmd_printk(KERN_INFO, cmd,
>  						            "rejecting unknown extended message code %02x, length %d\n",

-- 
Martin K. Petersen	Oracle Linux Engineering

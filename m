From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
Date: Thu, 16 Oct 2014 12:28:40 -0700
Message-ID: <1413487720.15773.1.camel@perches.com>
References: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-10-16 at 21:14 +0200, Michael Opdenacker wrote:
> This replaces kmalloc + memset by a call to kzalloc.
[]
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
[]
> @@ -4780,10 +4779,10 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>  	SLIST_INIT(&scb_data->sg_maps);
>  
>  	/* Allocate SCB resources */
> -	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> +	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> +				GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
>  		return (ENOMEM);
> -	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
>  
>  	/* Determine the number of hardware SCBs and initialize them */
>  

Probably better as kcalloc.

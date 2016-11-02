From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 3/6] g_NCR5380: Check for chip presence before calling
 NCR5380_init()
Date: Wed, 2 Nov 2016 18:46:06 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611011228350.25806@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-4-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:46066 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbcKBHp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2016 03:45:59 -0400
In-Reply-To: <1477945112-25659-4-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Mon, 31 Oct 2016, Ondrej Zary wrote:

> Write and read back MODE_REG to check if the chip is really there
> before doing more initialization.
> 
> This prevents hang when incorrect I/O address was specified by user (in
> the most common case where no device is present there so all reads
> result in 0xff).
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/g_NCR5380.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 0d1f6ad..e713dba 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -322,6 +322,13 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
>  		}
>  	}
>  
> +	/* check if the chip is really there */
> +	NCR5380_write(MODE_REG, 0);
> +	if (NCR5380_read(MODE_REG) != 0) {

Wouldn't it be more accurate to write,

	/* Check for some kind of device. A vacant slot reads 0xff. */

?

> +		ret = -ENODEV;
> +		goto out_unregister;
> +	}
> +
>  	ret = NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP);
>  	if (ret)
>  		goto out_unregister;
> 

-- 

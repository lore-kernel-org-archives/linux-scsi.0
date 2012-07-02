From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: [patch] [SCSI] bnx2i: use strlcpy() instead of memcpy() for strings
Date: Mon, 2 Jul 2012 11:09:19 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6F6F@saturn3.aculab.com>
References: <20120630114935.GB22767@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20120630114935.GB22767@elgon.mountain>
Sender: netdev-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Barak Witkowski <barak@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

> Subject: [patch] [SCSI] bnx2i: use strlcpy() instead of memcpy() for
strings
> 
> DRV_MODULE_VERSION here is "2.7.2.2" which is only 8 chars but we copy
> 12 bytes from the stack so it's a small information leak.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This was just added to linux-next yesterday, but I'm not sure 
> which tree it came from.
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c 
> b/drivers/scsi/bnx2i/bnx2i_init.c
> index 7729a52..b17637a 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -400,7 +400,7 @@ int bnx2i_get_stats(void *handle)
>  	if (!stats)
>  		return -ENOMEM;
>  
> -	memcpy(stats->version, DRV_MODULE_VERSION,
sizeof(stats->version));
> +	strlcpy(stats->version, DRV_MODULE_VERSION,
sizeof(stats->version));
>  	memcpy(stats->mac_add1 + 2, hba->cnic->mac_addr, ETH_ALEN);

Doesn't that leak the original contents of the last bytes of
stats->version instead?

	David

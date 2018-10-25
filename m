From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: aic7xxx: Fix unintended sign extension issue
Date: Thu, 25 Oct 2018 08:32:16 -0700
Message-ID: <ce7de2909b7c9958ac63c4386e889509926b651b.camel@perches.com>
References: <20181025151334.15622-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025151334.15622-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-10-25 at 16:13 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the expression "ahc_inb(ahc, port+3) << 24", the initial value is a
> u8, but is promoted to a signed int, then sign-extended to uint64_t.  If
> the value read from the port has the upper bit set then the sign
> extension will set all the upper bits of the expression which is probably
> not what was intended.  Cast to uint64_t to avoid the sign extension.
[]
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
[]
> @@ -622,7 +622,7 @@ ahd_inq(struct ahd_softc *ahd, u_int port)
>  	return ((ahd_inb(ahd, port))
>  	      | (ahd_inb(ahd, port+1) << 8)
>  	      | (ahd_inb(ahd, port+2) << 16)
> -	      | (ahd_inb(ahd, port+3) << 24)
> +	      | (((uint64_t)ahd_inb(ahd, port+3)) << 24)
>  	      | (((uint64_t)ahd_inb(ahd, port+4)) << 32)
>  	      | (((uint64_t)ahd_inb(ahd, port+5)) << 40)
>  	      | (((uint64_t)ahd_inb(ahd, port+6)) << 48)

Perhaps a different method using two calls to ahd_inl
is clearer and possibly faster like:

uint64_t
ahd_inq(struct ahd_softc *ahd, u_int port)
{
	return ahd_inl(port) | ((uint64_t)ahd_inl(port + 4) << 32);
}

> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
[]
> @@ -493,7 +493,7 @@ ahc_inq(struct ahc_softc *ahc, u_int port)
>  	return ((ahc_inb(ahc, port))
>  	      | (ahc_inb(ahc, port+1) << 8)
>  	      | (ahc_inb(ahc, port+2) << 16)
> -	      | (ahc_inb(ahc, port+3) << 24)
> +	      | (((uint64_t)ahc_inb(ahc, port+3)) << 24)
>  	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
>  	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
>  	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)

here too

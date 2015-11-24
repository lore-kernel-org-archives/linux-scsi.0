From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: use sector_div instead of do_div
Date: Tue, 24 Nov 2015 16:03:12 +0100
Message-ID: <56547C30.20800@suse.de>
References: <24882658.08y4bWL6tn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24882658.08y4bWL6tn@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org
Cc: jbottomley@odin.com, martin.petersen@oracle.com, nico@fluxnic.net, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 05:38 PM, Arnd Bergmann wrote:
> do_div is the wrong way to divide a sector_t, as it is less
> efficient when sector_t is 32-bit wide. With the upcoming
> do_div optimizations, the kernel starts warning about this:
>=20
> drivers/scsi/scsi_debug.c: In function 'dif_store':
> include/asm-generic/div64.h:207:28: warning: comparison of distinct p=
ointer types lacks a cast
>=20
> This changes the code to use sector_div instead, which always
> produces optimal code.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Found on the ARM randconfig build today, after I merged Nico's patche=
s
> for linux-next
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index dfcc45bb03b1..ec622ba9864a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -678,7 +678,7 @@ static void *fake_store(unsigned long long lba)
> =20
>  static struct sd_dif_tuple *dif_store(sector_t sector)
>  {
> -	sector =3D do_div(sector, sdebug_store_sectors);
> +	sector =3D sector_div(sector, sdebug_store_sectors);
> =20
>  	return dif_storep + sector;
>  }
> @@ -2780,7 +2780,7 @@ static unsigned long lba_to_map_index(sector_t =
lba)
>  		lba +=3D scsi_debug_unmap_granularity -
>  			scsi_debug_unmap_alignment;
>  	}
> -	do_div(lba, scsi_debug_unmap_granularity);
> +	sector_div(lba, scsi_debug_unmap_granularity);
> =20
>  	return lba;
>  }
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

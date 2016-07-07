From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] libata-scsi: better style in ata_msense_caching()
Date: Thu, 7 Jul 2016 13:55:43 +0300
Message-ID: <b7d33126-814b-60c2-8699-0e63bbf42834@cogentembedded.com>
References: <20160707014334.1031-1-me>
 <577db3cf.0a6a620a.c3774.1508@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577db3cf.0a6a620a.c3774.1508@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/7/2016 4:43 AM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index bfec66f..e3f5751 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2424,10 +2424,12 @@ static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
>  static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
>  {
>  	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
> -	if (changeable || ata_id_wcache_enabled(id))
> -		buf[2] |= (1 << 2);	/* write cache enable */
> -	if (!changeable && !ata_id_rahead_enabled(id))
> -		buf[12] |= (1 << 5);	/* disable read ahead */
> +	if (changeable)
> +		buf[2] |= (1 << 2); /* ata_mselect_caching() */

     Parens not really needed.

> +	else {

    CodingStyle: {} should be used in all branches if used in at least one.

> +		buf[2] |= (ata_id_wcache_enabled(id) << 2);	/* write cache enable */
> +		buf[12] |= (!ata_id_rahead_enabled(id) << 5);	/* disable read ahead */

    Outer parens not needed.

> +	}
>  	return sizeof(def_cache_mpage);
>  }
>

MBR, Sergei


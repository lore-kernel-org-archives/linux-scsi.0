From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] libata-scsi: better style in ata_msense_caching()
Date: Tue, 12 Jul 2016 10:48:24 -0400
Message-ID: <20160712144824.GD3190@htj.duckdns.org>
References: <20160712133703.2076-1-me>
 <5784f28c.c4d0620a.69372.3df2@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35135 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030249AbcGLOs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 10:48:26 -0400
Content-Disposition: inline
In-Reply-To: <5784f28c.c4d0620a.69372.3df2@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 12, 2016 at 09:37:03PM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index bfec66f..48ea887 100644
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
> +	if (changeable) {
> +		buf[2] |= 1 << 2; /* ata_mselect_caching() */
> +	} else {
> +		buf[2] |= ata_id_wcache_enabled(id) << 2;	/* write cache enable */
> +		buf[12] |= !ata_id_rahead_enabled(id) << 5;	/* disable read ahead */
> +	}

It's different but I'm not sure this is better.

Thanks.

-- 
tejun

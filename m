From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] drivers: scsi: scsi_lib.c: add prefix "SCSILIB_" to macro
 "SP"
Date: Sun, 01 Dec 2013 17:17:03 +0100
Message-ID: <529B60FF.7030601@acm.org>
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com> <52955913.3060809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:47656 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3LAQRJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Dec 2013 11:17:09 -0500
In-Reply-To: <52955913.3060809@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>, Bottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: rkuo <rkuo@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 11/27/13 03:29, Chen Gang wrote:
> the macro "SP" is too common to make conflict with some architectures,
> so recommend to add prefix for it.
> 
> The related warning (with allmodconfig for hexagon):
> 
>     CC [M]  drivers/scsi/scsi_lib.o
>   drivers/scsi/scsi_lib.c:46:0: warning: "SP" redefined [enabled by default]
>   arch/hexagon/include/uapi/asm/registers.h:9:0: note: this is the location of the previous definition
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/scsi/scsi_lib.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7bd7f0d..f78e21b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -43,28 +43,28 @@ struct scsi_host_sg_pool {
>  	mempool_t	*pool;
>  };
>  
> -#define SP(x) { x, "sgpool-" __stringify(x) }
> +#define SCSILIB_SP(x) { x, "sgpool-" __stringify(x) }
>  #if (SCSI_MAX_SG_SEGMENTS < 32)
>  #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
>  #endif
>  static struct scsi_host_sg_pool scsi_sg_pools[] = {
> -	SP(8),
> -	SP(16),
> +	SCSILIB_SP(8),
> +	SCSILIB_SP(16),
>  #if (SCSI_MAX_SG_SEGMENTS > 32)
> -	SP(32),
> +	SCSILIB_SP(32),
>  #if (SCSI_MAX_SG_SEGMENTS > 64)
> -	SP(64),
> +	SCSILIB_SP(64),
>  #if (SCSI_MAX_SG_SEGMENTS > 128)
> -	SP(128),
> +	SCSILIB_SP(128),
>  #if (SCSI_MAX_SG_SEGMENTS > 256)
>  #error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
>  #endif
>  #endif
>  #endif
>  #endif
> -	SP(SCSI_MAX_SG_SEGMENTS)
> +	SCSILIB_SP(SCSI_MAX_SG_SEGMENTS)
>  };
> -#undef SP
> +#undef SCSILIB_SP
>  
>  struct kmem_cache *scsi_sdb_cache;

Sorry but the "SCSILIB_SP" name doesn't look very descriptive to me.
There are probably better choices possible. How about using e.g.
SG_POOL() instead ?

Bart.


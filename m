From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: mpt3sas: Mark expected switch fall-through
Date: Tue, 11 Jun 2019 11:55:11 -0700
Message-ID: <201906111153.4413672DE8@keescook>
References: <20190611150219.GA19152@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190611150219.GA19152@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 11, 2019 at 10:02:19AM -0500, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> This patch fixes the following warning:
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c: In function ‘_base_update_ioc_page1_inlinewith_perf_mode’:
> drivers/scsi/mpt3sas/mpt3sas_base.c:4510:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    if (ioc->high_iops_queues) {
>       ^
> drivers/scsi/mpt3sas/mpt3sas_base.c:4530:2: note: here
>   case MPT_PERF_MODE_LATENCY:
>   ^~~~
> 
> Warning level 3 was used: -Wimplicit-fallthrough=3
> 
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Fixes: 30cb97023f38 ("scsi: mpt3sas: Introduce perf_mode module parameter")
Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index e6377ec07f6c..9fefcd1e9c97 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -4527,6 +4527,7 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
>  			ioc_info(ioc, "performance mode: balanced\n");
>  			return;
>  		}
> +		/* Fall through */
>  	case MPT_PERF_MODE_LATENCY:
>  		/*
>  		 * Enable interrupt coalescing on all reply queues
> -- 
> 2.21.0
> 

-- 
Kees Cook

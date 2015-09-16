From: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH 14/31] message/fusion: use kmemdup rather than duplicating
 its implementation
Date: Wed, 16 Sep 2015 12:01:03 +0200
Message-ID: <55F93DDF.3060507@samsung.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
 <1438934377-4922-15-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1438934377-4922-15-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ping.

Regards
Andrzej

On 08/07/2015 09:59 AM, Andrzej Hajda wrote:
> The patch was generated using fixed coccinelle semantic patch
> scripts/coccinelle/api/memdup.cocci [1].
>
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2014320
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/message/fusion/mptbase.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 5dcc031..1551f51 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -5971,13 +5971,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
>  	if (mpt_config(ioc, &cfg) != 0)
>  		goto out;
>  
> -	mem = kmalloc(iocpage2sz, GFP_KERNEL);
> +	mem = kmemdup((u8 *)pIoc2, iocpage2sz, GFP_KERNEL);
>  	if (!mem) {
>  		rc = -ENOMEM;
>  		goto out;
>  	}
>  
> -	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
>  	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
>  
>  	mpt_read_ioc_pg_3(ioc);

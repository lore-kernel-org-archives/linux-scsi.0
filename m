From: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH 18/31] scsi/aic7xxx: use kmemdup rather than duplicating
 its implementation
Date: Wed, 16 Sep 2015 12:02:53 +0200
Message-ID: <55F93E4D.8060809@samsung.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
 <1438934377-4922-19-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1438934377-4922-19-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
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
>  drivers/scsi/aic7xxx/aic79xx_core.c | 4 ++--
>  drivers/scsi/aic7xxx/aic7xxx_core.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
> index 109e2c9..8592448 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -9494,10 +9494,10 @@ ahd_loadseq(struct ahd_softc *ahd)
>  	if (cs_count != 0) {
>  
>  		cs_count *= sizeof(struct cs);
> -		ahd->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
> +		ahd->critical_sections = kmemdup(cs_table, cs_count,
> +						 GFP_ATOMIC);
>  		if (ahd->critical_sections == NULL)
>  			panic("ahd_loadseq: Could not malloc");
> -		memcpy(ahd->critical_sections, cs_table, cs_count);
>  	}
>  	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE);
>  
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index c4829d8..3178730 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -6940,10 +6940,10 @@ ahc_loadseq(struct ahc_softc *ahc)
>  	if (cs_count != 0) {
>  
>  		cs_count *= sizeof(struct cs);
> -		ahc->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
> +		ahc->critical_sections = kmemdup(cs_table, cs_count,
> +						 GFP_ATOMIC);
>  		if (ahc->critical_sections == NULL)
>  			panic("ahc_loadseq: Could not malloc");
> -		memcpy(ahc->critical_sections, cs_table, cs_count);
>  	}
>  	ahc_outb(ahc, SEQCTL, PERRORDIS|FAILDIS|FASTMODE);
>  

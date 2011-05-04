From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
 ensure	commands don't get lost.
Date: Wed, 04 May 2011 13:15:50 +0200
Message-ID: <4DC13566.5070203@redhat.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110503195849.5478.13229.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On 05/03/2011 09:58 PM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Apparently we've been doin it rong for a decade, but only lately do we
> run into problems.
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 621a153..98c97ca 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -212,6 +212,7 @@ static void SA5_submit_command(struct ctlr_info *h,
>  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
>  		c->Header.Tag.lower);
>  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> +	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
>   
Hi,
a small nit -
the (void) ^ is I think not needed for gcc and isn't present in the cciss.h patch

Tomas

>  	h->commands_outstanding++;
>  	if (h->commands_outstanding > h->max_outstanding)
>  		h->max_outstanding = h->commands_outstanding;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

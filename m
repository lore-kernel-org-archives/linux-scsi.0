From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hpsa: do not attempt to read from a write-only register
Date: Mon, 11 Jul 2011 13:19:11 -0700
Message-ID: <20110711131911.31789ee0.akpm@linux-foundation.org>
References: <20110708195926.3623.30375.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110708195926.3623.30375.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 08 Jul 2011 14:59:26 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Most smartarrays tolerate it, but a few new ones don't.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 6d8dcd4..7f53cea 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -214,7 +214,7 @@ static void SA5_submit_command(struct ctlr_info *h,
>  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
>  		c->Header.Tag.lower);
>  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> -	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
> +	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
>  	h->commands_outstanding++;
>  	if (h->commands_outstanding > h->max_outstanding)
>  		h->max_outstanding = h->commands_outstanding;

The changelog forgot to tell us the user-visible effects of the bug. 
That was really really bad of it.  Bad changelog.  No bone for you.

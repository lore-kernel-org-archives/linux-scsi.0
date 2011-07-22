From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hpsa: do not attempt to read from a write-only
	register
Date: Fri, 22 Jul 2011 15:39:56 -0700
Message-ID: <20110722153956.e0b5da19.akpm@linux-foundation.org>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
In-Reply-To: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org, james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, thenzl@redhat.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Jul 2011 13:16:05 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Most smartarrays tolerate it, but a few new ones don't.
> Without this change some newer Smart Arrays will lock up
> and i/o will grind to a halt.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Cc: <stable@kernel.org>?

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

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable

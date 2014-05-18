From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] scsi: dc395x.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 21:50:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1405182147500.23804@axis700.grange>
References: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 18 May 2014, Rickard Strandqvist wrote:

> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/dc395x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 83d9bf6..0d86bc7 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -2637,7 +2637,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
>  	struct ScsiReqBlk *srb = NULL;
>  	struct ScsiReqBlk *i;
>  	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
> -		   srb->cmd, tag, srb);
> +		   srb ? srb->cmd : 0, tag, srb);

There's not just a risk, it is a NULL-pointer dereference, so, just remove 
it, e.g. like

> -	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
> -		   srb->cmd, tag, srb);
> +	dprintkdbg(DBG_0, "msgin_qtag: tag=%i\n", tag);

Thanks
Guennadi

>  	if (!(dcb->tag_mask & (1 << tag)))
>  		dprintkl(KERN_DEBUG,
> -- 
> 1.7.10.4

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] storvsc: remove bogus code to transfer struct
 scatterlist
Date: Mon, 30 Jan 2017 16:00:16 -0800
Message-ID: <20170130160016.2da37993@xeon-e3>
References: <1485681138-21236-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33376 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753363AbdAaAAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 19:00:45 -0500
Received: by mail-pf0-f173.google.com with SMTP id y143so95424397pfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2017 16:00:29 -0800 (PST)
In-Reply-To: <1485681138-21236-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org

On Sun, 29 Jan 2017 01:12:18 -0800
"Christoph Hellwig" <hch@lst.de> wrote:

> Remove a piece of code in storvsc_queuecommand that tries to pass the
> physical address of the kernel struct scatterlist pointer to the host.
> 
> Fortunately the code can't ever be reached anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/storvsc_drv.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 05526b7..62f4545 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1511,13 +1511,6 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  				page_to_pfn(sg_page((cur_sgl)));
>  			cur_sgl = sg_next(cur_sgl);
>  		}
> -
> -	} else if (scsi_sglist(scmnd)) {
> -		payload->range.len = length;
> -		payload->range.offset =
> -			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
> -		payload->range.pfn_array[0] =
> -			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
>  	}
>  
>  	cmd_request->payload = payload;

Looks like something that has been around from first versions of hyper-v support.

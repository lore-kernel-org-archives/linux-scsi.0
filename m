From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH] ibmvscsi: convert kmalloc + memset to kcalloc
Date: Thu, 13 Apr 2006 17:58:54 -0500
Message-ID: <17470.55214.687901.979984@hound.rchland.ibm.com>
References: <20060407191003X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.202]:52462 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751170AbWDMW7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 18:59:52 -0400
In-Reply-To: <20060407191003X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: boutcher@cs.umn.edu, linux-scsi@vger.kernel.org

On Fri, 07 Apr 2006 19:10:03 +0900, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> said:
> 
> Convert kmalloc + memset to kcalloc in ibmvscsi
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---

Acked-by: Dave Boutcher <sleddog@us.ibm.com>

> 
>  drivers/scsi/ibmvscsi/ibmvscsi.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> 359289bba3bd58e6650088ff65ff95e9a549efc0
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 0a8ad37..12cb743 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -121,10 +121,9 @@ static int initialize_event_pool(struct 
>  
>	pool-> size = size;
>	pool-> next = 0;
> -	pool->events = kmalloc(pool->size * sizeof(*pool->events), GFP_KERNEL);
> +	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
>  	if (!pool->events)
>  		return -ENOMEM;
> -	memset(pool->events, 0x00, pool->size * sizeof(*pool->events));
>  
>	pool-> iu_storage =
>  	    dma_alloc_coherent(hostdata->dev,
> -- 
> 1.1.3

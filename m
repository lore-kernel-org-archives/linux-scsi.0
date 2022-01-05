Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AABC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 20:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbiAEUfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 15:35:16 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:50326 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244036AbiAEUfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 15:35:15 -0500
Received: from [192.168.1.18] ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 5D04nytfdBazo5D05n0J6g; Wed, 05 Jan 2022 21:35:13 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 05 Jan 2022 21:35:13 +0100
X-ME-IP: 90.11.185.88
Message-ID: <b14613cc-afbd-752b-e338-a5372a8ea3a7@wanadoo.fr>
Date:   Wed, 5 Jan 2022 21:35:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
To:     hch@lst.de
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <20211222092247.928711-1-hch@lst.de>
Subject: Re: [PATCH] pmcraid: don't use GFP_DMA in pmcraid_alloc_sglist
Content-Language: en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20211222092247.928711-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The driver doesn't express DMA addressing limitation under 32-bits
> anywhere else, so remove the spurious GFP_DMA allocation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> drivers/scsi/pmcraid.c  <https://lore.kernel.org/all/20211222092247.928711-1-hch@lst.de/#Z31drivers:scsi:pmcraid.c>  | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff 
<https://lore.kernel.org/all/20211222092247.928711-1-hch@lst.de/#iZ31drivers:scsi:pmcraid.c> 
--git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c > index 
2fe7a0019fff2..928532180d323 100644 > --- a/drivers/scsi/pmcraid.c > +++ 
b/drivers/scsi/pmcraid.c > @@ -3221,8 +3221,8 @@ static struct 
pmcraid_sglist *pmcraid_alloc_sglist(int buflen) >  		return NULL;
>  
>  	sglist->order = order;
> -	sgl_alloc_order(buflen, order, false,  > - GFP_KERNEL | GFP_DMA | __GFP_ZERO, &sglist->num_sg); > + 
sgl_alloc_order(buflen, order, false, GFP_KERNEL | __GFP_ZERO, > + 
&sglist->num_sg); > 
>  	return sglist;
>  }

Hi,

some time ago I sent a patch because the address returned by
sgl_alloc_order() isn't saved anywhere and really look like a bogus allocation and certainly a memory leak.

See https://lore.kernel.org/linux-kernel/20200920075722.376644-1-christophe.jaillet@wanadoo.fr/


CJ


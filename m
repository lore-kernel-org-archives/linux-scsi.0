Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B82C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 14:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED786101A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 14:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhI0OqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 10:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhI0OqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 10:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0330960F11;
        Mon, 27 Sep 2021 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632753879;
        bh=LS1KhJETSb4nO4pMBC+bk3+dNekoa6bYzCm72KLLax0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gRHZmq/qvgs2J/H1gdpCgH2r7s1R+jHVoPA+PTVz2mpzidJvPhpshjb+C2QZ3OBCH
         Px3RSvx2uF1ff5F7smGu9zLxNHLPD01GvY30rQjJCKsrfneWZZH+4F+2yzY5vE0V+z
         h9Cd5jSssFwTsfc62WrcJsNr1iyMITBevbVqgxq68MzkB+KGdSZdC+z9YqiDJ+rno+
         Tfj4AsZEpRgDJZys0O0G+1xr69BpHjKyiYm/XELsiX4C6IKprOsBMcTBmizxPcPATH
         pn/6/3+/a+Q580xiSNC4Vh1bATIssrxkQZQI+PzSt/J+9nUlwnnnBSxMyfC2yLHtia
         JmI1++8x4a4rw==
Date:   Mon, 27 Sep 2021 09:48:38 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: advansys: Prefer struct_size over open coded
 arithmetic
Message-ID: <20210927144838.GA168427@embeddedor>
References: <20210925114205.11377-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925114205.11377-1-len.baker@gmx.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 25, 2021 at 01:42:05PM +0200, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() function.
> 
> This code was detected with the help of Coccinelle and audited and fixed
> manually.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

> ---
> Changelog v1 -> v2
> - Rebase against v5.15-rc2

Don't use mainline for these sorts of patches . Use linux-next instead:

https://www.kernel.org/doc/man-pages/linux-next.html

Thanks
--
Gustavo

> - Remove the unnecessary "size" variable (Gustavo A. R. Silva).
> - Update the commit changelog to inform that this code was detected
>   using a Coccinelle script (Gustavo A. R. Silva).
> 
>  drivers/scsi/advansys.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index ffb391967573..e341b3372482 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7477,8 +7477,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>  			return ASC_ERROR;
>  		}
> 
> -		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
> -			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
> +		asc_sg_head = kzalloc(struct_size(asc_sg_head, sg_list, use_sg),
> +				      GFP_ATOMIC);
>  		if (!asc_sg_head) {
>  			scsi_dma_unmap(scp);
>  			set_host_byte(scp, DID_SOFT_ERROR);
> --
> 2.25.1
> 

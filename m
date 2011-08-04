From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 9/11] drivers/target/target_core_rd.c: trivial: use
	BUG_ON
Date: Thu, 04 Aug 2011 11:05:22 -0700
Message-ID: <1312481122.22234.12.camel@haakon2.linux-iscsi.org>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
	 <1312281304-11847-10-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54413 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1HDSO4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 14:14:56 -0400
In-Reply-To: <1312281304-11847-10-git-send-email-julia@diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Tue, 2011-08-02 at 12:35 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use BUG_ON(x) rather than if(x) BUG();
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> 
> @@ identifier x; @@
> -if (!x) BUG();
> +BUG_ON(!x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 

Hi Julia,

Committed as 5acbe8a85d7 into lio-core-2.6.git/master, and will be
queued for the next round of target updates.

Thanks!

--nab

> ---
>  drivers/target/target_core_rd.c |   24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff -u -p a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -390,12 +390,10 @@ static int rd_MEMCPY_read(struct rd_requ
>  				length = req->rd_size;
>  
>  			dst = sg_virt(&sg_d[i++]) + dst_offset;
> -			if (!dst)
> -				BUG();
> +			BUG_ON(!dst);
>  
>  			src = sg_virt(&sg_s[j]) + src_offset;
> -			if (!src)
> -				BUG();
> +			BUG_ON(!src);
>  
>  			dst_offset = 0;
>  			src_offset = length;
> @@ -415,8 +413,7 @@ static int rd_MEMCPY_read(struct rd_requ
>  				length = req->rd_size;
>  
>  			dst = sg_virt(&sg_d[i]) + dst_offset;
> -			if (!dst)
> -				BUG();
> +			BUG_ON(!dst);
>  
>  			if (sg_d[i].length == length) {
>  				i++;
> @@ -425,8 +422,7 @@ static int rd_MEMCPY_read(struct rd_requ
>  				dst_offset = length;
>  
>  			src = sg_virt(&sg_s[j++]) + src_offset;
> -			if (!src)
> -				BUG();
> +			BUG_ON(!src);
>  
>  			src_offset = 0;
>  			page_end = 1;
> @@ -510,12 +506,10 @@ static int rd_MEMCPY_write(struct rd_req
>  				length = req->rd_size;
>  
>  			src = sg_virt(&sg_s[i++]) + src_offset;
> -			if (!src)
> -				BUG();
> +			BUG_ON(!src);
>  
>  			dst = sg_virt(&sg_d[j]) + dst_offset;
> -			if (!dst)
> -				BUG();
> +			BUG_ON(!dst);
>  
>  			src_offset = 0;
>  			dst_offset = length;
> @@ -535,8 +529,7 @@ static int rd_MEMCPY_write(struct rd_req
>  				length = req->rd_size;
>  
>  			src = sg_virt(&sg_s[i]) + src_offset;
> -			if (!src)
> -				BUG();
> +			BUG_ON(!src);
>  
>  			if (sg_s[i].length == length) {
>  				i++;
> @@ -545,8 +538,7 @@ static int rd_MEMCPY_write(struct rd_req
>  				src_offset = length;
>  
>  			dst = sg_virt(&sg_d[j++]) + dst_offset;
> -			if (!dst)
> -				BUG();
> +			BUG_ON(!dst);
>  
>  			dst_offset = 0;
>  			page_end = 1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


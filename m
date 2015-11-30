From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: use offset_in_page macro
Date: Sun, 29 Nov 2015 16:27:48 -0800
Message-ID: <1448843268.8534.45.camel@haakon3.risingtidesystems.com>
References: <a4523a15b2ebf30e6eec6d04ab851a2c8d8bf041.1448459290.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40814 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbK3A1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2015 19:27:49 -0500
In-Reply-To: <a4523a15b2ebf30e6eec6d04ab851a2c8d8bf041.1448459290.git.geliangtang@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Geliang,

On Wed, 2015-11-25 at 21:49 +0800, Geliang Tang wrote:
> Use offset_in_page macro instead of (addr & ~PAGE_MASK).
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
>  drivers/target/target_core_user.c | 2 +-
>  drivers/target/tcm_fc/tfc_io.c    | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 937cebf..d5477c0 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -194,7 +194,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
>  
>  static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
>  {
> -	unsigned long offset = (unsigned long) vaddr & ~PAGE_MASK;
> +	unsigned long offset = offset_in_page(vaddr);
>  
>  	size = round_up(size+offset, PAGE_SIZE);
>  	vaddr -= offset;
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> index 847c1aa..6f7c65a 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -154,9 +154,9 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
>  			BUG_ON(!page);
>  			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
>  			page_addr = from;
> -			from += mem_off & ~PAGE_MASK;
> +			from += offset_in_page(mem_off);
>  			tlen = min(tlen, (size_t)(PAGE_SIZE -
> -						(mem_off & ~PAGE_MASK)));
> +						offset_in_page(mem_off)));
>  			memcpy(to, from, tlen);
>  			kunmap_atomic(page_addr);
>  			to += tlen;
> @@ -314,9 +314,9 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
>  
>  		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
>  		page_addr = to;
> -		to += mem_off & ~PAGE_MASK;
> +		to += offset_in_page(mem_off);
>  		tlen = min(tlen, (size_t)(PAGE_SIZE -
> -					  (mem_off & ~PAGE_MASK)));
> +					  offset_in_page(mem_off)));
>  		memcpy(to, from, tlen);
>  		kunmap_atomic(page_addr);
>  

Applied to target-pending/for-next.

Thank you,

--nab


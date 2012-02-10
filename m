From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 25/60] target: remove the second argument of
 k[un]map_atomic()
Date: Fri, 10 Feb 2012 14:18:43 -0800
Message-ID: <1328912323.9333.92.camel@haakon2.linux-iscsi.org>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
	 <1328852421-19678-26-git-send-email-amwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328852421-19678-26-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-02-10 at 13:39 +0800, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  drivers/target/target_core_transport.c |    4 ++--
>  drivers/target/tcm_fc/tfc_io.c         |   10 ++++------
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 

Hi Cong,

This looks fine to me, I assume you'll push this upstream..?

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 58cea07..58c12d7 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2344,7 +2344,7 @@ static void transport_xor_callback(struct se_cmd *cmd)
>  
>  	offset = 0;
>  	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
> -		addr = kmap_atomic(sg_page(sg), KM_USER0);
> +		addr = kmap_atomic(sg_page(sg));
>  		if (!addr)
>  			goto out;
>  
> @@ -2352,7 +2352,7 @@ static void transport_xor_callback(struct se_cmd *cmd)
>  			*(addr + sg->offset + i) ^= *(buf + offset + i);
>  
>  		offset += sg->length;
> -		kunmap_atomic(addr, KM_USER0);
> +		kunmap_atomic(addr);
>  	}
>  
>  out:
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> index d8cabc2..2b693ee 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -146,14 +146,13 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
>  					PAGE_SIZE << compound_order(page);
>  		} else {
>  			BUG_ON(!page);
> -			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
> -					   KM_SOFTIRQ0);
> +			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
>  			page_addr = from;
>  			from += mem_off & ~PAGE_MASK;
>  			tlen = min(tlen, (size_t)(PAGE_SIZE -
>  						(mem_off & ~PAGE_MASK)));
>  			memcpy(to, from, tlen);
> -			kunmap_atomic(page_addr, KM_SOFTIRQ0);
> +			kunmap_atomic(page_addr);
>  			to += tlen;
>  		}
>  
> @@ -291,14 +290,13 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
>  
>  		tlen = min(mem_len, frame_len);
>  
> -		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
> -				 KM_SOFTIRQ0);
> +		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT));
>  		page_addr = to;
>  		to += mem_off & ~PAGE_MASK;
>  		tlen = min(tlen, (size_t)(PAGE_SIZE -
>  					  (mem_off & ~PAGE_MASK)));
>  		memcpy(to, from, tlen);
> -		kunmap_atomic(page_addr, KM_SOFTIRQ0);
> +		kunmap_atomic(page_addr);
>  
>  		from += tlen;
>  		frame_len -= tlen;

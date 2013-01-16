From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with non-contiguous
 descriptors
Date: Wed, 16 Jan 2013 18:09:14 +0530
Message-ID: <50F69F72.4030807@codeaurora.org>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>  <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>  <50F64AC1.3040304@codeaurora.org> <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, martin.petersen@oracle.com, asias@redhat.com, tj@kernel.org, linux-arm-kernel@lists.infradead.org, Russell King <linux@arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

On 1/16/2013 4:02 PM, James Bottomley wrote:
> On Wed, 2013-01-16 at 12:07 +0530, Subhash Jadavani wrote:
>
>> Now consider this call stack from MMC block driver (this is on the ARmv7
>> based board):
>>       [   98.918174] [<c001b50c>] (v7_dma_inv_range+0x30/0x48) from
>> [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c)
>>       [   98.927819] [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c) from
>> [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c)
>>       [   98.937982] [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c) from
>> [<c0017ff8>] (dma_map_sg+0x3c/0x114)
> OK, so this is showing that ARM itself is making the assumption that the
> pages are contiguous in the page offset map.
>
> Fix this by doing the increment via the pfn, which will do the right
> thing whatever the memory model.
>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>

Thanks James. Yes, it make sense to fix the ARM code itself if it is the 
only one giving this trouble.
I have tried your change below and it also fixes this issue (without 
having my blk-merge patch). I will forward your change to Russel King to 
see what he thinks about it.

Regards,
Subhash
>
> ---
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 6b2fb87..ab88c5b 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -809,7 +809,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>   			op(vaddr, len, dir);
>   		}
>   		offset = 0;
> -		page++;
> +		page = pfn_to_page(page_to_pfn(page) + 1);
>   		left -= len;
>   	} while (left);
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

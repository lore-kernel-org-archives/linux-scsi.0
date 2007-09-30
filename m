From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] x86-64: pci-gart iommu sg chaining zeroes wrong sg.
Date: Sun, 30 Sep 2007 13:34:46 +0200
Message-ID: <46FF89D6.4090201@panasas.com>
References: <20070928013550M.tomof@acm.org> <20070928014634H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa2.bezeqint.net ([192.115.104.16]:49685 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXI3MPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 08:15:06 -0400
In-Reply-To: <20070928014634H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sep 27, 2007, 18:46 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> On Fri, 28 Sep 2007 01:38:27 +0900
> FUJITA Tomonori <tomof@acm.org> wrote:
> 
>> This patch is for Jens' block tree (sg chaining branch).
>>
>> I don't have the hardware but this looks like a bug.
>>
>> ---
>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Subject: [PATCH] x86-64: pci-gart iommu sg chaining zeroes a wrong sg's dma_length
>>
>> Needs to zero the end of the list.
>>
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> ---
>>  arch/x86_64/kernel/pci-gart.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
>> index 27b7db4..a4151a7 100644
>> --- a/arch/x86_64/kernel/pci-gart.c
>> +++ b/arch/x86_64/kernel/pci-gart.c
>> @@ -425,9 +425,10 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>>  	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
>>  		goto error;
>>  	out++;
>> +	sgmap = sg_next(sgmap);
>>  	flush_gart();
>>  	if (out < nents)
>> -		ps->dma_length = 0;
>> +		sgmap->dma_length = 0;
>>  	return out;
> 
> Sorry, it should be:
> 
> 
> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> index 27b7db4..cfcc84e 100644
> --- a/arch/x86_64/kernel/pci-gart.c
> +++ b/arch/x86_64/kernel/pci-gart.c
> @@ -426,8 +426,10 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>  		goto error;
>  	out++;
>  	flush_gart();
> -	if (out < nents)
> -		ps->dma_length = 0;
> +	if (out < nents) {
> +		sgmap = sg_next(sgmap);
> +		sgmap->dma_length = 0;
> +	}

looks correct to me.
ps points at the previous "scanned" sg entry while you want to zero out
dma_length at the entry immediately following the last entry mapped
(if (out < nents))

the original code before 62296749bd421904dace1e6b0fc3c4538aac7111 was:
-	if (out < nents) 
-		sg[out].dma_length = 0; 

Benny

>  	return out;
>  
>  error:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


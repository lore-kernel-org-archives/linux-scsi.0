From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/3] arcmsr: Split dma resource allocation to a new
 function
Date: Fri, 27 Nov 2015 16:05:39 +0100
Message-ID: <56587143.7090407@redhat.com>
References: <1448538075.10768.47.camel@Centos6.3-64>
 <1448567174.18647.19.camel@perches.com>
 <1448593128.4834.5.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbbK0PFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Nov 2015 10:05:43 -0500
In-Reply-To: <1448593128.4834.5.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, Joe Perches <joe@perches.com>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de, hch@lst.de

On 27.11.2015 03:58, Ching Huang wrote:
> On Thu, 2015-11-26 at 11:46 -0800, Joe Perches wrote:
>> On Thu, 2015-11-26 at 19:41 +0800, Ching Huang wrote:
>>> split dma resource allocation and io register assignment from get_config to a new function arcmsr_alloc_io_queue.
>> trivia:
>>
>>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
>> []
>>> +static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
>>> +{
>> []
>>> +		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
>>> +			&dma_coherent_handle, GFP_KERNEL);
>>> +		if (!dma_coherent){
>>> +			pr_notice("arcmsr%d: DMA allocation failed.\n", acb->host->host_no);
>>> +			return false;
>>> +		}
>>> +		memset(dma_coherent, 0, acb->roundup_ccbsize);
>>>
>> There is a dma_zalloc_coherent
>>
>> (and even more trivially)
>>
>> Most all of your error messages don't use periods.
> Thanks Joe.
> Revised as below.
>
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


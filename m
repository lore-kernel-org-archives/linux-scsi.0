From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: use GFP_ATOMIC with dma_alloc_coherent in
 map_sg_data
Date: Thu, 10 Jan 2019 12:11:53 -0800
Message-ID: <1214b6b5-92f2-7789-7530-36a0d16323c5@linux.vnet.ibm.com>
References: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <20190110150703.GA26696@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190110150703.GA26696@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/10/2019 07:07 AM, Christoph Hellwig wrote:
> On Wed, Jan 09, 2019 at 06:58:56PM -0800, Tyrel Datwyler wrote:
>> While mapping DMA for scatter list when a scsi command is queued the
>> existing call to dma_alloc_coherent() in our map_sg_data() function
>> passes zero for the gfp_flags parameter. We are most definitly in atomic
>> context at this point as queue_command() is called in softirq context
>> and further we have a spinlock holding the scsi host lock.
>>
>> Fix this by passing GFP_ATOMIC to dma_alloc_coherent() to prevent any
>> sort of sleeping in atomic context deadlock.
> 
> This is a pretty clear sign you should not be using dma_alloc_coherent
> to start with.  GFP_ATOMIC support in many of the implementations either
> doesn't work at all or is severly constrained.  Given that the
> descriptor is written by the OS and read by the hardware exactly once
> there is no point in having the coherent mapping to start with.
> 

This allocation isn't a single use allocation. The driver is just lazy about allocating our ext_list area for large SG lists (ie. SG_ALL). When the driver was first written it only supported up to 10 indirect SRP buffers. James Bottemley added the large SG support back in 2005 with the commit referenced here in the fixes tag "4dddbc26c389". We only allocate the ext_list when we come across a SG list requiring more than 10 indirect buffers. Once allocated we will reuse if already allocated.

-Tyrel

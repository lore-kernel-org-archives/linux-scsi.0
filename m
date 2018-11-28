From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Nov 27 (scsi/aha1542)
Date: Tue, 27 Nov 2018 23:11:23 -0800
Message-ID: <3b57ed57-102e-ec3a-f68c-480252b9060f@infradead.org>
References: <20181127152539.55426063@canb.auug.org.au>
 <ef9090cf-e86a-7fd0-dfa9-6810eaaf7e65@infradead.org>
 <20181128153847.08ead1c9@canb.auug.org.au>
 <1543383684.3518.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543383684.3518.2.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 11/27/18 9:41 PM, James Bottomley wrote:
> On Wed, 2018-11-28 at 15:38 +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> On Tue, 27 Nov 2018 20:14:58 -0800 Randy Dunlap <rdunlap@infradead.or
>> g> wrote:
>>>
>>> On 11/26/18 8:25 PM, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20181126:
>>>>   
>>>
>>> on i386:
>>>
>>> ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!
>>>
>>> somewhere in aha1542_interrupt() according to objdump.
>>
>> Presumably caused by commit
>>
>>   1794ef2b150d ("scsi: aha1542: convert to DMA mapping API")
> 
> Yes, it's because dma_addr_t can be u64 on pae systems but
> isa_virt_to_bus only ever returns unsigned long (because an ISA
> physical address can only be 24 bits).
> 
> I think this is the fix; there doesn't seem to be much point converting
> to do_div given all the limitations.
> 
> James

Yes, that works.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
> 
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index a9c29757172f..afb693d7b44f 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -325,7 +325,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
>  			return IRQ_HANDLED;
>  		};
>  
> -		mbo = (scsi2int(mb[mbi].ccbptr) - aha1542->ccb_handle) / sizeof(struct ccb);
> +		mbo = (scsi2int(mb[mbi].ccbptr) - (unsigned long)aha1542->ccb_handle) / sizeof(struct ccb);
>  		mbistatus = mb[mbi].status;
>  		mb[mbi].status = 0;
>  		aha1542->aha1542_last_mbi_used = mbi;
> 


-- 
~Randy

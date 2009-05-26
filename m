From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
Date: Tue, 26 May 2009 19:28:14 +0300
Message-ID: <4A1C189E.1070200@panasas.com>
References: <20090526062952.GB11363@kernel.dk>	 <20090526162545U.fujita.tomonori@lab.ntt.co.jp>	 <20090526073229.GC11363@kernel.dk>	 <20090526163823U.fujita.tomonori@lab.ntt.co.jp> <1243349222.2815.22.camel@localhost.localdomain> <4A1C14F3.5090209@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755856AbZEZQ2a@vger.kernel.org>
In-Reply-To: <4A1C14F3.5090209@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, rdreier@cisco.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/26/2009 07:12 PM, Boaz Harrosh wrote:
> On 05/26/2009 05:47 PM, James Bottomley wrote:
>> There are several other approaches:
>>
>>      1. Keep the sense buffer packed in the command but disallow DMA to
>>         it, which fixes all the alignment problems.  Then we supply a
>>         set of rotating DMA buffers to drivers which need to do the DMA
>>         (which isn't the majority).
> 
> This one is not possible because it is scsi-ml in majority of cases that
> does the DMA request through scsi_eh_prep_cmnd() and a regular read.
> The drivers don't even know anything about it.
> 

I retract that no, yes and scsi-ml is one more possible client of
the "rotating DMA buffers"

>>      2. Sense is a comparative rarity, so us a more compact pooling
>>         scheme and discard sense for reuse as soon as we know it's not
>>         used (as in at softirq time when there's no sense collected).
>>
> 
> This is the way to go for sure. And only on ARCHs with none-coherent-cache
> all the good ARCHs can just use embedded sense just fine.
> 
>> I'd need a little more clarity on the actual size of the problem before
>> making any choices.
>>
>> The other thing to bear in mind is that two allocations of M and N might
>> be more costly than a single allocation of N+M; however, an allocation
>> of M+N+extra can end up more costly if the extra causes more page
>> reclaim before we get an actual command.
>>
>> James
>>
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

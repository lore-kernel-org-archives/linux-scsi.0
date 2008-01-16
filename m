From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH v2] use dynamically allocated sense buffer
Date: Wed, 16 Jan 2008 14:35:50 +0200
Message-ID: <478DFA26.2020706@panasas.com>
References: <20080115182342Q.fujita.tomonori@lab.ntt.co.jp> <1200410457.9273.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa7.bezeqint.net ([192.115.104.21]:47483 "EHLO sa7.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbYAPNSW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 08:18:22 -0500
In-Reply-To: <1200410457.9273.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, tomof@acm.org

On Jan. 15, 2008, 17:20 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-01-15 at 18:23 +0900, FUJITA Tomonori wrote:
>> This is the second version of
>>
>> http://marc.info/?l=linux-scsi&m=119933628210006&w=2
>>
>> I gave up once, but I found that the performance loss is negligible
>> (within 1%) by using kmem_cache_alloc instead of mempool.
>>
>> I use scsi_debug with fake_rw=1 and disktest (DIO reads with 8
>> threads) again:
>>
>> scsi-misc (slub)         | 486.9 MB/s  IOPS 124652.9/s
>> dynamic sense buf (slub) | 483.2 MB/s  IOPS 123704.1/s
>>
>> scsi-misc (slab)         | 467.0 MB/s  IOPS 119544.3/s
>> dynamic sense buf (slab) | 468.7 MB/s  IOPS 119986.0/s
>>
>> The results are the averages of three runs with a server using two
>> dual-core 1.60 GHz Xeon processors with DDR2 memory.
>>
>>
>> I doubt think that someone will complain about the performance
>> regression due to this patch. In addition, unlike scsi_debug, the real
>> LLDs allocate the own data structure per scsi_cmnd so the performance
>> differences would be smaller (and with the real hard disk overheads).
>>
>> Here's the full results:
>>
>> http://www.kernel.org/pub/linux/kernel/people/tomo/sense/results.txt
> 
> Heh, that's one of those good news, bad news things.  Certainly good
> news for you.  The bad news for the rest of us is that you just
> implicated mempool in a performance problem  and since they're the core
> of the SCSI scatterlist allocations and sit at the heart of the critical
> path in SCSI, we have a potential performance issue in the whole of
> SCSI.

Looking at mempool's code this is peculiar as what seems to be its
critical path for alloc and free looks pretty harmless and lightweight.
Maybe an extra memory barrier, spin_{,un}lock_* and two extra function call
(one of them can be eliminated BTW if the order of arguments to the
mempool_{alloc,free}_t functions were the same as for kmem_cache_{alloc,free}).

Benny

> 
> James


From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Tue, 15 Jul 2008 10:37:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-parisc-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>> This bug could happen on alpha, parisc, and sparc, which use VMERGE.
>>
>> Parisc doesn't use virtual merge accounting (there is variable for it but
>> it's always 0).
>
> Hmm, really? Looks like PARISC IOMMUs (ccio-dma.c and sba_iomm.c) set
> parisc_vmerge_boundary (CC'ed PARISC mailing list).

That's right, I looked only at arch and include.

>> On sparc64 it is broken anyway with or without your patch.
>
> Yeah, we need to modify SPARC64 IOMMU code (I'm not sure that it's
> worth). Right now, the best fix is setting BIO_VMERGE_BOUNDARY to 0.

Even if we fix it now, the question is: how long it will stay fixed? Until 
someone makes another change to struct device that restricts boundaries on 
some wacky hardware.

Mikulas

>> And alpha alone doesn't justify substantial code bloat in generic block
>> layer. So I propose this patch to drop it at all.
>
> Jens, what do you think about removing VMERGE code?
>

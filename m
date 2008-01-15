From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] use dynamically allocated sense buffer
Date: Tue, 15 Jan 2008 09:20:57 -0600
Message-ID: <1200410457.9273.10.camel@localhost.localdomain>
References: <20080115182342Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53306 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYAOPU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 10:20:59 -0500
In-Reply-To: <20080115182342Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org


On Tue, 2008-01-15 at 18:23 +0900, FUJITA Tomonori wrote:
> This is the second version of
> 
> http://marc.info/?l=linux-scsi&m=119933628210006&w=2
> 
> I gave up once, but I found that the performance loss is negligible
> (within 1%) by using kmem_cache_alloc instead of mempool.
> 
> I use scsi_debug with fake_rw=1 and disktest (DIO reads with 8
> threads) again:
> 
> scsi-misc (slub)         | 486.9 MB/s  IOPS 124652.9/s
> dynamic sense buf (slub) | 483.2 MB/s  IOPS 123704.1/s
> 
> scsi-misc (slab)         | 467.0 MB/s  IOPS 119544.3/s
> dynamic sense buf (slab) | 468.7 MB/s  IOPS 119986.0/s
> 
> The results are the averages of three runs with a server using two
> dual-core 1.60 GHz Xeon processors with DDR2 memory.
> 
> 
> I doubt think that someone will complain about the performance
> regression due to this patch. In addition, unlike scsi_debug, the real
> LLDs allocate the own data structure per scsi_cmnd so the performance
> differences would be smaller (and with the real hard disk overheads).
> 
> Here's the full results:
> 
> http://www.kernel.org/pub/linux/kernel/people/tomo/sense/results.txt

Heh, that's one of those good news, bad news things.  Certainly good
news for you.  The bad news for the rest of us is that you just
implicated mempool in a performance problem  and since they're the core
of the SCSI scatterlist allocations and sit at the heart of the critical
path in SCSI, we have a potential performance issue in the whole of
SCSI.

James



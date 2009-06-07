From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Sun, 7 Jun 2009 19:45:12 +0900
Message-ID: <20090607194506J.fujita.tomonori@lab.ntt.co.jp>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	<20090605104132.GE24836@amd.com>
	<20090607081305.GA12497@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46532 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZFGKpn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Jun 2009 06:45:43 -0400
In-Reply-To: <20090607081305.GA12497@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, torvalds@linux-foundation.org, lethal@linux-sh.org, just.for.lkml@googlemail.com, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 7 Jun 2009 10:13:05 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > 
> > On Fri, Jun 05, 2009 at 05:33:14PM +0900, FUJITA Tomonori wrote:
> > > dma-debugs wrongly assumes that no multiple DMA transfers are
> > > performed against the same dma address on one device at the same
> > > time. However it's true only with hardware IOMMUs. For example, an
> > > application can easily send the same buffer twice with different
> > > lengths to one device by using DIO and AIO. If these requests are not
> > > unmapped in the same order in which they were mapped,
> > > hash_bucket_find() finds a wrong entry and gives a false warning.
> > > 
> > > We should fix this before 2.6.30 release. Seems that there is no
> > > easy way to fix it. I think that it's better to just disable
> > > dma-debug for now.
> > > 
> > > Torsten Kaiser found this bug with the RAID1 configuration:
> > > 
> > > http://marc.info/?t=124336541900008&r=1&w=2
> > > 
> > 
> > Argh, I never thought that this can happen. But its not explicitly 
> > forbidden so we have to handle this situation. Thanks for tracking 
> > down the bug to this issue.
> >
> > However, I think there is a somehow simple fix for the issue. 
> > Patch is attached. Its the least intrusive way I can think of to 
> > fix this problem.
> >
> > But its up to Linus/Ingo to decide if it can be accepted at this 
> > very late point in the cycle. Since dma-debug is new with 2.6.30 
> > it will at least not introduce any regression. [...]
> 
> I think it's too late for v2.6.30 to do any of the changes - and the 
> DMA debug facility is off by default.

Fedora enables it by default and seems that we got some bogus bug
reports. I like not to see any bogus bug reports about v2.6.30. So I
prefer to disable dma-debug feature.


> Also, i think such DMA patterns, while 'allowed' can be quite 
> dangerous as its such a rare usage combination really. AIO and DIO 
> are crazy to begin with, mixing AIO and DIO for the same buffer is 
> madness square two. (It can result in 3 agents for the same memory 
> address: CPU, dma1 and dma2. How many interesting chipset erratums 
> could there be related to such scenarios?)

As Torsten pointed out, this bug happens on common and sane
configurations. And if you want to write the same contents to two
places on disk, AIO and DIO is a reasonable solution, I think.


> But it is certainly not the task of a debug facility to restrict 
> existing user-visible ABIs, so fixing the false positive is correct.
> 
> So i've applied your fix to the iommu branch for v2.6.31 and marked 
> it for -stable backporting, that way 2.6.30.1 will be able to pick 
> the patch up (if it remains problem-free in testing).
> 

Joerg patch weakens the checking capability. IMHO, it's the wrong
direction.

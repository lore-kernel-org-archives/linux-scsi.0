From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 06 Feb 2008 21:07:35 +0300
Message-ID: <47A9F767.9080402@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<47A751C5.60600@vlnb.net>	<1202149322.3096.66.camel@localhost.localdomain>	<47A75B8A.3020503@vlnb.net>	<1202151293.3096.80.camel@localhost.localdomain>	<47A8B210.8040202@vlnb.net> <1202238802.3133.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:40782 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYBFSHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 13:07:40 -0500
In-Reply-To: <1202238802.3133.71.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

James Bottomley wrote:
> On Tue, 2008-02-05 at 21:59 +0300, Vladislav Bolkhovitin wrote:
> 
>>>>Hmm, how can one write to an mmaped page and don't touch it?
>>>
>>>I meant from user space ... the writes are done inside the kernel.
>>
>>Sure, the mmap() approach agreed to be unpractical, but could you 
>>elaborate more on this anyway, please? I'm just curious. Do you think 
>>about implementing a new syscall, which would put pages with data in the 
>>mmap'ed area?
> 
> No, it has to do with the way invalidation occurs.  When you mmap a
> region from a device or file, the kernel places page translations for
> that region into your vm_area.  The regions themselves aren't backed
> until faulted.  For write (i.e. incoming command to target) you specify
> the write flag and send the area off to receive the data.  The gather,
> expecting the pages to be overwritten, backs them with pages marked
> dirty but doesn't fault in the contents (unless it already exists in the
> page cache).  The kernel writes the data to the pages and the dirty
> pages go back to the user.  msync() flushes them to the device.
> 
> The disadvantage of all this is that the handle for the I/O if you will
> is a virtual address in a user process that doesn't actually care to see
> the data. non-x86 architectures will do flushes/invalidates on this
> address space as the I/O occurs.

I more or less see, thanks. But (1) pages still needs to be mmaped to 
the user space process before the data transmission, i.e. they must be 
zeroed before being mmaped, which isn't much faster, than data copy, and 
(2) I suspect, it would be hard to make it race free, e.g. if another 
process would want to write to the same area simultaneously

>>>However, as Linus has pointed out, this discussion is getting a bit off
>>>topic. 
>>
>>No, that isn't off topic. We've just proved that there is no good way to 
>>implement zero-copy cached I/O for STGT. I see the only practical way 
>>for that, proposed by FUJITA Tomonori some time ago: duplicating Linux 
>>page cache in the user space. But will you like it?
> 
> Well, there's no real evidence that zero copy or lack of it is a problem
> yet.

The performance improvement from zero copy can be easily estimated, 
knowing the link throughput and data copy throughput, which are about 
the same for 20Gbps links (I did that few e-mail ago).

Vlad

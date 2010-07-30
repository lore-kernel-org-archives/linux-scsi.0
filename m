From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 16:46:12 +0400
Message-ID: <4C52C994.2040405@vlnb.net>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab0G3Mqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2010 08:46:32 -0400
In-Reply-To: <20100729200327.GA17767@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Christoph Hellwig, on 07/30/2010 12:03 AM wrote:
> On Thu, Jul 29, 2010 at 02:59:51PM -0500, James Bottomley wrote:
>> That's basically everything FUA ... you might just as well switch your
>> cache to write through and have done.
>>
>> This, by the way, is one area I'm hoping to have researched on SCSI
>> (where most devices do obey the caching directives).  Actually see if
>> write through without flush barriers is faster than writeback with flush
>> barriers.  I really suspect it is.
>
> We have done the research and at least for XFS a write through cache
> actually is faster for many workloads.  Ric always has workloads where
> the cache is faster, though - mostly doing lots of small file write
> kind of setups.

I supposed, with write back cache you did the queue drain after 
request(s) with ordered requirements, correct? Did you also do the queue 
drain in the same places with write through caching?

Just in case, to be sure the comparison was fair. I can't see why 
sequence of [(write command/internal cache sync) .. (write 
command/internal cache sync)] for write through caching should be faster 
than sequence of [(write command) .. (write command) (cache sync) .. 
(write command) .. (write command) (cache sync)], except if there are 
additional queue flushing (draining) in the latter case. I think we need 
to explain that before doing the next step.

Vlad

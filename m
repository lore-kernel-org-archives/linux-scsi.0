From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 21:40:06 +0400
Message-ID: <4C530E76.6070407@vlnb.net>
References: <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de> <4C52C994.2040405@vlnb.net> <20100730125750.GB26118@lst.de> <4C52CF20.6090404@vlnb.net> <20100730131205.GA27348@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab0G3Rkm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2010 13:40:42 -0400
In-Reply-To: <20100730131205.GA27348@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Christoph Hellwig, on 07/30/2010 05:12 PM wrote:
> On Fri, Jul 30, 2010 at 05:09:52PM +0400, Vladislav Bolkhovitin wrote:
>> Sorry, I can't follow you here. What was the load pattern difference
>> between the tests in the way how the backend device saw it? I thought,
>> it was only in absence of the cache flush commands (SYNCHRONIZE_CACHE?)
>> in the write through case, but looks like there is something more different?
>
> The only difference in commands is that we see no SYNCHRONIZE_CACHE.
> The big picture difference is that we also only drain the queue just
> to undrain it ASAP, instead of keeping it drained over a sequence
> of SYNCHRONIZE_CACHE + WRITE + SYNCHRONIZE_CACHE, which can make
> a huge difference for a device with very low latencies like the SSD
> in my laptop.

It's weird. I can only explain it if:

1. The device fully or particularly lies about write through mode. Under 
"particularly" I mean something like if the response returned when the 
writes "almost" sent to the media.

2. The device has very ineffective SYNCHRONIZE_CACHE implementation. For 
instance, it has relatively slow internal cache scan (you do complete 
cache flush, not only affected by the previous writes blocks, correct?).

It would be good if you performed your test on some software SCSI target 
device, where we can fully control and see what's going on inside.

Vlad

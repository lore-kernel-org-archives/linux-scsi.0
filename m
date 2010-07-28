From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 17:55:08 +0400
Message-ID: <4C5036BC.30709@vlnb.net>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0G1Nzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 09:55:41 -0400
In-Reply-To: <4C4FE860.7000903@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Tejun Heo, on 07/28/2010 12:20 PM wrote:
> On 07/28/2010 10:08 AM, Tejun Heo wrote:
>> Having writeback cache or not doesn't make any difference
>> w.r.t. request ordering requirements.  If filesystems don't need the
>> heavy handed ordering provided by barrier, it should just use flush
>> instead of barrier.  If filesystem needs the barrier ordering, whether
>> the device in question is battery backed and costs more than a house
>> doesn't make any difference.
>
> BTW, if filesystems already have code to order the requests they're
> issuing, it would be *great* to phase out barrier and replace it with
> simple in-stream, non-ordering flush request.  There have been several
> different suggestions about how to improve barrier and most revolved
> around how to transfer more information from filesystem to block layer
> so that block layer can use more relaxed orderign, but the more I
> think about it, it becomes clear that it doesn't belong to block layer
> at all.
>
> The only benefit of doing it in the block layer, and probably the
> reason why it was done this way at all, is making use of advanced
> ordering features of some devices - ordered tag and linked commands.
> The latter is deprecated and the former is fundamentally broken in
> error handling anyway.

Why? SCSI provides ACA and UA_INTLCK which provide all needed facilities 
for errors handling in deep ordered queues.

> Furthermore, although they do relax ordering
> requirements from the device queue side, the level of flexibility is
> significantly lower compared to what filesystems can do themselves.

Can you elaborate more what is not sufficiently flexible in SCSI ordered 
commands, please?

Vlad

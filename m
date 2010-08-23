From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 23 Aug 2010 16:13:36 +0200
Message-ID: <4C728210.6040605@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <20100823140823.GA23490@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0HWOMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 10:12:46 -0400
In-Reply-To: <20100823140823.GA23490@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Ric Wheeler <rwheeler@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "tytso@mit.edu" <tytso@mit.edu>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "swhiteho@redhat.com" <swhiteho@redhat.com>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "vst@vlnb.net" <vst@vlnb.net>, "jack@suse.cz" <jack@suse.cz>, "hare@suse.de" <hare@suse.de>

Hello,

On 08/23/2010 04:08 PM, Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 04:01:15PM +0200, Jens Axboe wrote:
>> The problem purely exists on arrays that report write back cache enabled
>> AND don't implement SYNC_CACHE as a noop. Do any of them exist, or are
>> they purely urban legend?
> 
> I haven't seen it.  I don't care particularly about this case, but once
> it a while people want to disable flushing for testing or because they
> really don't care.
> 
> What about adding a sysfs attribue to every request_queue that allows
> disabling the cache flushing feature?  Compared to the barrier option
> this controls the feature at the right level and makes it available
> to everyone instead of beeing duplicated.  After a while we can then
> simply ignore the barrier/nobarrier options.

Yeah, that sounds reasonable.  blk_queue_flush() can be called anytime
without locking anyway, so it should be really easy to implement too.

Thanks.

-- 
tejun

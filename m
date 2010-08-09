From: Tejun Heo <teheo@suse.de>
Subject: Re: [PATCH REPOST RFC] relaxed barriers
Date: Mon, 09 Aug 2010 16:50:37 +0200
Message-ID: <4C6015BD.6090304@suse.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <4C5C3287.1010404@kernel.org> <4C5D31B2.9080509@suse.de> <20100808143126.GA15531@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46168 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab0HIOvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2010 10:51:40 -0400
In-Reply-To: <20100808143126.GA15531@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org

On 08/08/2010 04:31 PM, Christoph Hellwig wrote:
> On Sat, Aug 07, 2010 at 12:13:06PM +0200, Tejun Heo wrote:
>> The patch was on top of v2.6.35 but was generated against dirty tree
>> and wouldn't apply cleanly.  Here's the proper one.
> 
> Here's an updated version:
> 
>  (a) ported to Jens' current block tree
>  (b) optimize barriers on devices not requiring flushes to be no-ops
>  (b) redo the blk_queue_ordered interface to just set QUEUE_HAS_FLUSH
>      and QUEUE_HAS_FUA flags.

Nice.  I'm working on a properly split patchset implementing
REQ_FLUSH/FUA based interface, which replaces REQ_HARDBARRIER.  Empty
request w/ REQ_FLUSH just flushes cache but has no other ordering
restrictions.  REQ_FLUSH + data means preflush + data write.  REQ_FUA
+ data means data would be committed to NV media on completion.
REQ_FLUSH + FUA + data means preflush + NV data write.  All FLUSH/FUA
requests w/ data are ordered only against each other.  I think I'll be
able to post in several days.

Thanks.

-- 
tejun

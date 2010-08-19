From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Thu, 19 Aug 2010 17:45:51 +0200
Message-ID: <4C6D51AF.3050008@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org> <20100817140734.GA30768@redhat.com> <4C6ABE12.40705@kernel.org> <4C6D0824.3070908@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0HSPuE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 11:50:04 -0400
In-Reply-To: <4C6D0824.3070908@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Hello,

On 08/19/2010 12:32 PM, Kiyoshi Ueda wrote:
>> I see but single pending flush and steady write streams w/o saturating
>> the mempool would be able to stall dm_wait_for_completeion(), no?  Eh
>> well, it's a separate issue, I guess.
> 
> Your understanding is correct, dm_wait_for_completion() for flush
> will stall in such cases for request-based dm.
> That's why I mentioned below in
> https://www.redhat.com/archives/dm-devel/2010-August/msg00026.html.
> 
>     In other words, current request-based device-mapper can't handle
>     other requests while a flush request is in progress.
>
> In flush request handling, request-based dm uses dm_wait_for_completion()
> to wait for the completion of cloned flush requests, depending on
> the fact that there should be only flush requests in flight owning
> to the block layer sequencing.

I see.  bio based implementation also uses dm_wait_for_completion()
but it also has DMF_QUEUE_IO_TO_THREAD to plug all the follow up bio's
while flush is in progress, which sucks for throughput but
successfully avoids starvation.

> It's not a separate issue and we need to resolve it at least.
> I'm still considering how I can fix the request-based dm.

Right, I thought you were talking about REQ_FLUSHes not sycnhronized
against barrier write.  Anyways, yeah, it's a problem.  I don't think
not being able to handle multiple flushes concurrently would be a
major issue.  The problem is not being able to process other
bios/requests while a flush is in progress.  All that's necessary is
making the completion detection a bit more fine grained so that it
counts the number of in flight flush bios/requests and completes when
it reaches zero instead of waiting for all outstanding commands.
Shouldn't be too hard.

Thanks.

-- 
tejun

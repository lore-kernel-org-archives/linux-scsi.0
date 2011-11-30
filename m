From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 30 Nov 2011 05:26:43 -0500
Message-ID: <20111130102643.GA2033@infradead.org>
References: <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
 <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
 <20110928174859.GA21628@redhat.com>
 <20110928175304.GA3985@infradead.org>
 <20110928180905.GB21628@redhat.com>
 <20110928181649.GA27441@infradead.org>
 <CADOQvuM2VP1TsLMAOL+NC-zEypDS2NJGmiN6RFCxmjUT6LqaPA@mail.gmail.com>
 <4ED60302.7000304@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35571
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540Ab1K3K0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 05:26:55 -0500
Content-Disposition: inline
In-Reply-To: <4ED60302.7000304@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Eric Seppanen <eric@purestorage.com>, Christoph Hellwig <hch@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, Nov 30, 2011 at 11:18:42AM +0100, Jens Axboe wrote:
> I agree on a+b, but c is definitely more than debatable. I have yet to
> see a device saturate its bandwidth on 4KB IOS. So merging on the write
> side is always going to be a win.

We shouldn't submit 4k I/O in the first place unless they truely are
random.  If you look at XFS for example you'd basically never see them.
The only small I/O in a typical workloads are individual btree blocks
and AG header updates, which generally can't be merged anyway.  Data I/O
happens in larger chunks generally, as do reads/writes of inodes
(generally in 32k chunks, with plans to go larger).

Note that the merges in the way the are done currently are one of the
most painful bits of the current request_fn based drivers.  They require
the addition of the struct request data structure, which needs to be
allocated and initialized for every bio, no matter if it's beeing merged
or not, and are the prime reason why make_request_fn and request_fn
style drivers can't operate on the same data structures.

I've been wondering if it would be possible to simply chain bios for
merging, and while it's theoretically possible I'm wondering about
the impact on drivers.  Fortunately scsi drivers generally don't touch
struct request directly, so it might be doable.

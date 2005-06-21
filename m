From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC]: performance improvement by coalescing requests?
Date: Tue, 21 Jun 2005 09:28:22 +0200
Message-ID: <20050621072822.GE9020@suse.de>
References: <60807403EABEB443939A5A7AA8A7458B01520F3F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:4497 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262037AbVFUH1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 03:27:04 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520F3F@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jun 20 2005, Salyzyn, Mark wrote:
> Jens Axboe [mailto:axboe@suse.de] writes:
> > You say io, but I guess you mean writes in particular?
> 
> Read or writes. One of the test cases was:
> 
> dd if=/dev/sda of=/dev/null bs=512b
> 
> would break apart into 64 4K reads with no completion dependencies
> between them.

That's a silly test case though, because you are intentionally issuing
io in a really small size. Do you have any real world cases?

If you do

dd if=/dev/zero of=/dev/sda bs=512b

and see lots of small requests, then that would be more strange. Can you
definitely verify this is what happens?

> > Or for any substantial amount of io, you would be queueing it so fast
> > that it should have plenty of time to be merged
> > until the drive sucks them in.
> 
> Did I mention that this problem started occurring when we increased the
> aacraid adapter and driver performance last year? We managed to suck the
> requests in faster. Sadly (from the perspective of Adaptec pride in our
> hardware controllers ;-> ), the scsi_merge layer is more efficient at
> coalescing the requests than the adapter's Firmware solely because of
> the PCI bus bandwidth used.
> 
> I must admit that the last time I did this instrumented test was in the
> 2.6.3 timeframe with SL9.1. This 'plugging' you are talking about, when
> did it make it into the scsi layer? Sounds like I need to retest,
> certainly a good result of opening my mouth to start this thread.

The plugging is a block layer property, it's been in use for ages (since
at least 2.0, I forget when it was originall introduced).

> > And a few ms should be enough time to queue that amount many many
> > times over.
> 
> The adapter can suck in 256 requests within a single ms.

I'm sure it can, I'm also sure that you can queue io orders of magnitude
faster than you can send them to hardware!

-- 
Jens Axboe


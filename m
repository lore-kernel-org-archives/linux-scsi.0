From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [RFC]: performance improvement by coalescing requests?
Date: Mon, 20 Jun 2005 16:48:33 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520F3F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:32134 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261570AbVFTUtT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 16:49:19 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Jens Axboe [mailto:axboe@suse.de] writes:
> You say io, but I guess you mean writes in particular?

Read or writes. One of the test cases was:

dd if=/dev/sda of=/dev/null bs=512b

would break apart into 64 4K reads with no completion dependencies
between them.

> Or for any substantial amount of io, you would be queueing it so fast
> that it should have plenty of time to be merged
> until the drive sucks them in.

Did I mention that this problem started occurring when we increased the
aacraid adapter and driver performance last year? We managed to suck the
requests in faster. Sadly (from the perspective of Adaptec pride in our
hardware controllers ;-> ), the scsi_merge layer is more efficient at
coalescing the requests than the adapter's Firmware solely because of
the PCI bus bandwidth used.

I must admit that the last time I did this instrumented test was in the
2.6.3 timeframe with SL9.1. This 'plugging' you are talking about, when
did it make it into the scsi layer? Sounds like I need to retest,
certainly a good result of opening my mouth to start this thread.

> And a few ms should be enough time to queue that amount many many
times over.

The adapter can suck in 256 requests within a single ms.

Sincerely -- Mark Salyzyn

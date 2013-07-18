From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 18 Jul 2013 11:51:55 -0700
Message-ID: <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
References: <cover.1369155164.git.agordeev@redhat.com>
	 <20130521235003.GE6985@mtj.dyndns.org>
	 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
	 <20130522170305.GD9563@kernel.dk>
	 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
	 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
	 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
	 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
	 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
	 <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
	 <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56381 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab3GRSqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jul 2013 14:46:32 -0400
In-Reply-To: <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2013-07-17 at 18:19 +0200, Alexander Gordeev wrote:
> On Tue, Jul 16, 2013 at 02:38:03PM -0700, Nicholas A. Bellinger wrote:
> > [    7.927818] scsi_execute(): Calling blk_mq_free_request >>>
> > [    7.927826] scsi 0:0:0:0: Direct-Access     ATA      ST9500530NS      CC03 PQ: 0 ANSI: 5
> > 
> > OK, so INQUIRY response payload is looking as expected here.
> 
> Yep. It is not on the top of my head, but I remember something like INQUIRYs
> are emulated and thus do not have payload.
> 
> > [    7.927960] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> > [    7.927964] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
> > [    7.927965] sd 0:0:0:0: [sda] 0-byte physical blocks
> > 
> > Strange..  READ_CAPACITY appears to be returning a payload as zeros..?
> 
> Yep. Because blk_execute_rq() does not put the proper callback and data do
> not get copied from sg's to bounce buffer. That is why I tried to use
> blk_mq_execute_rq() instead. Once I do that, data start getting read and
> booting stops elsewhere.

Mmmmmm.

The call to blk_queue_bounce() exists within blk_mq_make_request(), but
AFAICT this should still be getting invoked regardless of if the struct
request is dispatched into blk-mq via the modified blk_execute_rq() ->
blk_execute_rq_nowait() -> blk_mq_insert_request() codepath, or directly
via blk_mq_execute_rq()..

Jens..?

> 
> Of course, I was suspecting that change alone is not valid and wondered
> about the status of scsi-mq in the first place, and if more changes are
> coming.

Most certainly.  ;)

> 
> So I it turns out "req->errors + req->resid_len" issue (you described
> earlier) needs to be addressed before going forward with libata (only?).

AFAICT, getting an initial conversion of libata up does not depend upon
this specific issue being addressed first.  I could be wrong however..

> 
> > Not sure why yet some control CDBs are getting back the expected
> > payload, while others are returning zeros..
> 
> Bio buffers do not get updated from callback.
> 
> > Also, looking at the included stack back-trace:
> 
> [...]
> 
> Thanks a lot for these and other your comments, Nicholas!
> 

Sure.  I should have a few extra cycles to hack on this over the
weekend.

Also, thinking about this some more, trying to convert ahci to scsi-mq
first (using QEMU emulation), while keeping a rootfs on PIIX_IDE might
make debugging slightly easier..

--nab


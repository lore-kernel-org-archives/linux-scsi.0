From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 18 Jul 2013 18:30:34 -0600
Message-ID: <20130719003034.GG28005@kernel.dk>
References: <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
 <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
 <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
 <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
 <51E83E32.9050306@cs.wisc.edu>
 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 18 2013, Nicholas A. Bellinger wrote:
> On Thu, 2013-07-18 at 13:12 -0600, Mike Christie wrote:
> > On 07/18/2013 12:51 PM, Nicholas A. Bellinger wrote:
> > > On Wed, 2013-07-17 at 18:19 +0200, Alexander Gordeev wrote:
> > >> On Tue, Jul 16, 2013 at 02:38:03PM -0700, Nicholas A. Bellinger wrote:
> > >>> [    7.927818] scsi_execute(): Calling blk_mq_free_request >>>
> > >>> [    7.927826] scsi 0:0:0:0: Direct-Access     ATA      ST9500530NS      CC03 PQ: 0 ANSI: 5
> > >>>
> > >>> OK, so INQUIRY response payload is looking as expected here.
> > >>
> > >> Yep. It is not on the top of my head, but I remember something like INQUIRYs
> > >> are emulated and thus do not have payload.
> > >>
> > >>> [    7.927960] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> > >>> [    7.927964] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
> > >>> [    7.927965] sd 0:0:0:0: [sda] 0-byte physical blocks
> > >>>
> > >>> Strange..  READ_CAPACITY appears to be returning a payload as zeros..?
> > >>
> > >> Yep. Because blk_execute_rq() does not put the proper callback and data do
> > >> not get copied from sg's to bounce buffer. That is why I tried to use
> > >> blk_mq_execute_rq() instead. Once I do that, data start getting read and
> > >> booting stops elsewhere.
> > > 
> > > Mmmmmm.
> > > 
> > > The call to blk_queue_bounce() exists within blk_mq_make_request(), but
> > > AFAICT this should still be getting invoked regardless of if the struct
> > > request is dispatched into blk-mq via the modified blk_execute_rq() ->
> > > blk_execute_rq_nowait() -> blk_mq_insert_request() codepath, or directly
> > > via blk_mq_execute_rq()..
> > > 
> > 
> > blk_mq_make_request is not called from the blk insert/execute paths.
> > blk_mq_make_request takes a bio and tries to merge it with a request and
> > adds it to the queue. It is only called when the make_request_fn is
> > called like when generic_make_request is called.
> > 
> > blk_mq_insert_request adds a already formed request to the queue. It is
> > already formed so that is why that path does not bounce bios. The
> > bios/pages should already be added within the drivers restrictions. So
> > for the read_cap path, the call to blk_rq_map_kern in scsi_execute does
> > the blk_queue_bounce call.
> > 
> 
> <nod>, just noticed the blk_queue_bounce() in blk_rq_map_kern().  
> 
> Not sure why this doesn't seem to be doing what it's supposed to for
> libata just yet..

How are you make the request from the bio? It'd be pretty trivial to
ensure that it gets bounced properly... blk_mq_execute_rq() assumes a
fully complete request, so it wont bounce anything.

-- 
Jens Axboe


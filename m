From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Thu, 3 Aug 2017 11:13:49 +0800
Message-ID: <20170803031344.GA8327@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-6-ming.lei@redhat.com>
 <1501544074.2466.29.camel@wdc.com>
 <20170801101718.GB31452@ming.t460p>
 <20170801105013.GD31452@ming.t460p>
 <1501600301.2475.1.camel@wdc.com>
 <20170802033135.GB7267@ming.t460p>
 <1501724126.30887.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdHCDOC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Aug 2017 23:14:02 -0400
Content-Disposition: inline
In-Reply-To: <1501724126.30887.3.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, Aug 03, 2017 at 01:35:29AM +0000, Bart Van Assche wrote:
> On Wed, 2017-08-02 at 11:31 +0800, Ming Lei wrote:
> > On Tue, Aug 01, 2017 at 03:11:42PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-08-01 at 18:50 +0800, Ming Lei wrote:
> > > > On Tue, Aug 01, 2017 at 06:17:18PM +0800, Ming Lei wrote:
> > > > > How can we get the accurate 'number of requests in progress' efficiently?
> > > 
> > > Hello Ming,
> > > 
> > > How about counting the number of bits that have been set in the tag set?
> > > I am aware that these bits can be set and/or cleared concurrently with the
> > > dispatch code but that count is probably a good starting point.
> > 
> > It has to be atomic_t, which is too too heavy for us, please see the report:
> > 
> > 	http://marc.info/?t=149868448400003&r=1&w=2
> > 
> > Both Jens and I want to kill hd_struct.in_flight, but looks still no
> > good way. 
> 
> Hello Ming,
> 
> Sorry but I disagree that a new atomic variable should be added to keep track
> of the number of busy requests. Counting the number of bits that are set in
> the tag set should be good enough in this context.

That won't work because the tag set is host wide and shared by all LUNs.


-- 
Ming

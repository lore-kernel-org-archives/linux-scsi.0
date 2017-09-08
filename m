From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Fri, 8 Sep 2017 11:08:00 +0800
Message-ID: <20170908030753.GA5627@ming.t460p>
References: <20170902130840.24609-1-ming.lei@redhat.com>
 <20170902130840.24609-8-ming.lei@redhat.com>
 <20170902131208.GA10940@ming.t460p>
 <1504498405.10804.10.camel@wdc.com>
 <20170904071653.GD7959@ming.t460p>
 <1504539634.3189.15.camel@wdc.com>
 <20170904160813.GA21757@ming.t460p>
 <1504575610.3360.7.camel@wdc.com>
 <20170905022325.GC24787@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753942AbdIHDIP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Sep 2017 23:08:15 -0400
Content-Disposition: inline
In-Reply-To: <20170905022325.GC24787@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>

On Tue, Sep 05, 2017 at 10:23:25AM +0800, Ming Lei wrote:
> On Tue, Sep 05, 2017 at 01:40:11AM +0000, Bart Van Assche wrote:
> > On Tue, 2017-09-05 at 00:08 +0800, Ming Lei wrote:
> > > On Mon, Sep 04, 2017 at 03:40:35PM +0000, Bart Van Assche wrote:
> > > > Have you considered to use the blk-mq "reserved request" mechanism to avoid
> > > > starvation of power management requests instead of making the block layer
> > > > even more complicated than it already is?
> > > 
> > > reserved request is really a bad idea, that means the reserved request
> > > can't be used for normal I/O, we all know the request/tag space is
> > > precious, and some device has a quite small tag space, such as sata.
> > > This way will affect performance definitely.
> > 
> > Sorry but I'm neither convinced that reserving a request for power management 
> > would be a bad idea nor that it would have a significant performance impact nor
> > that it would be complicated to implement. Have you noticed that the Linux ATA
> > implementation already reserves a request for internal use and thereby reduces
> > the queue depth from 32 to 31 (see also ATA_TAG_INTERNAL)? What I would like to
> > know if is whether the performance impact of reserving a request is more or less
> > than 1%.
> 
> Firstly we really can avoid the reservation, why do we have to
> wast one precious tag just for PM, which may never happen on
> one machine from its running. For SATA, the internal tag is for EH,
> I believe the reservation is inevitable.
> 
> Secondly reserving one tag may decrease the concurrent I/O by 1,
> that definitely hurts performance, especially for random I/O. Think
> about why NVMe increases its queue depth so many. Not mention
> there are some devices which have only one tag(.can_queue is 1),
> how can you reserve one tag on this kind of device?
> 
> Finally bad result will follow if you reserve one tag for PM only.
> Suppose it is doable to reserve one tag, did you consider
> how to do that? Tag can be shared in host wide, do you want to
> reserve one tag just for one request_queue?
> 	- If yes, lots of tag can be reserved/wasted for the unusual PM
> 	or sort of commands, even worse the whole tag space of HBA may
> 	not be enough for the reservation if there are lots of LUNs in
> 	this HBA.
> 	
> 	- If not, and you just reserve one tag for one HBA, then all
> 	PM commands share the one reservation. During suspend/resume, all
> 	these PM commands have to run exclusively(serialized) for diskes
> 	attached to the HBA, that will slow down the suspend/resume very
> 	much because there may be lots of LUNs in this HBA.
> 
> That is why I said reserving one tag is really bad, isn't it?

Hi Bart,

Looks I replied or clarified all your questions/comments on this
patchset.

So could you let me know if you still object this approach or
patchset?

If not, I think we need to move on and fix the real issue.

-- 
Ming

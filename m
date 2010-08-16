From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 03/11] block: deprecate barrier and replace
 blk_queue_ordered() with blk_queue_flush()
Date: Mon, 16 Aug 2010 13:38:45 -0700
Message-ID: <4C69A1D5.9000608@goop.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
	<1281616891-5691-4-git-send-email-tj@kernel.org>
	<4C65EC41.1060906@goop.org> <20100814094232.GA12336@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100814094232.GA12336@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>
Cc: "jack@suse.cz" <jack@suse.cz>, "Michael S. Tsirkin" <mst@redhat.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, Pierre Ossman <drzeus@drzeus.cx>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, Alasdair G Kergon <agk@redhat.com>, Stefan Weinhuber <wein@de.ibm.com>, "vst@vlnb.net" <vst@vlnb.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Daniel Stodden <daniel.stodden@citrix.com>, Nick Piggin <npiggin@kernel.dk>, Chris Wright <chrisw@sous-sol.org>, Tejun Heo <tj@kernel.org>, "swhiteho@redhat.com" <swhiteho@redhat.com>, chris.mason@oracle.com
List-Id: linux-scsi@vger.kernel.org

 On 08/14/2010 02:42 AM, hch@lst.de wrote:
> On Fri, Aug 13, 2010 at 06:07:13PM -0700, Jeremy Fitzhardinge wrote:
>>  On 08/12/2010 05:41 AM, Tejun Heo wrote:
>>> Barrier is deemed too heavy and will soon be replaced by FLUSH/FUA
>>> requests.  Deprecate barrier.  All REQ_HARDBARRIERs are failed with
>>> -EOPNOTSUPP and blk_queue_ordered() is replaced with simpler
>>> blk_queue_flush().
>>>
>>> blk_queue_flush() takes combinations of REQ_FLUSH and FUA.  If a
>>> device has write cache and can flush it, it should set REQ_FLUSH.  If
>>> the device can handle FUA writes, it should also set REQ_FUA.
>> Christoph, do these two patches (parts 2 and 3) make xen-blkfront
>> correct WRT barriers/flushing as far as your concerned?
> If all your backends handle a zero-length BLKIF_OP_WRITE_BARRIER request
> it is a fully correct, but rather suboptimal implementation.  To get
> all the benefit of the new non-draining barriers you'll need a new
> If all your backends handle a zero-length BLKIF_OP_FLUSH request that
> only flushes the cache, but has no ordering side effects.

Is the effect of the flush that, once complete, any previously completed
write is guaranteed to be on durable storage, but it is not guaranteed
to have any effect on pending writes?  If so, does it flush writes that
were completed before the flush is issued, or writes that complete
before the flush completes?

>   Note that
> the quite suboptimal here means not as good as the new barrier
> implementation, but it shouldn't be notiably worse than the old one
> for Xen.

OK, thanks.  We can do some testing on that and see if there's a benefit
to adding a flush operation with the appropriate semantics.

    J

From: "Jun'ichi Nomura (NEC)" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/2] lld busy status exporting interface
Date: Mon, 22 Sep 2008 13:49:58 +0900
Message-ID: <48D723F6.8040804@ce.jp.nec.com>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>	<20080919.104854.71084447.k-ueda@ct.jp.nec.com>	<20080919143344.44d1a83e.akpm@linux-foundation.org>	<20080919.191122.102582872.k-ueda@ct.jp.nec.com>
	<20080919164524.295e1f9a.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080919164524.295e1f9a.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, James.Bottomley@HansenPartnership.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Andrew,
(and James, Jens, please let us know your opinions on the possible
 changes described below)

Andrew Morton wrote:
> On Fri, 19 Sep 2008 19:11:22 -0400 (EDT)
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
>>> Back in the days when we first did the backing_dev_info.congested_fn()
>>> logic it was decided that there basically was no single place in which
>>> the congested state could be stored.
>>>
>>> So we ended up deciding that whenever a caller wants to know a
>>> backing_dev's congested status, it has to call in to the
>>> ->congested_fn() and that congested_fn would then call down into all
>>> the constituent low-level drivers/queues/etc asking each one if it is
>>> congested.
>> bdi_lld_congested() also does that using bdi_congested(), which calls
>> ->congested_fn().
>> And only real device drivers (e.g. scsi, ide) set/clear the flag.
>> Stacking drivers like request-based dm don't.
> 
> umm, OK, that should work.
> 
>> So stacking drivers always check the BDI_lld_congested flag of
>> the bottom device of the device stack.
> 
> How does a stacking driver know that the backing_device which it is
> looking at is a "lowest level" device?
> 
> I don't think it does - only the code which implements that device
> knows this, so the stacking driver has to call into that device's
> congested_fn(), yes?

Yes. So the stacking driver calls bdi_congested, which calls
the underlying device's congested_fn if exists, and eventually
checks the bottom device's congestion state.
Translation of multiple devices' congestion status is done by
the congested_fn of the stacking device.
E.g. dm-multipath returns 'not congested' if any of its paths are not
congested.

> In which case one wonders why the state was stored in the
> backing_dev_info at all.  Why not store it in the device-private data
> to avoid confusion and abuse?

It should be possible.
We've just followed the existing scheme of BDI_{read,write}congested
because of their similarity.

I would like to know which part of the patch was your concern:
  1) Exposing set/clear_bdi_lld_congested without explicit comments
     that says they should be used only by bottom-level devices
  2) A new bdi_state, BDI_lld_congested
  3) Use of backing_dev_info for this purpose

If 1), either or both of the followings can be easily done:
  [a] Add a comment in backing-dev.h that says set/clear_bdi_lld_congested
      should be called only from the bottom device
  [b] Move set/clear_bdi_lld_congested from mm/backing-dev.c
      to block/blk-core.c, with renaming to blk_set/clear_lld_congested,
      so that only a block device that knows what it does will set/clear
      the flag

If 2) or 3), I think we need to rewrite the patch in either way of these:
  [c] Add a new strategy function to request_queue and use it instead,
      e.g. q->lld_busy_fn, which is NULL by default.
      Set/clear QUEUE_FLAG_BUSY in request_queue by the bottom device,
      and the block layer will check the flag if q->lld_busy_fn is NULL.
  [d] Similar to [c], except that storing the busy flag in struct scsi_device
      and q->lld_busy_fn() of the scsi device will check that.
      If q->lld_busy_fn is NULL, the block layer will just return
      'not congested'.

Which do you think is better?

>> BDI_[write|read]_congested flags have been using for queue's
>> congestion, so that I/O queueing/merging can be proceeded even if
>> the lld is congested.  So I added a new flag.
> 
> iirc, BDI_read/write_congested predated the introduction of the
> congested_fn() and perhaps should have been removed once we went to the
> congested_fn approach.  But it's been a while since I spent a lot of
> time looking in there.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation

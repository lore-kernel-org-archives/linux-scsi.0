From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH] SCSI: delay run queue if device is blocked in
 scsi_dev_queue_ready()
Date: Mon, 4 Dec 2017 23:48:07 +0000 (UTC)
Message-ID: <pan$2c3c7$7c7c04a5$f22df3ad$bef841cb@applied-asynchrony.com>
References: <20171202163150.1273-1-ming.lei@redhat.com>
        <1512400159.23838.1.camel@wdc.com> <20171204224507.GB6888@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 05 Dec 2017 06:45:08 +0800, Ming Lei wrote:

> On Mon, Dec 04, 2017 at 03:09:20PM +0000, Bart Van Assche wrote:
>> On Sun, 2017-12-03 at 00:31 +0800, Ming Lei wrote:
>> > Fixes: 0df21c86bdbf ("scsi: implement .get_budget and .put_budget for blk-mq")
>> 
>> It might be safer to revert commit 0df21c86bdbf instead of trying to fix all
>> issues introduced by that commit for kernel version v4.15 ...
> 
> What are all issues in v4.15-rc? Up to now, it is the only issue reported,
> and can be fixed by this simple patch, which one can be thought as cleanup
> too.

Even with this patch I've encountered at least one hang that
seemed related. I'm using most of block/scsi-4.15 on top of 4.14 and
the hang in question was on a rotating disk. It could be solved by activating
a different scheduler on the hanging device; all hanging sync/df processes got
unstuck and all was fine again, which leads me to believe that there is at least
one more rare condition where delaying requests (as done in the budget patch)
leads to a hang.

This happened with mq-deadline which I was testing specifically to avoid
any BFQ-related side effects.

I didn't do anything specific to trigger the hang and have not been able
to reproduce it during regular usage.

-h

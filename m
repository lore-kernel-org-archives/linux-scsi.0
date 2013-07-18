From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 18 Jul 2013 15:21:03 -0600
Message-ID: <51E85C3F.8070509@kernel.dk>
References: <cover.1369155164.git.agordeev@redhat.com>  <20130521235003.GE6985@mtj.dyndns.org>  <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>  <20130522170305.GD9563@kernel.dk>  <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>  <1373583637.7397.370.camel@haakon3.risingtidesystems.com>  <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>  <1373692812.7397.625.camel@haakon3.risingtidesystems.com>  <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>  <1374010683.7397.880.camel@haakon3.risingtidesystems.com>  <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>  <1374173515.7397.948.camel@haakon3.risingtidesystems.com> <1374174891.7397.964.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374174891.7397.964.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/18/2013 01:14 PM, Nicholas A. Bellinger wrote:
> On Thu, 2013-07-18 at 11:51 -0700, Nicholas A. Bellinger wrote:
>> On Wed, 2013-07-17 at 18:19 +0200, Alexander Gordeev wrote:
>>> On Tue, Jul 16, 2013 at 02:38:03PM -0700, Nicholas A. Bellinger wrote:
>>>> [    7.927818] scsi_execute(): Calling blk_mq_free_request >>>
>>>> [    7.927826] scsi 0:0:0:0: Direct-Access     ATA      ST9500530NS      CC03 PQ: 0 ANSI: 5
>>>>
>>>> OK, so INQUIRY response payload is looking as expected here.
>>>
>>> Yep. It is not on the top of my head, but I remember something like INQUIRYs
>>> are emulated and thus do not have payload.
>>>
>>>> [    7.927960] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
>>>> [    7.927964] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
>>>> [    7.927965] sd 0:0:0:0: [sda] 0-byte physical blocks
>>>>
>>>> Strange..  READ_CAPACITY appears to be returning a payload as zeros..?
>>>
>>> Yep. Because blk_execute_rq() does not put the proper callback and data do
>>> not get copied from sg's to bounce buffer. That is why I tried to use
>>> blk_mq_execute_rq() instead. Once I do that, data start getting read and
>>> booting stops elsewhere.
>>
>> Mmmmmm.
>>
>> The call to blk_queue_bounce() exists within blk_mq_make_request(), but
>> AFAICT this should still be getting invoked regardless of if the struct
>> request is dispatched into blk-mq via the modified blk_execute_rq() ->
>> blk_execute_rq_nowait() -> blk_mq_insert_request() codepath, or directly
>> via blk_mq_execute_rq()..
>>
>> Jens..?
>>
> 
> Actually sorry, your right.  A call to blk_mq_insert_request() for
> REQ_TYPE_BLOCK_PC will not invoke blk_queue_bounce() located near the
> top of blk_mq_execute_rq(), which means that only REQ_TYPE_FS is
> currently using bounce buffers, if required.
> 
> Need to think a bit more about what to do here for REQ_TYPE_BLOCK_PC
> bounce buffer special case with blk_execute_rq(), but I'm thinking that
> blk_mq_execute_rq() should really not be used here..
> 
> Jens..?

It needs to be pre-bounced, blk-mq will only bounce incoming bios and
not requests merely added to the queue(s). Might be useful to add an
equiv blk_mq_make_request() for this.

-- 
Jens Axboe

From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
 4.17.0-x64-08428-g7d3bf613e99a
Date: Thu, 14 Jun 2018 11:12:01 +0800
Message-ID: <b9942f20-9949-ebd8-b574-e4730a12b0ae@oracle.com>
References: <201806091606.51078.randrianasulu@gmail.com>
 <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org>
 <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com>
 <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
 <20180613140411.GA32701@lst.de>
 <09e8bd7605febd091679172d68ca1e9ca3990c91.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09e8bd7605febd091679172d68ca1e9ca3990c91.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "randrianasulu@gmail.com" <randrianasulu@gmail.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph and Bart

On 06/13/2018 10:08 PM, Bart Van Assche wrote:
> On Wed, 2018-06-13 at 16:04 +0200, hch@lst.de wrote:
>>> I suspect this is due to we could expire a same request twice or even more.
>>> For scsi mid-layer, it return BLK_EH_DONE from .timeout, in fact, the request is not
>>> completed there, but just queue a delayed abort_work (HZ/100). If the blk_mq_timeout_work
>>> runs again before the abort_work, the request will be timed out again, because there is not
>>> any mark on it to identify this request has been timed out.
>>>
>>> Would please try the patch attached on to see whether this issue could be fixed ?
>>> (this patch only works for scsi device currently)
>>
>> The patch isn't really going to work without a caller of your new
>> __blk_mq_complete_request helper, is it?> 
> __blk_mq_complete_request() is already called today by blk_mq_complete_request().
> However, it's not clear to me why that function is exported by Jianchao's patch.
> 

Sorry for the confusion about this path.

In the current blk-mq timeout mechanism of 4.18, the reference count of request only ensure the request tag
will not be release during the timeout handing, this is a great idea to fix the life recycle issue.

But we don't protect the timed out request against the normal completion path.
For example, if a request is in scsi abort or eh procedure, it still could be completed by the normal completion path.
Before this, blk_mq_complete_request cannot proceed to invoke __blk_mq_complete_request if a request is timed out,
because we have marked 'completed' or 'aborted_gstate' when we find the request is timed out. In the blk-legacy, we
still do this with blk_mark_request_complete in blk_rq_check_expired and blk_complete_request.

The patch I posted here is to change the request state to MQ_RQ_COMPLETE if it is timed out, then we could protect
the timed out request against the normal request again. But we have handed the task of completing a timed out request to LLDD, and blk_mq_complete_request cannot work any more, so I exported __blk_mq_complete_request here for the time out path of LLDD to complete the request. There is another patch to replace the blk_mq_complete_request to __blk_mq_complete_request, but I did't post here due to this is just a test.

For scsi mid-layer, the scsi_mq_done will invoke blk_mq_complete_request, the abort and eh procedure will finally invoke blk_mq_requeue_request and blk_mq_end_request, so the this patch should work for scsi.

Thanks
Jianchao

>> Either way the concept of doing error handling without quiescing the
>> queue just looks bogus to me and will end up with some sort of race
>> here or there.
> 
> The SCSI error handler already waits until all pending requests have finished
> before it starts handling timed out commands. This e-mail thread started with a
> report of a crash in the SCSI error handler, which is a regression introduced in
> the v4.18 merge window.
> 
> Bart.
> 

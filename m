From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] scsi-mq: fix hw queue hang caused by timeout
Date: Fri, 19 Sep 2014 22:18:48 +0800
Message-ID: <CACVXFVN1juQnXNkRvi5gHX89y-Eqr_Y7bLbOwHS-Shc5MKeHqg@mail.gmail.com>
References: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
	<20140918163549.GB3950@lst.de>
	<541B105E.1030507@fb.com>
	<CACVXFVP18pgz03LSwab-n2tKMAT15JmuF7Eh_O+q9TOHmhj2Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVP18pgz03LSwab-n2tKMAT15JmuF7Eh_O+q9TOHmhj2Qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 19, 2014 at 9:07 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Fri, Sep 19, 2014 at 1:03 AM, Jens Axboe <axboe@fb.com> wrote:
>> On 2014-09-18 10:35, Christoph Hellwig wrote:
>>>
>>> On Thu, Sep 18, 2014 at 11:59:10PM +0800, Ming Lei wrote:
>>>>
>>>> If there are two requests or more timed out, the dispatch queue
>>>> is put into stopped state and never be recoverd, and there
>>>> is no such problem in non-mq mode.
>>>>
>>>> This patch trys to recover the stopped queue when the queue
>>>> becomes unbusy, then the following retries can move on.
>>>>
>>>> Basically this patch maintains same behavior for this situation
>>>> with non-mq mode.
>>>
>>>
>>> This looks somewhat similar to the issues that Doug reported, and I
>>> remember
>>> when he was last running into boot problems it was timeout related, too.
>>>
>>> As far as the implementation is concerned I think the correct fix is
>>> to clear the BLK_MQ_S_STOPPED queue flags in blk_mq_kick_requeue_list.
>>
>>
>> Since that's the kick part of the requeue, auto-starting the queue for that
>> makes a lot of sense. I say that's the way we go.
>
> Yeah, that looks better.
>
> But it doesn't work after the simple change, and I need to
> investigate further.

It is because of the timer miss, now it starts to work.

Thanks,

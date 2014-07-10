From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 15:52:16 +0200
Message-ID: <53BE9A90.8010602@kernel.dk>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com> <53BD9A24.7010203@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net> <20140710062040.GB20146@infradead.org> <20140710133609.GO12478@kvack.org> <53BE97AD.9080306@kernel.dk> <20140710134439.GP12478@kvack.org> <53BE999A.6060309@kernel.dk> <20140710135034.GR12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140710135034.GR12478@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2014-07-10 15:50, Benjamin LaHaise wrote:
> On Thu, Jul 10, 2014 at 03:48:10PM +0200, Jens Axboe wrote:
>> On 2014-07-10 15:44, Benjamin LaHaise wrote:
>>> On Thu, Jul 10, 2014 at 03:39:57PM +0200, Jens Axboe wrote:
>>>> That's how fio always runs, it sets up the context with the exact queue
>>>> depth that it needs. Do we have a good enough understanding of other aio
>>>> use cases to say that this isn't the norm? I would expect it to be, it's
>>>> the way that the API would most obviously be used.
>>>
>>> The problem with this approach is that it works very poorly with per cpu
>>> reference counting's batching of references, which is pretty much a
>>> requirement now that many core systems are the norm.  Allocating the bare
>>> minimum is not the right thing to do today.  That said, the default limits
>>> on the number of requests probably needs to be raised.
>>
>> Sorry, that's a complete cop-out. Then you handle this internally,
>> allocate a bigger pool and cap the limit if you need to. Look at the
>> API. You pass in the number of requests you will use. Do you expect
>> anyone to double up, just in case? Will never happen.
>>
>> But all of this is side stepping the point that there's a real bug
>> reported here. The above could potentially explain the "it's using X
>> more CPU, or it's Y slower". The above is a softlock, it never completes.
>
> I'm not trying to cop out on this -- I'm asking for a data point to see
> if changing the request limits has any effect.

Fair enough, if the question is "does it solve the regression", then 
it's a valid data point. Rob/Doug, for fio, you can just double the 
iodepth passed in in engines/libaio:fio_libaio_init() and test with that 
and see if it makes a difference.

-- 
Jens Axboe

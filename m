From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: bnx2i kthread madness
Date: Wed, 28 Sep 2011 15:07:02 -0500
Message-ID: <4E837E66.3040306@cs.wisc.edu>
References: <1317222318.24040.46.camel@twins> <1317230982.3678.1000.camel@ltirv-waie-lx1> <CAO+b5-r68WC7_noWohbRKyCsrzEpdXxHmhD4s1pT4bJ685Gs9Q@mail.gmail.com> <1317234379.3678.1020.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57209 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab1I1UHn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 16:07:43 -0400
In-Reply-To: <1317234379.3678.1020.camel@ltirv-waie-lx1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Peter Zijlstra <peterz@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/28/2011 01:26 PM, Eddie Wai wrote:
> 
> On Wed, 2011-09-28 at 10:33 -0700, Bart Van Assche wrote:
>> On Wed, Sep 28, 2011 at 7:29 PM, Eddie Wai <eddie.wai@broadcom.com> wrote:
>>> On Wed, 2011-09-28 at 08:05 -0700, Peter Zijlstra wrote:
>>>> I accidentally looked at all kthreads in existence on my system and
>>>> found I had:
>>>>
>>>> [iscsi_eh]
>>>> [bnx2i_thread/0]
>>>> [bnx2i_thread/1]
>>>> [bnx2i_thread/2]
>>>> [bnx2i_thread/3]
>>>> [bnx2i_thread/4]
>>>> [bnx2i_thread/5]
>>>> [bnx2i_thread/6]
>>>> [bnx2i_thread/7]
>>>> [bnx2i_thread/8]
>>>> [bnx2i_thread/9]
>>>> [bnx2i_thread/10]
>>>> [bnx2i_thread/11]
>>>> [bnx2i_thread/12]
>>>> [bnx2i_thread/13]
>>>> [bnx2i_thread/14]
>>>> [bnx2i_thread/15]
>>>> [bnx2i_thread/16]
>>>> [bnx2i_thread/17]
>>>> [bnx2i_thread/18]
>>>> [bnx2i_thread/19]
>>>> [bnx2i_thread/20]
>>>> [bnx2i_thread/21]
>>>> [bnx2i_thread/22]
>>>> [bnx2i_thread/23]
>>>>
>>>> This left me wondering why, because I most certainly am not using iSCSI.
>>>> I don't even know why its enabled in my .config (and it won't be long).
>>>>
>>>> Please fix this muck to not create useless threads.
>>>
>>> Point noted.  In the current bnx2i driver, one kthread is created per
>>> cpu core upon module init (and destroyed upon module exit).  The
>>> kthreads are meant only to improve I/O performance when iSCSI is
>>> employed.  Otherwise, I agree that they should not exist.
>>
>> Why doesn't bnx2i use one of the system work queues defined in
>> <linux/workqueue.h> ?
> We defined our own kthreads instead is mainly because we felt that work
> queues might not have the response time we like to handle I/O
> completions under heavy stress environments as we migrated from
> tasklets.  Although we really haven't yet quantified this assumption.


bnx2fc and fcoe have the same issue. qla2xxx seems to use workqueues and
is ok.

If perf is a issue then like have I said before when this patch was
submitted, and when the fcoe and bnx2fc ones were too, :) I think you
need to change blkiopoll to do what you actually want.

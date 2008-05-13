From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Tue, 13 May 2008 20:47:47 +0400
Message-ID: <4829C633.2090301@vlnb.net>
References: <200805021638.42972.bart.vanassche@gmail.com>	<20080502153306.GB7376@infradead.org>	<e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>	<20080502155525.GA16353@infradead.org>	<e2e108260805040830i7d797c53o9757bae7243d6e27@mail.gmail.com>	<e2e108260805080802r1ad75926idc8654e2acfe014f@mail.gmail.com> <1210262043.12678.9.camel@blackadder>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:47195 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbYEMQrs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 12:47:48 -0400
In-Reply-To: <1210262043.12678.9.camel@blackadder>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Redlich <agr@powerkom-dd.de>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Arne Redlich wrote:
> Am Donnerstag, den 08.05.2008, 17:02 +0200 schrieb Bart Van Assche:
>> On Sun, May 4, 2008 at 5:30 PM, Bart Van Assche
>> <bart.vanassche@gmail.com> wrote:
>>> On Fri, May 2, 2008 at 5:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
>>>> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>>>>> Regarding scsi_execute_async(): I didn't know that this API is on its
>>>>> way out. What will it be replaced by, and when ?
>>>> blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
>>>> ontop to build requests.
>>> Source reading learned me that the function scsi_execute_async() calls
>>> blk_execute_rq_nowait() with 1 as fourth argument, which means that
>>> the request is inserted at the head of the queue. This means that
>>> requests queued with scsi_execute_async() are executed before other
>>> queued requests, and that this function has LIFO (last in first out)
>>> semantics.
>>>
>>> All non-SCSI calls to blk_execute_rq() / blk_execute_rq_nowait() add
>>> requests at the end of the queue (except those calls for terminating
>>> I/O).
>>>
>>> What is the background of this special behavior of the SCSI subsystem ?
>> Is the linux-scsi mailing list the appropriate mailing list to post
>> questions like the above ?
> 
> I guess this should
>  http://marc.info/?l=linux-scsi&m=116668527804801&w=2
> answer your question.

Thanks for pointing on it. There were another threads about that, e.g. 
http://thread.gmane.org/gmane.linux.scsi/16498/focus=16784. So, there 
was an agreement that the current LIFO requests submission behavior is 
inappropriate and a good solution will be to add to scsi_execute_async() 
one more argument to specify where to insert the request, in the tail or 
in the head of the queue. The patch Bart sent basically implements 
exactly that, with the only difference that the new argument passed 
explicitly via new function scsi_execute_async_fifo(). There only thing 
left is to update via another patch other users of scsi_execute_async() 
to use new function, where necessary. Correct?

I wouldn't mind if that will be done after the pending patchset removing 
scsi_execute_async() will be applied for new scsi_execute_async() 
substitute function. But it seems this patchset is pending for pretty 
long time (a half a year? Or even more?). So, what does prevent it from 
being applied? How long more are we going to wait for it?

Vlad

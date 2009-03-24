From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH resend] bsg: Add support for submitting requests at tail
 of queue
Date: Tue, 24 Mar 2009 14:53:52 +0200
Message-ID: <49C8D7E0.9000107@panasas.com>
References: <49C20CCD.5070607@panasas.com>	<49C89CBC.7050306@panasas.com> <20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:55489 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642AbZCXMza (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 08:55:30 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2539724yxl.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 05:55:27 -0700 (PDT)
In-Reply-To: <20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, dgilbert@interlog.com

FUJITA Tomonori wrote:
> On Tue, 24 Mar 2009 10:41:32 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Boaz Harrosh wrote:
>>> Hi Tomo Jens
>>>
>>> Tomo you never ack-by on this patch. I absolutely needs this for the
>>> user-mode API of osd-initiator. Which is needed with up-coming exofs
>>> utilities.
>>>
>>> What do you want to do?
>>>
>>> Thanks 
>>>
>> Hi Jens.
>>
>> I absolutely need this patch for 2.6.30 merge window. It is totally
>> un-dangerous since defaults are left unchanged.
> 
> The question is we really need this feature or not. Though I guess
> that we need to address this starvation issue.
> 

Good, this patch solves exactly that problem. Thanks Tomo
 
> 
>> I need it because the user-mode utilities for osd and exofs that
>> correspond to code in 2.6.30 will need this patch to compile,
>> because they use a flag constant defined in this patch.
> 
> What do the user-mode utilities does for what?
> 

The immediate problem is that the code uses this API and will
not compile without it. This is because the user-mode library
exports the exact API and fixture set as the Kernel one. Submitting
commands in order is one important aspect.

This is a general purpose library for developers to use, with
published API. In the purpose of attracting users to develop for
OSD, so the argument of not yet used does not apply. I don't want
the users to go around inventing work arounds when the solution
is obvious and the blame is clear.

> You always say something like, "we need this for OSD, pNFS or
> something". But I'm not sure you explain the detailed background.
> 

I don't think this argument applies to this particular patch.
The shortcoming of bsg code is clear and should be fixed. And
it has a user. libosd in user-mode.

But if you want details then just calling osd_execute_request_async()
from user-mode in succession, will reveal this problem. Not fixing
it now will hide mines to any developer that wants to use libosd.

> A typical example is, why does the osd library export lots of
> functions that exofs doesn't use with EXPORT_SYMBOL 

This is unrelated to this patch of course, but...
They are all used by the osd_ktest.ko which you objected to
be included in the Kernel, and I removed.

> instead of
> EXPORT_SYMBOL_GPL?

What is that got to do with it?
The libosd.ko is a general purpose library for any kind of user.
It exports the API defined in osd_initiator.h. This API is globally
public, and has until now 3 implementations Linux-kernel, Linux-user-mode,
BSD-kernel. I hope it will have many more implementations on all
major OSs.
I do not designate this API to be private Linux API, hence
EXPORT_SYMBOL_GPL does not apply.

Boaz


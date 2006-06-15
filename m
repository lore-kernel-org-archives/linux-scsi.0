From: Michael Reed <mdr@sgi.com>
Subject: Re: [REPOST][PATCH 1/6] mpt fusion - fibre channel target discovery
 prematurely terminates
Date: Thu, 15 Jun 2006 12:49:45 -0500
Message-ID: <44919DB9.1060002@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D70199836@NAMAIL4.ad.lsil.com> <44917FB9.3010604@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:48285 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030922AbWFORtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 13:49:52 -0400
In-Reply-To: <44917FB9.3010604@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

There's another problem.  The routines doing the wakeup don't have
access to the sleep variable so the thread sleeps forever.

I'll summarize the problems in the original patch so they don't get
lost.
	1) sleep variable must be initialized to zero before sleep
	2) sleep variable must be set non-zero before wakeup
	3) wakeup should be in mpt_free_msg_frame, conditioned
	   on whether frames are exhausted, instead of in
	   mpt_put_msg_frame().  (keep mpt_ioc_activate())

That's probably all I can do on this today.  I'll be OOTO tomorrow
and next week.

Mike


Michael Reed wrote:
> Thanks for finding the problem.  I'll rework James' patch to take
> into account your comments and give it a try.
> 
> Mike
> 
> 
> Moore, Eric wrote:
>> On Thursday, June 15, 2006 8:51 AM, Michael Reed wrote: 
>>
>>>> What overhead?  We don't read config pages on every I/O.  James
>>>> patch only effects the reading of config pages when there is
>>>> a host reset.
>>> I think you're mistaken about James' patch.
>>>
>>> Doesn't every i/o use a message frame?  James' patch to sleep on frame
>>> exhaustion requires a wakeup every time a msg frame is released,
>>> which is performed at the end of mpt_put_msg_frame().  Am I missing
>>> something?
>>>
>>>
>> Ok, my mistake.  I overlooked the wake_up() at the end of
>> mpt_put_msg_frame().
>>
>> BTW, this is incorrect.  The wake_up() should been in
>> mpt_free_msg_frame(), 
>> instead of mpt_put_msg_frame().   The _put_ function is sending the mf
>> to 
>> the firmware.   The mf is not freed untill the command is completd by
>> firmware,
>> and the _free_function is called.  Meaning this issue can be solved by
>> moving 
>> wake_up() to mpt_free_msg_frame(), and only calling wake_up() when the
>> list_empty(&ioc->FreeQ) was empty going into this call.
>>
>> Eric Moore
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

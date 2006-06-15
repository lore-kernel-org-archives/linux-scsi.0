From: Michael Reed <mdr@sgi.com>
Subject: Re: [REPOST][PATCH 1/6] mpt fusion - fibre channel target discovery
 prematurely terminates
Date: Thu, 15 Jun 2006 09:51:19 -0500
Message-ID: <449173E7.5000108@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D70199735@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:33409 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030496AbWFOOvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 10:51:24 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70199735@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Moore, Eric wrote:
> On Wednesday, June 14, 2006 1:00 PM, Mike Reed wrote: 
>> James Bottomley wrote:
>>> I was still thinking of something that made mpt_config() 
>> never return
>>> -EAGAIN.  How does the following work out?  It's my first pass at
>>> sorting out the frame and active logic in mptbase:
> 
...snip...
> 
>> Another comment, for every i/o, this patch introduces overhead.
>> spinlock and checking a list which is empty 99.99[...]% of the time.
>> I'll have to perform an iop measurement to see if there is a
>> measurable impact on system performance.
>>
> 
> What overhead?  We don't read config pages on every I/O.  James
> patch only effects the reading of config pages when there is
> a host reset.

I think you're mistaken about James' patch.

Doesn't every i/o use a message frame?  James' patch to sleep on frame
exhaustion requires a wakeup every time a msg frame is released,
which is performed at the end of mpt_put_msg_frame().  Am I missing
something?


> 
> One concern on this patch.  A possible deadlock situation could
> occur if we run out of message frames.  Meaning there is another way
> that  mpt_get_msg_frame() could return NULL, and that is becuase
> the ioc->FreeQ list is empty.  This patch only addresses the case
> when there is a host reset.   Utimatley we need to address both
> cases when NULL is returned.  Id rather try to come  up with a
> solution where the fix is isolated inside of mpt_get_msg_frame().

James' code handles both frame exhaustion and ioc->active == 0.
But, the only caller to mpt_get_msg_frame() that now sleeps is
mpt_config().

Mike


> 
> Eric Moore
> 

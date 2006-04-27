From: Mark Lord <mlord@pobox.com>
Subject: Re: [PATCH] drivers/scsi/sd.c: fix uninitialized variable in handling
 medium errors
Date: Thu, 27 Apr 2006 12:03:10 -0400
Message-ID: <4450EB3E.7000902@pobox.com>
References: <200604261627.29419.lkml@rtr.ca>	<1146092161.12914.3.camel@mulgrave.il.steeleye.com>	<20060426161444.423a8296.akpm@osdl.org>	<44500033.3010605@rtr.ca> <20060426163536.6f7bff77.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proof.pobox.com ([207.106.133.28]:11962 "EHLO proof.pobox.com")
	by vger.kernel.org with ESMTP id S965164AbWD0QDk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 12:03:40 -0400
In-Reply-To: <20060426163536.6f7bff77.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Mark Lord <lkml@rtr.ca> wrote:
>>> That's if we think -stable needs this fixed.
>> Let's say a bunch of read bio's get coalesced into a single
>> 200+ sector request.  This then fails on one single bad sector
>> out of the 200+.  Without the patch, there is a very good chance
>> that sd.c will simply fail the entire request, all 200+ sectors.
>>
>> With the patch, it will fail the first block, and then retry
>> the remaining blocks.  And repeat this until something works,
>> or until everything has failed one by one.
> 
> Yowch.  I have the feeling that this'll take our EIO-handling time from
> far-too-long to far-too-long*200.
> 
> I am still traumatised by my recent ten-minute wait for a dodgy DVD to
> become ejectable.
> 
> I don't think -stable needs this, personally.

Perhaps, perhaps not.  The current behaviour is semi *random*, though.
Sometimes it may just fail the entire request (wrong!),
sometimes it may do the (almost as wrong) fail a block at a time
from the beginning, until the bad sector is passed, and then succeed
on the remainder.

Ugh.
>> What I need to have happen when a request is failed due to bad-media,
>> is have it split the request into a sequence of single-block requests
>> that are passed to the LLD one at a time.  The ones with real bad
>> sectors will then be independently failed, and the rest will get done.
>>
>> Much better.  Much more complex.

-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com

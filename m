From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Date: Fri, 11 Jan 2013 11:35:31 -0600
Message-ID: <50F04D63.9080703@linux.vnet.ibm.com>
References: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au> <1357889656.3065.2.camel@dabdike.int.hansenpartnership.com> <50F02F4E.4070804@linux.vnet.ibm.com> <1357918637.3065.22.camel@dabdike.int.hansenpartnership.com> <20130111160514.GA10823@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40752 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab3AKRfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2013 12:35:37 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 11 Jan 2013 12:35:36 -0500
In-Reply-To: <20130111160514.GA10823@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Wen Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/11/2013 10:05 AM, Greg KH wrote:
> On Fri, Jan 11, 2013 at 03:37:17PM +0000, James Bottomley wrote:
>> On Fri, 2013-01-11 at 09:27 -0600, Brian King wrote:
>>> It looks like this was a due to the fact that the new patches
>>> added __devinit tags in the same merge window the __devinit tag
>>> itself was getting removed.
>>
>> Not exactly.  The patch which makes them nops went into 3.8.  Now
>> there's a patch queued in, Gregs tree I presume, to remove them all and
>> the #defines which causes the compile failure.
>>
>>> As to the sparse warnings, this patch fixed the ones that
>>> were actual bugs in the new code, although we could have
>>> made that more clear in the patch description.
>>>
>>> http://marc.info/?l=linux-scsi&m=135716576204083&w=2
>>
>> Ah, thanks ... I've been on holiday for a while, so I did miss that.
>>
>>> There is one outstanding issue I am aware of which was an
>>> array bounds compiler warning which looks to be a misdetection
>>> by the compiler. Wendy and I discussed adding a BUG_ON
>>> to stop the compiler from complaining.
>>>
>>> Wendy - lets queue these two changes up ASAP. They should both
>>> be very simple changes.
>>
>> If it's a simple gcc bug, just ignore it.
>>
>> I do need you to redo the patches to remove the __dev annotations,
>> though.  We can't risk introducing a bisect killing compile breakage if
>> Greg's tree merges before mine in the next merge window.
> 
> This change should be pushed to Linus in time for 3.8-final, so there
> should not be any bisect issues.

We can do this either way.

James - what is your preference? Drop everything and do a resend of the
entire series or delta patches on top of what is currently in your tree?

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center



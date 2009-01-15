From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 19:47:06 +0100
Message-ID: <496F84AA.9060708@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40076 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZAOSrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 13:47:33 -0500
In-Reply-To: <496F7DB6.6090506@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> Stefan Richter wrote:
>> I believe your kref_get_not_zero() invention is because you want to
>> count two unrelated numbers in the same counter.  This won't work, I'm
>> afraid.
>>  
> It does work actually, just in a way that people don't seem to like very
> much.

No, it doesn't work.  You can track how many transactions are pending,
and you can track how many sites look at memory X, but you can't track
both issues in the same counter.

If you only count pending transactions, you know when to deregister the
device from the idr.  But you don't know when it's OK to free the
device's memory.

If you cont only references to the memory, you know when it is OK to
free it but you don't know when to deregister from the idr.

> And it is not really my invention; other people have run into the
> same problem and come up with the same solution.

Perhaps these people did not analyze rigorously what it really is what
they want to count?

...
> Please, cast your votes now.

I for one am not interested in what you guys do with sg.

However, the proposal to change the kref API in a way which IMO
undermines the whole principle of reference counting motivated me to
comment in this thread, to try to understand what you want to solve, and
to propose something.

What is this kref_get_not_zero()?  Do you want to encode object state
into the reference counter?  That's not the purpose of a reference
count; use separate object attribute for that.  The reference count says
how many sites look at the object.  Nothing more, nothing less.

> 7) I am told to use three krefs now, using one kref to refcount another
> kref.  However, it may be necessary to use as many as four.
...
> How much more complicated does it have to get just to make things simpler?

As I said:  Why count independent numbers with a single counter?
Count number A with counter a.  Count number B with counter b.  This is
easy, works 100%, and is obvious to everybody.  How much simpler than
that can it get?
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/

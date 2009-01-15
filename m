From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 13:17:26 -0500
Message-ID: <496F7DB6.6090506@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1040 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZAOSR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 13:17:28 -0500
In-Reply-To: <496F62CC.8000007@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> I believe your kref_get_not_zero() invention is because you want to
> count two unrelated numbers in the same counter.  This won't work, I'm
> afraid.
>
>   
It does work actually, just in a way that people don't seem to like very
much.  And it is not really my invention; other people have run into the
same problem and come up with the same solution.  Sometimes people drop
kref and go directly to using atomic ops just so that they can use
atomic_inc_not_zero() without "violating" the kref API.

> One number is
>   - the number of unfinished transactions (request->response)
> of an sg device.  (Is that struct sg_device, or struct sg_fd?)
>
> The other number is
>   - the number of contexts which peek and poke at the device
> representation's memory.  (struct sg_device, or struct sg_fd?)
>
> These two numbers are of course unrelated.  Hence I recommend you count
> them in separate counters.
>
>   
I might be able to get this to work, but is it really better than
kref_get_not_zero()?  And since there are actually two different types
of objects being refcounted with the same issue (sg_fd and sg_device),
applying the same "trick" to both might require (ugh) four counters
total.  Does anyone else favor this approach?  I expect that if I put
the effort into a patch that does this, someone else will just tell me
to do it some other way.  But if someone else seconds your proposal, I
will give it a try.  Please, cast your votes now.

Rant:
1) I posted a patch that fixes a bunch of oopses.
2) I was told to use a kref because it makes things "simpler".
3) I posted a second patch using one kref, being very careful to avoid
the subtle pitfalls of the kref API.
4) Someone else modified my patch to use two krefs to make things "even
simpler", but it was subtly broken because krefs aren't an ideal fit for
this problem.
5) I fixed the patch that used two krefs by extending the kref API.
6) I get flamed all to hell.
7) I am told to use three krefs now, using one kref to refcount another
kref.  However, it may be necessary to use as many as four.
8) I give up being a programmer, move to Wisconsin, and become a dairy
farmer.

I am of course just joking around and not actually offended, but this
whole thing is starting to seem a bit silly.  How much more complicated
does it have to get just to make things simpler?  NIH syndrome, anyone?

--Tony "moo cow" Battersby


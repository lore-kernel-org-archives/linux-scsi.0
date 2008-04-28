From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 14:25:33 -0400
Message-ID: <1209407133.3367.37.camel@localhost.localdomain>
References: <1209320076.3801.26.camel@localhost.localdomain>
	 <20080428013400.GA6245@elte.hu>
	 <1209351113.3801.107.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0804280903230.3119@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53362 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936320AbYD1SZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 14:25:38 -0400
In-Reply-To: <alpine.LFD.1.10.0804280903230.3119@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2008-04-28 at 09:05 -0700, Linus Torvalds wrote:
> 
> On Sun, 27 Apr 2008, James Bottomley wrote:
> > 
> > Try this; the signature for an uninitialised free list is easy (both
> > list pointers NULL), so the patch detects that and doesn't try to run
> > over the uninitialised list head.
> 
> Why aren't these things initialized?

They are, but not until we begin the freelist allocation.  That way we
can keep the list head being NULL as the signal for the freelist not
being initialised.

> You say that the signature of an uninitialised free list is trivial, but 
> that's not at all true in general. It depends intimately on how the memory 
> was allocated, and is thus very subtle indeed - some change to allocations 
> can break something simple like this, by initializing it with random old 
> memory contents.

No, no; for us it's guaranteed to be NULL ... they're allocated in the
host memory area with kzalloc. (and before kzalloc, we were using
kmalloc/memset because the host area has an API guarantee of being zero
initialised).

> So why not just initialize lists like this so early (ie at allocation 
> time) that problems like this cannot happen? Instead of adding ugly and 
> fragile cases to the freeing?

Because then I'd need another flag to know whether or not the free list
has actually been set up.  In theory, if we initialise the list,
list_empty() would do because when you're freeing you should always have
the reserve command on the free list ... but that would have prevented
us from seeing the bug Ingo reported recently (where we were freeing
with active commands), so I'm a bit reluctant to do that.

James



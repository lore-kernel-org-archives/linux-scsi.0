From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 069/104] lib/string_helpers.c:string_get_size(): remove
 redundant prefixes
Date: Thu, 12 Feb 2015 15:55:16 -0800
Message-ID: <20150212155516.937d2df60ad00737096478b2@linux-foundation.org>
References: <54dd30d9.8sIvA5PVH18vSWTI%akpm@linux-foundation.org>
	<1423783508.6286.25.camel@HansenPartnership.com>
	<20150212154019.6c27b3301962c0650ee3a516@linux-foundation.org>
	<1423784729.6286.32.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbBLXzS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2015 18:55:18 -0500
In-Reply-To: <1423784729.6286.32.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: torvalds@linux-foundation.org, linux@rasmusvillemoes.dk, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 12 Feb 2015 15:45:29 -0800 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:

> ...
>
> > I don't get it.  As the man says, this is presently dead code and
> > string_get_size() will need to be changed to work for disks larger than
> > 2^64 bytes.  That change may be to take a u128 or it may be as you
> > suggest: replace the `u64 size' with `u64 size, u64 units' which is
> > effectively the same thing.
> 
> The first thing someone's going to do is pass in blocks, because that's
> the way the rest of block functions. If we're lucky the add "ZB" too,
> but if not we run off the end in some obscure large cluster somewhere.
> Don't set people up to make mistakes.

Well maybe.  A little bit.  But it assumes that someone is going to
make a change then not test it.

> > > > Also there's no need to include and test for the NULL sentinel; once we
> > > > reach "E" size is at most 18.  [The test is also wrong; it should be
> > > > units_str[units][i+1]; if we've reached NULL we're already doomed.]
> > > 
> > > So fix the bug, don't set us up to run off the end of the array.  And
> > > please consult the community which keeps track of this rather than
> > > trying to get it into Linux without review.
> > 
> > That seems a bit harsh - you've been cc'ed on this every step of the way.
> 
> I think you need to check your scripts.  This is the first time I've
> seen this patch, which is why I'm reacting this way.

No, James.Bottomley@HansenPartnership.com was cc'ed on the original
email and on the -mm spam.

Perhaps Rasmus should should also have cc'ed linux-scsi - practice
seems to vary a lot.  But he did cc the scsi maintainer and the author
of the patch he was modifying (yourself).


So I think the patch is reasonable and the way Rasmus and I handled it
is also reasonable.  Going nuts at us over it isn't reasonable!

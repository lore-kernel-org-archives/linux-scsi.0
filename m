From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 069/104] lib/string_helpers.c:string_get_size(): remove
 redundant prefixes
Date: Thu, 12 Feb 2015 15:45:29 -0800
Message-ID: <1423784729.6286.32.camel@HansenPartnership.com>
References: <54dd30d9.8sIvA5PVH18vSWTI%akpm@linux-foundation.org>
	 <1423783508.6286.25.camel@HansenPartnership.com>
	 <20150212154019.6c27b3301962c0650ee3a516@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35550 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbbBLXpb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2015 18:45:31 -0500
In-Reply-To: <20150212154019.6c27b3301962c0650ee3a516@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux@rasmusvillemoes.dk, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2015-02-12 at 15:40 -0800, Andrew Morton wrote:
> On Thu, 12 Feb 2015 15:25:08 -0800 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> 
> > On Thu, 2015-02-12 at 15:01 -0800, akpm@linux-foundation.org wrote:
> > > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > > Subject: lib/string_helpers.c:string_get_size(): remove redundant prefixes
> > > 
> > > While 3c9f3681d0b4 "[SCSI] lib: add generic helper to print sizes rounded
> > > to the correct SI range" says that Z and Y are included in preparation for
> > > 128 bit computers, they just waste .text currently.  If and when we get
> > > u128, string_get_size needs updating anyway (and ISO needs to come up with
> > > four more prefixes).
> > 
> > This is rubbish. It's nothing to do with 128 bits.  This is to do with
> > disk sizes linux gets attached to.  The current largest device clusters
> > are Petabytes ... I think we may have some exabyte ones somewhere in the
> > Academic community, so it's by no means inconcievable we'll have
> > Zettabyte ones within a few years.  The SCSI standard, with 4k blocks
> > supports up to 2^76, which is well into Zettabytes.  We obviously run
> > off the mmap possibilities a lot sooner, because of the byte offsets,
> > but that's fixable.  Someone will probably start first by passing blocks
> > into that interface not bytes, so we'd like it not to be based on
> > assumptions that think 2^64 is the largest possible value.
> 
> I don't get it.  As the man says, this is presently dead code and
> string_get_size() will need to be changed to work for disks larger than
> 2^64 bytes.  That change may be to take a u128 or it may be as you
> suggest: replace the `u64 size' with `u64 size, u64 units' which is
> effectively the same thing.

The first thing someone's going to do is pass in blocks, because that's
the way the rest of block functions. If we're lucky the add "ZB" too,
but if not we run off the end in some obscure large cluster somewhere.
Don't set people up to make mistakes.

> > > Also there's no need to include and test for the NULL sentinel; once we
> > > reach "E" size is at most 18.  [The test is also wrong; it should be
> > > units_str[units][i+1]; if we've reached NULL we're already doomed.]
> > 
> > So fix the bug, don't set us up to run off the end of the array.  And
> > please consult the community which keeps track of this rather than
> > trying to get it into Linux without review.
> 
> That seems a bit harsh - you've been cc'ed on this every step of the way.

I think you need to check your scripts.  This is the first time I've
seen this patch, which is why I'm reacting this way.

James



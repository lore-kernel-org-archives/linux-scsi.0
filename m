From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11800] New: building SES support fails w/ gcc-3.4.5
Date: Thu, 23 Oct 2008 11:35:13 -0500
Message-ID: <1224779713.3330.13.camel@localhost.localdomain>
References: <bug-11800-11613@http.bugzilla.kernel.org/>
	 <20081021155240.851b69c3.akpm@linux-foundation.org>
	 <200810221943.m9MJh8bR031381@colby.verdasys.com>
	 <20081022133046.0fa7de8a.akpm@linux-foundation.org>
	 <1224710227.6851.50.camel@localhost.localdomain>
	 <200810231614.m9NGEg1p019191@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40768 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976AbYJWQfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 12:35:16 -0400
In-Reply-To: <200810231614.m9NGEg1p019191@colby.verdasys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2008-10-23 at 12:14 -0400, Marc Bejarano wrote:
> At 17:17 10/22/2008, James Bottomley wrote:
>  >On Wed, 2008-10-22 at 13:30 -0700, Andrew Morton wrote:
>  >> OK, it's here:
>  >>
>  >> 	buf = kmalloc(vpd_len, GFP_KERNEL);
>  >>
>  >> it's a gcc bug.
>  >>
>  >> Please see if you can find some way to make it go away - perhaps change
>  >> vpd_len's type to `int', things like that.
>  >>
>  >> Or use a different compiler version :(
> 
> i'm not worried about compiling this.  i already did a compilation 
> without it and i'll be fine without SES.  i just selected it on the 
> off chance i'd find time to play with it.  i was just doing my duty 
> of reporting this to save others the trouble.
> 
>  >Could it be an optimisation issue?  The static oversize test relies on
>  >the compiler optimising away a leg that can never be reached if the size
>  >is under the max. If you do a make V=1 you'll see what optimisation
>  >flags the compiler is using ... if it's -O2 then yes, the compiler
>  >should be optimising stuff away and it's a clear compiler problem.  If
>  >it's anything else, we might have a mis setting of the optimisation
>  >level in the kernel build.
> 
> looks to me like -Os:

I think we have a winner: -Os is rather less well implemented in older
versions of gcc.  Could you retry with -O2?

You do this by setting the config option

CONFIG_CC_OPTIMIZE_FOR_SIZE

to N (it defaults to Y).  If we verify this to be the root cause, we
might consider making the default for that option N if gcc version is <
4.

James



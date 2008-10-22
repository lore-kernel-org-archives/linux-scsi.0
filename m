From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11800] New: building SES support fails w/ gcc-3.4.5
Date: Wed, 22 Oct 2008 15:17:07 -0600
Message-ID: <1224710227.6851.50.camel@localhost.localdomain>
References: <bug-11800-11613@http.bugzilla.kernel.org/>
	 <20081021155240.851b69c3.akpm@linux-foundation.org>
	 <200810221943.m9MJh8bR031381@colby.verdasys.com>
	 <20081022133046.0fa7de8a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55794 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569AbYJVVRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 17:17:15 -0400
In-Reply-To: <20081022133046.0fa7de8a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc Bejarano <beej@alum.mit.edu>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-10-22 at 13:30 -0700, Andrew Morton wrote:
> OK, it's here:
> 
> 	buf = kmalloc(vpd_len, GFP_KERNEL);
> 
> it's a gcc bug.
> 
> Please see if you can find some way to make it go away - perhaps change
> vpd_len's type to `int', things like that.
> 
> Or use a different compiler version :(

Could it be an optimisation issue?  The static oversize test relies on
the compiler optimising away a leg that can never be reached if the size
is under the max. If you do a make V=1 you'll see what optimisation
flags the compiler is using ... if it's -O2 then yes, the compiler
should be optimising stuff away and it's a clear compiler problem.  If
it's anything else, we might have a mis setting of the optimisation
level in the kernel build.

James



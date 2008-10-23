From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11800] building SES support fails w/ gcc-3.4.5
Date: Thu, 23 Oct 2008 09:35:26 -0700 (PDT)
Message-ID: <20081023163526.15B94108047@picon.linux-foundation.org>
References: <bug-11800-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268AbYJWQf2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 12:35:28 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9NGZQE8016693
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2008 09:35:27 -0700
In-Reply-To: <bug-11800-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11800





------- Comment #6 from anonymous@kernel-bugs.osdl.org  2008-10-23 09:35 -------
Reply-To: James.Bottomley@HansenPartnership.com

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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

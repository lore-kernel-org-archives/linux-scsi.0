From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries
	330
Date: Fri, 12 Feb 2010 13:37:18 -0700
Message-ID: <20100212203717.GI11239@parisc-linux.org>
References: <bug-15288-11613@http.bugzilla.kernel.org/> <201002122028.o1CKSOFI005099@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40059 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab0BLUhS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 15:37:18 -0500
Content-Disposition: inline
In-Reply-To: <201002122028.o1CKSOFI005099@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 12, 2010 at 08:28:24PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> --- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2010-02-12 20:28:19 ---
> I'll reassign this regression to scsi.
> 
> I reattached the most interesting jpg screenshot: scsi_async_scan got stuck.

This probably isn't anything to do with the scsi async scan (boot with
scsi_mod.scan=sync to eliminate the possibility).  It's probably a driver
failing to finish the scan.  Probably the reason for that is broken
interrupt routing.  But that's a lot of probables, so some investigation
with scsi_mod.scan=sync should be used to confirm the first hypothesis
before assigning the blame elsewhere.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

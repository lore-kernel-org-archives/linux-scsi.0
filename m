From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 12:43:42 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408201227300.1063-100000@ida.rowland.org>
References: <41261E65.8010504@optonline.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:25348 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267468AbUHTQno (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 12:43:44 -0400
In-Reply-To: <41261E65.8010504@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Aug 2004, Nathan Bryant wrote:

> True, but users could cold-swap a non-removable drive too, and I don't 
> think we should make the same assumptions there.

Well, you could assume that if a drive with non-removable media sends
ASC x28 it's not because the medium has changed.  Apart from that, I think 
the assumptions should be pretty much the same.  The real question is 
whether a power change will result in ASC x29 -- some drives might not 
send it at all, others might send x28 instead.

>  Users expect resume 
> from suspend to be fast, so needlessly invalidating all our buffer cache 
> is silly.
> 
> Point being that we should probably do something about removable drives, 
> but a hardcoded invalidate on resume is overkill.

I agree that in the absence of RMB, ASC x28 probably shouldn't invalidate
anything.


> > IMHO they should be treated equivalently.  Neither the new medium nor the
> > I/O stream should be allowed to get corrupted.  Does sd.c even know 
> > whether or not an open file handle refers to a mounted volume?
> 
> A mounted fs has more complexities than a block device that is only 
> opened by userspace. For the latter case we can invalidate all buffers 
> and after that the only question is how aggressive to be about passing 
> errors up to userspace. For a mounted fs we may have to deal with busy 
> inodes and I don't know how well the VFS layer deals with that. So there 
> may yet turn out to be a reason to handle them differently.

Well yes, but we have to expect that VFS will learn to handle its own
problems.  At the level of sd.c, I'm not aware that the code can
distinguish between a userspace open and a mount.  If it can't then it has
no choice but to treat them the same.


>  But we currently don't make the distinction between good/bad UA's. 
> If we introduce the distinction, we need to be careful about 
> regressions. Currently the default is that all UA's are "bad" (trigger a 
> media change.) It may make the most sense to keep that as the default 
> and only exclude certain additional sense codes that are known to be 
> good. In order for those exceptions to be added, someone might have to 
> complain about it first, since I'm not sure we can make that change 
> without a testcase ;)

That sounds like a reasonable approach.

Alan Stern


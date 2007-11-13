From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 9370] v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Date: Tue, 13 Nov 2007 15:08:49 -0700
Message-ID: <20071113220849.GN17785@parisc-linux.org>
References: <bug-9370-35@http.bugzilla.kernel.org/> <20071113211329.9D052108069@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59022 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXKMWIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 17:08:50 -0500
Content-Disposition: inline
In-Reply-To: <20071113211329.9D052108069@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org, Thomas Meyer <thomas@m3y3r.de>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 13, 2007 at 01:13:29PM -0800, bugme-daemon@bugzilla.kernel.org wrote:
> Probably caused by:
> 
> commit 6f5391c283d7fdcf24bf40786ea79061919d1e1d
> Author: Matthew Wilcox <matthew@wil.cx>
> Date:   Tue Sep 25 12:42:04 2007 -0400
> 
>     [SCSI] Get rid of scsi_cmnd->done
> 
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6f5391c283d7fdcf24bf40786ea79061919d1e1d

Since the reporter says that reverting this commit fixes the problem, it
must have caused the problem.  For the benefit of those on linux-scsi
who are just tuning into this report, the original mail is at
http://lkml.org/lkml/2007/11/13/250 and the report that reverting this
commit fixes it is a followup to it.

I've stared at the patch, trying to figure out what's wrong.  The only
thing which makes any sense to me is that a request comes in, tagged as
REQ_TYPE_FS.  Later, it becomes REQ_TYPE_BLOCK_PC.  This would have
caused us to call sr_done() before the patch, and after the patch, we
would not call sr_done().  Further eyes are welcome.

James has suggested that the problem may be that ide-scsi does just this.
Thomas, can you confirm whether or not you were using ide-scsi?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

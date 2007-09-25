From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Some plans for scsi_cmnd
Date: Tue, 25 Sep 2007 09:31:30 -0600
Message-ID: <20070925153130.GV10625@parisc-linux.org>
References: <20070925133733.GT10625@parisc-linux.org> <46F9205A.8060003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42816 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbXIYPbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 11:31:31 -0400
Content-Disposition: inline
In-Reply-To: <46F9205A.8060003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 04:51:06PM +0200, Boaz Harrosh wrote:
> > As I said, it's ambitious.  But it'll let us get rid of scsi_pointer
> > and host_scribble entirely.
> > 
> This all is an excellent idea and you will find that in the patchset to
> gdth, I have made the work of one driver a bit easier for you.

;-)

> I suggest gradual work, where both Scp and host_scribble are intact
> but the .cmnd_size and mechanics are available with few major drivers
> moved to that. Than one kernel after that deprecating both, while 
> converting lots of drivers, and 1-2 kernels after that remove them when
> all drivers are converted. Don't sit on a large patchset with lots of
> drivers and submit them all at once.

Yup, incremental work is always good.

> Please review my patches to scsi_error and the REQUEST_SENSE paths
> (James are they not going to be accepted into 2.6.24-rcx?)
> I have introduced an abstract way to convert a command to point to
> it's sense buffer, So drivers can now transfer data to the sense buffer
> the way they do to regular IO, throw an sg_list.

Brilliant.  I'd only just started looking at the sense buffer issue, so
now I can stop entirely ;-)

> RFC patches early and set up a git tree, if possible. I will help in any way 
> I can also with drivers.

I was planning on just throwing patches at this list and seeing what
sticks.  You'll see a few from me today ... looks like item 2 on the
original mail (getting rid of ->done) may be easier than we thought, and
lead to some really nice cleanups.  Of course, gdth is still the
sticking point for that ;-(

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

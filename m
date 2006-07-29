From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 12:30:39 -0500
Message-ID: <1154194239.9447.89.camel@mulgrave.il.steeleye.com>
References: <20060729045249.GA23398@redhat.com>
	 <20060729111240.GG13095@suse.de>
	 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:29603 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751394AbWG2RbO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 13:31:14 -0400
In-Reply-To: <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

On Sat, 2006-07-29 at 10:06 -0700, Linus Torvalds wrote:
> Not so. I can (and have) written tons of CD's as a normal user, with 
> perfect security.

But not for every CD burner ... that's the point.  The heuristics we
have now work for a large subset.  For the rest, we get a stream of "my
CD won't burn as a user like it's supposed to" bug reports.

In the old days, the gnome/kde stuff simply gave the user ownership of
the cd device and we allowed any command through and so all CDs worked,
if not very safely.  Suddenly with the new "are you root, if not I
consult my allowed tables" method we get this list of CDs that can't
burn as a user.

> No, the kernel shouldn't allow device-specific commands. That goes without 
> saying. Whether this is a sg.c problem, or a cdrecord problem is
> unclear, 
> I suspect it's the latter. 

There are certain CDs that just require vendor specific magic to
work ... even cdrecord has no choice but to do this.

In general, this allowed command list is solidifying policy in the
kernel, which is the problem.  If we merely put the ability to enforce
policy in the kernel (without actually having any by default and allow
the distros to set it via sysfs as we do now for the SCSI blacklist)
then we'll go back to the old days (of every CD just works) and if
there's a problem it will be a distro issue because they got their
policy wrong (they're the ones who can scan a computer, see a plextor
on /dev/sdc and allow certain vendor specific commands to /dev/sdc only)

James



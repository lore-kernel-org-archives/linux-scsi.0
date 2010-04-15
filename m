From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] [RFC] block: replace BKL with global mutex
Date: Thu, 15 Apr 2010 16:29:44 +0200
Message-ID: <201004151629.45029.arnd@arndb.de>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <201004150911.45842.arnd@arndb.de> <4BC7117C.7090208@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0DOO3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2010 10:29:51 -0400
In-Reply-To: <4BC7117C.7090208@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>

On Thursday 15 April 2010, Douglas Gilbert wrote:
> At the level of SCSI commands, tape device state assumptions
> made by the st driver could be compromised by SCSI commands
> sent by the sg driver. However the BKL was never meant
> to address that concern.
> 
>  From the comment in st_open() [st.c] it would be using
> nonseekable_open() as well but there are apps out there
> that do lseek()s on its file descriptors. Not sure
> how long nonseekable_open() has been in the sg driver
> but no-one has complained to me about it.

It's been there for a long time, at least since the start of
the git history, and it's very likely correct this way.

> > The most simple solution for this would be to let sg
> > take both blkdev_mutex and the BKL, which of course
> > feels like a step backwards.
> > 
> > A better way is to get rid of the BKL in sg, which requires
> > a better understanding of what it's actually protecting.
> > It only gets it in the open and ioctl functions, which is a
> > result of the pushdown from the respective file operations.
> > Chances are that it's not needed at all, but that's really
> > hard to tell. Can you shed some more light on this?
> 
> The BKL is not used to protect any of the internal
> objects within the sg driver. From memory it was added
> in some large code sweep through, not unlike what you
> are proposing now.

The one in the open function was moved there when the
BKL was moved out from vfs_open(), while the use in ioctl is
implicit by never having been converted to unlocked_ioctl.

I don't see anything that really needs BKL protection in
sg_open, so that can probably just be killed. For sg_ioctl,
at least the blk_trace_* and scsi_ioctl stuff is currently
called with BKL held everywhere else (not in st_ioctl though)
and may still need that.

> So I would not be concerned about any kernel locking
> interactions between the sg and st drivers. I have
> added Kai Makisara (st maintainer) to the cc list.

Ok. I've also checked st.c again and noticed that it
doesn't use use the BKL in ioctl() but only in open(),
which is very unlikely to race against anything in sg.c
or the block subsystem.

	Arnd

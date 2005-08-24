From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Process in D state with st driver
Date: Wed, 24 Aug 2005 22:35:23 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0508242214360.2982@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:34909 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751455AbVHXTaq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 15:30:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hjb@pro-linux.de, Andrew Morton <akpm@osdl.org>

I am sorry that this is not a proper reply email. For some reason I did 
not get this email although I subscribe to linux-scsi and found this 
accidentally from an archive.

On Wed, 24 Aug 2005 akpm@osdl.org wrote:

> Hans-Joachim Baader <hjb@pro-linux.de> wrote:
> >
> > Hi,
> > 
> > > >
> > > > I do nightly backups on tape. Every 3 to 4 weeks a process is stuck in
> > > >  D state while accessing the drive:
> > > > 
> > > >  12398 ?        D      0:00 /usr/sbin/amcheck -ms daily
> > > > 
> > > >  There are no messages in the log. Only a reboot can remove this process.
> > > 
> > > Next time it happens, do
> > > 
> > > 	dmesg -c
> > > 	echo t > /proc/sysrq-trigger
> > > 	dmesg -s 1000000 > foo
> > 
> > thanks for looking into this. Since I haven't rebooted yet, I have the
> > output for you. Hope it helps.
> > 
> 
> OK, thanks.
> 
> It would appear that st_do_scsi() is stuck in the wait_for_completion().
> 
> 
> Just looking at that function: I wonder if there's a problem with incoming
> arg `do_wait'.  If it's false and some other thread is waiting on STp->wait
> then this thread will go and scribble on the completion structure.  Maybe
> there's additional synchronisation which can prevent that?
> 
This should never happen. The st driver is designed so that only one SCSI 
command is active for one device at any time. The device can be opened by 
only a single user at a time. More than one thread can access the device 
if the fd is dup'ed. The trace shows that the process is hanging in 
st_open(). The SCSI commands there use 'do_wait' true and no other thread 
should be able to access this device through st.

'do_wait' is set to false only with the so called "asynchronous 
writes" when a write returns. One of the first things in read(), write(), 
and ioctl() is to check that a potential previous write has finished.

Well, this is the theory. Bugs may exist.

This kind of a problem of a process using a tape hanging in D state has 
occurred sometimes for numerous years. When the user has waited long 
enough (the default timeouts are loooong), the process has continued. When 
st has printed the command timed out, it has been usually a legitimate 
read or write. St has sent the command and waited for it to finish but 
this has never occurred. These problems may or may not be related to the 
current one.

I have never been able to reproduce the problem in my systems.

-- 
Kai

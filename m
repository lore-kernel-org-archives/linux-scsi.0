From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10915] New: echo min_power >
	/sys/class/scsi_host/host0/active_mode causes problem
Date: Sun, 15 Jun 2008 21:00:10 -0500
Message-ID: <1213581610.3517.44.camel@localhost.localdomain>
References: <bug-10915-10286@http.bugzilla.kernel.org/>
	 <20080615180146.8abb9450.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45065 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYFPCAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2008 22:00:16 -0400
In-Reply-To: <20080615180146.8abb9450.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, cijoml@volny.cz

On Sun, 2008-06-15 at 18:01 -0700, Andrew Morton wrote:
> On Sun, 15 Jun 2008 01:52:26 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=10915
> > 
> >            Summary: echo min_power > /sys/class/scsi_host/host0/active_mode
> >                     causes problem
> >            Product: File System
> >            Version: 2.5
> >      KernelVersion: 2.6.25.6
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: SysFS
> >         AssignedTo: greg@kroah.com
> >         ReportedBy: cijoml@volny.cz
> > 
> > 
> > Latest working kernel version: unknown
> > Earliest failing kernel version: unknown
> > Distribution: Debian testing
> > Hardware Environment: HP Compaq 6910p
> > Software Environment: Debian testing, sysfs
> > Problem Description:
> > 
> > In accident I proceed
> > echo min_power > /sys/class/scsi_host/host0/active_mode
> > 
> > which causes HIGH cpu load, echo wasn't killable so reboot was only solution :(
> > 
> > Steps to reproduce:
> > proceed command
> 
> For reasons which escape me, there is no description text in bugzilla
> for this report, yet the reporter entered some.
> 
> Anyway.  Could someone please refile this under scsi?  Or fix the bug ;)

Um ... actually, maybe not.  The active_mode file is read only (it has a
NULL store method).  It's designed to show what mode the host is
activated in "initiator", "target" (or both or unknown).  If echoing
something to a read only sysfs file with no actual store method is
causing this behaviour, the root cause has to be somewhere in sysfs.

However, since the file has nothing to do with power saving ... unless
some driver I can't find is trying to duplicate it, so there's no reason
to try to echo "min_power" to it, so some of the details on this report
might bear further investigation ...

James



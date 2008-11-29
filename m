From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 10:36:11 -0800 (PST)
Message-ID: <20081129183611.8AD15108041@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbYK2Sgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 13:36:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATIaBDq017659
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 10:36:12 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-11-29 10:36 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sat, 2008-11-29 at 16:12 +0100, Stefan Richter wrote:
> On 29 Nov, bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12120
> > 
> >            Summary: [Block layer or SCSI] requests aborted too early during
> >                     check_partition()
> >            Product: IO/Storage
> >            Version: 2.5
> >      KernelVersion: 2.6.28-rc
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: SCSI
> >         AssignedTo: linux-scsi@vger.kernel.org
> >         ReportedBy: stefan-r-bz@s5r6.in-berlin.de
> > OtherBugsDependingO 11808
> >              nThis:
> >         Regression: 1
> > 
> > 
> > Latest working kernel version: 2.6.27.4
> > Earliest failing kernel version: 2.6.28-rc6  (I didn't test earlier -rcs yet)
> > 
> > Hardware Environment: OxSemi 912 and 92x based FireWire harddisks
> > 
> > 
> > See http://marc.info/?l=linux-scsi&m=122774022130397 --
> > Disks may still spin their motor up when the kernel attempts to read
> > partitions. In kernel 2.6.27, this was handled transparently.  But since
> > 2.6.28-rc?, the kernel immediately aborts the associated requests and sets the
> > new scsi_device offline.
> > 
> > 
> 
> I tried a workaround in firewire-sbp2:  Check whether the new sdev is
> offline right after scsi_add_device.  If so, remove the sdev and try
> everything again.  However,
>   - a regression still remains because the addition of the HDD takes
>     about 30...40 seconds instead of only a few seconds like in 2.6.27.
>   - The workaround works with OXFW912 and OXUF922, but not with
>     OXUF924DSB.  Login retries don't succeed with the latter at all.
>   - The workaround would be very hard to implement in the older
>     ieee1394/sbp2 driver.
>   - Other hardware besides FireWire may be affected.

It sounds like the device isn't being spun up, so commands which require
media read are being failed with not ready.  Could we get some traces to
show this; just enable all tracing in the boot up sequence:

echo 0xffffffff > /sys/module/scsi_mod/parameters/scsi_logging_level

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

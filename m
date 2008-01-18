From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9775] HOST_MSG_LOOP invalid SCB ff
Date: Fri, 18 Jan 2008 14:28:00 -0800 (PST)
Message-ID: <20080118222800.2D5AB10806A@picon.linux-foundation.org>
References: <bug-9775-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762894AbYARW22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2008 17:28:28 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m0IMS0Uf008323
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2008 14:28:01 -0800
In-Reply-To: <bug-9775-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9775





------- Comment #5 from anonymous@kernel-bugs.osdl.org  2008-01-18 14:27 -------
Reply-To: James.Bottomley@HansenPartnership.com


> Latest working kernel version:
> Earliest failing kernel version: 
> Distribution: Gentoo
> Hardware Environment: ML150G3, (2Core cpu, 64Bit)  AHA3944AUWD card, Storagetek
> L80 +2x DLT8000
> Software Environment: gentoo
> Problem Description: kernel panic 
> 
> Steps to reproduce:
> Panic if the L80 is powered up when the kernel boots. 100% on any failing
> kernel.
> Not all kernels fail but most do.
> Git Bisect across linus's tree did not produce a convincing patch.
> Originally filed here: http://bugs.gentoo.org/show_bug.cgi?id=200708
> I have joined the linux-scsi list and will
> 
> The event that brought the problem to light was the installation of a
> secondhand Storagetek L80
> tape library. This has two DLT8000 drives on a HV-Differential bus.
> This needed special card, an adaptec 3944AUWD.
> The kernel I was running at that time was 2.6.22-gentoo-r8.
> It worked fine. Then when -r9 came out and this error manifested, the
> assumption
> was that -r9 was broken.
> 
> I no longer think this to be the case.
> 
> I think they are _ALL_ broken, possibly going way back toward the start of the
> 2.6 series.
> I think that the bug may or may not manifest depending on the internal layout
> of data in the kernel
> --A true heisenbug--
> 
> All that the git bisect did was to change the internal layout, not add/remove a
> bad patch.
> 
> This explains why I could take the 2.6.23.8 kernel and compile for SMP and have
> it fail.
> Compile it for UP and have it work. Initially I thought that meant a locking or
> race issue.
> Now I think its was just another case of altering the internal kernel layout.

Actually, I'd investigate either your tapes or the SCSI bus.

The message is produced deep in the heart of the aic7xxx driver.  It
happens when the driver gets reselected with a tag that doesn't exist.
However, in this case, I think your device is untagged, in which case
this is some handling issue with SCB_LIST_NULL (the value 0xff).

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

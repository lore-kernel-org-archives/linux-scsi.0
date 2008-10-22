From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11803] New: sr_mod: CDROM_DRIVE_STATUS ioctl causes tray
	to be closed
Date: Wed, 22 Oct 2008 08:57:13 -0700
Message-ID: <1224691033.6851.14.camel@localhost.localdomain>
References: <bug-11803-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40744 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbYJVP5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 11:57:21 -0400
In-Reply-To: <bug-11803-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-10-21 at 15:37 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11803
> 
>            Summary: sr_mod: CDROM_DRIVE_STATUS ioctl causes tray to be
>                     closed
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27-2
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: martin.pitt@ubuntu.com
> 
> 
> Latest working kernel version: 2.6.24 (maybe later)
> Earliest failing kernel version: 2.6.27 (maybe earlier)
> Distribution: Ubuntu 8.10
> Hardware Environment:
>  - standard ATAPI CD-ROM drive which works through sr_mod (e. g. PIONEER DVD-RW
> DVR-212)
>  - not using IDE drivers, but libata and pata (PATA_AMD in my case)
> Software Environment:
>  - single user mode
> Problem Description:
> 
> As reported in https://launchpad.net/bugs/283316 and a couple of duplicates,
> CD-ROM drives which are opened/ejected immediately close again. This is due to
> hal polling the device every 2 seconds for an inserted medium for automounting.
> 
> The reason is that the CDROM_DRIVE_STATUS ioctl now causes an open CD tray to
> get closed, instead of just returning CDS_TRAY_OPEN and leaving the tray alone
> (as in earlier kernel releases).
> 
> Unfortunately I cannot precisely tell at which kernel version it regressed,
> since the CD drive of my workstation doesn't support mechanical closing (one of
> those external Dell drives).
> 
> I built a minimal upstream 2.7.27.2 vanilla kernel with just enough PATA_AMD
> and SCSI stuff to boot and reproduce this. Given the reported duplicates, it is
> not specific to a CD ROM drive model or architecture (I reproduced it on
> x86_64, many reporters are on i386).
> 
> IANAKD, but a cursory glance at
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=drivers/scsi/sr_ioctl.c
> revealed that there weren't any changes since about 2.6.24 (where it still
> worked fine). So I'm afraid I'm lost where to look.
> 
> Steps to reproduce:
>  - Open CD tray (CD drive must support mechanical closing)
>  - perl -e 'open F, "/dev/scd0"; ioctl (F, 0x5326, 0x7fffffff);'

I'd finger this commit:

commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Jan 5 10:39:51 2008 -0600

    [SCSI] sr: update to follow tray status correctly

It's actually a gentoo patch trying to make tray status report with
finer detail.  Can you revert it and see if the problem goes away?

Thanks,

James



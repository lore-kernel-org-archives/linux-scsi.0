From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 01:15:22 -0700 (PDT)
Message-ID: <20080401081522.634D310803B@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbYDAIPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 04:15:24 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m318FMEB017341
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 01:15:23 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-04-01 01:15 -------
Reply-To: akpm@linux-foundation.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue,  1 Apr 2008 01:01:22 -0700 (PDT) bugme-daemon@bugzilla.kernel.org
wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10374
> 
>            Summary: sym53c8xx: weird behavior with udev
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.24.4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: seraph@xs4all.nl
> 
> 
> Latest working kernel version: 2.6.22.9
> Earliest failing kernel version: 2.6.23
> Distribution: Gentoo
> Hardware Environment: sparc64 (Sun Blade 100)
> Software Environment:
> Problem Description:
> 
> Since kernel 2.6.23, I have been having problems getting the sungem network
> device working on one of my two Blade 100s, see bug #10273.
> 
> After debugging this, I found that this seems to be somehow related to
> sym53c8xx and udev.
> 
> If I allow udev to load sym53c8xx during boot, the attached disks work fine but
> the network does not work at all. While the device is up and mii-diag says
> there is link beat, no packets can be sent or received, and attempts to use the
> network result in "network unreachable" errors.
> 
> If I blacklist sym53c8xx in /etc/modprobe.d/blacklist, let the machine boot
> normally and then manually load sym53c8xx after everything is settled, both the
> scsi disks and the network appear to work fine.
> 
> None of this happened in kernel versions 2.6.22.9 and earlier, 2.6.23 was the
> first to start showing this behavior, and it still persists in 2.6.24.
> 
> I've tried playing with the option CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE as
> that is what seems to have changed between kernel versions 2.6.22 and 2.6.23.
> The recommended value for my machine is 0, but I have tried the other possible
> values without result. I have also tried toggling CONFIG_SCSI_SYM53C8XX_MMIO,
> also without result.
> 
> Steps to reproduce:
> 
> Let udev load sym53c8xx in kernel 2.6.23 or newer.

urgh.  Perhaps it's related to platform IRQ routing or something.

I'd suggest that the next step would be to send us the `dmesg -s 1000000'
output for both good and bad kernels.  A comparison might show where things
went bad.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

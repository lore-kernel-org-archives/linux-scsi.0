From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11619] Hotplug doesn't work with SAS1064
Date: Mon, 22 Sep 2008 16:11:21 -0700 (PDT)
Message-ID: <20080922231121.EAB4610806C@picon.linux-foundation.org>
References: <bug-11619-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYIVXMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 19:12:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8MNC3s5025704
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:12:04 -0700
In-Reply-To: <bug-11619-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11619





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-09-22 16:11 -------
Reply-To: akpm@linux-foundation.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 22 Sep 2008 02:49:03 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11619
> 
>            Summary: Hotplug doesn't work with SAS1064
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.27-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: vseliverstov@yandex-team.ru
> 
> 
> Latest working kernel version: 2.6.20
> Earliest failing kernel version: 2.6.22
> Hardware Environment: Any Intel-powered server with SAS1064 PCI-X SAS
> controller
> Problem Description: I have linux-box with SAS1064 PCI-X SAS Controller, and
> I'm experiencing problems with hotswapping. When I detach disk from system,
> replace it with another one, and trying to attach it again, nothing happens.
> After reboot, it's OK - I have this disk attached and functioning. Interesting,
> that if I try to attach old disk just after detaching it's OK too. 
> I've tried following Vanilla kernel builds from linux git tree: 2.6.20, 2.6.22,
> 2.6.24, 2.6.26, 2.6.27-rc6 and it's worked only with 2.6.20. So, I tried to
> bisect buggy commit between 2.6.20 and 2.6.22 versions.
> Here is bad commit: df9e062ad994c4db683377b108c0dbed4690e4b0 
> 
> Steps to reproduce: 
> - detach disk with:
> # echo "scsi remove-single-device x y z k" > /proc/scsi/scsi
> - physically remove it and insert another one;
> - try to attach disk with:
> # echo "scsi add-single-device x y z k" > /proc/scsi/scsi
> or with
> echo "- - -" > /sys/class/scsi_host/hostN/scan
> 
> 

Eric, df9e062ad994c4db683377b108c0dbed4690e4b0 was your

commit df9e062ad994c4db683377b108c0dbed4690e4b0
Author: Eric Moore <eric.moore@lsi.com>
Date:   Mon Jan 29 09:46:21 2007 -0700

    [SCSI] fusion - serialize target resets in mptsas.c


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

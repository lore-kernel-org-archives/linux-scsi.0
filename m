From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 11619] New: Hotplug doesn't work with SAS1064
Date: Mon, 22 Sep 2008 16:10:28 -0700
Message-ID: <20080922161028.d519bffd.akpm@linux-foundation.org>
References: <bug-11619-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbYIVXLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 19:11:21 -0400
In-Reply-To: <bug-11619-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, vseliverstov@yandex-team.ru, Eric Moore <Eric.Moore@lsi.com>


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


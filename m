From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sat, 31 Aug 2013 20:50:22 +0000
Message-ID: <bug-60758-11613-ryBlSpWcK3@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45092 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab3HaUu0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Aug 2013 16:50:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 889D72029B
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 20:50:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5F60220299
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 20:50:22 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #11 from Jeff Zhou <jz.researcher@yahoo.com> ---
Thanks. I am a bit curious about the description in Kconfig,
since the scsi_wait_scan.ko was built from scsi_wait_scan.c, which was removed
in v.3.6.
How to refer a non-exist module, as described in the section of "config
SCSI_SCAN_ASYNC"

>From v.3.5.7 to v.3.6.1, there is a change in source code, but it seems the
documentation in Kconfig has not been updated.




(In reply to Alan Bartlett from comment #7)
> (In reply to Jeff Zhou from comment #5)
> > If your system fails by "module scsi_wait_scan not found", then it could be
> > the init script issue in your CentOS box.
> > 
> > The last kernel with scsi_wait_scan.ko is v3.5.7, it has been removed ever
> > since v3.6. Any init script for 3.10 should not use that module.
> > 
> > 
> > Another point is in your config, the CONFIG_SCSI_SCAN_ASYNC is not set, try
> > to turn it into Y and see what's happening.
> 
> Jeff, 
> 
> For the fuller picture please see --
> 
> http://elrepo.org/bugs/view.php?id=401
> 
> This non-booting issue only occurs with one system. The reporter has other
> systems which do boot correctly using the same kernel(s).
> 
> As was explained in the referenced bug report (note 3235), the mention of
> "module scsi_wait_scan not found" is a red-herring.
> 
> Note the following section from the 3.10.10 drivers/scsi/Kconfig file --
> 
> [quote]
> config SCSI_SCAN_ASYNC
>         bool "Asynchronous SCSI scanning"
>         depends on SCSI
>         help
>           The SCSI subsystem can probe for devices while the rest of the
>           system continues booting, and even probe devices on different
>           busses in parallel, leading to a significant speed-up.
> 
>           If you have built SCSI as modules, enabling this option can
>           be a problem as the devices may not have been found by the
>           time your system expects them to have been.  You can load the
>           scsi_wait_scan module to ensure that all scans have completed.
>           If you build your SCSI drivers into the kernel, then everything
>           will work fine if you say Y here.
> 
>           You can override this choice by specifying "scsi_mod.scan=sync"
>           or async on the kernel's command line.
> [/quote]
> 
> It still makes a reference to the scsi_wait_scan module and advises against
> setting SCSI_SCAN_ASYNC=y when scsi drivers have been built as modules.
> 
> It is unnecessary to build a new kernel to test, as per your last point.
> Just appending "scsi_mod.scan=async" to the kernel boot line will be
> sufficient.
> 
> Perhaps the reporter will test with that and then report back?
> 
> Alan / burakkucat.

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sat, 31 Aug 2013 16:02:53 +0000
Message-ID: <bug-60758-11613-1Abs1cS8b1@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40246 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab3HaQC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Aug 2013 12:02:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6D44D202C3
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 16:02:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9663C20292
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 16:02:53 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #7 from Alan Bartlett <ajb@elrepo.org> ---
(In reply to Jeff Zhou from comment #5)
> If your system fails by "module scsi_wait_scan not found", then it could be
> the init script issue in your CentOS box.
> 
> The last kernel with scsi_wait_scan.ko is v3.5.7, it has been removed ever
> since v3.6. Any init script for 3.10 should not use that module.
> 
> 
> Another point is in your config, the CONFIG_SCSI_SCAN_ASYNC is not set, try
> to turn it into Y and see what's happening.

Jeff, 

For the fuller picture please see --

http://elrepo.org/bugs/view.php?id=401

This non-booting issue only occurs with one system. The reporter has other
systems which do boot correctly using the same kernel(s).

As was explained in the referenced bug report (note 3235), the mention of
"module scsi_wait_scan not found" is a red-herring.

Note the following section from the 3.10.10 drivers/scsi/Kconfig file --

[quote]
config SCSI_SCAN_ASYNC
        bool "Asynchronous SCSI scanning"
        depends on SCSI
        help
          The SCSI subsystem can probe for devices while the rest of the
          system continues booting, and even probe devices on different
          busses in parallel, leading to a significant speed-up.

          If you have built SCSI as modules, enabling this option can
          be a problem as the devices may not have been found by the
          time your system expects them to have been.  You can load the
          scsi_wait_scan module to ensure that all scans have completed.
          If you build your SCSI drivers into the kernel, then everything
          will work fine if you say Y here.

          You can override this choice by specifying "scsi_mod.scan=sync"
          or async on the kernel's command line.
[/quote]

It still makes a reference to the scsi_wait_scan module and advises against
setting SCSI_SCAN_ASYNC=y when scsi drivers have been built as modules.

It is unnecessary to build a new kernel to test, as per your last point. Just
appending "scsi_mod.scan=async" to the kernel boot line will be sufficient.

Perhaps the reporter will test with that and then report back?

Alan / burakkucat.

-- 
You are receiving this mail because:
You are the assignee for the bug.

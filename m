From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: 17 Jul 2004 18:43:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090111437.5175.10.camel@patibmrh9>
References: <20040716160224.GA2402@suse.de><1089994751.4844.5.camel@patibmrh
	9>  <20040716175118.GG11255@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:38593 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263093AbUGRAoC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jul 2004 20:44:02 -0400
In-Reply-To: <20040716175118.GG11255@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> I'll start by forwarding this patch,
> so it at least will work in 2.6.8.

2.6.8-rc1-bk6 looks good here now.

diff says the patch arrived intact.  tty shows the expected results.

Thank you.

Pat LaVarre

---

$ uname -msr
Linux 2.6.8-rc1-bk6 i686
$
$ sudo plscsi /dev/scd0 /dev/hdd
export PLSCSI=/dev/scd0       // B Iomega   RRD              74.B
export PLSCSI=/dev/hdd        // @ Iomega   RRD              74.B
$
$ sudo blockdev --getro /dev/scd0 /dev/hdd
0
0
$
$ sudo dd of=/dev/scd0 bs=64K seek=0 count=1 if=/dev/zero
dd: opening `/dev/scd0': Read-only file system
$ sudo dd of=/dev/hdd bs=64K seek=0 count=1 if=/dev/zero
1+0 records in
1+0 records out
$
$ # swap discs
$
$ sudo dd of=/dev/scd0 bs=64K seek=0 count=1 if=/dev/zero
1+0 records in
1+0 records out
$ sudo dd of=/dev/hdd bs=64K seek=0 count=1 if=/dev/zero
dd: opening `/dev/hdd': Read-only file system
$

---



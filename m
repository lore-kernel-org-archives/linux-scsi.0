From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: 16 Jul 2004 10:19:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089994751.4844.5.camel@patibmrh9>
References: <20040716122845.GE2025@suse.de><1089993519.7028.26.camel@patibm
	rh9>  <20040716160224.GA2402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:59316 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266567AbUGPQTU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 12:19:20 -0400
In-Reply-To: <20040716160224.GA2402@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> Have you tested it works as expected as well, with
> rw and ro media?

Ouch, yes, please, never assume I've tested unless I say so explicitly.

So far I've just seen the expected, with one rewritable and one
read-only disc, in a pair of USB and PATAPI drives:

$ sudo plscsi /dev/scd0 /dev/hdd
export PLSCSI=/dev/scd0       // B Iomega   RRD              DB76
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

> looks perfect!

Excellent, I conclude I have understood correctly.

> Have you tested ...

I trust you will tell me if I can help further.

Pat LaVarre



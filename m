From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 13 Jun 2004 12:48:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087152503.3172.11.camel@patibmrh9>
References: <1086807083.3741.21.camel@patibmrh9><1086823857.5997.124.camel@
	patibmrh9> <20040611093027.GW13836@suse.de><20040611093815.GX13836@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:61407 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265245AbUFMSsg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 14:48:36 -0400
In-Reply-To: <20040611093815.GX13836@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

> > should work, I think.

Yes, thank you!

I reverted drivers/ide/ide.c ide-floppy.c to 2.6.7-rc3 and then saw your
updated version applied clean.

> Here's an updated version.

For me now ioctl SG_GET_VERSION_NUM works, and ioctl SG_IO works, ...

Except ioctl SG_IO sg_io_hdr_t.resid always comes back unchanged from
its initial dxfer_len value.  I see nonzero residue reported by the
trivial code I mentioned before, same there as in plscsi.

Pat LaVarre

$ echo -n $'\xAE' >xae.bin
$ hexdump -C xae.bin
00000000  ae                                                |.|
00000001
$
$ sudo plscsi /dev/hdd -f xae.bin -i x24 -x "12 00:00:00 24 00" -v
x 00000000 12 00:00:00 24 00 .. .. .. .. .. .. .. .. .. .. "R@@@$@"
x 00000000 00:80:00:01 75:00:00:00 49:4F:4D:45 47:41:20:20 "@@@Au@@@IOMEGA  "
x 00000010 5A:49:50:20 32:35:30:20 20:20:20:20 20:20:20:20 "ZIP 250         "
x 00000020 32:35:2E:51 .. .. .. .. .. .. .. .. .. .. .. .. "25.Q"
// 36 = x24 = plscsi.main exit int
$
$ sudo plscsi /dev/hdd -f xae.bin -i x7A -x "12 00:00:00 7A 00" -v
x 00000000 12 00:00:00 7A 00 .. .. .. .. .. .. .. .. .. .. "R@@@z@"
x 00000000 00:80:00:01 75:00:00:00 49:4F:4D:45 47:41:20:20 "@@@Au@@@IOMEGA  "
x 00000010 5A:49:50:20 32:35:30:20 20:20:20:20 20:20:20:20 "ZIP 250         "
x 00000020 32:35:2E:51 30:36:2F:31 33:2F:30:32 00:00:00:00 "25.Q06/13/02@@@@"
x 00000030 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
...
x 00000050 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
x 00000060 28:63:29:20 43:6F:70:79 72:69:67:68 74:20:49:4F "(c) Copyright IO"
x 00000070 4D:45:47:41 20:32:30:30 30:20 .. .. .. .. .. .. "MEGA 2000 "
// 122 = x7A = plscsi.main exit int
$
$ sudo plscsi /dev/hdd -f xae.bin -i xFF -x "12 00:00:00 FF 00" -v
x 00000000 12 00:00:00 FF 00 .. .. .. .. .. .. .. .. .. .. "R@@@?@"
x 00000000 00:80:00:01 75:00:00:00 49:4F:4D:45 47:41:20:20 "@@@Au@@@IOMEGA  "
x 00000010 5A:49:50:20 32:35:30:20 20:20:20:20 20:20:20:20 "ZIP 250         "
x 00000020 32:35:2E:51 30:36:2F:31 33:2F:30:32 00:00:00:00 "25.Q06/13/02@@@@"
x 00000030 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
...
x 00000050 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
x 00000060 28:63:29:20 43:6F:70:79 72:69:67:68 74:20:49:4F "(c) Copyright IO"
x 00000070 4D:45:47:41 20:32:30:30 30:20:00:00 00:00:00:00 "MEGA 2000 @@@@@@"
x 00000080 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
...
x 000000E0 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
x 000000F0 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00 .. "@@@@@@@@@@@@@@@"
// 255 = xFF = plscsi.main exit int
$



From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 16 Aug 2004 11:55:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092678938.4235.37.camel@patlinux.iomegacorp.com>
References: <1091228652.6845.1.camel@patibmrh9><20040731141240.GE23697@suse.
	de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:39913 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S267832AbUHPR4p
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 13:56:45 -0400
In-Reply-To: <20040731141240.GE23697@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> in short, please try again :-)

I much appreciate your patient encouragement.  I now know I can ask:

Is there an ide-cd option to allow more bytes/CDB?

That is, an option analogous to the /sys/block/sr*/device/max_sectors
setting of usb-storage, allowing up to the xFF:FF LBA's/CDB standard at
t10.org?  Else can I help create such an option?

I see ioctl SG_IO chokes via EIO if bytes/CDB goes much above zero.

I ask for a workaround because a friend of mine cares.

I see EIO at 130 KiB/CDB, though happy at 128 KiB/CDB, when I try
ide-cd.  I see usb-storage defaults to choke thruput off at 120 KiB/CDB,
but thru /sys lets us reach a little farther above zero i.e. 512
KiB/CDB.

How coordinated is our 2.6 effort to choke off thruput near zero across
PATAPI, USB, FireWire, SPI, SATAPI, etc.?

Is there an ide-cd option to allow more bytes/CDB?

Pat LaVarre

--- tty log

$ uname -msr
Linux 2.6.8.1 i686
$
$ dc -e '120 2 / 16dio 78Pp 800 * 78Pp'
x3C
x1E000
$ dc -e '128 2 / 16dio 78Pp 800 * 78Pp'
x40
x20000
$ dc -e '512  2 / 16dio 78Pp 800 * 78Pp'
x100
x80000
$
$ sudo plscsi -i x1E000 -x "28 00 00:00:00:00 00 00:3C 00" /dev/scd1
$ sudo plscsi -i x1E800 -x "28 00 00:00:00:00 00 00:3D 00" /dev/scd1 2>&1 | grep ioctl:
// sgioSay.ioctl: Input/output error
$ sudo plscsi -i x20000 -x "28 00 00:00:00:00 00 00:40 00" /dev/hdc
$ sudo plscsi -i x20800 -x "28 00 00:00:00:00 00 00:41 00" /dev/hdc 2>&1 | grep ioctl:
// sgioSay.ioctl: Input/output error
$
$ sudo strace plscsi -i x1E000 -x "28 00 00:00:00:00 00 00:3C 00" /dev/scd1 2>&1 | egrep '(open|ioctl)\(' | tail -3
open("/dev/scd1", O_RDONLY|O_NONBLOCK)  = 3
ioctl(3, 0x2282, 0xbfffd9dc)            = 0
ioctl(3, 0x2285, 0x804f0a8)             = 0
$ grep O_RDONLY /usr/include/bits/fcntl.h
#define O_RDONLY             00
$
$ grep . /sys/block/*/device/max_sectors
/sys/block/sr0/device/max_sectors:240
/sys/block/sr1/device/max_sectors:240
$
$ sudo echo 65535 >/sys/block/sr1/device/max_sectors
bash: /sys/block/sr1/device/max_sectors: Permission denied
$ sudo su
# echo 65535 >/sys/block/sr1/device/max_sectors
# grep . /sys/block/*/device/max_sectors
/sys/block/sr0/device/max_sectors:240
/sys/block/sr1/device/max_sectors:240
# echo 1028 >/sys/block/sr1/device/max_sectors
# grep . /sys/block/*/device/max_sectors
/sys/block/sr0/device/max_sectors:240
/sys/block/sr1/device/max_sectors:240
# echo 1024 >/sys/block/sr1/device/max_sectors
# grep . /sys/block/*/device/max_sectors
/sys/block/sr0/device/max_sectors:240
/sys/block/sr1/device/max_sectors:1024
# exit
$
$ sudo plscsi -i x80000 -x "28 00 00:00:00:00 00 01:00 00" /dev/scd1
$ sudo plscsi -i x80800 -x "28 00 00:00:00:00 00 01:01 00" /dev/scd1 2>&1 | grep ioctl:
// sgioSay.ioctl: Input/output error
$

--- how awful my English is

> > Offline a friend reports seeing bytes/CDB of Linux ioctl SG_IO
> > grossly limited - like down below 0.000000128 GB/CDB for op x3B
> > "WRITE BUFFER".
> 
> Could you have chosen a more awkward way to express that number?

Numbers near zero are hard to quote, sure.

0.000000128 GB = 0.000128 MB = 0.128 KB, which isn't what I meant.

> I can't even make sense of it if I try, 0.128 bytes/cdb?!

Another source of imprecision is the GiB MiB KiB vs. GB MB KB
distinction.

I meant to say I was hearing that we choke off thruput near 128 KiB/CDB,
but also that 128 KiB/CDB is very near zero when measured in the year
2004, for example 128 KiB/CDB is barely above 0.000000119 GB/CDB.

$ dc -e '33 k 128 1024 / 1024 / 1024 / p'
.000000119209289550781250000000000
$

I was failing to make myself more clear by speaking in the more popular
units of decimal and GB rather than in the more natural units of hex and
GiB.

> And are you talking about the length of the cdb, or do you mean the
> data that it can send/receive? I'd guess the latter,

Yes.

> but then cdb isn't the correct term.

Sorry I don't yet see why this thread doesn't fit into the category of
arbitrary limits on bytes per CDB.

What is the correct linux-scsi jargon for this?

Pat LaVarre
http://linux-pel.blog-city.com/read/752705.htm


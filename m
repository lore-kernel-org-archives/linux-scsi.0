From: Pat LaVarre <p.lavarre@ieee.org>
Subject: aligned /dev/scd$n reads less rare how
Date: 29 Sep 2003 11:55:21 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064858121.4262.0.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2>  <1064850600.25057.7.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:25324 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264062AbTI2RzF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 13:55:05 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 789951611
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 11:55:04 -0600 (MDT)
In-Reply-To: <1064850600.25057.7.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Anything easy I can do to make aligned reads more common?

I ask because often thru /dev/scd$n I see seemingly pointless
misalignment, for example, if I read a 1 GiB disk:

$ sudo blockdev --flushbufs /dev/scd0
$ time sudo dd if=/dev/scd0 bs=1M
...

usb-storage:  x 43 00 00 00 00 00 00 00 0C 00
usb-storage:  x 43 02 00 00 00 00 01 00 0C 00
usb-storage:  x 1E 00 00 00 01 00
usb-storage:  x 00 00 00 00 00 00
usb-storage:  x 28 00 00 00 00 00 00 00 20 00
usb-storage:  x 28 00 00 00 00 20 00 00 24 00
usb-storage:  x 28 00 00 00 00 44 00 00 40 00
usb-storage:  x 28 00 00 00 00 84 00 00 40 00
usb-storage:  x 28 00 00 00 00 C4 00 00 40 00
...
usb-storage:  x 28 00 00 07 FE C4 00 00 40 00
usb-storage:  x 28 00 00 07 FF 04 00 00 06 00
usb-storage:  x 28 00 00 07 FF 0A 00 00 3A 00
usb-storage:  x 28 00 00 07 FF 44 00 00 40 00
usb-storage:  x 28 00 00 07 FF 84 00 00 0A 00
usb-storage:  x 28 00 00 07 FF 8E 00 00 36 00
usb-storage:  x 28 00 00 07 FF C4 00 00 3C 00
...

1024+0 records in
1024+0 records out
 
real    0m54.809s
user    0m0.015s
sys     0m9.039s
$

Pat LaVarre

P.S.

I know I can read aligned thru /dev/sg0 as follows.

$
$ time sudo sg_dd if=/dev/sg0 bs=2k bpt=512 count=524288
of=/mnt/hda11/z.bin
...
 
Attached scsi generic sg0 at scsi1, channel 0, id 0, lun 0,  type 5
usb-storage:  x 28 00 00 00 00 00 00 02 00 00
usb-storage:  x 28 00 00 00 02 00 00 02 00 00
usb-storage:  x 28 00 00 00 04 00 00 02 00 00
usb-storage:  x 28 00 00 00 06 00 00 02 00 00
...
usb-storage:  x 28 00 00 07 FA 00 00 02 00 00
usb-storage:  x 28 00 00 07 FC 00 00 02 00 00
usb-storage:  x 28 00 00 07 FE 00 00 02 00 00

524288+0 records in
524288+0 records out
 
real    0m56.567s
user    0m0.027s
sys     0m7.236s
$

I see this approach to aligning reads slowed me down a second or two.




From: Douglas Gilbert <dougg@torque.net>
Subject: [2.5.69-bk8] block SCSI_IOCTL_SEND_COMMAND+SG_IO borken
Date: Wed, 14 May 2003 21:41:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC22B56.9080800@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:29706 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262025AbTENMl0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 08:41:26 -0400
Received: from torque.net (d-242-115.stlucia.uq.net.au [203.101.242.115])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4ECsAHO017624
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2003 22:54:11 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lk 2.5.68-bk8 seems a bit flaky with slab corruption
(hopefully James and Mike have addressed that).

One thing that fails all the time is trying to send
SCSI_IOCTL_SEND_COMMAND or SG_IO ioctls through the
block layer (i.e. code in drivers/block/scsi_ioctl.c).
The only change in that file in bk8 is from me to
fix sense buffer handling which is not being exercised
in the failure case (e.g. simple commands like INQUIRY).

The sym53c8xx driver seems to interpret commands from
block layer as bus reset requests:

  sym0:1: ERROR (0:48) (c-2d-61) (3e/18/80) @ (scripta b00:14000000).
  sym0: script cmd = 88080000
  sym0: regdump: da 10 c0 18 47 3e 01 0e 00 0c 81 2d
80 01 0d 08 00 d4 48 1e 0a 00 00 00.
  sym0: SCSI BUS reset detected.
  sym0: SCSI BUS has been reset.

Sending those two ioctls through the scsi mid-level
works (e.g. 'sg_inq /dev/sda' fails while 'sg_inq /dev/sg0'
works).

Doug Gilbert



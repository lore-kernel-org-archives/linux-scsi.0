From: "Thomas Schmitt" <scdbackup@gmx.net>
Subject: Re: CD media burnt using TAO mode fails to boot
Date: Thu, 09 Jun 2016 15:15:49 +0200
Message-ID: <11388603735865559649@scdbackup.webframe.org>
References: <CAJDAfTCoLLBiOfcK+ws5wOUvg+4QkAppH_s3D7r+1rdyRoKV=g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53361 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbcFINOt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2016 09:14:49 -0400
In-Reply-To: <CAJDAfTCoLLBiOfcK+ws5wOUvg+4QkAppH_s3D7r+1rdyRoKV=g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: albapompeo@gmail.com
Cc: linux-scsi@vger.kernel.org

Hi,

(I am currently not subscribed to linux-scsi but will do if a
 discussion arises. Just give me a note by direct mail.)

Alba Pompeo wrote:
> [    9.698784] sr 1:0:0:0: [sr0] tag#12 Sense Key : 0x4 [current]
> [    9.698788] sr 1:0:0:0: [sr0] tag#12 ASC=0x3e ASCQ=0x2
> [    9.698795] sr 1:0:0:0: [sr0] tag#12 CDB: opcode=0x28 28 00 00 00 ae 96 00 00 02 00

  4 3E 02 TIMEOUT ON LOGICAL UNIT

Quite a harsh reaction for an attempt to read the TAO roun-out blocks.
Normal would be rather something like

  5 30 02 CANNOT READ MEDIUM  INCOMPATIBLE FORMAT
  5 64 00 ILLEGAL MODE FOR THIS TRACK


> My best guess would be that this confuses the entity among the ISO
> payload, which is in charge for creating /dev/disk/by-label/ links
> while the system boots up.

At least with Archlinux it is/was the program blkid.

A few weeks ago i posted to linux-scsi 

  Date: Sun, 28 Feb 2016 14:41:59 +0100
  Subject: sr: Failures to read TAO CD track ends
  Message-Id: <6531578277915568387@scdbackup.webframe.org>

  http://marc.info/?l=linux-scsi&m=145666692729714&w=2

with CD drive observations and remarks about drivers/scsi/sr.c and
its strange theory of 75 block fuzziness of READ CAPACITY.

The problem is rather about the last two blocks which are reported
to be part of a TAO track. They need to be handled mistrustingly,
because the CD drives show no uniform behavior with counting the
unreadable run-out blocks as part of readable payload or not.

As of april 19 2016 the problem gets circumvented in upstream
libblkid:
  https://github.com/karelzak/util-linux/commit/bfebe74e3babe8c188a51269acc2673f1aea283f
At least for me it solved the failure of blkid on a TAO CD.

So it might be worth to inform the publishers of CD-sized ISOs that
they can close the pitfall by updating the blkid program which they
put into their ISOs.


Have a nice day :)

Thomas


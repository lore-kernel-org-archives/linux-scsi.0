From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: HP G6 hardware kernel boot issue > 2.6.37 cciss/hpsa
Date: Wed, 02 Mar 2011 18:42:49 +0100
Message-ID: <1299087769.4279.27.camel__28868.4732433923$1299088195$gmane$org@firesoul.comx.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:35296 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1CBRtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2011 12:49:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maximilian Attems <max@stro.at>, Michael Prokop <mika@debian.org>, Marco d'Itri <md@linux.it>, Debian kernel team <debian-kernel@lists.debian.org>, Mike Miller <mike.miller@hp.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>

Hi Google and maintainers,

I have a kernel booting problem with kernels above 2.6.37 on Debian
Squeeze, on HP G6 hardware, which have the harddisk controller:

 HP Smart Array P410i Controller / Smart Array G6 controllers

This problem is (of cause) related to the introduction of the driver
HPSA, which takes over from the driver CCISS (the overlapping PCI IDs
were removed in commit 6fa977520871 see below).

This driver transition causes the device names to change
  from /dev/cciss/c0d0p1
  to   /dev/sda1.

Thus, it would be really nice if UUID / LABEL / udev worked, as it
would make it possible to boot kernels above and below 2.6.37.

== Here comes the BUG and work-around ==

The BUG is that, if I compile the kernel and include the CCISS driver
(even-though it will not be used), then initramfs will drop me into a
shell, complaining that it cannot find /dev/disk/by-uuid/...

The work-around is, either
 1) to avoid using initrd images, or
 2) don't compile the kernel with the CCISS driver.

== Maintainers tasks ==

I suspect the bug lies in initramfs-tools, or the udev version used by
initramfs-tools.

Could the maintainers of initramfs-tools and udev, please tell me
something like its fixed in version XXX, and the Debian maintainers
just need to compile initramfs-tools with this version to fix the
issue? ;-)

 initramfs-tools Version: 0.98.8
 udev            Version: 164-3

ps. I'm testing with net-next 2.6.38-rc5-02558-g07df529
-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network Kernel Developer
  Cand. Scient Datalog / MSc.CS
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer

Keywords: driver CCISS, HPSA, HP DL G6, uuid, udev, mkinitramfs,
initramfs-tools, debian squeeze

== Commit info ==

commit 6fa977520871b1fc0be64247abad02b678c13fda
Author: Mike Miller <mike.miller@hp.com>
Date:   Thu Oct 28 06:33:27 2010 -0600

    cciss: remove overlapping PCI IDs
    
    This patch removes the controller overlap between cciss and hpsa. It was
    decided that no overlap should exist. All new controllers will use the hpsa
    SCSI based driver.
    
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

git describe --contains 6fa977520871b1
v2.6.37-rc1~75^2





From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Tue, 25 Aug 2009 19:28:49 +0000
Message-ID: <1251228529.7539.8.camel@mulgrave.site>
References: <200908252124.22562.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbZHYT2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 15:28:54 -0400
In-Reply-To: <200908252124.22562.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Tue, 2009-08-25 at 21:24 +0200, Arkadiusz Miskiewicz wrote:
> What could be the reason for scsi_wait_scan not waiting untill all disks are 
> found?
> 
> I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios Logic MegaRAID 530 
> SCSI 320-0X RAID controller and modprobe scsi_wait_scan finishes earlier than 
> disks are found.
> 
> My initrd (romfs) does:
> insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_mm.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_mbox.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_scan.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/exportfs.ko
> insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
> if [ "${ROOT##/dev/}" != "${ROOT}" ]; then
> rootnr="$(busybox awk -v rootnode="${ROOT##/dev/}" '$4 == rootnode { print 256 
> * $1 + $2 }' /proc/partitions)"
> if [ -n "$rootnr" ]; then
> echo "$rootnr" > /proc/sys/kernel/real-root-dev
> fi
> 
> 
> Now if I add sleep few seconds or /bin/sh at the end of this initrd, then boot 
> and then disks are detected properly and rootfs is mounted properly (after I 
> exit from sh in case when /bin/sh is used).
> 
> The question remains - why scsi_wait_scan doesn't wait?

It's caused by the sd async patches.  What's happening is wait_scan is
waiting until all the scans are complete, but now sd attachment may not
be completed by the time that happens.  So, although you have a scanned
disk, you can't mount it without and attached sd driver. Hopefully when
all initrds are configured to wait until root appears, this problem will
go away.

James



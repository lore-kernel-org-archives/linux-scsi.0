From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Tue, 25 Aug 2009 19:15:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908251912370.3665-100000@netrider.rowland.org>
References: <200908252322.51810.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39724 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932221AbZHYXPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 19:15:05 -0400
In-Reply-To: <200908252322.51810.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Tue, 25 Aug 2009, Arkadiusz Miskiewicz wrote:

> On Tuesday 25 of August 2009, Arkadiusz Miskiewicz wrote:
> > On Tuesday 25 of August 2009, you wrote:
> > > On Tue, 2009-08-25 at 21:44 +0200, Arkadiusz Miskiewicz wrote:
> > > > On Tuesday 25 of August 2009, James Bottomley wrote:
> > > > > On Tue, 2009-08-25 at 21:24 +0200, Arkadiusz Miskiewicz wrote:
> > > > > > What could be the reason for scsi_wait_scan not waiting untill all
> > > > > > disks are found?
> > > > > >
> > > > > > I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios Logic
> > > > > > MegaRAID 530 SCSI 320-0X RAID controller and modprobe
> > > > > > scsi_wait_scan finishes earlier than disks are found.
> > > > > >
> > > > > > My initrd (romfs) does:
> > > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod.ko
> > > > > > insmod
> > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_mm.
> > > > > >ko insmod
> > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_mbo
> > > > > >x. ko insmod /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.ko
> > > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.ko
> > > > > > insmod
> > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_scan.ko
> > > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/exportfs.ko
> > > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
> > > > > > if [ "${ROOT##/dev/}" != "${ROOT}" ]; then
> > > > > > rootnr="$(busybox awk -v rootnode="${ROOT##/dev/}" '$4 == rootnode
> > > > > > { print 256 * $1 + $2 }' /proc/partitions)"
> > > > > > if [ -n "$rootnr" ]; then
> > > > > > echo "$rootnr" > /proc/sys/kernel/real-root-dev
> > > > > > fi
> > > > > >
> > > > > >
> > > > > > Now if I add sleep few seconds or /bin/sh at the end of this
> > > > > > initrd, then boot and then disks are detected properly and rootfs
> > > > > > is mounted properly (after I exit from sh in case when /bin/sh is
> > > > > > used).
> > > > > >
> > > > > > The question remains - why scsi_wait_scan doesn't wait?
> > > > >
> > > > > It's caused by the sd async patches.  What's happening is wait_scan
> > > > > is waiting until all the scans are complete, but now sd attachment
> > > > > may not be completed by the time that happens.  So, although you have
> > > > > a scanned disk, you can't mount it without and attached sd driver.
> > > > >
> > > > > Hopefully when
> > > > > all initrds are configured to wait until root appears, this problem
> > > > > will go away.
> > > >
> > > > Uh, ugly. I'll disable SCSI_SCAN_ASYNC here then.
> > >
> > > That won't actually help: the sd async scan is a separate mechanism not
> > > tied to that variable
> >
> > I assume there is no configurable way to disable this?
> 
> I found this patch
> 
> http://marc.info/?l=linux-scsi&m=124388639906873&w=2
> 
> but it doesn't work on 30.5 (it's still not waiting untill everything is 
> discovered)

Did you remember to rebuild your initrd after applying this patch and 
rebuilding the module?

Can you provide the dmesg log showing what happens during bootup with 
the patch applied?

Alan Stern


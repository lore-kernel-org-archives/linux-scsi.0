From: Pat LaVarre <p.lavarre@ieee.org>
Subject: oops if unplug dd of=/dev/scd$n
Date: 12 Sep 2003 08:57:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063378664.5059.19.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:63373 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261778AbTILRTb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 13:19:31 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 88FE81818
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2003 11:19:30 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's an oops for we of linux-scsi to fix, brought to us courtesy the
usb-storage mailing list  ...

> > > Subject: [usb-storage] unplug while writing
> > >
> > > I inadvertently unplugged a [usb] drive during a
> > > 2.6.0-test5:
> > >
> > > sudo dd of=/dev/scd1 if=/dev/zero bs=1M count=128
> > >
> > > And I got the following /proc/kmsg ...
> > >
> > > I ask because seemingly til reboot I'm
> > > stuck with:
> > > $
> > > $ /sbin/modprobe -r sr_mod
> > > FATAL: Module sr_mod is in use.
> > > $
> >
> > ... always ... an oops ... Must be fixed.
>
> ... doesn't look like a usb-storage specific
> problem; ... looks ... like a SCSI hotplug
> problem ... Unplug while writing should 'work'
> gracefully.  Much of the filesystem code
> doesn't yet handle this, but something like
> dd to a scd node should.

Pat LaVarre

...
<4>SCSI error : <1 0 0 0> return code = 0x70000
<4>end_request: I/O error, dev sr1, sector 154656
<3>Buffer I/O error on device sr1, logical block 19332
<4>lost page write due to I/O error on sr1
...
<4>lost page write due to I/O error on sr1
<4>SCSI error : <1 0 0 0> return code = 0x10000
<4>end_request: I/O error, dev sr1, sector 262136
<3>Buffer I/O error on device sr1, logical block 32767
<4>lost page write due to I/O error on sr1
<1>Unable to handle kernel NULL pointer dereference at virtual address 00000000
<4> printing eip:
<4>c01eb383
<1>*pde = 00000000
<4>Oops: 0000 [#1]
<4>CPU:    1
<4>EIP:    0060:[<c01eb383>]    Not tainted
<4>EFLAGS: 00010282
<4>EIP is at get_kobj_path_length+0x19/0x30
<4>eax: 00000000   ebx: 00000000   ecx: ffffffff   edx: d60e0af4
<4>esi: 00000015   edi: 00000000   ebp: ce1cde78   esp: ce1cde6c
<4>ds: 007b   es: 007b   ss: 0068
<4>Process dd (pid: 3015, threadinfo=ce1cc000 task=ce73f940)
<4>Stack: ce1cc000 0000008c dda34300 ce1cdec0 c01eb543 c03ff060 d65fe1ac 0000008c 
<4>       d65fe188 ce1cdea4 df91e1be ce17e400 dda34280 ce17e419 c03c35a0 c038cfce 
<4>       00000000 d65fe1b0 d65fe1ac c03ff0a8 de6066ac ce1cded8 c01eba47 c0387165 
<4>Call Trace:
<4> [<c01eb543>] kset_hotplug+0x15e/0x2b0
<4> [<df91e1be>] sr_remove+0x6f/0x8d [sr_mod]
<4> [<c01eba47>] kobject_del+0x66/0x6d
<4> [<c024bbd1>] device_del+0x83/0xa5
<4> [<c0280f64>] scsi_device_put+0xe0/0xfe
<4> [<df8e78d6>] cdrom_release+0x8c/0x105 [cdrom]
<4> [<c0166597>] blkdev_put+0x20f/0x23e
<4> [<c015e497>] __fput+0x123/0x135
<4> [<c015caf4>] filp_close+0x57/0x81
<4> [<c015cb9f>] sys_close+0x81/0xc7
<4> [<c010b46d>] sysenter_past_esp+0x52/0x71
<4>
<4>Code: f2 ae f7 d1 49 8b 52 24 8d 74 31 01 85 d2 75 e7 5b 89 f0 5e 
<4> <6>updfstab: numerical sysctl 1 23 is obsolete.
...



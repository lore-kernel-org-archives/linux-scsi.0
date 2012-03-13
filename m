From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()
 -- should I be concerned?
Date: Tue, 13 Mar 2012 19:56:36 +0400
Message-ID: <4F5F6E34.6070208@msgid.tls.msk.ru>
References: <4F5379F5.6010604@msgid.tls.msk.ru> <4F545EB5.1070700@msgid.tls.msk.ru> <4F54FE51.1010401@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:52095 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2CMP4j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 11:56:39 -0400
In-Reply-To: <4F54FE51.1010401@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 05.03.2012 21:56, Bart Van Assche wrote:
> On 03/05/12 06:35, Michael Tokarev wrote:
>> [   22.635290] WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()
> 
> I've seen that warning message a few times myself, but no longer after
> having applied this patch:*[PATCH] Fix NULL pointer dereference in
> sd_revalidate_disk <http://marc.info/?t=113987361900002&r=1&w=2>*
> (http://marc.info/?l=linux-kernel&m=132987267132047).

So, should this patch go to -stable 3.0 maybe?  I tried 3.0
kernel on a few more machines here, and many of them shows
this very warning.  Here's a fresh example from today:

[    0.784600] aic7xxx 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[    5.996733] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[    5.996735]         <Adaptec 3950B Ultra2 SCSI adapter>
[    5.996736]         aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
..
[    8.976584]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    8.985840]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
[    8.986271]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
[    8.986886]  sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 sdd7 sdd8 >
[    9.065080] ------------[ cut here ]------------
[    9.065134] WARNING: at block/genhd.c:1474 __disk_unblock_events+0x123/0x130()
[    9.065193] Hardware name: System Product Name
[    9.065234] Modules linked in: aic7xxx(+) scsi_transport_spi sd_mod scsi_mod crc_t10dif
[    9.065411] Pid: 280, comm: blkid Not tainted 3.0.0-amd64 #3.0.23
[    9.065455] Call Trace:
[    9.065496]  [<ffffffff8104c0db>] ? warn_slowpath_common+0x7b/0xc0
[    9.065542]  [<ffffffff811d7fc3>] ? __disk_unblock_events+0x123/0x130
[    9.065588]  [<ffffffff8115fefa>] ? __blkdev_get+0x19a/0x420
[    9.065632]  [<ffffffff811604b0>] ? blkdev_get+0x330/0x330
[    9.065675]  [<ffffffff811601cb>] ? blkdev_get+0x4b/0x330
[    9.065718]  [<ffffffff811604b0>] ? blkdev_get+0x330/0x330
[    9.065763]  [<ffffffff8112bb36>] ? __dentry_open+0x156/0x320
[    9.065807]  [<ffffffff8113733e>] ? path_get+0x1e/0x30
[    9.065850]  [<ffffffff8113a7b0>] ? do_last+0xe0/0x8f0
[    9.065893]  [<ffffffff8113bd43>] ? path_openat+0xd3/0x420
[    9.065937]  [<ffffffff8113c1bd>] ? do_filp_open+0x4d/0xc0
[    9.065981]  [<ffffffff81147dbb>] ? alloc_fd+0x4b/0x130
[    9.066024]  [<ffffffff8112b781>] ? do_sys_open+0x101/0x1e0
[    9.066069]  [<ffffffff81360f60>] ? cstar_dispatch+0x7/0x2e
[    9.066113] ---[ end trace 14d0a5b9a96ea726 ]---
[    9.121871] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.130588] sd 0:0:1:0: [sdb] Attached SCSI disk
[    9.147290] sd 0:0:2:0: [sdc] Attached SCSI disk
[    9.189841] sd 0:0:3:0: [sdd] Attached SCSI disk
[   11.210126] scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   11.210128]         <Adaptec 3950B Ultra2 SCSI adapter>
[   11.210129]         aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs

The pattern is common, it is always blkid, the same calltrace,
and after this message, there's a long delay in discovery of
next adaptor/address, sometimes with reported errors like the
one from mptbase in my first message.

I'll try applying the patch mentioned, but really, if that's
a known and fixed issue, shouldn't it go to -stable?

Thank you!

/mjt

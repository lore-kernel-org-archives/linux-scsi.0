From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Wed, 01 Aug 2007 08:51:14 -0500
Message-ID: <1185976274.3468.70.camel@localhost.localdomain>
References: <46ACE62F.4070108@panasas.com> <46ACEA0A.5040101@panasas.com>
	 <20070730171331.5237bb94.rdunlap@xenotime.net>
	 <46AEEBF7.3060808@panasas.com>
	 <20070731114021.488735ec.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:32910 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbXHANvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 09:51:16 -0400
In-Reply-To: <20070731114021.488735ec.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "=?ISO-8859-1?Q? J=FCrg?= =?ISO-8859-1?Q?en_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-07-31 at 11:40 -0700, Randy Dunlap wrote:
> On Tue, 31 Jul 2007 10:59:51 +0300 Boaz Harrosh wrote:
> 
> > Randy Dunlap wrote:
> > > 
> > > Since you grok all of that (above), maybe you can help here:
> > > 
> > > With these 6 patches applied, I do the following:
> > > 
> > > 1.  insert PCMCIA aha152x card with SCSI drive attached (/dev/sdb4)
> > > 2.  mount -t vfat /dev/sdb4 /mnt/disk
> > > 3.  play with /mnt/disk
> > > 4.  umount /mnt/disk
> > > 
> > > Now I would like to rmmod the aha152x_cs module, but its use count
> > > is 2.  Even if I eject the card, its use count stays at 2.
> > > Maybe the reset or check_condition patch doesn't clean up correctly,
> > > or one of them isn't releasing a used resource ?
> > > 
> > > (this is 2.6.23-rc1 + your 6 patches + 1 acpi seq-file throttling fix.)
> > > 
> > 
> > I had an hard look and a very careful line-by-line compare
> > and I can't find anything obvious. Could you do a bisect.
> > maybe it will give me a clue as to where to look. Also please
> > Enable debug prints. Maybe the driver is stuck at some state 
> > and does not exit.
> 
> The good news is that this problem has nothing to do with this
> patch series.  The bad news is that this problem is there anyway.

So on a functionality basis you're prepared to ack this patch set on the
basis of empirical testing on the grounds that the bug predates them?

> When I umount /mnt/disk and then eject the SCSI adapter card,
> a sync-cache SCSI command is sent to the LLD and its use count
> increments, but the LLD cannot send this command to the drive.
> The LLD never recovers from this situation.
> 
> 
> [   88.821277] pccard: card ejected from slot 0
> [   88.830891] sd 2:0:4:0: [sdb] Synchronizing SCSI cache
> [   88.836187] (scsi2:4:0) queue: f7fab1a0; cmd_len=10 pieces=0 size=0 cmnd=Synchronize Cac
> he(10) 35 00 00 00 00 00 00 00 00 00
> [   88.847545] (scsi-1:-1:-1) (aha152x_internal_queue:1039) locking
> [   88.853528] (scsi-1:-1:-1) (aha152x_internal_queue:1039) locked
> [   88.859437] (scsi-1:-1:-1) (aha152x_internal_queue:1055) unlocking (locked at aha152x_in
> ternal_queue:1039)
> [   88.869051] (scsi-1:-1:-1) (aha152x_internal_queue:1055) unlocked
> [   89.884469] (scsi-1:-1:-1) (aha152x_abort:1113) locking
> [   89.889717] (scsi-1:-1:-1) (aha152x_abort:1113) locked
> [   89.894835] (scsi-1:-1:-1) (aha152x_abort:1123) unlocking (locked at aha152x_abort:1113)
> [   89.902904] (scsi-1:-1:-1) (aha152x_abort:1123) unlocked
> [   89.908224] (scsi2:4:0) queue: f7fab1a0; cmd_len=6 pieces=0 size=0 cmnd=Test Unit Ready 
> 00 00 00 00 00 00
> [   89.917878] (scsi-1:-1:-1) (aha152x_internal_queue:1039) locking
> [   89.923861] (scsi-1:-1:-1) (aha152x_internal_queue:1039) locked
> [   89.929764] (scsi-1:-1:-1) (aha152x_internal_queue:1055) unlocking (locked at aha152x_in
> ternal_queue:1039)
> [   89.939375] (scsi-1:-1:-1) (aha152x_internal_queue:1055) unlocked
> [   90.415863] (scsi-1:-1:-1) (aha152x_abort:1113) locking
> [   90.421098] (scsi-1:-1:-1) (aha152x_abort:1113) locked
> [   90.426219] (scsi-1:-1:-1) (aha152x_abort:1123) unlocking (locked at aha152x_abort:1113)
> [   90.434289] (scsi-1:-1:-1) (aha152x_abort:1123) unlocked
> [   90.439593] (scsi-1:-1:-1) (aha152x_device_reset:1173) locking
> [   90.445412] (scsi-1:-1:-1) (aha152x_device_reset:1173) locked
> [   90.451134] (scsi-1:-1:-1) (aha152x_device_reset:1176) unlocking (locked at aha152x_devi
> ce_reset:1173)
> [   90.460413] (scsi-1:-1:-1) (aha152x_device_reset:1176) unlocked
> [   90.466319] (scsi2:4:0) queue: f7fab1a0; cmd_len=0 pieces=0 size=0 cmnd=Synchronize Cach
> e(10) 35 00 00 00 00 00 00 00 00 00
> [   90.477686] (scsi2:4:0) cannot reuse command

OK ... I'll take a look into this ... it seems to be something trivial
in the state machine.

James



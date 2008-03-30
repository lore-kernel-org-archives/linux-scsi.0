From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/9][RESEND] mvsas: fill in error info record and phy
	mode6 bits.
Date: Sun, 30 Mar 2008 10:03:12 -0500
Message-ID: <1206889392.4224.16.camel@localhost.localdomain>
References: <47EB4464.4070308@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44595 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbYC3PDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 11:03:16 -0400
In-Reply-To: <47EB4464.4070308@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

On Thu, 2008-03-27 at 14:53 +0800, Ke Wei wrote:
> and remove some unused members from struct.

Well ... I'll put this in, since it's an improvement.  However, it looks
like error handling is broken; this is what I get ejecting a CD (which
was successfully inserted and read):

00000000 : 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
00 : ................

sas: command 0xf53617c0, task 0xf741fcb0, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf741fcb0
sas: sas_scsi_find_task: aborting task 0xf741fcb0
sas: sas_scsi_find_task: task 0xf741fcb0 is aborted
sas: sas_eh_handle_sas_errors: task 0xf741fcb0 is aborted
sas: --- Exit sas_scsi_recover_host
BUG: unable to handle kernel paging request at 6b6b6c2b
IP: [<c014066b>] __lock_acquire+0x6b/0xff0
*pde = 00000000 
Oops: 0002 [#1] SMP 
Modules linked in: isofs iTCO_wdt serio_raw iTCO_vendor_support
i3000_edac ext3 jbd mbcache sg sr_mod cdrom sd_mod uhci_hcd tg3 aic79xx
scsi_transport_spi aic94xx usbcore mvsas libsas libata firmware_class
scsi_transport_sas scsi_mod

Pid: 0, comm: swapper Not tainted (2.6.25-rc7 #78)
EIP: 0060:[<c014066b>] EFLAGS: 00010002 CPU: 0
EIP is at __lock_acquire+0x6b/0xff0
EAX: 00000002 EBX: 00000046 ECX: f741fccc EDX: 00000002
ESI: 00000001 EDI: 6b6b6b6b EBP: c0479e38 ESP: c0479db8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c0478000 task=c044c3c0 task.ti=c0478000)
Stack: c044c3c0 c044c3c0 00000001 c044c3c0 c02f4c77 00000292 c0479de0
c01400fa 
       f531d1ec 00000292 c0479df0 00000292 00000002 00000000 00000000
f741fccc 
       c044c3c0 f799c1c0 c0479e2c f89ce647 00000286 000002b4 f531d030
c044c3c0 
Call Trace:
 [<c02f4c77>] ? _spin_unlock_irqrestore+0x47/0x60
 [<c01400fa>] ? trace_hardirqs_on+0x7a/0x140
 [<f89ce647>] ? scsi_run_queue+0xf7/0x1b0 [scsi_mod]
 [<c0141668>] ? lock_acquire+0x78/0xa0
 [<f8837fb0>] ? mvs_slot_complete+0x60/0x300 [mvsas]
 [<c02f47cb>] ? _spin_lock+0x2b/0x40
 [<f8837fb0>] ? mvs_slot_complete+0x60/0x300 [mvsas]
 [<f8837fb0>] ? mvs_slot_complete+0x60/0x300 [mvsas]
 [<f8838351>] ? mvs_int_full+0x91/0x450 [mvsas]
 [<f8839459>] ? mvs_interrupt+0x39/0x60 [mvsas]
 [<c02f47d2>] ? _spin_lock+0x32/0x40
 [<f8839460>] ? mvs_interrupt+0x40/0x60 [mvsas]
 [<c0150fc8>] ? handle_IRQ_event+0x28/0x60
 [<c01523a1>] ? handle_fasteoi_irq+0x71/0xe0
 [<c01066d8>] ? do_IRQ+0x48/0xa0
 [<c0104c26>] ? common_interrupt+0x2e/0x34
 [<c01400d8>] ? trace_hardirqs_on+0x58/0x140
 [<c0102d93>] ? default_idle+0x63/0xa0
 [<c0102d30>] ? default_idle+0x0/0xa0
 [<c0102bbd>] ? cpu_idle+0x5d/0xe0
 [<c02e5969>] ? rest_init+0x49/0x50
 =======================
Code: c4 02 0f 85 78 05 00 00 83 7d b8 07 0f 87 9f 05 00 00 8b 4d b8 85
c9 0f 85 6b 03 00 00 8b 4d bc 8b 79 04 85 ff 0f 84 5d 03 00 00 <f0> ff
87 c0 00 00 00 89 f8 e8 57 d4 ff ff 85 c0 0f 85 00 02 00 
EIP: [<c014066b>] __lock_acquire+0x6b/0xff0 SS:ESP 0068:c0479db8
Kernel panic - not syncing: Fatal exception in interrupt



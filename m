From: Ke Wei <kewei@marvell.com>
Subject: Re: [PATCH 1/9][RESEND] mvsas: fill in error info record and phy
 mode6 bits.
Date: Mon, 31 Mar 2008 18:44:15 +0800
Message-ID: <47F0C07F.8060109@marvell.com>
References: <47EB4464.4070308@marvell.com> <1206889392.4224.16.camel@localhost.localdomain>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:49541 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751543AbYCaKoT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 06:44:19 -0400
In-Reply-To: <1206889392.4224.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

James Bottomley wrote:
> Well ... I'll put this in, since it's an improvement.  However, it looks
> like error handling is broken; this is what I get ejecting a CD (which
> was successfully inserted and read):
> 
Today I checked this bug report. It doesn't happen. Do you have more detail information? 
But I observed that the GPCMD_GET_EVENT_STATUS_NOTIFICATION command will be retried when timeout occurs. Maybe it will cause WARNING then system hangs sometimes. 

------------[ cut here ]------------
WARNING: at drivers/ata/libata-core.c:5769 __ata_qc_complete+0x9f/0xc0()
Modules linked in: mvsas dm_mod md_mod lp parport_pc psmouse floppy parport serio_raw pcspkr rng_core ide_pci_generic it821x button af_packet evdev ide_generic piix usbhid thermal processor fan [last unloaded: mvsas]
Pid: 1437, comm: cc1 Not tainted 2.6.25-rc6 #5
 [<c01289cf>] warn_on_slowpath+0x5f/0xa0
 [<c0149e20>] __lock_acquire+0x250/0x10b0
 [<c03eb61f>] __ata_qc_complete+0x9f/0xc0
 [<c03cb19b>] sas_ata_task_done+0xdb/0x250
 [<d78d52f0>] mvs_slot_complete+0x160/0x2f0 [mvsas]
 [<d78d52fa>] mvs_slot_complete+0x16a/0x2f0 [mvsas]
 [<d78d5578>] mvs_int_full+0x98/0x480 [mvsas]
 [<d78d599c>] mvs_interrupt+0x3c/0x60 [mvsas]
 [<c015c1d0>] handle_IRQ_event+0x20/0x60
 [<c015dcc9>] handle_fasteoi_irq+0x79/0x110
 [<c010734b>] do_IRQ+0x3b/0x80
 [<c0105792>] common_interrupt+0x2e/0x34
 [<c012007b>] pick_next_highest_task_rt+0x6b/0x110
 [<c012dce2>] __do_softirq+0x72/0x100
 [<c012ddc5>] do_softirq+0x55/0x60
 [<c0111f54>] smp_apic_timer_interrupt+0x54/0x80
 [<c0105869>] apic_timer_interrupt+0x29/0x38
 [<c0105873>] apic_timer_interrupt+0x33/0x38
 =======================
---[ end trace ea458b53b1ca42bf ]---
sr0: CDROM (ioctl) error, command: Read TOC/PMA/ATIP 43 00 00 00 00 00 00 00 0c 00
sr: Sense Key : No Sense [current] 
sr: Add. Sense: No additional sense information


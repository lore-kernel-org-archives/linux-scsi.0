From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Fwd: 2.6.17-rc5-mm1
Date: Tue, 30 May 2006 20:57:19 +0200
Message-ID: <6bffcb0e0605301157o6b7c5f66q3c9f151cbb4537d5@mail.gmail.com>
References: <20060530022925.8a67b613.akpm@osdl.org>
	 <6bffcb0e0605301155h3b472d79h65e8403e7fa0b214@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:56304 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S932393AbWE3S5V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 14:57:21 -0400
Received: by wr-out-0506.google.com with SMTP id i21so740135wra
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 11:57:20 -0700 (PDT)
In-Reply-To: <6bffcb0e0605301155h3b472d79h65e8403e7fa0b214@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-scsi@vger.kernel.org

Sorry, I forgot CC.

---------- Forwarded message ----------
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: 30-May-2006 20:55
Subject: Re: 2.6.17-rc5-mm1
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org


Hi,

On 30/05/06, Andrew Morton <akpm@osdl.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17-rc5/2.6.17-rc5-mm1/
>

SCSI or libata problem.
============================
[ BUG: illegal lock usage! ]
----------------------------
illegal {in-hardirq-W} -> {hardirq-on-W} usage.
init/1 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&base->lock#2){++..}, at: [<c0129a24>] lock_timer_base+0x29/0x55
{in-hardirq-W} state was registered at:
  [<c0139a56>] lockdep_acquire+0x69/0x82
  [<c02f237c>] _spin_lock_irqsave+0x2a/0x3a
  [<c0129a24>] lock_timer_base+0x29/0x55
  [<c0129e48>] del_timer+0x19/0x4c
  [<c02651e2>] scsi_delete_timer+0xe/0x1f
  [<c0262964>] scsi_done+0xb/0x19
  [<c0273ed3>] ata_scsi_qc_complete+0x73/0x7f
  [<c027024a>] __ata_qc_complete+0x26c/0x274
  [<c02704f0>] ata_qc_complete+0xd5/0xdc
  [<c0270c42>] ata_hsm_qc_complete+0x201/0x210
  [<c02713e7>] ata_hsm_move+0x796/0x7ac
  [<c027314e>] ata_interrupt+0x173/0x1b4
  [<c014c4f4>] handle_IRQ_event+0x20/0x50
  [<c014d76e>] handle_level_irq+0xa1/0xeb
  [<c010579c>] do_IRQ+0xa1/0xc9
irq event stamp: 576924
hardirqs last  enabled at (576923): [<c02f26c7>]
_spin_unlock_irqrestore+0x36/0x69
hardirqs last disabled at (576924): [<c02f2361>] _spin_lock_irqsave+0xf/0x3a
softirqs last  enabled at (576878): [<c0125873>] __do_softirq+0xea/0xf0
softirqs last disabled at (576869): [<c0105689>] do_softirq+0x59/0xcb

other info that might help us debug this:
1 locks held by init/1:
 #0:  (&base->lock#2){++..}, at: [<c0129a24>] lock_timer_base+0x29/0x55

stack backtrace:
 [<c0103e52>] show_trace_log_lvl+0x4b/0xf4
 [<c01044b3>] show_trace+0xd/0x10
 [<c010457b>] dump_stack+0x19/0x1b
 [<c0137d63>] print_usage_bug+0x1a1/0x1ab
 [<c0138458>] mark_lock+0x2d7/0x514
 [<c01386dc>] mark_held_locks+0x47/0x65
 [<c0139745>] trace_hardirqs_on+0x12b/0x16f
 [<c02f2b61>] restore_nocheck+0x8/0xb

Here is config
http://www.stardust.webpages.pl/files/mm/2.6.17-rc5-mm1/mm-config2

Here is dmesg
http://www.stardust.webpages.pl/files/mm/2.6.17-rc5-mm1/mm-dmesg2

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/wiki/)

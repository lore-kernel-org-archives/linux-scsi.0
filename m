From: James.Smart@Emulex.Com
Subject: RE: [Patch] Fix Suspend I/O block/unblock patch
Date: Sat, 16 Oct 2004 17:59:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C08670E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56492 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S268915AbUJPV7N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 17:59:13 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

> Could you give an example of this problem?  If there's a demonstrable
> issue with device_for_each_child(), we can probably persuade Greg to
> alter it.

Here's the stack trace that was giving us headaches...

Oct 11 10:04:37 daffy kernel: Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
Oct 11 10:04:37 daffy kernel: in_atomic():1, irqs_disabled():0
Oct 11 10:04:37 daffy kernel:  [<c0122f15>] __might_sleep+0x95/0xb0
Oct 11 10:04:37 daffy kernel:  [<f8834600>] fc_timeout_blocked_tgt+0x0/0x40 [scsi_transport_fc]
Oct 11 10:04:37 daffy kernel:  [<c0230516>] device_for_each_child+0x26/0x80
Oct 11 10:04:37 daffy kernel:  [<f88345f0>] fc_device_unblock+0x0/0x10 [scsi_transport_fc]
Oct 11 10:04:37 daffy kernel:  [<f8834600>] fc_timeout_blocked_tgt+0x0/0x40 [scsi_transport_fc]
Oct 11 10:04:38 daffy kernel:  [<c012e2f9>] run_timer_softirq+0xd9/0x170
Oct 11 10:04:38 daffy kernel:  [<c012a262>] __do_softirq+0x62/0xe0
Oct 11 10:04:38 daffy kernel:  [<c012a30d>] do_softirq+0x2d/0x40
Oct 11 10:04:38 daffy kernel:  [<c011ac3a>] smp_apic_timer_interrupt+0xfa/0x110
Oct 11 10:04:38 daffy kernel:  [<c0107a6e>] apic_timer_interrupt+0x1a/0x20
Oct 11 10:04:38 daffy kernel:  [<c0105030>] default_idle+0x0/0x40
Oct 11 10:04:38 daffy kernel:  [<c0105059>] default_idle+0x29/0x40
Oct 11 10:04:38 daffy kernel:  [<c01050e4>] cpu_idle+0x34/0x50
Oct 11 10:04:38 daffy kernel:  target207:0:2: blocked target time out: target resuming


-- James S

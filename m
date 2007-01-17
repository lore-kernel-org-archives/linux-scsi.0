From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 17 Jan 2007 17:20:08 -0500
Message-ID: <45AEA118.5030608@torque.net>
References: <45ACA765.3030701@aboo.org> <45AD80F3.6020100@torque.net> <45ADE01F.3020708@s5r6.in-berlin.de> <45ADF979.7090003@aboo.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXAQWUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 17:20:25 -0500
In-Reply-To: <45ADF979.7090003@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> Hi All,
> 
> Thanks everyone to have a look at this.
> 
> I think i modified to have the latest kernel support. Unfortunately I
> could not test it with 2.6.20 kernel due to some issues in my laptop and
> 2.6.20 kernel. But it should work with 2.6.20 with this modification.
> 
> The modified version is available through
> http://vscsihba.aboo.org/vscsihbav202.tgz.
> 
> 1. I fixed the kmem_cache issue for sure.
> 2. I think i got around with INIT_WORK ... Made the following
> modifications ...

Perhaps you could get some of my scsi tools (e.g.
sdparm and sg3_utils) and make sure that vscsihba
can handle everything they can throw at it.
If the user space doesn't support a SCSI command then
your driver should fail gracefully (i.e. CHECK CONDITION,
etc).

Here is a worrying example: sdparm sends an INQUIRY
and a couple of MODE SENSE(10) commands to a device.
/dev/sda was created by your script:
$ ./start_target.sh id=3 -files zz_lun0

$ sdparm /dev/sda
    /dev/sda: VirtualH  VHD               0
<long wait>
$


However dmesg showed this:

vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
sd 0:0:0:0: SCSI error: return code = 0x00000002
end_request: I/O error, dev sda, sector 10240
Buffer I/O error on device sda, logical block 10240
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
sd 0:0:0:0: SCSI error: return code = 0x00000002
end_request: I/O error, dev sda, sector 10240
Buffer I/O error on device sda, logical block 10240
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
sd 0:0:0:0: SCSI error: return code = 0x00000002
end_request: I/O error, dev sda, sector 10240
Buffer I/O error on device sda, logical block 10240
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
sd 0:0:0:0: SCSI error: return code = 0x00000002
end_request: I/O error, dev sda, sector 10240
Buffer I/O error on device sda, logical block 10240
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
sd 0:0:0:0: SCSI error: return code = 0x00000002
end_request: I/O error, dev sda, sector 10240
Buffer I/O error on device sda, logical block 10240
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
vscsihba:3: In Reset Device
sd 0:0:0:0: SCSI error: return code = 0x00000002
end_request: I/O error, dev sda, sector 10240
Buffer I/O error on device sda, logical block 10240
BUG: at kernel/sched.c:3388 sub_preempt_count()
 [<e1bf029c>] scsitap_eh_abort+0x1c/0x90 [vscsihba]
 [<c024fe22>] scsi_error_handler+0x3e2/0xbe0
 [<c02d74f1>] __sched_text_start+0x2f1/0x660
 [<c024fa40>] scsi_error_handler+0x0/0xbe0
 [<c0131679>] kthread+0xa9/0xe0
 [<c01315d0>] kthread+0x0/0xe0
 [<c0103d0f>] kernel_thread_helper+0x7/0x18
 =======================
vscsihba:3: Abortng command serial number : 94
BUG: scheduling while atomic: scsi_eh_0/0x00000001/4749
 [<c02d7684>] __sched_text_start+0x484/0x660
 [<c013183b>] autoremove_wake_function+0x1b/0x50
 [<c01264a8>] lock_timer_base+0x28/0x70
 [<c01265f2>] __mod_timer+0x92/0xd0
 [<c02d826b>] schedule_timeout+0x4b/0xd0
 [<c01269c0>] process_timeout+0x0/0x10
 [<c02d7bbc>] wait_for_completion_timeout+0x9c/0x130
 [<c0119ee0>] default_wake_function+0x0/0x10
 [<c024f3c9>] scsi_send_eh_cmnd+0x1b9/0x390
 [<c011df3e>] vprintk+0x1fe/0x3a0
 [<c024f805>] scsi_delete_timer+0x15/0x60
 [<c024f624>] scsi_eh_tur+0x34/0xa0
 [<c024fe69>] scsi_error_handler+0x429/0xbe0
 [<c02d74f1>] __sched_text_start+0x2f1/0x660
 [<c024fa40>] scsi_error_handler+0x0/0xbe0
 [<c0131679>] kthread+0xa9/0xe0
 [<c01315d0>] kthread+0x0/0xe0
 [<c0103d0f>] kernel_thread_helper+0x7/0x18
 =======================
vscsihba:3: Abortng command serial number : 95
vscsihba:3: In Reset Device
BUG: scheduling while atomic: scsi_eh_0/0x00000001/4749
 [<c02d7684>] __sched_text_start+0x484/0x660
 [<c011df3e>] vprintk+0x1fe/0x3a0
 [<c01264a8>] lock_timer_base+0x28/0x70
 [<c01265f2>] __mod_timer+0x92/0xd0
 [<c02d826b>] schedule_timeout+0x4b/0xd0
 [<c01269c0>] process_timeout+0x0/0x10
 [<c02d7bbc>] wait_for_completion_timeout+0x9c/0x130
 [<c0119ee0>] default_wake_function+0x0/0x10
 [<c024f3c9>] scsi_send_eh_cmnd+0x1b9/0x390
 [<c024f805>] scsi_delete_timer+0x15/0x60
 [<c024f624>] scsi_eh_tur+0x34/0xa0
 [<e1bf00cd>] scsitap_eh_device_reset+0x1d/0x30 [vscsihba]
 [<c02503a8>] scsi_error_handler+0x968/0xbe0
 [<c02d74f1>] __sched_text_start+0x2f1/0x660
 [<c024fa40>] scsi_error_handler+0x0/0xbe0
 [<c0131679>] kthread+0xa9/0xe0
 [<c01315d0>] kthread+0x0/0xe0
 [<c0103d0f>] kernel_thread_helper+0x7/0x18
 =======================
vscsihba:3: Abortng command serial number : 96
vscsihba:3: In Reset Host
BUG: scheduling while atomic: scsi_eh_0/0x00000001/4749
 [<c02d7684>] __sched_text_start+0x484/0x660
 [<c01264a8>] lock_timer_base+0x28/0x70
 [<c01265f2>] __mod_timer+0x92/0xd0
 [<c02d826b>] schedule_timeout+0x4b/0xd0
 [<c01269c0>] process_timeout+0x0/0x10
 [<c01273d5>] msleep+0x25/0x30
 [<c024efb1>] scsi_try_host_reset+0xa1/0xd0
 [<c0250150>] scsi_error_handler+0x710/0xbe0
 [<c02d74f1>] __sched_text_start+0x2f1/0x660
 [<c024fa40>] scsi_error_handler+0x0/0xbe0
 [<c0131679>] kthread+0xa9/0xe0
 [<c01315d0>] kthread+0x0/0xe0
 [<c0103d0f>] kernel_thread_helper+0x7/0x18
 =======================
BUG: scheduling while atomic: scsi_eh_0/0x00000001/4749
 [<c02d7684>] __sched_text_start+0x484/0x660
 [<c01264a8>] lock_timer_base+0x28/0x70
 [<c01265f2>] __mod_timer+0x92/0xd0
 [<c02d826b>] schedule_timeout+0x4b/0xd0
 [<c01269c0>] process_timeout+0x0/0x10
 [<c02d7bbc>] wait_for_completion_timeout+0x9c/0x130
 [<c0119ee0>] default_wake_function+0x0/0x10
 [<c024f3c9>] scsi_send_eh_cmnd+0x1b9/0x390
 [<c02d74f1>] __sched_text_start+0x2f1/0x660
 [<c01265f2>] __mod_timer+0x92/0xd0
 [<c02d8272>] schedule_timeout+0x52/0xd0
 [<c024f624>] scsi_eh_tur+0x34/0xa0
 [<c02501a0>] scsi_error_handler+0x760/0xbe0
 [<c02d74f1>] __sched_text_start+0x2f1/0x660
 [<c024fa40>] scsi_error_handler+0x0/0xbe0
 [<c0131679>] kthread+0xa9/0xe0
 [<c01315d0>] kthread+0x0/0xe0
 [<c0103d0f>] kernel_thread_helper+0x7/0x18
 =======================
vscsihba:3: Abortng command serial number : 97
sd 0:0:0:0: scsi: Device offlined - not ready after error recovery
BUG: scheduling while atomic: scsi_eh_0/0x00000001/4749
 [<c02d7684>] __sched_text_start+0x484/0x660
 [<c013aa11>] module_put+0x31/0x60
 [<c024bd6e>] scsi_device_put+0x3e/0x40
 [<c024be5f>] __scsi_iterate_devices+0x6f/0x90
 [<c024fa86>] scsi_error_handler+0x46/0xbe0
 [<c024fa40>] scsi_error_handler+0x0/0xbe0
 [<c0131679>] kthread+0xa9/0xe0
 [<c01315d0>] kthread+0x0/0xe0
 [<c0103d0f>] kernel_thread_helper+0x7/0x18
 =======================


Doug Gilbert

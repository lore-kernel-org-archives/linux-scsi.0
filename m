From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: eata fails to load on post 4.2 kernels
Date: Sun, 06 Sep 2015 15:58:12 +0930
Message-ID: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44557 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbIFHXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 03:23:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ZYUIH-00069S-2I
	for linux-scsi@vger.kernel.org; Sun, 06 Sep 2015 09:23:17 +0200
Received: from ppp118-210-85-162.lns20.adl2.internode.on.net ([118.210.85.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2015 09:23:17 +0200
Received: from arthur.marsh by ppp118-210-85-162.lns20.adl2.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2015 09:23:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, I'm seeing the following on post 4.2 kernels, am currently bisecting 
to find where it started:

[ 3834.024169] scsi 3:0:1:0: reset, enter.
[ 3834.024174] EATA0: reset, locked mbox 2 forced free.
[ 3834.024176] EATA0: reset, mbox 3 in reset.
[ 3834.024180] EATA0: reset, board reset done, enabling interrupts.
[ 3844.024044] EATA0: reset, interrupts disabled, loops 46367.
[ 3844.024052] EATA0, reset, mbox 3 locked, DID_RESET, done.
[ 3844.024056] EATA0: reset, exit, done.
[ 3854.032147] scsi 3:0:1:0: abort, mbox 4.
[ 3854.032160] EATA0: abort, mbox 4 is in use.
[ 3854.032167] EATA0: abort, mbox 4, interrupt pending.
[ 3854.032175] scsi 3:0:1:0: reset, enter.
[ 3854.032181] EATA0: reset, locked mbox 3 forced free.
[ 3854.032186] EATA0: reset, mbox 4 in reset.
[ 3854.032192] EATA0: reset, board reset done, enabling interrupts.
[ 3864.036057] EATA0: reset, interrupts disabled, loops 50625.
[ 3864.036065] EATA0, reset, mbox 4 locked, DID_RESET, done.
[ 3864.036068] EATA0: reset, exit, done.
[ 3874.040090] scsi 3:0:1:0: Device offlined - not ready after error 
recovery
[ 3895.016173] scsi 3:0:2:0: abort, mbox 5.
[ 3895.016182] EATA0: abort, mbox 5 is in use.
[ 3895.016185] EATA0: abort, mbox 5, interrupt pending.
[ 3895.016208] scsi 3:0:2:0: reset, enter.
[ 3895.016212] EATA0: reset, locked mbox 4 forced free.
[ 3895.016215] EATA0: reset, mbox 5 in reset.
[ 3895.016219] EATA0: reset, board reset done, enabling interrupts.
[ 3905.017316] EATA0: reset, interrupts disabled, loops 61783.
[ 3905.017324] EATA0, reset, mbox 5 locked, DID_RESET, done.
[ 3905.017327] EATA0: reset, exit, done.
[ 3915.024082] scsi 3:0:2:0: abort, mbox 6.
[ 3915.024091] EATA0: abort, mbox 6 is in use.
[ 3915.024095] EATA0: abort, mbox 6, interrupt pending.
[ 3915.024099] scsi 3:0:2:0: reset, enter.
[ 3915.024103] EATA0: reset, locked mbox 5 forced free.
[ 3915.024106] EATA0: reset, mbox 6 in reset.
[ 3915.024109] EATA0: reset, board reset done, enabling interrupts.
[ 3925.035006] EATA0: reset, interrupts disabled, loops 58910.
[ 3925.035013] EATA0, reset, mbox 6 locked, DID_RESET, done.
[ 3925.035017] EATA0: reset, exit, done.
[ 3935.036086] scsi 3:0:2:0: Device offlined - not ready after error 
recovery
[ 3956.040095] scsi 3:0:3:0: abort, mbox 7.
[ 3956.040104] EATA0: abort, mbox 7 is in use.
[ 3956.040108] EATA0: abort, mbox 7, interrupt pending.
[ 3956.040132] scsi 3:0:3:0: reset, enter.
[ 3956.040136] EATA0: reset, locked mbox 6 forced free.
[ 3956.040139] EATA0: reset, mbox 7 in reset.
[ 3956.040143] EATA0: reset, board reset done, enabling interrupts.
[ 3960.140145] INFO: task modprobe:5046 blocked for more than 120 seconds.
[ 3960.140154]       Not tainted 4.2.0+ #1922
[ 3960.140156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 3960.140160] modprobe        D 00000282     0  5046   3353 0x00000004
[ 3960.140168]  f3d89e18 00000086 c107b2f6 00000282 c177fa40 abef61f2 
00000369 f5f11410
[ 3960.140178]  e58bb100 e52091c0 f3d8a000 ffffffff ffffffff f3d89e24 
c15520e0 00000000
[ 3960.140189]  f3d89e70 c1077ec5 c10762a3 e520962c c1786a80 c1786a80 
fa2b8400 f3d89e4c
[ 3960.140199] Call Trace:
[ 3960.140208]  [<c107b2f6>] ? preempt_count_sub+0x26/0x70
[ 3960.140214]  [<c15520e0>] schedule+0x30/0x80
[ 3960.140218]  [<c1077ec5>] async_synchronize_cookie_domain+0xb5/0x150
[ 3960.140221]  [<c10762a3>] ? __blocking_notifier_call_chain+0x43/0x60
[ 3960.140227]  [<c109ecb6>] ? up_read+0x16/0x30
[ 3960.140231]  [<c1098a10>] ? wake_atomic_t_function+0x70/0x70
[ 3960.140235]  [<c1077f94>] async_synchronize_full+0x14/0x20
[ 3960.140240]  [<c154f36a>] do_init_module+0xa6/0x1b2
[ 3960.140244]  [<c10e76ab>] load_module+0x145b/0x1a00
[ 3960.140250]  [<c11af57a>] ? kernel_read+0x3a/0x50
[ 3960.140256]  [<c10e7e55>] SyS_finit_module+0x95/0xe0
[ 3960.140260]  [<c109ece6>] ? up_write+0x16/0x40
[ 3960.140265]  [<c11662c3>] ? vm_mmap_pgoff+0x83/0xb0
[ 3960.140271]  [<c1557e18>] sysenter_do_call+0x12/0x12
[ 3960.140274] no locks held by modprobe/5046.
[ 3966.044078] EATA0: reset, interrupts disabled, loops 48095.
[ 3966.044086] EATA0, reset, mbox 7 locked, DID_RESET, done.
[ 3966.044090] EATA0: reset, exit, done.
[ 3976.052070] scsi 3:0:3:0: abort, mbox 8.
[ 3976.052079] EATA0: abort, mbox 8 is in use.
[ 3976.052083] EATA0: abort, mbox 8, interrupt pending.
[ 3976.052087] scsi 3:0:3:0: reset, enter.
[ 3976.052091] EATA0: reset, locked mbox 7 forced free.
[ 3976.052094] EATA0: reset, mbox 8 in reset.
[ 3976.052097] EATA0: reset, board reset done, enabling interrupts.
[ 3986.056117] EATA0: reset, interrupts disabled, loops 47494.
[ 3986.056126] EATA0, reset, mbox 8 locked, DID_RESET, done.
[ 3986.056129] EATA0: reset, exit, done.
[ 3996.060087] scsi 3:0:3:0: Device offlined - not ready after error 
recovery
[ 4017.064090] scsi 3:0:4:0: abort, mbox 9.
[ 4017.064099] EATA0: abort, mbox 9 is in use.
[ 4017.064103] EATA0: abort, mbox 9, interrupt pending.
[ 4017.064127] scsi 3:0:4:0: reset, enter.
[ 4017.064131] EATA0: reset, locked mbox 8 forced free.
[ 4017.064134] EATA0: reset, mbox 9 in reset.
[ 4017.064138] EATA0: reset, board reset done, enabling interrupts.
[ 4027.064089] EATA0: reset, interrupts disabled, loops 49828.
[ 4027.064097] EATA0, reset, mbox 9 locked, DID_RESET, done.
[ 4027.064101] EATA0: reset, exit, done.
[ 4037.072072] scsi 3:0:4:0: abort, mbox 10.
[ 4037.072081] EATA0: abort, mbox 10 is in use.
[ 4037.072084] EATA0: abort, mbox 10, interrupt pending.
[ 4037.072088] scsi 3:0:4:0: reset, enter.
[ 4037.072092] EATA0: reset, locked mbox 9 forced free.
[ 4037.072095] EATA0: reset, mbox 10 in reset.
[ 4037.072099] EATA0: reset, board reset done, enabling interrupts.


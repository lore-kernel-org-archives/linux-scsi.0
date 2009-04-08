From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: crash unrelated to sym53c8xx
Date: Wed, 8 Apr 2009 17:42:15 +0900
Message-ID: <20090408174204B.fujita.tomonori@lab.ntt.co.jp>
References: <20090402130156.GQ8014@parisc-linux.org>
	<20090402193927.GA7106@nik-comp.linuxbox.cz>
	<20090408083002.GA9961@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52533 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZDHImY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Apr 2009 04:42:24 -0400
In-Reply-To: <20090408083002.GA9961@develbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: extmaillist@linuxbox.cz
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, nikola.ciprich@linuxbox.cz

On Wed, 8 Apr 2009 10:30:02 +0200
Nikola Ciprich <extmaillist@linuxbox.cz> wrote:

> Hi Matthew,
> finally we caught the crash even with backtrace, here it goes:
> 
> [65468.555522] BUG: spinlock lockup on CPU#1, scsi_eh_9/5912, ec5625e0
> [65468.555522] Pid: 5912, comm: scsi_eh_9 Tainted: G        W  2.6.28lb.10 #1
> [65468.555522] Call Trace:
> [65468.555522]  [<c0333654>] _raw_spin_lock+0x144/0x180
> [65468.555522]  [<c046178c>] _spin_lock_irqsave+0x4c/0x60
> [65468.555522]  [<c031d111>] ? blk_put_request+0x21/0x50
> [65468.555522]  [<c031d111>] blk_put_request+0x21/0x50
> [65468.555522]  [<f827163c>] sg_finish_rem_req+0x9c/0xf0 [sg]
> [65468.555522]  [<f8272589>] sg_rq_end_io+0x1a9/0x2b0 [sg]
> [65468.555522]  [<c0461afc>] ? _spin_unlock_irqrestore+0x2c/0x50
> [65468.555522]  [<c031cda0>] end_that_request_last+0x50/0x230
> [65468.555522]  [<c046178c>] ? _spin_lock_irqsave+0x4c/0x60
> [65468.555522]  [<c031d05e>] blk_end_io+0x5e/0x90
> [65468.555522]  [<c031d0ea>] blk_end_request+0x1a/0x20
> [65468.555522]  [<f81a9305>] scsi_end_request+0x25/0x90 [scsi_mod]
> [65468.555522]  [<f81aa072>] scsi_io_completion+0x92/0x420 [scsi_mod]
> [65468.555522]  [<f81a973b>] ? scsi_device_unbusy+0x8b/0xb0 [scsi_mod]
> [65468.555522]  [<f81a3538>] scsi_finish_command+0x98/0x100 [scsi_mod]
> [65468.555522]  [<f81a790c>] ? scsi_eh_ready_devs+0x54c/0x720 [scsi_mod]
> [65468.555522]  [<f81a6eba>] scsi_eh_flush_done_q+0x4a/0x100 [scsi_mod]
> [65468.555522]  [<f81a815d>] scsi_error_handler+0x31d/0x520 [scsi_mod]
> [65468.555522]  [<c0461afc>] ? _spin_unlock_irqrestore+0x2c/0x50
> [65468.555522]  [<c021eda9>] ? complete+0x49/0x60
> [65468.555522]  [<f81a7e40>] ? scsi_error_handler+0x0/0x520 [scsi_mod]
> [65468.555522]  [<c023fda2>] kthread+0x42/0x70
> [65468.555522]  [<c023fd60>] ? kthread+0x0/0x70
> [65468.555522]  [<c02041c7>] kernel_thread_helper+0x7/0x10
> 
> Will it help?

This looks like a sg bug.

2.6.30-rc1 includes the following commit to fix this bug:

commit 015640edb1f346e0b2eda703587c4cd1c310ec1d
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Fri Apr 3 19:28:06 2009 +0900

    [SCSI] sg: fix q->queue_lock on scsi_error_handler path


It's tagged 'Cc: stable@kernel.org' so it will be merged into stable
trees too.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12945] SCSI Generic (sg): BUG: sleeping function called from
 invalid context
Date: Thu, 26 Mar 2009 18:38:48 GMT
Message-ID: <200903261838.n2QIcmMO016095@demeter.kernel.org>
References: <bug-12945-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54125 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZCZSiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 14:38:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2QIcmWW016096
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 18:38:48 GMT
In-Reply-To: <bug-12945-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12945





--- Comment #2 from Tobias <txtoxtox285@googlemail.com>  2009-03-26 18:38:47 ---
On Thu, Mar 26, 2009 at 3:49 PM, Andrew Morton
<akpm@linux-foundation.org>wrote:

>
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Thu, 26 Mar 2009 12:27:53 GMT bugzilla-daemon@bugzilla.kernel.orgwrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=12945
> >
> >            Summary: SCSI Generic (sg): BUG: sleeping function called from
> >                     invalid context
> >            Product: SCSI Drivers
> >            Version: 2.5
> >     Kernel Version: 2.6.28.9
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
> >         ReportedBy: txtoxtox285@googlemail.com
> >         Regression: No
> >
> >
> > Created an attachment (id=20685)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20685)
> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=20685)
> > Stack trace on program kill (2.6.28.9)
> >
> > I am experimenting with CD audio extraction. I use the SCSI Generic
> driver for
> > this.
> >
> > My test program uses read() and write() (instead of ioctl) to send
> requests to
> > the driver and receive responses. I use SG_FLAG_DIRECT_IO.
> >
> > When I kill my program (because I don't want to wait until it has ripped
> the
> > entire CD), I am often rewarded with messages like "BUG: sleeping
> function
> > called from invalid context at
> linux-2.6.28.9/include/linux/pagemap.h:347". I
> > have attached typical stack trace.
> >
> > Another case when I hit this BUG is when I set a time out and the CD
> drive
> > doesn't respond fast enough. A stack trace is attached.
>
> > [34215.786870] BUG: sleeping function called from invalid context at
> /mnt/var-pub/src/linux-2.6.28.9/include/linux/pagemap.h:347
> > [34215.786880] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper
> > [34215.786886] Pid: 0, comm: swapper Not tainted 2.6.28.9 #1
> > [34215.786890] Call Trace:
> > [34215.786894]  <IRQ>  [<ffffffff8026c4cc>] set_page_dirty_lock+0x1a/0x45
> > [34215.786911]  [<ffffffff802ae17d>] bio_unmap_user+0x1e/0x4a
> > [34215.786920]  [<ffffffff802e876b>] __blk_rq_unmap_user+0x14/0x20
> > [34215.786928]  [<ffffffff80210852>] pit_next_event+0x2e/0x49
> > [34215.786934]  [<ffffffff802e8795>] blk_rq_unmap_user+0x1e/0x4b
> > [34215.786965]  [<ffffffffa0163475>] sg_finish_rem_req+0x6d/0x88 [sg]
> > [34215.786979]  [<ffffffffa0164ef3>] sg_rq_end_io+0x131/0x205 [sg]
> > [34215.786986]  [<ffffffff802e5c1f>] end_that_request_last+0x58/0x194
> > [34215.786992]  [<ffffffff802e5e00>] blk_end_io+0x48/0x7d
> > [34215.787019]  [<ffffffffa0026bef>] scsi_next_command+0x219/0x283
> [scsi_mod]
> > [34215.787039]  [<ffffffffa00279b1>] scsi_io_completion+0x181/0x53b
> [scsi_mod]
> > [34215.787047]  [<ffffffff802e9737>] blk_done_softirq+0x5f/0x6d
> > [34215.787054]  [<ffffffff80230787>] __do_softirq+0x5e/0xf8
> > [34215.787061]  [<ffffffff8020ca8c>] call_softirq+0x1c/0x28
> > [34215.787067]  [<ffffffff8020d6bc>] do_softirq+0x2c/0x68
> > [34215.787073]  [<ffffffff80230696>] irq_exit+0x36/0x82
> > [34215.787079]  [<ffffffff8020d79e>] do_IRQ+0xa6/0xb8
> > [34215.787085]  [<ffffffff8020c256>] ret_from_intr+0x0/0xa
> > [34215.787088]  <EOI>  [<ffffffff8034f648>] menu_reflect+0x0/0x6d
> > [34215.787112]  [<ffffffffa0147d51>] acpi_idle_enter_simple+0x170/0x1d6
> [processor]
> > [34215.787127]  [<ffffffffa0147d47>] acpi_idle_enter_simple+0x166/0x1d6
> [processor]
> > [34215.787134]  [<ffffffff8034eb32>] cpuidle_idle_call+0x73/0xb1
> > [34215.787140]  [<ffffffff8020ac2a>] cpu_idle+0x3c/0x73
>
> Argh.  sg_finish_rem_req() is called from interrupt context.  But
> blk_rq_unmap_user() can run
> __bio_unmap_user()->set_page_dirty_lock()->lock_page(), which can call
> schedule().  If it does call schedule(), the machine will crash.
>
> afacit, blk_rq_unmap_user() has always been a can-sleep function, and
> this is a regression caused by
>
> commit 6e5a30cba5e7c03b2cd564e968f1dd667a0f7c42
> Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> AuthorDate: Thu Aug 28 16:17:08 2008 +0900
> Commit:     Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Thu Oct 9 08:56:10 2008 +0200
>
>    sg: convert the direct IO path to use the block layer
>
>    This patch converts the direct IO path (SG_FLAG_DIRECT_IO) to use the
>    block layer functions (blk_get_request, blk_execute_rq_nowait,
>    blk_rq_map_user, etc) instead of scsi_execute_async().
>
>    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>    Signed-off-by: Douglas Gilbert <dougg@torque.net>
>    Cc: Mike Christie <michaelc@cs.wisc.edu>
>    Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
>
Andrew,

thank you for your quick response. So as a temporary workaround I will not
use direct I/O and wait for a patch.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: Tobias X <txtoxtox285@googlemail.com>
Subject: Re: [Bug 12945] New: SCSI Generic (sg): BUG: sleeping function called
	from invalid context
Date: Thu, 26 Mar 2009 19:45:38 +0100
Message-ID: <e747d180903261145n44b7083fj5b175fd39824eba2@mail.gmail.com>
References: <bug-12945-11613@http.bugzilla.kernel.org/>
	 <20090326074952.40ffdcd9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:40788 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134AbZCZSpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 14:45:41 -0400
Received: by yx-out-2324.google.com with SMTP id 31so594048yxl.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 11:45:39 -0700 (PDT)
In-Reply-To: <20090326074952.40ffdcd9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Thu, Mar 26, 2009 at 3:49 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> (switched to email. =A0Please respond via emailed reply-to-all, not v=
ia the
> bugzilla web interface).
>
> On Thu, 26 Mar 2009 12:27:53 GMT bugzilla-daemon@bugzilla.kernel.org =
wrote:
>
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D12945
>>
>> =A0 =A0 =A0 =A0 =A0 =A0Summary: SCSI Generic (sg): BUG: sleeping fun=
ction called from
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalid context
>> =A0 =A0 =A0 =A0 =A0 =A0Product: SCSI Drivers
>> =A0 =A0 =A0 =A0 =A0 =A0Version: 2.5
>> =A0 =A0 Kernel Version: 2.6.28.9
>> =A0 =A0 =A0 =A0 =A0 Platform: All
>> =A0 =A0 =A0 =A0 OS/Version: Linux
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Tree: Mainline
>> =A0 =A0 =A0 =A0 =A0 =A0 Status: NEW
>> =A0 =A0 =A0 =A0 =A0 Severity: normal
>> =A0 =A0 =A0 =A0 =A0 Priority: P1
>> =A0 =A0 =A0 =A0 =A0Component: Other
>> =A0 =A0 =A0 =A0 AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>> =A0 =A0 =A0 =A0 ReportedBy: txtoxtox285@googlemail.com
>> =A0 =A0 =A0 =A0 Regression: No
>>
>>
>> Created an attachment (id=3D20685)
>> =A0--> (http://bugzilla.kernel.org/attachment.cgi?id=3D20685)
>> Stack trace on program kill (2.6.28.9)
>>
>> I am experimenting with CD audio extraction. I use the SCSI Generic =
driver for
>> this.
>>
>> My test program uses read() and write() (instead of ioctl) to send r=
equests to
>> the driver and receive responses. I use SG_FLAG_DIRECT_IO.
>>
>> When I kill my program (because I don't want to wait until it has ri=
pped the
>> entire CD), I am often rewarded with messages like "BUG: sleeping fu=
nction
>> called from invalid context at linux-2.6.28.9/include/linux/pagemap.=
h:347". I
>> have attached typical stack trace.
>>
>> Another case when I hit this BUG is when I set a time out and the CD=
 drive
>> doesn't respond fast enough. A stack trace is attached.
>
>> [34215.786870] BUG: sleeping function called from invalid context at=
 /mnt/var-pub/src/linux-2.6.28.9/include/linux/pagemap.h:347
>> [34215.786880] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swa=
pper
>> [34215.786886] Pid: 0, comm: swapper Not tainted 2.6.28.9 #1
>> [34215.786890] Call Trace:
>> [34215.786894] =A0<IRQ> =A0[<ffffffff8026c4cc>] set_page_dirty_lock+=
0x1a/0x45
>> [34215.786911] =A0[<ffffffff802ae17d>] bio_unmap_user+0x1e/0x4a
>> [34215.786920] =A0[<ffffffff802e876b>] __blk_rq_unmap_user+0x14/0x20
>> [34215.786928] =A0[<ffffffff80210852>] pit_next_event+0x2e/0x49
>> [34215.786934] =A0[<ffffffff802e8795>] blk_rq_unmap_user+0x1e/0x4b
>> [34215.786965] =A0[<ffffffffa0163475>] sg_finish_rem_req+0x6d/0x88 [=
sg]
>> [34215.786979] =A0[<ffffffffa0164ef3>] sg_rq_end_io+0x131/0x205 [sg]
>> [34215.786986] =A0[<ffffffff802e5c1f>] end_that_request_last+0x58/0x=
194
>> [34215.786992] =A0[<ffffffff802e5e00>] blk_end_io+0x48/0x7d
>> [34215.787019] =A0[<ffffffffa0026bef>] scsi_next_command+0x219/0x283=
 [scsi_mod]
>> [34215.787039] =A0[<ffffffffa00279b1>] scsi_io_completion+0x181/0x53=
b [scsi_mod]
>> [34215.787047] =A0[<ffffffff802e9737>] blk_done_softirq+0x5f/0x6d
>> [34215.787054] =A0[<ffffffff80230787>] __do_softirq+0x5e/0xf8
>> [34215.787061] =A0[<ffffffff8020ca8c>] call_softirq+0x1c/0x28
>> [34215.787067] =A0[<ffffffff8020d6bc>] do_softirq+0x2c/0x68
>> [34215.787073] =A0[<ffffffff80230696>] irq_exit+0x36/0x82
>> [34215.787079] =A0[<ffffffff8020d79e>] do_IRQ+0xa6/0xb8
>> [34215.787085] =A0[<ffffffff8020c256>] ret_from_intr+0x0/0xa
>> [34215.787088] =A0<EOI> =A0[<ffffffff8034f648>] menu_reflect+0x0/0x6=
d
>> [34215.787112] =A0[<ffffffffa0147d51>] acpi_idle_enter_simple+0x170/=
0x1d6 [processor]
>> [34215.787127] =A0[<ffffffffa0147d47>] acpi_idle_enter_simple+0x166/=
0x1d6 [processor]
>> [34215.787134] =A0[<ffffffff8034eb32>] cpuidle_idle_call+0x73/0xb1
>> [34215.787140] =A0[<ffffffff8020ac2a>] cpu_idle+0x3c/0x73
>
> Argh. =A0sg_finish_rem_req() is called from interrupt context. =A0But
> blk_rq_unmap_user() can run
> __bio_unmap_user()->set_page_dirty_lock()->lock_page(), which can cal=
l
> schedule(). =A0If it does call schedule(), the machine will crash.
>
> afacit, blk_rq_unmap_user() has always been a can-sleep function, and
> this is a regression caused by
>
> commit 6e5a30cba5e7c03b2cd564e968f1dd667a0f7c42
> Author: =A0 =A0 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> AuthorDate: Thu Aug 28 16:17:08 2008 +0900
> Commit: =A0 =A0 Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Thu Oct 9 08:56:10 2008 +0200
>
> =A0 =A0sg: convert the direct IO path to use the block layer
>
> =A0 =A0This patch converts the direct IO path (SG_FLAG_DIRECT_IO) to =
use the
> =A0 =A0block layer functions (blk_get_request, blk_execute_rq_nowait,
> =A0 =A0blk_rq_map_user, etc) instead of scsi_execute_async().
>
> =A0 =A0Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> =A0 =A0Signed-off-by: Douglas Gilbert <dougg@torque.net>
> =A0 =A0Cc: Mike Christie <michaelc@cs.wisc.edu>
> =A0 =A0Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> =A0 =A0Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
>

Andrew,

thank you for your quick response. So as a temporary workaround I will
not use direct I/O and wait for a patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

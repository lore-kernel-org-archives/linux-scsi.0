From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12945] SCSI Generic (sg): BUG: sleeping function called from
 invalid context
Date: Thu, 26 Mar 2009 18:45:41 GMT
Message-ID: <200903261845.n2QIjf6j016977@demeter.kernel.org>
References: <bug-12945-11613@http.bugzilla-testing.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45985 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760051AbZCZSpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 14:45:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2QIjfbu016978
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 18:45:41 GMT
In-Reply-To: <bug-12945-11613@http.bugzilla-testing.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla-testing.kernel.org/show_bug.cgi?id=3D12945





--- Comment #3 from Tobias <txtoxtox285@googlemail.com>  2009-03-26 18:=
45:40 ---
On Thu, Mar 26, 2009 at 3:49 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> (switched to email. =C2=A0Please respond via emailed reply-to-all, no=
t via the
> bugzilla web interface).
>
> On Thu, 26 Mar 2009 12:27:53 GMT bugzilla-daemon@bugzilla.kernel.org =
wrote:
>
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D12945
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Summary: SCSI Generic (sg):=
 BUG: sleeping function called from
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 invalid context
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Product: SCSI Drivers
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Version: 2.5
>> =C2=A0 =C2=A0 Kernel Version: 2.6.28.9
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Platform: All
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 OS/Version: Linux
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Tree: Mainline
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: NEW
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Severity: normal
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Priority: P1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Component: Other
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 AssignedTo: scsi_drivers-other@kernel-bu=
gs.osdl.org
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ReportedBy: txtoxtox285@googlemail.com
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Regression: No
>>
>>
>> Created an attachment (id=3D20685)
 --> (http://bugzilla-testing.kernel.org/attachment.cgi?id=3D20685)
>> =C2=A0--> (http://bugzilla.kernel.org/attachment.cgi?id=3D20685)
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
>> [34215.786894] =C2=A0<IRQ> =C2=A0[<ffffffff8026c4cc>] set_page_dirty=
_lock+0x1a/0x45
>> [34215.786911] =C2=A0[<ffffffff802ae17d>] bio_unmap_user+0x1e/0x4a
>> [34215.786920] =C2=A0[<ffffffff802e876b>] __blk_rq_unmap_user+0x14/0=
x20
>> [34215.786928] =C2=A0[<ffffffff80210852>] pit_next_event+0x2e/0x49
>> [34215.786934] =C2=A0[<ffffffff802e8795>] blk_rq_unmap_user+0x1e/0x4=
b
>> [34215.786965] =C2=A0[<ffffffffa0163475>] sg_finish_rem_req+0x6d/0x8=
8 [sg]
>> [34215.786979] =C2=A0[<ffffffffa0164ef3>] sg_rq_end_io+0x131/0x205 [=
sg]
>> [34215.786986] =C2=A0[<ffffffff802e5c1f>] end_that_request_last+0x58=
/0x194
>> [34215.786992] =C2=A0[<ffffffff802e5e00>] blk_end_io+0x48/0x7d
>> [34215.787019] =C2=A0[<ffffffffa0026bef>] scsi_next_command+0x219/0x=
283 [scsi_mod]
>> [34215.787039] =C2=A0[<ffffffffa00279b1>] scsi_io_completion+0x181/0=
x53b [scsi_mod]
>> [34215.787047] =C2=A0[<ffffffff802e9737>] blk_done_softirq+0x5f/0x6d
>> [34215.787054] =C2=A0[<ffffffff80230787>] __do_softirq+0x5e/0xf8
>> [34215.787061] =C2=A0[<ffffffff8020ca8c>] call_softirq+0x1c/0x28
>> [34215.787067] =C2=A0[<ffffffff8020d6bc>] do_softirq+0x2c/0x68
>> [34215.787073] =C2=A0[<ffffffff80230696>] irq_exit+0x36/0x82
>> [34215.787079] =C2=A0[<ffffffff8020d79e>] do_IRQ+0xa6/0xb8
>> [34215.787085] =C2=A0[<ffffffff8020c256>] ret_from_intr+0x0/0xa
>> [34215.787088] =C2=A0<EOI> =C2=A0[<ffffffff8034f648>] menu_reflect+0=
x0/0x6d
>> [34215.787112] =C2=A0[<ffffffffa0147d51>] acpi_idle_enter_simple+0x1=
70/0x1d6 [processor]
>> [34215.787127] =C2=A0[<ffffffffa0147d47>] acpi_idle_enter_simple+0x1=
66/0x1d6 [processor]
>> [34215.787134] =C2=A0[<ffffffff8034eb32>] cpuidle_idle_call+0x73/0xb=
1
>> [34215.787140] =C2=A0[<ffffffff8020ac2a>] cpu_idle+0x3c/0x73
>
> Argh. =C2=A0sg_finish_rem_req() is called from interrupt context. =C2=
=A0But
> blk_rq_unmap_user() can run
> __bio_unmap_user()->set_page_dirty_lock()->lock_page(), which can cal=
l
> schedule(). =C2=A0If it does call schedule(), the machine will crash.
>
> afacit, blk_rq_unmap_user() has always been a can-sleep function, and
> this is a regression caused by
>
> commit 6e5a30cba5e7c03b2cd564e968f1dd667a0f7c42
> Author: =C2=A0 =C2=A0 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> AuthorDate: Thu Aug 28 16:17:08 2008 +0900
> Commit: =C2=A0 =C2=A0 Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Thu Oct 9 08:56:10 2008 +0200
>
> =C2=A0 =C2=A0sg: convert the direct IO path to use the block layer
>
> =C2=A0 =C2=A0This patch converts the direct IO path (SG_FLAG_DIRECT_I=
O) to use the
> =C2=A0 =C2=A0block layer functions (blk_get_request, blk_execute_rq_n=
owait,
> =C2=A0 =C2=A0blk_rq_map_user, etc) instead of scsi_execute_async().
>
> =C2=A0 =C2=A0Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.=
co.jp>
> =C2=A0 =C2=A0Signed-off-by: Douglas Gilbert <dougg@torque.net>
> =C2=A0 =C2=A0Cc: Mike Christie <michaelc@cs.wisc.edu>
> =C2=A0 =C2=A0Cc: James Bottomley <James.Bottomley@HansenPartnership.c=
om>
> =C2=A0 =C2=A0Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
>

Andrew,

thank you for your quick response. So as a temporary workaround I will
not use direct I/O and wait for a patch.

--=20
Configure bugmail: http://bugzilla-testing.kernel.org/userprefs.cgi?tab=
=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

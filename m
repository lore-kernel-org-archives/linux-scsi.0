From: "John Stoffel" <john@stoffel.org>
Subject: Re: 2.6.24-rc5: tape drive not responding
Date: Mon, 17 Dec 2007 15:08:58 -0500
Message-ID: <18278.55130.471797.398922@stoffel.org>
References: <18277.52079.718004.969358@stoffel.org>
	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>
	<20071217031510.c3d500fd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:41684 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043AbXLQUJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 15:09:40 -0500
In-Reply-To: <20071217031510.c3d500fd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, john@stoffel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> On Mon, 17 Dec 2007 11:25:51 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Sun, 16 Dec 2007 20:05:51 -0500
>> "John Stoffel" <john@stoffel.org> wrote:
>> > 
>> > [  273.382057] sd 12:0:0:3: Attached scsi generic sg13 type 0
>> > [  276.244872] ------------[ cut here ]------------
>> > [  276.300215] kernel BUG at include/linux/scatterlist.h:59!
>> > [  276.364873] invalid opcode: 0000 [#1] SMP 
>> > [  276.414346] Modules linked in:
>> > [  276.451148] 
>> > [  276.469036] Pid: 1824, comm: stinit Not tainted (2.6.24-rc5 #2)
>> > [  276.539940] EIP: 0060:[<c0343c30>] EFLAGS: 00010213 CPU: 0
>> > [  276.605651] EIP is at st_do_scsi+0x2e0/0x340
>> > [  276.656788] EAX: 00000000 EBX: 00000000 ECX: c16ef780 EDX: f7c4f050
>> > [  276.731847] ESI: f7c4f7d0 EDI: 00001000 EBP: f7c4f000 ESP: f712bdf8
>> > [  276.806904]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> > [  276.871568] Process stinit (pid: 1824, ti=f712b000 task=f750a030 task.ti=f712b000)
>> > [  276.960139] Stack: 00000003 f7c4f050 00000000 00000000 00d59f80 00000000 f776fe20 c03468a0 
>> > [  277.062012]        000000d0 f712be9c f7d2a000 f776fe20 f7d2a018 00000000 00000006 f712be9c 
>> > [  277.163890]        f7d2a000 f712beac f7c4f000 c0345790 00000006 00000002 000dbba0 00000000 
>> > [  277.265771] Call Trace:
>> > [  277.297383]  [<c03468a0>] st_sleep_done+0x0/0x70
>> > [  277.352894]  [<c0345790>] check_tape+0x510/0x640
>> > [  277.408414]  [<c0346cfb>] st_open+0x18b/0x220
>> > [  277.460803]  [<c01707e0>] exact_match+0x0/0x10
>> > [  277.514237]  [<c0346b70>] st_open+0x0/0x220
>> > [  277.564553]  [<c0170ebf>] chrdev_open+0x9f/0x190
>> > [  277.620069]  [<c0170e20>] chrdev_open+0x0/0x190
>> > [  277.674543]  [<c016c86f>] __dentry_open+0xaf/0x1b0
>> > [  277.732136]  [<c016ca25>] nameidata_to_filp+0x35/0x40
>> > [  277.792847]  [<c016ca7b>] do_filp_open+0x4b/0x60
>> > [  277.848364]  [<c016c732>] get_unused_fd_flags+0x52/0xd0
>> > [  277.911153]  [<c016cadc>] do_sys_open+0x4c/0xe0
>> > [  277.965629]  [<c016cbac>] sys_open+0x1c/0x20
>> 
>> I think that you need the following patch for the scatterlist problem:
>> 
>> http://marc.info/?l=linux-scsi&m=119770154127770&w=2

Andrew> err, you sent that patch to John a day earlier too.

Andrew> John, can you please apply, test and report?

Happily, this seems to fix the problem with the above crash on
2.6.24-rc5-mm1, I've also left the fix in 2.6.24-rc5 and I'll be
testing that in my next reboot.  It's looking good!

So, this regression is fixed in 2.6.24-rc5-mm1.

Next, it would be nice to rate limit the "Parity error detected..."
messages from the Symbios driver, I'll see if I can hack something up
in the next day or so.

Thanks,
John

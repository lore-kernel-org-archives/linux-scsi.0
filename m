From: Tao Ma <tm@tao.ma>
Subject: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 14:13:16 +0800
Message-ID: <510B5CFC.2040801@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:36081 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751243Ab3BAGNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 01:13:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Hi All,
	In our product system, we have several sata disks attached to one
machine. So when one of the disk fails, the jbd2(yes, we use ext4) will
hang forever and we will get something in /var/log/messages like below.
It seems to me that the io sent to the scsi layer is never returned back
with -EIO which is a little bit surprised for me(It should be a timeout
somewhere, right?). We have tried echo "offline" >
/sys/block/sdl/device/state, but it doesn't work. So is there any way
for us to let the scsi device returns all the io requests back with EIO
so that all the end_io can be called accordingly? Am I missing something
here?

Thanks,
Tao


sd 0:0:11:0: attempting task abort! scmd(ffff88180e900580)
sd 0:0:11:0: [sdl] CDB: Write(10): 2a 00 0d ca e0 3f 00 04 00 00
target0:0:11: handle(0x0015), sas_address(0x500e004aaaaaaa0b), phy(11)
target0:0:11: enclosure_logical_id(0x500e004aaaaaaa00), slot(11)
INFO: task jbd2/sdl1-8:4629 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/sdl1-8   D 0000000000000000     0  4629      2 0x00000000
 ffff88180aa79ae0 0000000000000046 ffff88180aa79aa8 0000000000000000
 ffff88007ce0fe40 0000000000015f40 ffff8818102c0638 ffff8818102c0080
 ffff880a9184a100 ffff8818102c0638 0000000105006028 0000000100000000
Call Trace:
 [<ffffffff81236a15>] ? cpumask_next_and+0x25/0x40
 [<ffffffff810122b6>] ? read_tsc+0x16/0x40
 [<ffffffff81093cd9>] ? ktime_get_ts+0xa9/0xe0
 [<ffffffff810122b6>] ? read_tsc+0x16/0x40
 [<ffffffff81093cd9>] ? ktime_get_ts+0xa9/0xe0
 [<ffffffff814a8a53>] io_schedule+0x73/0xc0
 [<ffffffff811036a8>] sync_page+0x38/0x50
 [<ffffffff814a927e>] __wait_on_bit+0x5e/0x90
 [<ffffffff81103670>] ? sync_page+0x0/0x50
 [<ffffffff81103845>] wait_on_page_bit+0x75/0x80
 [<ffffffff81089320>] ? wake_bit_function+0x0/0x40
 [<ffffffff811197c7>] ? pagevec_lookup_tag+0x27/0x40
 [<ffffffff81118b55>] write_cache_pages+0x1d5/0x440
 [<ffffffff811172f0>] ? __writepage+0x0/0x40
 [<ffffffff81118de4>] generic_writepages+0x24/0x30
 [<ffffffffa02dc719>] jbd2_journal_commit_transaction+0x3e9/0x1490 [jbd2]
 [<ffffffff81074299>] ? try_to_del_timer_sync+0x49/0xe0
 [<ffffffffa02e2734>] kjournald2+0xb4/0x220 [jbd2]
 [<ffffffff810892e0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa02e2680>] ? kjournald2+0x0/0x220 [jbd2]
 [<ffffffff81089166>] kthread+0x96/0xa0
 [<ffffffff8100c08a>] child_rip+0xa/0x20
 [<ffffffff810890d0>] ? kthread+0x0/0xa0
 [<ffffffff8100c080>] ? child_rip+0x0/0x20


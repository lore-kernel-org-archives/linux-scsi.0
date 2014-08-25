From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: scsi-mq and 3.17rc1
Date: Mon, 25 Aug 2014 14:31:58 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C22037@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:26348 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaHYOcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 10:32:32 -0400
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3427.houston.hp.com (Postfix) with ESMTPS id 7D51113F
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 14:32:31 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Two scsi-mq tips:

1. Several people have been wondering how to enable scsi-mq.
Add this to your kernel command line (e.g., in /boot/grub/grub.conf
if using grub-1):
	scsi_mod.use_blk_mq=Y

One way to tell it is enabled is to notice these directories
being created in sysfs:
	/sys/block/sda/mq

2. If you're running kernel-3.17.0rc1 and scsi-mq, you may want
to pick up this patch from Tejun in Jens' linux-block tree:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=cddd5d17642cc6881352732693c2ae6930e9ce65

to avoid errors like this on device removal:
[ 1454.516816] ------------[ cut here ]------------
[ 1454.518348] WARNING: CPU: 0 PID: 4157 at lib/percpu-refcount.c:179 percpu_ref_kill_and_confirm+0x69/0x80()
[ 1454.521464] percpu_ref_kill() called more than once! 
...
[ 1454.553623] Call Trace:
[ 1454.554707]  [<ffffffff815af44f>] dump_stack+0x49/0x62
[ 1454.556349]  [<ffffffff81055f6c>] warn_slowpath_common+0x8c/0xc0
[ 1454.558487]  [<ffffffff81056056>] warn_slowpath_fmt+0x46/0x50
[ 1454.560565]  [<ffffffff812aa1b9>] percpu_ref_kill_and_confirm+0x69/0x80
[ 1454.562654]  [<ffffffff8127a753>] blk_mq_freeze_queue+0x53/0xf0
[ 1454.565179]  [<ffffffff8127ae56>] blk_mq_free_queue+0x26/0x140
[ 1454.567572]  [<ffffffff81272da8>] blk_release_queue+0x88/0xe0
[ 1454.569465]  [<ffffffff81299972>] kobject_cleanup+0x82/0x1c0
[ 1454.571316]  [<ffffffff81299abd>] kobject_release+0xd/0x10
[ 1454.573289]  [<ffffffff81299af1>] kobject_put+0x31/0x70
[ 1454.574937]  [<ffffffff8126e8d5>] blk_put_queue+0x15/0x20
[ 1454.576651]  [<ffffffff813dfaa4>] scsi_device_dev_release_usercontext+0xc4/0x120
[ 1454.579026]  [<ffffffff8106cc7d>] execute_in_process_context+0x5d/0x70
[ 1454.581442]  [<ffffffff813df9dc>] scsi_device_dev_release+0x1c/0x20
[ 1454.583502]  [<ffffffff813a46d8>] device_release+0x38/0xb0
[ 1454.585483]  [<ffffffff81299972>] kobject_cleanup+0x82/0x1c0
[ 1454.587547]  [<ffffffff81299abd>] kobject_release+0xd/0x10
[ 1454.589307]  [<ffffffff81299af1>object_put+0x31/0x70
[ 1454.691222]  [<ffffffff813a42f7>] put_device+0x17/0x20
[ 1454.692843]  [<ffffffff813ce8f5>] scsi_device_put+0x45/0x60

Both Douglas Gilbert and I ran into that.

---
Rob Elliott    HP Server Storage




From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Tue, 31 Dec 2013 06:22:02 +0000
Message-ID: <bug-60758-11613-eIHwx7rdV5@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3LaGWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Dec 2013 01:22:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A461E20138
	for <linux-scsi@vger.kernel.org>; Tue, 31 Dec 2013 06:22:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7426220121
	for <linux-scsi@vger.kernel.org>; Tue, 31 Dec 2013 06:22:04 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #53 from Lin Feng <linf@chinanetcenter.com> ---
hello,

After diving into it I found that in my qemu-VM case "FATAL: Module
scsi_wait_scan" is not the root cause, because even I backport the
scsi_wait_scan module, it still can't boot, but reports "dracut Warning: No
root device "block:/dev/disk/by-uuid/cedcbd9c-32eb-4a3f-9dad-ae5fc560642a"
found". 

I bisect through the 3.13-rc6 tree of upstream, and locates this commit broke
my initramfs, 
[root@CentOS6 linux]# git bisect bad
1cf7e9c68fe84248174e998922b39e508375e7c1 is the first bad commit
commit 1cf7e9c68fe84248174e998922b39e508375e7c1
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Nov 1 10:52:52 2013 -0600

    virtio_blk: blk-mq support

    Switch virtio-blk from the dual support for old-style requests and bios
    to use the block-multiqueue.

    Acked-by: Asias He <asias@redhat.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

though it's somthing about virtio driver(my guest uses virtio as the storage
driver), looking into this commit it is mainly about C code changes, not module
compiling or not. Also I have checked the modules compiled, in both cases(with
and without this commit) we get virtio_blk.ko module. But the difference is
that with this commit virtio_blk.ko isn't packed into the initramfs. 

However between both cases there is no environmental changes, with exactly the
same config, same dracut, same gcc, everything...So I don't know why dracut
doesn't pack the virtio_blk.ko into the initramfs, and more kidding I find that
it packed the floppy.ko instead. 
(In my case as a workround we can compile virtio moduels into kernel or use
other disk bus driver such as IDE or USB instead)

But one thing I don't understand can someone tell me why, Will dracut look
through the kernel tree(C codes) to find some useful information to pack the
final initramfs?

Ps. Related to the initial creative of this bugzilla, I guess it may also be
caused by some storage drivers are not packed into initramfs.

thanks

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Wed, 22 Jan 2014 21:17:56 +0000
Message-ID: <bug-60758-11613-WoPUOTEVlC@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbaAVVR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jan 2014 16:17:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 95BDD201B6
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 21:17:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 830E5201B4
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 21:17:57 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #54 from Akemi Yagi <toracat@elrepo.org> ---
(In reply to Lin Feng from comment #53)

> though it's somthing about virtio driver(my guest uses virtio as the storage
> driver), looking into this commit it is mainly about C code changes, not
> module compiling or not. Also I have checked the modules compiled, in both
> cases(with and without this commit) we get virtio_blk.ko module. But the
> difference is that with this commit virtio_blk.ko isn't packed into the
> initramfs. 
> 
> However between both cases there is no environmental changes, with exactly
> the same config, same dracut, same gcc, everything...So I don't know why
> dracut doesn't pack the virtio_blk.ko into the initramfs, and more kidding I
> find that it packed the floppy.ko instead. 
> (In my case as a workround we can compile virtio moduels into kernel or use
> other disk bus driver such as IDE or USB instead)
> 
> But one thing I don't understand can someone tell me why, Will dracut look
> through the kernel tree(C codes) to find some useful information to pack the
> final initramfs?

Thank you for this extensive analysis. I, too, was having the same problem on
my KVM guest that uses virtio (host=RHEL 6.5 and guest=CentOS 6.5). Just to
reconfirm your findings, I created initramfs with a '--add-drivers virtio_blk'
option and the kernel booted just fine.

It would indeed be great if we could find out why dracut fails to pick up some
particular modules.

-- 
You are receiving this mail because:
You are the assignee for the bug.

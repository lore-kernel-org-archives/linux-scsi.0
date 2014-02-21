From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Fri, 21 Feb 2014 05:31:39 +0000
Message-ID: <bug-60758-11613-3sQOaaQ55d@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33903 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaBUFbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Feb 2014 00:31:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DBF682018A
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 05:31:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A5ACE201B9
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 05:31:41 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

Thorsten Kohfeldt <thorsten.kohfeldt@gmx.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thorsten.kohfeldt@gmx.de

--- Comment #57 from Thorsten Kohfeldt <thorsten.kohfeldt@gmx.de> ---
I have filed a bug against dracut:

https://bugzilla.redhat.com/show_bug.cgi?id=1067669

which gives an explanation at least for kernel 3.13.


That kernel version introduces multi queue block i/o for virtio_blk, which in
turn does not any more call blk_init_queue() but blk_mq_init_queue() instead.

Dracut matches against symbol blk_init_queue but not yet against symbol
blk_mq_init_queue.

This should be fixed for Fedora and also for all RHEL derivatives ...


In the mean time there is this WORKAROUND:

1) check if virtio_blk is in intrd:
# for i in /boot/initramfs-* ; do echo $i: ; lsinitrd $i | grep virt ; done

2) if virtio_blk is missing in the relevant initrd, then

# echo 'add_drivers+="virtio_blk"'
>/etc/dracut.conf.d/force-vitio_blk-to-ensure-boot.conf
   (NOTE that the .conf extension is mandatory !)

3) then rebuild the initrd

-- 
You are receiving this mail because:
You are the assignee for the bug.

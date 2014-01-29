From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Wed, 29 Jan 2014 10:19:53 +0000
Message-ID: <bug-60758-11613-0huB3RBA3l@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59052 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaA2KT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jan 2014 05:19:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E551201BC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2014 10:19:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 26DB22018A
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2014 10:19:55 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

abiko <antun@martuna.co> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |antun@martuna.co

--- Comment #55 from abiko <antun@martuna.co> ---
I've had this problem on my CentOS 6 boxes on 3.10, 3.12, until I've cleared
the .config files from the kernel source directory and you would need to have
Virtio suppoer for block, PCI, net devices compiled in kernel (either a module
or embedded).

Good guide to follow is: http://www.linux-kvm.org/page/Virtio

This has  been tested on following kernels:

kernel 3.10.27
kernel 3.10.28
kernel 3.12.8
kernel 3.12.9
kernel 3.13

Currently using the 3.12.8 kernel on one of my VMs :
root@dev01 [~]# lsinitrd /boot/initrd-3.12.8.img | grep virt
-rw-r--r--   1 root     root        28720 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/block/virtio_blk.ko
-rw-r--r--   1 root     root        26688 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/scsi/virtio_scsi.ko
drwxr-xr-x   2 root     root            0 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/virtio
-rw-r--r--   1 root     root        12752 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/virtio/virtio.ko
-rw-r--r--   1 root     root        18304 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/virtio/virtio_mmio.ko
-rw-r--r--   1 root     root        20744 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/virtio/virtio_pci.ko
-rw-r--r--   1 root     root        20912 Jan 25 04:14
lib/modules/3.12.8/kernel/drivers/virtio/virtio_ring.ko

-- 
You are receiving this mail because:
You are the assignee for the bug.

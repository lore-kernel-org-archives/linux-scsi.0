From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] target : replace netlink
Date: Sat, 29 Jul 2006 10:01:33 +0900 (JST)
Message-ID: <20060730030304U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:12174 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1161398AbWG2BBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jul 2006 21:01:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

The target code wrongly uses netlink to pass user-space buffer
pointers. The kernel module sends SCSI commands to user space and
receives responses from user-space daemon. So we need bi-directional,
high-speed interface between user and kernel space. Currently, there
isn't such interface in mainline. For example, mmapped packet and
relayfs move data only from kernel to user space.

This patchset replaces netlink shared memory between kernel and user
spaces. The user-space daemon and the kernel module create shared
memory via mmap and use it like ring buffer (like mmapped packet
does). The poll system call is used for notification from kernel to
user space and the write system call is used for notification from
user to kernel space. We use a simple approach so that we easily
replace it if we find something better later on (or we implement a
generic interface if necessary).

This patchset is against the scsi-target git tree and on the top of
the following patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114960851929878&w=2


From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/2] target : replace netlink
Date: Fri, 28 Jul 2006 22:34:28 -0400
Message-ID: <44CAC934.9030409@torque.net>
References: <20060730030304U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17828 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932579AbWG2Cen (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jul 2006 22:34:43 -0400
In-Reply-To: <20060730030304U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

FUJITA Tomonori wrote:
> The target code wrongly uses netlink to pass user-space buffer
> pointers. The kernel module sends SCSI commands to user space and
> receives responses from user-space daemon. So we need bi-directional,
> high-speed interface between user and kernel space. Currently, there
> isn't such interface in mainline. For example, mmapped packet and
> relayfs move data only from kernel to user space.

Good-bye netlink, another ioctl (or char driver)
replacement bites the dust. It looks like your
netlink replacement char driver has a lot in common
with the sg driver ...

I hope to present soon a version 4 of the SCSI generic
interface structure that will address some of
these concerns. [Basically an expanded version of
'struct sg_io_hdr' that includes bidirectional data
transfers and multi-protocol support.]

Doug Gilbert

> This patchset replaces netlink shared memory between kernel and user
> spaces. The user-space daemon and the kernel module create shared
> memory via mmap and use it like ring buffer (like mmapped packet
> does). The poll system call is used for notification from kernel to
> user space and the write system call is used for notification from
> user to kernel space. We use a simple approach so that we easily
> replace it if we find something better later on (or we implement a
> generic interface if necessary).
> 
> This patchset is against the scsi-target git tree and on the top of
> the following patch:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114960851929878&w=2


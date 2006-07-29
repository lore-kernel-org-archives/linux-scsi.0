From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] target : replace netlink
Date: Sun, 30 Jul 2006 02:36:47 +0900
Message-ID: <200607291736.k6THamKF022995@r-dd.iij4u.or.jp>
References: <20060730030304U.fujita.tomonori@lab.ntt.co.jp>
	<44CAC934.9030409@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo00.iij4u.or.jp ([210.130.0.19]:36853 "EHLO mo00.iij4u.or.jp")
	by vger.kernel.org with ESMTP id S932186AbWG2RhL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 13:37:11 -0400
In-Reply-To: <44CAC934.9030409@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/2] target : replace netlink
Date: Fri, 28 Jul 2006 22:34:28 -0400

> FUJITA Tomonori wrote:
> > The target code wrongly uses netlink to pass user-space buffer
> > pointers. The kernel module sends SCSI commands to user space and
> > receives responses from user-space daemon. So we need bi-directional,
> > high-speed interface between user and kernel space. Currently, there
> > isn't such interface in mainline. For example, mmapped packet and
> > relayfs move data only from kernel to user space.
> 
> Good-bye netlink, another ioctl (or char driver)
> replacement bites the dust. It looks like your
> netlink replacement char driver has a lot in common
> with the sg driver ...
> 
> I hope to present soon a version 4 of the SCSI generic
> interface structure that will address some of
> these concerns. [Basically an expanded version of
> 'struct sg_io_hdr' that includes bidirectional data
> transfers and multi-protocol support.]
>
> Doug Gilbert

I'm not sure sg provides all our necessities.

sg's mmapped IO might be useful for us. The user-space daemon does
something like sg's mmapped IO, though it does not send SCSI commands
to kernel space (it performs SCSI commands for itself).

Does sg provide fast notification mechanism? Our kernel module needs
to send SCSI commands (comes from LLDs) to the user-space
daemon. Mapped ring buffer can do this very well. That is, the module
puts lots of SCSI commands in the ring buffer and tells the daemon to
perform them.

A generic interface of mapped ring buffer might be useful for others
(mmapped packet, possible async network I/O and Xen blktap driver,
etc).


> > This patchset replaces netlink shared memory between kernel and user
> > spaces. The user-space daemon and the kernel module create shared
> > memory via mmap and use it like ring buffer (like mmapped packet
> > does). The poll system call is used for notification from kernel to
> > user space and the write system call is used for notification from
> > user to kernel space. We use a simple approach so that we easily
> > replace it if we find something better later on (or we implement a
> > generic interface if necessary).
> > 
> > This patchset is against the scsi-target git tree and on the top of
> > the following patch:
> > 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=114960851929878&w=2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

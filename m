From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 18:35:49 +0900
Message-ID: <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
References: <20050301161951K.fujita.tomonori@lab.ntt.co.jp>
	<1109666441.6293.62.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:4559 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S261841AbVCAJgJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 04:36:09 -0500
In-Reply-To: <1109666441.6293.62.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: arjan@infradead.org, iscsitarget-devel@lists.sourceforge.net

From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 09:40:38 +0100

> > Could you please review the code? Any comments are greatly
> > appreciated.
> > -
> 
> can you explain why the target has to be inside the kernel and can't be
> a pure userspace daemon ?

o synchronization

Suppose that an target runs in the user space and an initiator sends
two WRITE commands (A and B) with the simple attribute.

The target can write A and B simultaneously. Before the target sends
the response of A, A must be committed to disk (that is, some dirty
page cache must be committed). So the target calls fsync(). It commits
A to disk. Moreover, it also commits B to disk unnecessarily. This
really hurts performance.

The current code uses the sync_page_range function.

o disk drive cache

When the target calls fsync(), dirty page cache is supposed to be
committed to disk. However, the disk drive uses write-back policy, it
is not. The data is still in disk drive cache. There is no system call
to control disk drive cache. So the target (in the user space) cannot
make good use of it.

The current code also assumes the disk drive uses write-through
policy. This is because no handy vfs interface for controlling disk
drive cache. I think that there is some room for further improvement
in the Linux kernel for storage systems.

If the kernel maintainers add new system calls to do the above jobs
for storage systems, We can implement good iSCSI target software
running in the user space.


The last reason is that user-space cost like memory copy. With 1Gbs
Ethernet, is is not critical. However, with 10G, it is critical, I
expect. I've been setting up 10G experimental infrastructure to
evaluate iSCSI performance.

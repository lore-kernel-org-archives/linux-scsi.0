From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target
 software
Date: Tue, 01 Mar 2005 19:22:57 +0900
Message-ID: <20050301192257C.fujita.tomonori@lab.ntt.co.jp>
References: <1109666441.6293.62.camel@laptopd505.fenrus.org>
	<20050301183549J.fujita.tomonori@lab.ntt.co.jp>
	<1109670363.6293.70.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:5102 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S261852AbVCAKXI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 05:23:08 -0500
In-Reply-To: <1109670363.6293.70.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

From: Arjan van de Ven <arjan@infradead.org>
Subject: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 10:46:03 +0100

> fsync or msync() ? I would imagine the target mmaping it's backend in
> userspace and using msync() to kick off IO. At which point it's not that
> much different from the control you do of the pagecache from inside the
> kernel...

Can we avoid calling mmap() and munmap() repeatedly with large disk?


> > When the target calls fsync(), dirty page cache is supposed to be
> > committed to disk. However, the disk drive uses write-back policy, it
> > is not. The data is still in disk drive cache. There is no system call
> > to control disk drive cache. So the target (in the user space) cannot
> > make good use of it.
> 
> fsync() (and I suppose msync()) nowadays send a "flush cache" command to
> the physical disk as well. This is new since 2.6.9 or so.
> 
> > The current code also assumes the disk drive uses write-through
> > policy. This is because no handy vfs interface for controlling disk
> > drive cache. I think that there is some room for further improvement
> > in the Linux kernel for storage systems.
> 
> that's already present since 2.6.9.....

Thanks a lot. I've not noticed these changes. I'll see the code later.

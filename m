From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 10:46:03 +0100
Message-ID: <1109670363.6293.70.camel@laptopd505.fenrus.org>
References: <20050301161951K.fujita.tomonori@lab.ntt.co.jp>
	 <1109666441.6293.62.camel@laptopd505.fenrus.org>
	 <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:44935 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261845AbVCAJqL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 04:46:11 -0500
In-Reply-To: <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

On Tue, 2005-03-01 at 18:35 +0900, FUJITA Tomonori wrote:
> From: Arjan van de Ven <arjan@infradead.org>
> Subject: Re: [ANNOUNCE] iSCSI enterprise target software
> Date: Tue, 01 Mar 2005 09:40:38 +0100
> 
> > > Could you please review the code? Any comments are greatly
> > > appreciated.
> > > -
> > 
> > can you explain why the target has to be inside the kernel and can't be
> > a pure userspace daemon ?
> 
> o synchronization
> 
> Suppose that an target runs in the user space and an initiator sends
> two WRITE commands (A and B) with the simple attribute.
> 
> The target can write A and B simultaneously. Before the target sends
> the response of A, A must be committed to disk (that is, some dirty
> page cache must be committed). So the target calls fsync(). It commits
> A to disk. Moreover, it also commits B to disk unnecessarily. This
> really hurts performance.

fsync or msync() ? I would imagine the target mmaping it's backend in
userspace and using msync() to kick off IO. At which point it's not that
much different from the control you do of the pagecache from inside the
kernel...

> o disk drive cache
> 
> When the target calls fsync(), dirty page cache is supposed to be
> committed to disk. However, the disk drive uses write-back policy, it
> is not. The data is still in disk drive cache. There is no system call
> to control disk drive cache. So the target (in the user space) cannot
> make good use of it.

fsync() (and I suppose msync()) nowadays send a "flush cache" command to
the physical disk as well. This is new since 2.6.9 or so.

> The current code also assumes the disk drive uses write-through
> policy. This is because no handy vfs interface for controlling disk
> drive cache. I think that there is some room for further improvement
> in the Linux kernel for storage systems.

that's already present since 2.6.9.....

> The last reason is that user-space cost like memory copy. With 1Gbs
> Ethernet, is is not critical. However, with 10G, it is critical, I
> expect. I've been setting up 10G experimental infrastructure to
> evaluate iSCSI performance.

if you use the mmap not write/read approach this copy isn't there.



From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target
	software
Date: Tue, 01 Mar 2005 11:33:40 +0100
Message-ID: <1109673220.6293.78.camel@laptopd505.fenrus.org>
References: <1109666441.6293.62.camel@laptopd505.fenrus.org>
	 <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
	 <1109670363.6293.70.camel@laptopd505.fenrus.org>
	 <20050301192257C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:44680 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261854AbVCAKdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 05:33:45 -0500
In-Reply-To: <20050301192257C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

On Tue, 2005-03-01 at 19:22 +0900, FUJITA Tomonori wrote:
> From: Arjan van de Ven <arjan@infradead.org>
> Subject: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target software
> Date: Tue, 01 Mar 2005 10:46:03 +0100
> 
> > fsync or msync() ? I would imagine the target mmaping it's backend in
> > userspace and using msync() to kick off IO. At which point it's not that
> > much different from the control you do of the pagecache from inside the
> > kernel...
> 
> Can we avoid calling mmap() and munmap() repeatedly with large disk?

my server has 512Gb address space with 2.6.9/2.6.10, and a lot more than
that with the 2.6.11 kernel (4 level page tables rock). So the answer
would be yes.

(and on old servers without 64 bit, you indeed need to mmap/munmap
lazily to create a window, but I suspect that the 3 Gb of address space
you have there can be managed smart to minimize the number of unmaps if
you really try)



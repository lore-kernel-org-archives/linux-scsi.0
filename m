From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Wed, 02 Mar 2005 12:30:29 +0900
Message-ID: <20050302123029Z.fujita.tomonori@lab.ntt.co.jp>
References: <1109702911.2878.16.camel@localhost.localdomain>
	<OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:19639 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S262155AbVCBDa3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 22:30:29 -0500
In-Reply-To: <OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: iscsitarget-devel@lists.sourceforge.net

From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 1 Mar 2005 13:04:58 -0800

> >it is hard to beat linux kernel [page] cache performance though.
> 
> It's quite easy to beat it for particular applications.  You can use 
> special knowledge about the workload to drop pages that won't be accessed 
> soon in favor of pages that will, not clean a page that's just going to 
> get discarded or overwritten soon, allocate less space to less important 
> data, and on and on.

Yes. The page-cache replacement policy has a big impact on the
performance. And a smart storage system tries to know how initiators
use its disk volume and adjust the replacement policy. For example, if
a initiator uses a file system, page cache keeping data used as
meta-data blocks can be important than page cache keeping data for
file-data blocks. mlock and madvise may helps, however, storage people
need more functionality for this issue, I guess.

As Arjan said, all page cache are not identical on some
architectures. So, target software need to control the way to
allocate page cache to get the best performance out of such
architectures. Can user-mode target software do it? (sorry, I've not
used such architectures.)

Another possible reason why kernel-space target software is preferable
is handling hardware. For example, NVRAM is very useful and widely
used for storage systems. I have no experience with NVRAM cards,
however, after a scan of drivers/block/umem.c (Micro Memory's NVRAM
card driver), I think that you need to modify the interrupt handler or
using bio to get the best performance out of it (although user-mode
target software can write, read, and mmap it like normal block
devices). And user-mode target software cannot handle this issue well.

Note that I'm not trying to push highly-specialized functionality,
such as new page-cache replacement policy, for storage systems into
the mainline kernel. As I said before, our code doesn't touch other
parts of the kernel.

I consider our project as a kind of a plat-home for building iSCSI
storage systems. I think that basic iSCSI functionality that our code
provides satisfies the majority. In addition, industry and academic
people can modify our code and the linux kernel to add what they
want. They can build remote mirroring systems, failover storage
systems, etc possibly by using their own hardware. We may benefit from
some of them. Thus, I think that kernel-mode iSCSI target
functionality, which can control all the system-resources and provide
the maximum flexibility and performance, is a better approach.

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target
 software
Date: Wed, 02 Mar 2005 14:04:13 +0900
Message-ID: <20050302140413R.fujita.tomonori@lab.ntt.co.jp>
References: <20050301161951K.fujita.tomonori@lab.ntt.co.jp>
	<1109666441.6293.62.camel@laptopd505.fenrus.org>
	<20050301183549J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:18419 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S262176AbVCBFEY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 00:04:24 -0500
In-Reply-To: <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 18:35:49 +0900

> The last reason is that user-space cost like memory copy. With 1Gbs
> Ethernet, is is not critical. However, with 10G, it is critical, I
> expect. I've been setting up 10G experimental infrastructure to
> evaluate iSCSI performance.

If we try to build high-performance iSCSI target software on 10Gbs
Ethernet, I think that we need to implement it in the kernel
space, although this topic is still in the research stage.

IICR, Intel provides open-source iSCSI target software, which uses
mmap() in the user space, as you suggested. However, they chose a
different approach to implement iSCSI target software for 10Gbs. They
modified the Linux kernel TCP stack to fully integrate iSCSI
functionality with it. It is still not clear how to get the best
performance out of 10GBs Ethernet, however, it seems that using just
the socket interface is not good enough. So I think that we need to
control all the system-resources to do it.

We've not optimized our code yet. The current code simply uses the
socket interface, however, moving some functionality to the TCP stack
can improve the performance, although I don't plan to modify the TCP
stack. A possible approach to do it is exploiting sk_data_ready().

In addition, you can find several papers (e.g., Chelsio technical
papers) saying that UP kernel can achieve better throughput than SMP
kernels with 10Gbs. There is some room for further improvement in the
Linux kernel.

From: Andi Kleen <ak@muc.de>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 21:38:34 +0100
Message-ID: <m1d5ujp0dx.fsf@muc.de>
References: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>
	<1109702227.6293.137.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from one.firstfloor.org ([213.235.205.2]:49566 "EHLO
	one.firstfloor.org") by vger.kernel.org with ESMTP id S262025AbVCAUif
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 15:38:35 -0500
In-Reply-To: <1109702227.6293.137.camel@laptopd505.fenrus.org> (Arjan van de
 Ven's message of "Tue, 01 Mar 2005 19:37:07 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> You want to *use* the kernel pagecache as much as you can. You do so by
> using mmap and such, and msync to force content to disk. That uses the

Last time I checked you couldn't mmap block devices. Has this changed
now?  Could be a problem for an iSCSI target.

I remember there used to be a hack in 2.2 to map them to a pseudo fs
to allow mmaping, but that's not very nice and would require
another step by the administrator.

Also using mmap would imply the server only works on 64bit systems,
and may even there have uncomfortable limits. One issue is that
the kernel currently doesn't garbage collect page tables, so 
e.g. when you map a 10TB volume this way and the user accesses
it randomly you will eventually have quite a lot of page tables
filling up your RAM. And those will not go away.

My overall feeling is that mmap is not a good idea for this.

-Andi

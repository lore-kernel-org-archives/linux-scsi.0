From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 19:37:07 +0100
Message-ID: <1109702227.6293.137.camel@laptopd505.fenrus.org>
References: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:12689 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262019AbVCAShP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 13:37:15 -0500
In-Reply-To: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, 2005-03-01 at 10:24 -0800, Bryan Henderson wrote:
> One thing that's implicit in your reasons for wanting to be in the kernel 
> is that you've chosen to exploit the kernel's page cache.  As a user of 
> the page cache, you have more control from inside the kernel than from 
> user space.  The page cache was designed to be fundamentally invisible to 
> user space.
> 
> A pure user space implementation of an ISCSI target would use process 
> virtual memory for a cache and manage it itself.  It would access the 
> storage with direct I/O. 

why would it use direct I/O ? Direct I/O would be really stupid for such
a thing to use since that means there's no caching going on *at all*.

You want to *use* the kernel pagecache as much as you can. You do so by
using mmap and such, and msync to force content to disk. That uses the
kernel pagecache to the maximum extend, while not having to bother with
knowing the intimate details of the implementation thereof, which a
kernel side implementation would be involved in. (if it wasnt and only
used highlevel functions, then you might as well do the same in
userspace after all)


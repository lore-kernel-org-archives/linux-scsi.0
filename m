From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 15:49:19 -0500
Message-ID: <1109710158.2878.42.camel@localhost.localdomain>
References: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>
	 <1109702227.6293.137.camel@laptopd505.fenrus.org>  <m1d5ujp0dx.fsf@muc.de>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from leviathan.ele.uri.edu ([131.128.51.64]:27385 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262067AbVCAUuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 15:50:06 -0500
In-Reply-To: <m1d5ujp0dx.fsf@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2005-03-01 at 15:38, Andi Kleen wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> >
> > You want to *use* the kernel pagecache as much as you can. You do so by
> > using mmap and such, and msync to force content to disk. That uses the
> 
> Last time I checked you couldn't mmap block devices. Has this changed
> now?  Could be a problem for an iSCSI target.
> 
we definitely need to support export any block device like lv or md, or
just regular hdX or sdX.

we also need supports to act as an iSCSI bridge mode, which means it can
export real scsi devices.


ming

> I remember there used to be a hack in 2.2 to map them to a pseudo fs
> to allow mmaping, but that's not very nice and would require
> another step by the administrator.
> 
> Also using mmap would imply the server only works on 64bit systems,
> and may even there have uncomfortable limits. One issue is that
> the kernel currently doesn't garbage collect page tables, so 
> e.g. when you map a 10TB volume this way and the user accesses
> it randomly you will eventually have quite a lot of page tables
> filling up your RAM. And those will not go away.
> 
> My overall feeling is that mmap is not a good idea for this.
> 
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


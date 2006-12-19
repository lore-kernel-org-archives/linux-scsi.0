From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Tue, 19 Dec 2006 22:55:18 +0900
Message-ID: <200612191355.kBJDtIWk000664@r-dd.iij4u.or.jp>
References: <20061216001753F.fujita.tomonori@lab.ntt.co.jp>
	<20061215185704.GZ5010@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo06.iij.ad.jp ([210.130.1.94]:50813 "EHLO mfo06.iij.ad.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbWLSO2G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 09:28:06 -0500
Received: MFO(mfo06) for <linux-scsi@vger.kernel.org> id kBJDu7Tx028086; Tue, 19 Dec 2006 22:56:07 +0900 (JST)
In-Reply-To: <20061215185704.GZ5010@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, dougg@torque.net

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Fri, 15 Dec 2006 19:57:05 +0100

> On Sat, Dec 16 2006, FUJITA Tomonori wrote:
> > The following patches add SG v4 support to bsg. They are over Jens'
> > bsg branch.
> > 
> > I just replaced bsg's SG v3 support with SG v4 and haven't added
> > anything new yet. So it can only handle SCSI commands.
> 
> Good start! Just one comment before I look over this and merge it - I'd
> prefer keeping this out of sg.c. One of the problems we have right now
> are dual pieces of code for sg v3, and I think it would be silly to
> continue down this path. Lets keep sg.c as a legacy sg v3 interface
> (it'll be the only one except SG_IO in the block layer), and let bsg
> take sg v4 and forward.

Yeah, that's what I want to do.


> There's really zero gain in having it in two places.
> 
> IOW, put the sg v4 structure in bsg.h.

That's fine by me. I put the sg v4 structure in sg.h simply I thought
bsg.h is for kernel space and some user-space programs need to include
sg.h for some old ioctl stuff even if they use only sg v4.


> > I've uploaded simple programs to just read/write by using SG v4:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tomo/sg4/
> 
> Great!
> 
> I'll get this reviewed and merged as soon as I can, probably monday.

Thanks. The patchset is on the top of the two minor patches:

http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265732083&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265731963&w=2

The latter needs small modifications if you will change
blk_rq_unmap_user interface.

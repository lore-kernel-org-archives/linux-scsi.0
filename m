From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Tue, 17 Jun 2008 17:45:24 -0400
Message-ID: <48583074.8010909@redhat.com>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>	<20080616151328Q.fujita.tomonori@lab.ntt.co.jp>	<6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com> <20080618051447L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbYFQVqO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 17:46:14 -0400
In-Reply-To: <20080618051447L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dgilbert@interlog.com

FUJITA Tomonori wrote:

> Well, this changes sg behaviour since sg's allow_ops filter has a
> access permission different from blk_verify_command filter's.
 >
> I guess that the first thing you need to do is that figuring out a
> proper access permission for each command, which sg maintainer, etc
> can agree. It's pretty hard and that's the reason why this patch has
> not been merged for years, I think.

I don't think this logic is sound.

The patch makes it so distros (and individuals, if they're so inclined) 
can configure the filter correctly for whatever hardware is present, 
regardless of the kernel's ideas of which commands are correct.  It 
leaves intact the defaults from the current list used by SG_IO and bsg 
(and maybe some other interfaces?), which most programs have been using 
for quite some time.

If anything, sg is overdue with converting to using the same command 
filter as other direct-scsi-command mechanisms.  sg_allow_access() is 
really not something we should be keeping.

I don't think this is a reason not to merge the patch; in fact, quite 
the opposite.  This is another case where we've got a specific filter in 
one code path that doesn't match any of the others.  Fixing it is 
something that needs to be done.  Making it configurable from the 
userland at the same time effectively aleviates the pain that could 
result from doing so.

-- 
   Peter

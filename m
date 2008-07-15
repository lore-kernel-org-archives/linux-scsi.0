From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Tue, 15 Jul 2008 17:50:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151731530.14420@devserv.devel.redhat.com>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
  <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>  <1216133421.3312.30.camel@localhost.localdomain>
  <Pine.LNX.4.64.0807151104450.26824@devserv.devel.redhat.com>
 <1216136503.3312.48.camel@localhost.localdomain>
 <Pine.LNX.4.64.0807151147040.29803@devserv.devel.redhat.com>
 <1216138072.3312.54.camel@localhost.localdomain>
 <Pine.LNX.4.64.0807151210400.31336@devserv.devel.redhat.com>
 <1216139792.3312.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYGOVu4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 17:50:56 -0400
In-Reply-To: <1216139792.3312.74.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

> > > Yes, but it's gains very little ... architectures that don't want it can
> > > already turn it off, and it's useful for those, like parisc, who do.
> > 
> > It increases maintainability of the code, reduces bloat and bugs.
> 
> That's not really a good reason.  You can eliminate code because it's
> unused and unikely to be used or you redo it to better or fix it to be
> less buggy.  You don't simply eliminate useful functionality that
> currently has in-tree users, however marginal you might opine those
> users to be.
> 
> James

So show a specific device where the virtual merge accounting is useful.

(1) The device that is often used in alpha or pa-risc environments --- 
because the accounting is not used on other archs.

(2) The device that is performance-sensitive --- not something outdated or 
unusual.

(3) And the device that has limited sg-list size, so that generic I/O 
requests made by the kernel hit this limit. (if the sg-list is so big that 
nr_phys_segments of most requests fits into it, you don't need to count 
nr_hw_segments --- because nr_hw_segments < nr_phys_segments and 
nr_phys_segments already fits).

[ the device that traverses its sg-list slowly doesn't fall into category 
(3), beacuse virtual merging would happen with or without nr_hw_segments 
accounting ]

Mikulas

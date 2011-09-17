From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] target: Fix race between multiple invocations of
 target_qf_do_work()
Date: Sat, 17 Sep 2011 18:59:56 -0400
Message-ID: <20110917225956.GA31197@infradead.org>
References: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
 <1316169506-4441-2-git-send-email-nab@linux-iscsi.org>
 <CA+55aFx+NAovTWxDdPtC4U+v6eUUGfAX_Gt2LNutF6+42BE-gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59414
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317Ab1IQXAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2011 19:00:00 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFx+NAovTWxDdPtC4U+v6eUUGfAX_Gt2LNutF6+42BE-gQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Tejun Heo <tj@kernel.org>

On Sat, Sep 17, 2011 at 12:23:36PM -0700, Linus Torvalds wrote:
> > With multiple CPUs running this code, one CPU can end up deleting the
> > list entry that the other CPU is about to work on.
> >
> > Fix this by splicing the list entries onto a local list and then
> > operating on that in the work function.
> 
> Umm. It sounds like what you really want is just a single-threaded workqueue.
> 
> Wouldn't it be better to do the alloc_workqueue with WQ_UNBOUND, and a
> max limit of a single thread? There's a helper function for it:
> alloc_ordered_workqueue().
> 
> I dunno. Maybe there's a reason why you actually do want threaded
> workqueues, but your description makes it sound like this would be
> better resolved by simply using an ordered on.

The right fix is to restructure the code at an higher level, and queue
up each individual command to the workqueue, thus killing the list
entirely.  But that's not really in scope for 3.1 at this point.


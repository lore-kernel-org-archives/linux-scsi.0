From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Tue, 27 Dec 2011 14:07:38 -0800
Message-ID: <20111227140738.c9eedb7c.akpm@linux-foundation.org>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
	<20111221151503.4d78f94f.akpm@linux-foundation.org>
	<20111222150836.af172886.akpm@linux-foundation.org>
	<20111222232036.GP17084@google.com>
	<20111222152427.c944c747.akpm@linux-foundation.org>
	<20111222233843.GR17084@google.com>
	<20111222154427.89b245c7.akpm@linux-foundation.org>
	<20111222234639.GS17084@google.com>
	<20111223004244.GU17084@google.com>
	<alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
	<20111225010238.GA6013@htj.dyndns.org>
	<4EF7253E.3070606@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1L0WHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2011 17:07:40 -0500
In-Reply-To: <4EF7253E.3070606@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hugh Dickins <hughd@google.com>, x86@kernel.org

On Sun, 25 Dec 2011 14:29:34 +0100
Jens Axboe <axboe@kernel.dk> wrote:

> On 2011-12-25 02:02, Tejun Heo wrote:
> > While fixing io_context creation / task exit race condition,
> > 6e736be7f2 "block: make ioc get/put interface more conventional and
> > fix race on alloction" also prevented an exiting (%PF_EXITING) task
> > from creating its own io_context.  This is incorrect as exit path may
> > issue IOs, e.g. from exit_files(), and if those IOs are the first ones
> > issued by the task, io_context needs to be created to process the IOs.
> > 
> > Combined with the existing problem of io_context / io_cq creation
> > failure having the possibility of stalling IO, this problem results in
> > deterministic full IO lockup with certain workloads.
> > 
> > Fix it by allowing io_context creation regardless of %PF_EXITING for
> > %current.

The patch works for me.

> Thanks, applied.

So we get another great big bisection hole in mainline.  I feel
duty bound to rewhine about this :(


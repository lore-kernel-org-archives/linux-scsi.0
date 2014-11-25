From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 4/5] scsi_debug: change SCSI command parser to table
 driven
Date: Tue, 25 Nov 2014 10:24:49 -0800
Message-ID: <1416939889.15196.5.camel@HansenPartnership.com>
References: <5474000A.2030501@interlog.com>
	 <1416928359.2194.23.camel@HansenPartnership.com>
	 <5474A963.2030006@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54439 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbaKYSYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 13:24:52 -0500
In-Reply-To: <5474A963.2030006@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On Tue, 2014-11-25 at 11:08 -0500, Douglas Gilbert wrote:
> On 14-11-25 10:12 AM, James Bottomley wrote:
> > On Mon, 2014-11-24 at 23:05 -0500, Douglas Gilbert wrote:
> >> From: Douglas Gilbert <dgilbert@interlog.com>
> >> Date: Mon, 24 Nov 2014 20:46:29 -0500
> >> Subject: [PATCH 4/5] change SCSI command parser to table driven
> >>
> >> The existing 'big switch' parser in queuecommand() is changed to
> >> a table driven parser. The old and new queuecommand() were moved
> >> in the source so diff would not shuffle them. Apart from the new
> >> tables most other changes are refactoring existing response code
> >> to be more easily called out of the table parser. The 'strict'
> >> parameter is added so that cdb_s can be checked for non-zero
> >> values in parts of the cdb that are reserved. Some other changes
> >> include: tweak request sense response when D_SENSE differs; support
> >> NDOB in Write Same(16); and fix crash in Get LBA Status when LBP
> >> was inactive.
> >> ---
> >>    drivers/scsi/scsi_debug.c | 1391 +++++++++++++++++++++++++++------------------
> >>    1 file changed, 833 insertions(+), 558 deletions(-)
> >
> > There's a massive amount of apparently unnecessary code motion in this
> > patch (like moving the whole of scsi_debug_queuecommand).  This caused a
> > reject today on the merger of the drivers-for-3.19 with core-for-3.19
> > (conflict with the queue depth reason elimination). Can we not do large
> > pieces of code motion unless there's good reason.
> 
> I was asked to break up the code to make it easier to
> review. The critical part of this chunk was the replacement
> of the big switch in queuecommand() with a table driven
> version. Without that move, the diff (both in git and by hand)
> shuffles the two versions of queuecommand() in such a way
> that I cannot even understand what is going on (and I wrote
> half of the old one and all of the new one).

That may be, but it's even less reviewable if you simply move the code
to make the diff come out better because now there's a large chunk of
minusses and a large chunk of plusses and you can't necessarily see the
changes.  At least with in place changes you can use better diff tools
if the unified diff isn't working.  Things like reducing or increasing
context lines also help.

> There are two audiences to a presented patch: those who
> might review it (and Hannes has been the only volunteer
> to date) and those that might apply it after it is
> reviewed. Until today, I was still at the first hurdle.
> 
> Is there a way to tell (git) diff not to shuffle the old and
> new versions of a function? Would changing the name of the
> new version have helped (e.g. qcommand() )?

You can use -U<n> to reduce or increase context.  You can also change
the algorithm with --diff-algorithm=<alg> and in the last instance it
can do a word diff (--word-diff) although that probably would never be
suitable for posting to a mailing list.

> > Perhaps, also, it's time to reconsider whether we do actually need a
> > core and drivers branch separation.
> 
> I did a git pull on the drivers-for-3.19 just before I
> built this patch. That caused conflict due to the queue
> depth reason elimination so I rebuilt my patch. The kernel
> was then built as every chunk was applied. Not every step
> was tested (i.e. kernel was not run) but the end result
> is what was presented a month ago and tested then (modulo
> changes in drivers-for-3.19 since then).

Right, but that's not the problem ... the problem is a conflict with
core-for-3.19.

> > The merge was trivial but I've attached it below, just in case.
> 
> I don't understand the patch below. It seems to add
> back the old, big-switch parser. That will set up a conflict
> with the new one which has the same function signature.

Right, that's the extra chunk which is the source of the zero day build
failure. I've removed it, so everything should work now.

James



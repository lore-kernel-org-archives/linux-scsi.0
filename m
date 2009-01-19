From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 21:03:55 +1100
Message-ID: <200901192103.57508.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901191933.29322.nickpiggin@yahoo.com.au> <84144f020901190148r7ea135b6uead33842e93e59c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:23591 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758709AbZASKEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 05:04:21 -0500
In-Reply-To: <84144f020901190148r7ea135b6uead33842e93e59c2@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Christoph Lameter <cl@linux-foundation.org>

On Monday 19 January 2009 20:48:52 Pekka Enberg wrote:
> Hi Nick,
>
> On Mon, Jan 19, 2009 at 10:33 AM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> >> All I am saying is that I don't like how we're fixing a performance bug
> >> with a shiny new allocator without a credible explanation why the
> >> current approach is not fixable.
> >
> > To be honest, my biggest concern with SLUB is the higher order pages
> > thing. But Christoph always poo poos me when I raise that concern, and
> > it's hard to get concrete numbers showing real fragmentation problems
> > when it can take days or months to start biting.
>
> To be fair to SLUB, we do have the pending slab defragmentation
> patches in my tree. Not that we have any numbers on if defragmentation
> helps and how much. IIRC, Christoph said one of the reasons for
> avoiding queues in SLUB is to be able to do defragmentation. But I
> suppose with SLQB we can do the same thing as long as we flush the
> queues before attempting to defrag.

I have had a look at them, (and I raised some concerns about races with
the bufferhead "defragmentation" patch which I didn't get a reply to,
but now's not the time to get into that).

Christoph's design AFAIKS is not impossible with queued slab allocators,
but they would just need to do either some kind of per-cpu processing,
at least a way to flush queues of objects. This should not be impossible.

But in my reply, I also outlined an idea for a possibly better design for
targetted slab reclaim that could have fewer of the locking complexitiesin 
other subsystems like the slub defrag patches do. I plan to look at this
at some point, but I think we need to sort out the basics first.


From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 19:42:47 +1100
Message-ID: <200901191942.48548.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <1232352303.30141.25.camel@penberg-laptop> <200901191933.29322.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35419 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753343AbZASInL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 03:43:11 -0500
In-Reply-To: <200901191933.29322.nickpiggin@yahoo.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Christoph Lameter <cl@linux-foundation.org>

On Monday 19 January 2009 19:33:27 Nick Piggin wrote:
> On Monday 19 January 2009 19:05:03 Pekka Enberg wrote:

> > All I am saying is that I don't like how we're fixing a performance bug
> > with a shiny new allocator without a credible explanation why the
> > current approach is not fixable.
>
> To be honest, my biggest concern with SLUB is the higher order pages
> thing. But Christoph always poo poos me when I raise that concern, and
> it's hard to get concrete numbers showing real fragmentation problems
> when it can take days or months to start biting.
>
> It really stems from queueing versus not queueing I guess. And I think
> SLUB is flawed due to its avoidance of queueing.

And FWIW, Christoph was also not able to fix the OLTP problem although
I think it has been known for nearly two years ago now (I remember we
talked about it at 2007 KS, although I wasn't following slab development
very keenly back then).

At this point I feel spending time working on SLUB isn't a good idea if
a) Christoph himself hadn't fixed this problem; and b) we disagree about
fundamental design choices (see the "SLQB slab allocator" thread).

Anyway, nobody has disagreed with my proposal to merge SLQB, so in the
worst case I don't think it will cause too much harm, and in the best
case it might turn out to make the best tradeoffs and who knows, it
might actually not be catastrophic for HPC ;)


From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Fri, 2 Dec 2005 18:55:58 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512021836100.4940@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <1133468882.5232.14.camel@mulgrave>
 <Pine.LNX.4.63.0512012304240.5777@kai.makisara.local>
 <Pine.LNX.4.61.0512021325020.1507@goblin.wat.veritas.com>
 <Pine.LNX.4.63.0512021932590.4506@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gold.veritas.com ([143.127.12.110]:56202 "EHLO gold.veritas.com")
	by vger.kernel.org with ESMTP id S1750938AbVLBS4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 13:56:20 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (2796 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EiG4c-0001IYC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 2 Dec 2005 10:55:58 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <Pine.LNX.4.63.0512021932590.4506@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Ryan Richter <ryan@tau.solarneutrino.net>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2 Dec 2005, Kai Makisara wrote:
> On Fri, 2 Dec 2005, Hugh Dickins wrote:
> I include at the end of this message the patch I sent to linux-scsi 
> earlier. It should clarify what are the useful parts of the later patch.

Thanks, yes.  I'll leave out updating the verstr[],
I think that should be sent by you alone.

> I think the release_buffering() call at the end of st_read must say 1. All 
> returns use the same path (except the one returning -ERESTARTSYS).

Okay, if you insist.  Yes, all those returns pass that way, but if it
actually did some reading into the memory, it called read_tape, which
did the effective release_buffering immediately after st_do_scsi.

But perhaps I'm misreading it, and even if not, someone will come
along and "correct" it later, or change things around and make my
not-dirty assumption wrong.

It's just that after seeing how sg.c is claiming to dirty even readonly
memory, I'm excessively averse to saying we've dirtied memory we haven't.
My hangup, I'll get over it!

> st.c did set pages dirty after reading before 2.6.0-test4. It disappeared 
> when code was rearranged and I don't have any notes about why.

Possibly because of issues with hugetlb compound pages: David Gibson
raised that issue recently with respect to access_process_vm
(page[1].mapping is reused and crashes set_page_dirty), I'm thinking
we don't want to add PageCompound tests all over, and have mailed
Andrew separately for guidance on that.

Hugh

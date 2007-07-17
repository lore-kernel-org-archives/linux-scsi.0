From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 15:43:15 +0900
Message-ID: <20070717154315E.fujita.tomonori@lab.ntt.co.jp>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<20070717063810.GY5195@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38271 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbXGQGoJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 02:44:09 -0400
In-Reply-To: <20070717063810.GY5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 08:38:11 +0200

> On Mon, Jul 16 2007, Andrew Morton wrote:
> > 
> > A belated review (I've never seen this before and there it is in mainline)
> > 
> > > static char bsg_version[] = "block layer sg (bsg) 0.4";
> > 
> > `const' would be better.  That moves it into a write-protected memory section.
> 
> Agree
> 
> > > #define list_entry_bc(entry)	list_entry((entry), struct bsg_command, list)
> > 
> > This makes the code easier to write but harder to read.  We should optimise
> > for readers.  Please open-code this at callsites.
> > 
> > Or at least convert it into a (commented) (possibly inlined) C function.
> 
> list_entry_to_bc(), then? The main objective is to save on typing, and
> (just as important) make sure we don't bump over the 80 chars per line.
> 
> > > /*
> > >  * just for testing
> > >  */
> > > #define BSG_MAJOR	(240)
> > 
> > What's this doing in mainline?  240 is a "reserved for local use" major. 
> > This will cause collisions.  This code should be using dynamic major
> > assignment.
> 
> Yeah, that's a big error on my part. Will get that fixed up right away.

I've been testing the patchset to fix the issues that Andrew pointed
out. I can send it soon.

Jens, have you already fixed some?

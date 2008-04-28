From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 09:05:34 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804280903230.3119@woody.linux-foundation.org>
References: <1209320076.3801.26.camel@localhost.localdomain>  <20080428013400.GA6245@elte.hu> <1209351113.3801.107.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933537AbYD1QGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 12:06:22 -0400
In-Reply-To: <1209351113.3801.107.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Sun, 27 Apr 2008, James Bottomley wrote:
> 
> Try this; the signature for an uninitialised free list is easy (both
> list pointers NULL), so the patch detects that and doesn't try to run
> over the uninitialised list head.

Why aren't these things initialized?

You say that the signature of an uninitialised free list is trivial, but 
that's not at all true in general. It depends intimately on how the memory 
was allocated, and is thus very subtle indeed - some change to allocations 
can break something simple like this, by initializing it with random old 
memory contents.

So why not just initialize lists like this so early (ie at allocation 
time) that problems like this cannot happen? Instead of adding ugly and 
fragile cases to the freeing?

		Linus

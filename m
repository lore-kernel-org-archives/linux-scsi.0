From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 15:22:13 +0000
Message-ID: <1251386533.6426.36.camel@mulgrave.site>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	 <4A95226E.8030504@panasas.com> <yq1my5l934u.fsf@sermon.lab.mkp.net>
	 <4A9656B6.5060100@panasas.com> <1251380803.6426.16.camel@mulgrave.site>
	 <4A969AD4.7070309@panasas.com> <1251384706.6426.29.camel@mulgrave.site>
	 <4A96A3AF.4000701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZH0PWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 11:22:15 -0400
In-Reply-To: <4A96A3AF.4000701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 18:18 +0300, Boaz Harrosh wrote:
> >>> What you likely want is a way of telling that the page got re-written so
> >>> you don't need to print out scary warning messages about parity
> >>> problems.
> >>>
> >>
> >> Maybe that is a start. I guess I could signal a fast abort for these. What
> >> would be the cost for this knowledge. I guess O(sglist-size) right? loop
> >> on all pages and check? Anything better we can do?
> > 
> > I think it's a page flag indicating write begun on current page.  it
> > gets set when I/O is begun and reset if another write comes in in the
> > meantime.  Thus you can check before issue if this flag is set ... if it
> > is, your digest is likely set.  If not, you need to discard the page
> > from the I/O (or redo the digest).
> > 
> 
> Yes I thought so. The race here is bad so it will only eliminate some of
> the bad transitions, not all.

But surely mitigation is good enough?  The array will block digest
failures on its own ... we can recheck the flag when this happens to see
if we lost the race so not print the messages.  Winning this before
issue race most of the time still gives good performance.

James



From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] async: make sure independent async domains can't
 accidentally entangle.
Date: Sun, 24 May 2009 12:40:09 -0700
Message-ID: <20090524124009.0be540c5@infradead.org>
References: <1243175371.2889.17.camel@localhost.localdomain>
	<1243191043.2889.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZEXUUN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 16:20:13 -0400
In-Reply-To: <1243191043.2889.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 24 May 2009 13:50:43 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2009-05-24 at 09:29 -0500, James Bottomley wrote:
> > The problem occurs when async_synchronize_full_domain() is called
> > when the async_pending list is not empty.  This will cause
> > lowest_running() to return the cookie of the first entry on the
> > async_pending list, which might be nothing at all to do with the
> > domain being asked for and thus cause the domain synchronization to
> > wait for an unrelated domain.   This can cause a deadlock if domain
> > synchronization is used from one domain to wait for another.
> > 
> > Fix by running over the async_pending list to see if any pending
> > items actually belong to our domain (and return their cookies if
> > they do).
> > 
> > Signed-off-by: James Bottomley
> > <James.Bottomley@HansenPartnership.com>
> 
> OK, so that version locked up under testing ... this version doesn't
> --- I think the phrase "MUST be called with the lock held!" was
> supposed to be some sort of clue ...

there's not many comments there.. but the ones that exist do mean
something ;-)

I'll craft this patch into your original description and send it to
Linus to see if he'll take it for .30, otherwise it'll go for .31


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

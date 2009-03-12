From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: increase default timeout for INQUIRY
Date: Thu, 12 Mar 2009 11:24:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0903121120300.3155-100000@iolanthe.rowland.org>
References: <1236870949.3248.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34703 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753389AbZCLPYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 11:24:43 -0400
In-Reply-To: <1236870949.3248.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Paul Wellner Bou <paul@purecodes.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 12 Mar 2009, James Bottomley wrote:

> On Thu, 2009-03-12 at 09:12 -0600, Matthew Wilcox wrote:
> > On Thu, Mar 12, 2009 at 11:08:51AM -0400, Alan Stern wrote:
> > > It's hard to see how this could cause any signficant problems, unless 
> > > somebody actually depends on INQUIRY timing out.
> > 
> > Erm, like doing a scan of a bus?  With 15 devices to probe, you've
> > increased the time from 15 * 3 = 45 seconds to 15 * 20 = 300 seconds.
> > That's not cool ;-(
> > 
> > Maybe we could default this in the transport or something so USB can
> > override it.
> 
> Well, no, this is the overall command timeout.  Each bus (that's
> scannable) has its own timeout.  For instance, on a parallel bus this is
> 250ms per device ... don't respond in that time, we return
> DID_NO_CONNECT.
> 
> I think what Alan is saying is that some USB devices will take >5s to
> respond to an initial inquiry.  Remember that USB isn't actually a
> scannable bus.  We get told there's a device there and we have to send
> an INQUIRY to classify it.

That's right.  There are a few devices which take > 15 seconds to 
respond to INQUIRY, but once they do respond they go on to work 
correctly and at a reasonable speed.  Apparently this is some sort of 
initialization delay.

Obviously this isn't a huge issue, since users can set the module
parameter for themselves.  But it's a lot easier if they don't have to
-- especially since they won't have to figure out what _needs_ to
changed (it isn't at all obvious from the pattern of errors).

Alan Stern


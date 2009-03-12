From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: increase default timeout for INQUIRY
Date: Thu, 12 Mar 2009 10:15:49 -0500
Message-ID: <1236870949.3248.13.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0903121106480.3155-100000@iolanthe.rowland.org>
	 <20090312151206.GC14425@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60284 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681AbZCLPPz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2009 11:15:55 -0400
In-Reply-To: <20090312151206.GC14425@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Wellner Bou <paul@purecodes.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2009-03-12 at 09:12 -0600, Matthew Wilcox wrote:
> On Thu, Mar 12, 2009 at 11:08:51AM -0400, Alan Stern wrote:
> > It's hard to see how this could cause any signficant problems, unless 
> > somebody actually depends on INQUIRY timing out.
> 
> Erm, like doing a scan of a bus?  With 15 devices to probe, you've
> increased the time from 15 * 3 = 45 seconds to 15 * 20 = 300 seconds.
> That's not cool ;-(
> 
> Maybe we could default this in the transport or something so USB can
> override it.

Well, no, this is the overall command timeout.  Each bus (that's
scannable) has its own timeout.  For instance, on a parallel bus this is
250ms per device ... don't respond in that time, we return
DID_NO_CONNECT.

I think what Alan is saying is that some USB devices will take >5s to
respond to an initial inquiry.  Remember that USB isn't actually a
scannable bus.  We get told there's a device there and we have to send
an INQUIRY to classify it.

James



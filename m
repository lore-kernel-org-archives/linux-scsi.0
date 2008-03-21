From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 14:44:22 -0500
Message-ID: <1206128662.2961.37.camel@localhost.localdomain>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55741 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244AbYCUTo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 15:44:26 -0400
In-Reply-To: <47E3EC67.4050404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, 2008-03-21 at 13:12 -0400, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
> >     [SCSI] fix media change events for polled devices
> >     
> >     Commit:
> >       a341cd0f (SCSI: add asynchronous event notification API)
> >     breaks:
> >       285e9670 (sr,sd: send media state change modification events)
> >     by introducing an event filter, which is removed here, to make
> >     events, we are depending on, happen again.
> 
> 
> By simply reading the code history, it is trivial to verify that this 
> description is false:
> 
> Commit 285e9670 depends on a341cd0f, so by definition it is 285e9670 -- 
> or rather the incomplete update of your original patch that resulted in 
> 285e9670 -- that is broken.
> 
> Since commit 285e9670 is broken, you fixed the wrong thing.
> 
> Furthermore, you broke a userspace interface that was introduced by 
> a341cd0f, by removing the event filter controlled by userspace.

> Did anyone bother to read any code at all?

Yes, I did.  The userspace interface has never worked as a writeable
attribute because it's read only (as Kay has pointed out several times).
Based on that, I just #if'd out the filter code to get polled media
events working again.

The filter can be put back with a better discriminator for 2.6.26

> When 285e9670 was updated for the scsi_evt_* interface, it should have 
> initialized the supported_events mask.

That would break HAL ... it's using the presence of the media_event flag
in the variable to indicate it doesn't need to poll.  We need two flags,
one for polling and one for AN.

> And that is the fix -- initialize supported_events according to sr/sd's 
> needs, and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) 
> as obviously broken.

James



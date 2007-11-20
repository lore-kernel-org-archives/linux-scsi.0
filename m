From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 10:15:33 -0600
Message-ID: <1195575333.3131.37.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0711201053550.3931-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:37212 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758716AbXKTQPj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 11:15:39 -0500
In-Reply-To: <Pine.LNX.4.44L0.0711201053550.3931-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>


On Tue, 2007-11-20 at 11:02 -0500, Alan Stern wrote:
> On Tue, 20 Nov 2007, James Bottomley wrote:
> 
> > I don't really know ... I don't have a clear idea of what you're trying
> > to do.  I know Alan said it was something simple, but from what you're
> > saying it sounds like you need a full blown power management
> > infrastructure in all three places.
> 
> Basically that's right.
> 
> The higher-level drivers already have some PM infrastructure; all we
> would have to add would be idle-timeout detection.  The midlayer has to
> be involved in order to coordinate between the high-level and the
> low-level drivers.  The key addition is to get the low-level drivers 
> involved.
> 
> The main point I'm aiming for is to have the midlayer to inform the LLD 
> when all the devices on a particular bus are "idle".

This is the wrong assumption ... the mid layer would provide an API to
inform the transport.  Transport and host are separate things.  an 8
port SAS card could suspend a single phy and device while still
processing the others.  So what it sounds like you need is a transport
API saying a given device has been suspended or is requested to be
resumed?  What than means for the host would be transport class policy,
I think.

>   At that point the 
> LLD is free to suspend or power down the transport.  Conversely, if the 
> transport is suspended and an I/O request arrives, the LLD has to be 
> told to reactivate the transport.  Without some such form of 
> communication, there's no way to know when the tranport can safely be 
> suspended.
> 
> Does that clarify things?

A little ... I think your wake on command idea above is policy rather
than actual implementation ... so it would probably have to be
selectable (either error or wake).

James



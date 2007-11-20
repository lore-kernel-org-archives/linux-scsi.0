From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 11:02:10 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711201053550.3931-100000@iolanthe.rowland.org>
References: <1195573322.3131.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52838 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757646AbXKTQCL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 11:02:11 -0500
In-Reply-To: <1195573322.3131.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Oliver Neukum <oliver@neukum.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 Nov 2007, James Bottomley wrote:

> I don't really know ... I don't have a clear idea of what you're trying
> to do.  I know Alan said it was something simple, but from what you're
> saying it sounds like you need a full blown power management
> infrastructure in all three places.

Basically that's right.

The higher-level drivers already have some PM infrastructure; all we
would have to add would be idle-timeout detection.  The midlayer has to
be involved in order to coordinate between the high-level and the
low-level drivers.  The key addition is to get the low-level drivers 
involved.

The main point I'm aiming for is to have the midlayer to inform the LLD 
when all the devices on a particular bus are "idle".  At that point the 
LLD is free to suspend or power down the transport.  Conversely, if the 
transport is suspended and an I/O request arrives, the LLD has to be 
told to reactivate the transport.  Without some such form of 
communication, there's no way to know when the tranport can safely be 
suspended.

Does that clarify things?

Alan Stern


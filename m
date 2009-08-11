From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/7] Fix various bugs in the target code
Date: Tue, 11 Aug 2009 10:15:01 -0500
Message-ID: <1250003701.4301.31.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0908111109470.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35546 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbZHKPPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 11:15:02 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908111109470.2562-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2009-08-11 at 11:12 -0400, Alan Stern wrote:
> On Mon, 10 Aug 2009, James Bottomley wrote:
> 
> > > 	scsi_sysfs_add_sdev() would call transport_configure_device()
> > > 	for a target each time a new device was added under that
> > > 	target.  The call has been moved to scsi_target_add(), where
> > > 	it will be made only once.
> > 
> > That, unfortunately is an SPI required feature ... we can't actually
> > configure the target until we have a device because of the way SPI
> > parameters work.
> 
> Would it be sufficient to call transport_configure_device() only the
> first time a device is added?

No, because of renegotiations ... it would be sufficient only to call it
the last time a device is added, but we don't know when that will be.

James



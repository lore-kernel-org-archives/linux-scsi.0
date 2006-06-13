From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 15:02:40 -0500
Message-ID: <1150228960.3441.72.camel@mulgrave.il.steeleye.com>
References: <448DF5DA.3070800@sgi.com>
	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>
	 <448EDCEB.50702@sgi.com>
	 <1150221599.3441.54.camel@mulgrave.il.steeleye.com>
	 <448F1403.6090903@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37348 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932166AbWFMUCy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 16:02:54 -0400
In-Reply-To: <448F1403.6090903@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

On Tue, 2006-06-13 at 14:37 -0500, Michael Reed wrote:
> Not really true as the transport holds off the error handler until the
> transport dev loss timer expires.
> 
> And afterwards, commands are returned immediately with DID_NO_CONNECT.
> The device is never offlined (with my patch applied).

That was just a general examination of the options for retaining contact
with the target.

It seems we both agree that returning an error is about the only viable
option, in which case the user or application has to take a recovery
action anyway, so there's no logical difference between what you propose
and what we currently do as far as the application or filesystem is
concerned.

The only difference is what happens if the device reappears.  However,
since the application has to be modified in either case:  your patch to
continually probe with I/O to see if the device has returned, or the
existing case to wait out the udev event that says the device is back it
doesn't really buy us anything for the application.  Since the rest of
our infrastructure is already event driven, or migrating that way, I
really don't see value in introducing an anomaly like this purely for
fibre channel.

James



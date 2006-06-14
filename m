From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Wed, 14 Jun 2006 11:31:11 -0500
Message-ID: <449039CF.5090807@cs.wisc.edu>
References: <448DF5DA.3070800@sgi.com>	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>	 <448EDCEB.50702@sgi.com>	 <1150221599.3441.54.camel@mulgrave.il.steeleye.com>	 <448F1403.6090903@sgi.com> <1150228960.3441.72.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49566 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965025AbWFNQbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 12:31:24 -0400
In-Reply-To: <1150228960.3441.72.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

James Bottomley wrote:
> On Tue, 2006-06-13 at 14:37 -0500, Michael Reed wrote:
>> Not really true as the transport holds off the error handler until the
>> transport dev loss timer expires.
>>
>> And afterwards, commands are returned immediately with DID_NO_CONNECT.
>> The device is never offlined (with my patch applied).
> 
> That was just a general examination of the options for retaining contact
> with the target.
> 
> It seems we both agree that returning an error is about the only viable
> option, in which case the user or application has to take a recovery
> action anyway, so there's no logical difference between what you propose
> and what we currently do as far as the application or filesystem is
> concerned.
> 
> The only difference is what happens if the device reappears.  However,
> since the application has to be modified in either case:  your patch to
> continually probe with I/O to see if the device has returned, or the
> existing case to wait out the udev event that says the device is back it
> doesn't really buy us anything for the application.  Since the rest of
> our infrastructure is already event driven, or migrating that way, I
> really don't see value in introducing an anomaly like this purely for
> fibre channel.
> 

For iscsi we do sort of the probe option. The problem with software
iscsi is that we do not normally get a event that some target is back
online so from userspace we basically have to probe it. We try to open a
connection and poll it until it we can connect, then we try to log back
in. When we log back in, we set the devices online if we have to and we
set the driver and iscsi state to start accepting IO again.

For HW iscsi the card can signal an event that it has logged back into a
target, so we could do like FC. So for qla4xxx, should we follow the FC
model or software iscsi one that is already there?

Note, that for software iscsi we could do FC's model too. When
dev_loss_tmo expires we could remove the session/target. Then we could
just create the connection, poll, and if we successfully login we could
then create the session/target structs again.

From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 16:43:27 -0400
Message-ID: <431F50EF.1060901@adaptec.com>
References: <Pine.LNX.4.44L0.0509071519080.4988-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:2002 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932250AbVIGUnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 16:43:33 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509071519080.4988-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 09/07/05 15:31, Alan Stern wrote:
> 
> As for layering violations and deadlocks...  Unfortunately the violation
> is unavoidable.  It's related to the way the error handler sometimes tries
> to fix a non-working device by doing a bus reset, which will also affect
> all the other devices on the same bus.

Yes, that's a good point.

Is it possible to implement LU Reset TMF for USB storage devices?
If so, then you do not need to do a "bus reset".

*General note:* It is very bad to have to punish all devices on the
"bus" just because one device failed.  Isn't there a better way
to recover(*) a failed USB Storage device?

(*) That doesn't necessarily mean "bring back to life", it could
also mean "remove".

That is, a "bus reset" means that also any other device on the "bus" is
unreachable.  If this is _not_ the case, then a "bus" reset must _not_
take place.

>>This makes me believe that maybe USB storage would need an overhaul
>>of the event infra: removing and adding, and/or implement its own
>>eh.
> 
> In the long run that might be good, but for now I think we'll be okay.  
> The important thing is to make sure that once the device has moved to the
> CANCEL state, everything fails quickly.

If you have the means to do transport checking of the state of the
device, (and it seems like you can for USB Storage, since it is USB after
all), then you _must_ implement your own eh handler.  This is what
it is for.  Please, consider.

	Luben

P.S. It may actually simplify things in the USB transport layer _and_ in
SCSI Core (i.e. no need for those patches).







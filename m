From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 18:08:23 -0400
Message-ID: <446B9ED7.5050204@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F9FB.7020807@garzik.org>	 <1147797507.3505.52.camel@mulgrave.il.steeleye.com>	 <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>	 <446B3BE0.8040806@garzik.org>	 <1147881002.3463.23.camel@mulgrave.il.steeleye.com>	 <446B4CAA.1030409@garzik.org> <1147888381.3463.49.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55498 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751206AbWEQWI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:08:27 -0400
In-Reply-To: <1147888381.3463.49.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

James Bottomley wrote:
> On Wed, 2006-05-17 at 12:17 -0400, Jeff Garzik wrote:
>> Yes, and not only that...  you must describe the queue pipeline too. 
>> i.e. N logical devices can be bottlenecked behind a bridge (expander, 
>> port multiplier, tunnel) of queue depth Q, which may in turn be behind 
>> another bottleneck.  :)
> 
> Well ... no, I'm not convinced of this.  Block is currently a nice, fast
> abstraction.  It's designed to manage storage infrastructure and provide
> helpers to implementation.  The question is how much more common
> infrastructure do we need to slim down all of our storage stacks.  I.e.
> block provides the building blocks to allow the storage implementation
> to do what it wants, but it doesn't necessarily provide the full
> implementation.

My central thesis is that
* SCSI provides a generic _storage driver_ infrastructure, encapsulating 
many common idioms generic to SCSI and non-SCSI hardware alike.
* Any such storage driver infrastructure, outside of SCSI, should impose 
no burdens on existing block drivers.

Call such storage driver infrastructure "libstorage" if you will.


>> But overall, libata and SAS controllers are forced to deal with the 
>> reality of the situation:  they all wind up either using, or recreating 
>> from scratch, objects for host/device/bus/etc. in order to sanely allow 
>> all the infrastructure to interoperate.
> 
> but that doesn't go for all storage ... look at the way usb and firewire
> implement host in SCSI at the moment.

Let's just stop using the word host, its too confusing for all involved 
:)  I'm well aware of this, look at how libata uses Scsi_Host too...


>> You'll all note that struct Scsi_Host and struct scsi_cmnd have very 
>> little to do with SCSI.  Its almost all infrastructure and driver 
>> management.  That's the _useful_ stuff that libata uses SCSI for.
> 
> Some is driver management, others are SCSI specific.  We'll never get

Agreed, though IMO I claim that "a lot" is driver management.


> away from the need for Scsi_Host and scsi_cmnd, but we can make sure
> they contain only truly SCSI specific pieces.  scsi_cmnd is the closest
> since it pretty much has a one to one mapping with a block request.

Agreed.


>> Thus, moving libata to the block layer entails either 
>> s/Scsi_Host/Storage_Host/g or a highly similar infrastructure, to 
>> achieve the same gains.
> 
> I'm not sure.  Block is currently nicely lightweight.  A large number of
> implementations have no use for a host concept ... I don't think we
> should be forcing it on them.

Like I said above, think "libstorage".  I think block as-is, too.

	Jeff



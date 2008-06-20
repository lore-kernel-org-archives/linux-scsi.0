From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Fri, 20 Jun 2008 18:41:02 -0400
Message-ID: <485C31FE.8050408@garzik.org>
References: <485B2CC6.6070201@kernel.org> <1213993737.3443.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40426 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYFTWli (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2008 18:41:38 -0400
In-Reply-To: <1213993737.3443.35.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>

James Bottomley wrote:
> On Fri, 2008-06-20 at 13:06 +0900, Tejun Heo wrote:
>> The biggest problem is how to keep userland happy.  hdX -> sdX
>> transition was painful enough and I have a strong feeling that
>> everyone will come after and hunt down us if we try something like sdX
>> -> bdX now.  :-)

> In theory mounting by label or ID should have fixed a lot of this.
> However, if we need to head off a revolt, the sdX allocation algorithm
> can be placed into it's own module so both sd and a ULD ata driver could
> use it ...

> Actually, surely we can mostly dump the SAT layer?


I don't see that we can do that for a long time...  And it's not just 
the sdX allocation algorithm in question -- SCSI block devices come with 
their own partition limits and set of supported ioctls.

Therefore, my recommended path has always been

* create ata_disk block device driver (ULD, in your terminology)

* make SAT an optional piece, which maintains compatibility with 
existing SCSI blkdevs, ioctls, command sets


I just don't see a valid path moving forward that breaks userland 
/again/...  we (ATA hackers) would be drummed out of a job I think :)

Another option that's been discussed is

1) Make SCSI block devices themselves an allocate-able resource (I think 
that's what you meant by "placed into it's own module so both sd and a 
ULD ata driver could use it"?)

2) Ensure that any ata_disk ULD would support the same partition limits 
and ioctl set, enough to ensure binary compatibility.

Because that's the real need -- maintaining binary compatibility with 
SCSI block devices, so major/minor, ioctl supported set, partition 
limits, and other relevant details need to remain unchanged.

The underlying software we're of course free to change...

	Jeff



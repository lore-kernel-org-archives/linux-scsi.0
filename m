From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 12:17:46 -0400
Message-ID: <446B4CAA.1030409@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F9FB.7020807@garzik.org>	 <1147797507.3505.52.camel@mulgrave.il.steeleye.com>	 <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>	 <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57527 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750790AbWEQQRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 12:17:50 -0400
In-Reply-To: <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

James Bottomley wrote:
> On Wed, 2006-05-17 at 11:06 -0400, Jeff Garzik wrote:
>> storage device and storage host are key objects included in the 
> 
> This is one of the questions.  Currently block has no concept of "host".
> All it knows about are queues (which may be per host or per device
> depending on the implementation).  Do we need to introduce the concept
> of something like queue grouping (a sort of lightweight infrastructure
> that could be used by the underlying transport to implement a host
> concept without introducing hosts at the block layer)?

Yes, and not only that...  you must describe the queue pipeline too. 
i.e. N logical devices can be bottlenecked behind a bridge (expander, 
port multiplier, tunnel) of queue depth Q, which may in turn be behind 
another bottleneck.  :)

But overall, libata and SAS controllers are forced to deal with the 
reality of the situation:  they all wind up either using, or recreating 
from scratch, objects for host/device/bus/etc. in order to sanely allow 
all the infrastructure to interoperate.

You'll all note that struct Scsi_Host and struct scsi_cmnd have very 
little to do with SCSI.  Its almost all infrastructure and driver 
management.  That's the _useful_ stuff that libata uses SCSI for.

Thus, moving libata to the block layer entails either 
s/Scsi_Host/Storage_Host/g or a highly similar infrastructure, to 
achieve the same gains.

It is _trivial_ to write a new SCSI driver [even if your hardware is not 
SCSI], and there are good reasons for that.  Please all, examine those 
reasons...

	Jeff




From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: What still uses the block layer?
Date: Wed, 17 Oct 2007 19:43:14 -0400
Message-ID: <47169E12.2080108@tmr.com>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com> <4713B58B.9050905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:50700 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbXJQXf1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 19:35:27 -0400
In-Reply-To: <4713B58B.9050905@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Jeff Garzik wrote:

>> But again, please remember that these USB devices are really SCSI
>> devices.  Same for SATA devices.  There is a reason they are using the
>> SCSI layer, and it isn't just because the developers felt like it :)
> 
> /somewhat/ true I'm afraid:  libata uses the SCSI layer for ATAPI 
> devices because they are essentially bridges to SCSI devices.  It uses 
> the SCSI layer for ATA devices because the SCSI layer provided a huge 
> amount of infrastructure that would need to have been otherwise 
> duplicated, /then/ massaged into coordinating between <jgarzik's ATA 
> layer> and <SCSI layer> when dealing with ATAPI.
> 
> There is also a detail that was of /huge/ value when introducing a new 
> device class:  distro installers automatically work, if you use SCSI. If 
> you use a new block device type, that behaves differently from other 
> types and is on a different major, you have to poke the distros into 
> action or do it yourself.
> 
> IOW, it was the high Just Works(tm) value of the SCSI layer when it came 
> to ATA (not ATAPI) devices.
> 
> For the future, ATA will eventually be more independent (though the SCSI 
> simulator will be available as an option, for compat), but the value is 
> big enough to put that task on the back-burner.
> 
I remember being told that I didn't understand the problem when I 
suggested using ide-scsi for everything and just hiding the transport. I 
get great pleasure from having been (mostly) right on that one. I still 
have old systems running ZIP drives as scsi...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for
	sysfs	take 2
Date: 07 Sep 2004 11:35:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094571319.1716.108.camel@mulgrave>
References: <413557CB.8010008@cs.wisc.edu>	<20040901162042.GC26753@null.msp.redhat.com>	
	<20040906143251.GB21646@lst.de>	<20040906163336.GE642@parcelfarce.linux.thep
	 lanet.co.uk>	<413CA924.8030904@cs.wisc.edu> <413CB265.3070304@cs.wisc.edu>
	<413CE933.70509@us.ibm.com> <1094512278.1761.63.camel@mulgrave>
	<413D20F9.6000704@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56782 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268196AbUIGPgS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 11:36:18 -0400
In-Reply-To: <413D20F9.6000704@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-09-06 at 22:46, Mike Christie wrote: 
> In that first target patch you sent it had the target dev's bus set to 
> scsi_bus_type. That caused my confusion as to what the bus was for. I 
> see the new patch with this removed. Nevermind.

er, yes, cut and paste error ... 

> We just needed something to track the driver's scsi_hosts. It was also 
> used becuase we used a struct device_driver to hang setup attributes 
> (non iscsi related attrs needed to setup our driver's devices without an 
> ioctl) off of like scsi_debug (this is why I asked about a single 
> virtual bus for both of us to share).

Ah, OK, I see.  So you mean add a bus to the scsi_host->shost_gendev. 
That's certainly feasible.  With clever matching we could get all LLDs
that wanted this functionality to add a dummy driver which they could
then use to traverse their attached hosts.

> Since we followed the suggestion to do a host per transport endpoint 
> when we rmmod the driver we just need some way to loop over every 
> scsi_host and free them up. We had a linked list of scsi_hosts. 
> Christoph suggested a class or bus instead of the linked list, and had 
> preferred the bus. Now you are suggesting to use a class. It wouldn't be 
> ok to go back to the single host would it? In that case we would not 
> need a class, bus, or linked list?

A host is the analogue of a bus.  In iSCSI that's really the other end
point.  Using abstractions incorrectly (like a single host for the
entire iSCSI system) is bound to end up with problems due to the concept
mismatch.

James



From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Tue, 07 Apr 2009 16:50:15 -0700
Message-ID: <1239148215.14988.22.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
	 <1237488880.26341.15.camel@chandra-ubuntu> <49C3DF49.8050408@redhat.com>
	 <1237846429.14853.6.camel@chandra-ubuntu>
	 <1238798590.20924.0.camel@chandra-ubuntu>
	 <20090407232233.GE24591@pentland.suse.de>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:38564 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZDGXuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 19:50:05 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n37Nks72026594
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 17:46:54 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n37No4Pf210182
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 17:50:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n37No3bk029667
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 17:50:04 -0600
In-Reply-To: <20090407232233.GE24591@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

Thanks for your comment, Hannes.

On Wed, 2009-04-08 at 01:22 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> On Fri, Apr 03, 2009 at 03:43:10PM -0700, Chandra Seetharaman wrote:
> > Hi James,
> > 
> > Do you still have any concerns (after Peter's response) ?
> > 
> > If not, Can you accept the patches, please.
> > 
> The problem here is that module autoloading doesn't work for
> device_handler. We have to have the callbacks in place _before_
> driver probing starts as we might need to intercept the I/O
> requests and/or errors. When using modalias the module loading
> will be too late and the hooks will only be established after
> the probing has already happened.
> (The module autoloading is an asynchronous call in device_add(),
> where we don't write for it to succeed. So probing will continue
> and we woulnd't have the callbacks in place when probing 
> starts).

Your analysis is correct.

But, the chicken-n-egg problem you described exists only for the first
device that is probed, module will be in place for the other devices.

The first device race is handled by acting on the bus notification for
the BUS_NOTIFY_BOUND_DRIVER event (patch 3/3 in my patch list).

> 
> So adding the modalias will be of a purely informational value
> which I doubt is worth it.

Not true. I have tested this code, module gets inserted and the devices
come under the module as expected during device probing.

Please test it and let me know if you find it otherwise.
> 
> Cheers,
> 
> Hannes


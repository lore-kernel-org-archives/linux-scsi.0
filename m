From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Tue, 06 Apr 2004 08:10:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4072C876.7030906@pacbell.net>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<108109222		3.2034.8.camel@mulgrave> 	<407050F4.2090607@pacbell.net>	<1081104161.2112.34.camel@mulgrave> 	<4070D891.9040409@pacbell.net> <1081201463.2050.92.camel@mulgrave> 	<4071EA82.3020901@pacbell.net> <1081214360.1756.330.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw4.prodigy.net ([64.164.98.52]:16119 "EHLO mtaw4.prodigy.net")
	by vger.kernel.org with ESMTP id S263861AbUDFPLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 11:11:05 -0400
In-Reply-To: <1081214360.1756.330.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
>  that's intra subsystem synchronisation, not inter subsystem

I'd say that device_driver.remove() calls from the bus management
code to a given device driver are inter-subsystem...


> Look, the rules are very simple:
> 
> - Every subsystem gives out refcounted objects.
> 
> - Every subsystem takes in a disconnection event for another object. 
> ..
> 
> If you follow these rules, there's no *inter* subsystem ordering or
> synchronisation requirement.

Well, either handling the disconnection event from the lower level
subsystem (bus) is such a requirement, or it's not necessary!  I've
got to assume the former, since the Linux kernel doesn't garbage
collect its memory.

Refcounting systems need loop-breaking protocols ("disconnect");
this is needed for that sort of reason, if no other.

- Dave





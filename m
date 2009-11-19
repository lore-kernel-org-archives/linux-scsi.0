From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] libata: add TRIM support
Date: Thu, 19 Nov 2009 09:22:26 -0500
Message-ID: <4B0554A2.9060404@rtr.ca>
References: <20091116154343.GA6672@infradead.org>	<4B02AD86.8010304@rtr.ca>	<20091117143507.GC588@infradead.org>	<20091117145239.768072c9@lxorguk.ukuu.org.uk>	<20091117150012.GA10748@infradead.org>	<4B04BD01.5090706@rtr.ca> <20091119102346.3c656b99@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:47697 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZKSOWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 09:22:21 -0500
In-Reply-To: <20091119102346.3c656b99@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>

Alan Cox wrote:
>> I imagine some sort of port or host flag, that the LLD could set
>> to indicate that it can correctly handle TRIM.  Or not handle TRIM.
>>
>> Tejun is pretty good at these flag things.. I wonder what he might suggest?
> 
> As I said - just error it in your driver qc_issue function. If you are
> feeling really arty you can hook do_identify and mask the bit in the
> ident data as well. See it821x 'smart' RAID mode for both of those in
> pata_it821x.c
..

I don't know.. then we have lots of copies of the code,
rather than a single "ATA library" copy of it.

Isn't the idea of libata to provide helper functions and
central feature flagging, to simplify the chipset drivers?

Either way works, but right now we don't actually know all of the
chipsets that can handle this feature, and all of those that cannot.

Using a simple host_flag to disable it (or enable it, either way),
will make it trivial to patch them out/in as they are discovered.

Cheers

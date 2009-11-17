From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: add TRIM support
Date: Tue, 17 Nov 2009 14:52:39 +0000
Message-ID: <20091117145239.768072c9@lxorguk.ukuu.org.uk>
References: <20091116154343.GA6672@infradead.org>
	<4B02AD86.8010304@rtr.ca>
	<20091117143507.GC588@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60393 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712AbZKQOvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 09:51:05 -0500
In-Reply-To: <20091117143507.GC588@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Mark Lord <liml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>

> > Eg. sata_mv, sata_sil, .. won't work as-is with this command.
> 
> I can certainly add a blacklist, do you have a complete list of
> controllers that should be blacklisted.  Also is there a good reason
> why they are blacklisted or ist just controller bugs?

I'm not convinced that is the right way to handle it. If we start doing
that we'll have this massive unmanagable set of magic flags and twiddles
for every possible host specific corner case.

Far better to keep the issue of the command as Christoph has done and
block the command issue in the afflicted devices qc_issue so that you get
an error back. That keeps the mess in the right places.

Christoph - the problem with some overly bright and IMHO misdesigned
controllers is that they've got magic tables for command lengths in them
to drive their ATA state machines. Those controllers tend to need special
handlers when new commands come along to explain to them in simple terms
what sort of command it is and wipe their backside afterwards.

That belongs in the crappy hardware drivers not in the core code.

Alan

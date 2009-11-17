From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libata: add TRIM support
Date: Tue, 17 Nov 2009 09:35:07 -0500
Message-ID: <20091117143507.GC588@infradead.org>
References: <20091116154343.GA6672@infradead.org> <4B02AD86.8010304@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZKQOfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 09:35:02 -0500
Content-Disposition: inline
In-Reply-To: <4B02AD86.8010304@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>

On Tue, Nov 17, 2009 at 09:04:54AM -0500, Mark Lord wrote:
> Where is the code that sets up the multi-entry trim list
> that this command requires as data?  It's probably there,
> but I don't see it (blind or something).

It's not there, as the SCSI command we're translating only supports a
single range.  We can later also add UNMAP support, but it's a lot more
complicated to translate due to the different data formats.  My plan
for now is to get basic discard support done in all layers and then
later optimize it when all infrastructure is in place.

> And, where is the per-ATA-host flag to enable use of this feature,
> with the default being DISABLED.  Or vice versa, if you want to test
> all the supported controllers first for compatibility.
>
> Eg. sata_mv, sata_sil, .. won't work as-is with this command.

I can certainly add a blacklist, do you have a complete list of
controllers that should be blacklisted.  Also is there a good reason
why they are blacklisted or ist just controller bugs?


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 17:34:20 +0100
Message-ID: <20060610163420.GA23699@infradead.org>
References: <20060610160852.GA15316@havoc.gtf.org> <20060610161036.GA21454@infradead.org> <1149956952.3335.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20355 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751604AbWFJQeW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:34:22 -0400
Content-Disposition: inline
In-Reply-To: <1149956952.3335.22.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

On Sat, Jun 10, 2006 at 11:29:12AM -0500, James Bottomley wrote:
> On Sat, 2006-06-10 at 17:10 +0100, Christoph Hellwig wrote:
> > The driver is not for scsi hardware.  Please implement it as block
> > driver.
> 
> Actually, I'm afraid it is ... look at the mailbox path ... it's one of
> these increasingly prevalent raid HBAs that speaks SCSI at the firmware
> level.  Most commands are direct passthroughs, only INQUIRY and
> MODE_SENSE are actually emulated in the driver.

Oops, you're right.  It emulates READ/WRITE6 at the top of the queuecommand
routine which made me thing it'll emulate more below.

So removing the READ/WRITE6 emulation and setting the flag so the midlayer
only uses READ/WRITE10+ is on top of the TODO list.  Right after that is
using the scsi_kmap_atomic_sg/scsi_kunmap_atomic_sg for the remaining
emulated commands.  More comments later.


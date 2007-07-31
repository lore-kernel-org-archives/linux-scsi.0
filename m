From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi hotplug model
Date: Tue, 31 Jul 2007 15:57:23 +0100
Message-ID: <20070731145723.GA18819@infradead.org>
References: <20070731125510.GN21219@parisc-linux.org> <1185892945.3468.9.camel@localhost.localdomain> <20070731145227.GP21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33211 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXGaO50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 10:57:26 -0400
Content-Disposition: inline
In-Reply-To: <20070731145227.GP21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Tue, Jul 31, 2007 at 08:52:28AM -0600, Matthew Wilcox wrote:
> On Tue, Jul 31, 2007 at 09:42:25AM -0500, James Bottomley wrote:
> > Rather than changing this in every 53c700 based driver, shouldn't it
> > just be added to NCR_700_release()?
> 
> Then I'd have to change the few drivers that weren't leaking scsi_hosts
> ;-)  But I can, if that's what you prefer.

I don't think it's a good idea.  scsi_hhost_put should be the very
last thing in the release method and all the drivers do some kind
of cleanup after detaching from the generic ncr53c00 driver.

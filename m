From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] aic7xxx: Add suspend/resume support
Date: Fri, 19 Oct 2007 14:02:46 +0100
Message-ID: <20071019130246.GA30198@infradead.org>
References: <20071019083222.11DAE18C61E@pentland.suse.de> <20071019084407.GA23211@infradead.org> <4718A497.1010106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50453 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXJSNCs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 09:02:48 -0400
Content-Disposition: inline
In-Reply-To: <4718A497.1010106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Fri, Oct 19, 2007 at 02:35:35PM +0200, Hannes Reinecke wrote:
> Christoph Hellwig wrote:
> > I think this needs a little restructuring. ahd_pci_suspend/ahd_pci_resume
> > should be merged into their callers and use the normal Linux pci accessors,
> > and ahd_suspend/ahd_resume are tiny enough to merged into the caller aswell.
> > 
> Yes, partially. ahc_pci_resume() has to stay there as it uses quite some
> functions from aic7xxx_pci.c. And I'd rather keep the overall structure
> (ie split between linux-specific and generic pci access) for now.
> In the long run it should be restructured as we don't do cross-compilation
> with ***BSD anymore.

Ok..

> Ok. Done.
> Updated patch attached.
> More to your liking?

Much better.  There's still some if ((rc = fo())) left, but it's probably
not worth to delay the patch further because of that.  Just clean it up
in a followon patch.


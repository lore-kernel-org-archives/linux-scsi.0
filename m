From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 18:21:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922182142.A26720@infradead.org>
References: <20030922004943.E32009@one-eyed-alien.net> <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org> <20030922153123.A23388@infradead.org> <20030922161104.A24155@infradead.org> <20030922084930.A679@beaverton.ibm.com> <20030922173732.A25639@infradead.org> <20030922094404.A1056@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:32529 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263248AbTIVRWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 13:22:32 -0400
Content-Disposition: inline
In-Reply-To: <20030922094404.A1056@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Sep 22, 2003 at 09:44:04AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Sep 22, 2003 at 09:44:04AM -0700, Patrick Mansfield wrote:
> The current code allows us to set or clear a given bit, but not both. So
> if we set them in slave_alloc, they can't be cleared without adding
> other flags or code.

If we want drivers to mess with blist flags that's the more general
solution, yes.  But the blist flags really are a target thing and
I'd prefer to keep host drivers a bit away from this.  Of course
this doesn't really work for the usb case where the host driver only
deals with emulated targets that are all completly hosed.

Maybe sdev->scsi_level should recognize a new level, SCSI_TOTALLY_B0RKED
for those usb-storage devices where the vendor somehow heard of the
spec but nothing that isn't excercised by the windows drivers has
the slightest chance of working..

> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

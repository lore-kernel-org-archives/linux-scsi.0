From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 00:50:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615075012.GB179379@sgi.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9D31.6050606@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:20500 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S265349AbUFOHuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 03:50:50 -0400
Content-Disposition: inline
In-Reply-To: <40CE9D31.6050606@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Tue, Jun 15, 2004 at 02:54:41AM -0400, Jeff Garzik wrote:
> 
> This is definitely moving backwards from the direction we want to go.

You really need to look at this in the context of the original thread.


> The entity creating the SCSI command needs to specify data direction, 
> _not_ tables hardcoded into the kernel.  Bart recently removed such a 
> table from IDE.

Yes.  In this case, sg is the entity.  This table causes sg to get
it right much more often than it did.

> These tables are fundamentally broken anyway, due to vendor-reserved 
> commands where the data directions are not specified, but simply "known" 
> by the submittor.

If the reply length is trimmed to the minimum, it will still work as
well as it does today.

> If /dev/sg's userland interface does not permit userland to provide the 
> data direction, then let's just consider it broken and move to Axboe's 
> bsg post-haste.

If you look at Documentation/scsi/scsi-generic.txt and then refer to
the v1 and v2 sg requests, you'll notice that you can't find a way to
specify direction.  Sg tries to figure it out, but often gets it wrong.
Note that in the v3 sg interface, data direction is explicitly
specified (as it should have been originally, imho).


For those new to the thread, the idea is to remove the direction
overrides from various host drivers and centralize them in sg.  If
we remove the direction overrides from the host drivers and do not
add this code to sg, then several apps that use the sg v1 and v2
interfaces will suddenly break.


jeremy

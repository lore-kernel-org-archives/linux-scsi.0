From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Mon, 7 Jul 2014 02:37:46 -0700
Message-ID: <20140707093746.GA12985@infradead.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
 <1404474875-109997-2-git-send-email-hare@suse.de>
 <20140704134437.GA12345@infradead.org>
 <53B6B646.5080301@suse.de>
 <20140705094147.GA18130@infradead.org>
 <53BA524B.7060400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGJhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 05:37:48 -0400
Content-Disposition: inline
In-Reply-To: <53BA524B.7060400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, Jul 07, 2014 at 09:54:51AM +0200, Hannes Reinecke wrote:
> 1) Isolate from any fallout due to the 64bit LUN changes. By introducing
> accessors we are guaranteed that the drivers will only ever see LUN numbers
> they are expecting.

I really don't see the point.  The LUNs have to be passed up from the
driver anyway, so seeing anything unexpect just doesn't make sense.
Furthermore if we really are worried about this we should have asserts
that the higher bytes aren't set, and also take care of the even more
limited LUN size for SCSI-2.

> 2) Using accessors allows us to eventually change the ->lun field to 'struct
> scsi_lun', and call 'scsilun_to_int' only for display purposes. This will
> address the objection by Bart for
> ib_srp, but applies to other drivers as well.

So, for any SAM based drivers struct scsi_lun is the wire format anyway,
so those are easy.  For SCSI-2 and older we can just use scsilun_to_int
and easily get the back the LUN that came over the wire.  Is it worth to
micro optimize by not looking at the other fields?  I'd say no, but even
if it is I'd rather see this as part of the series moving to embedding
the scsi_lun.

FYI, I've merged your first set of fixes for the printk specifiers, but
I've not merged anything fixing the other warnings that the build but
sent reports for for now.


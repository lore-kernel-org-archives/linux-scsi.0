From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Transport Attributes Export API
Date: Fri, 2 Jan 2004 21:18:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040102211848.A1894@infradead.org>
References: <20031231190849.GE3066@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:27922 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265644AbUABVSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2004 16:18:50 -0500
Content-Disposition: inline
In-Reply-To: <20031231190849.GE3066@localhost>; from mort@wildopensource.com on Wed, Dec 31, 2003 at 02:08:49PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 31, 2003 at 02:08:49PM -0500, Martin Hicks wrote:
> 
> Hello,
> 
> I've run into a situation where I need to export driver-hidden
> information to sysfs.  This information is specific to a transport
> (e.g., Parallel SCSI or Fiber Channel) and, in general, the kernel
> doesn't use this information so it is not available outside the HBA
> driver.
> 
> Attached is a patch that attempts to provide a means to export this
> information to sysfs.  It introduces a new class for the scsi_device's
> transport and provides facilities to export class_device_attributes.
> 
> A few suggestions that James Bottomley has already given are below, but
> I thought that it was time that others saw this and could give their
> suggestions too.  Thanks.

You could get rid of most code in the drivers by placing a pointer
to the transport attributes and the desired transport class into
the host template and letting the common code do all setup for you.

That's also consistant to how we handle all the other attributes.

> - Separate the transports out into two separate .c files

probably a good idea.

> (so they can be loaded as modules).

for the sysfs code alone that's total overkill.

> This also plays in to future work I'm thinking
> about: make the error handler more transport specific.

Yupp, that's a good idea, but not really much related to this patch.

> - Then, the class register/unregister can be done in the
> module_init/exit routines
> - Probably move all the show/store routines in .h files so they can be
> used equally for fc and parallel
> - This switch on ttype (and the enum transport_type) in

> scsi_add_transport_attributes is not scaleable.  I think a better
> solution might be to have a struct scsi_transport which has the class
> device and a pointer to the overridden attribute.  Then, this is the
> thing pointed to in the scsi host structure (and it can contain the
> attributes, the class and a pointer to the default attributes, so most
> of the trying to find the defaults code goes away).

Or no extra structure and put the two pointers directly in the host
template as I suggested above.  Yes, that means drivers that support
multiple transports need a template for each of them, but that's not
a big overhead anyway.


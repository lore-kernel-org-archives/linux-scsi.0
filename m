From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 6 Jun 2003 07:36:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606073603.A13259@infradead.org>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:28423 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265335AbTFFGWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 02:22:34 -0400
Content-Disposition: inline
In-Reply-To: <1054754103.2360.8.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Jun 04, 2003 at 03:14:56PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Wed, Jun 04, 2003 at 03:14:56PM -0400, James Bottomley wrote:
> Yes, that's why I think forbidding *all* I/O after offlining is too much
> effort.  Offlining should be a precursor to device destruction, but
> actual destruction probably relys on detaching the queue from the block
> device interface and sitting on it until all use counts drop to zero.

We need a way to disable _all_ I/O to a device due to the way the driver
model works.  The driver model ->remove always is a surprise removal,
so the underlying PCI (or whatever) device for a scsi host can go away
anytime.  Because of that we need to make damn sure no call to
->queuecommand will happen after scsi_remove_host is called.  Whether
this is implemented with the same mechanisms as the current sdev->online
is another question.


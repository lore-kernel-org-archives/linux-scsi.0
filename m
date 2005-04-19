From: Christoph Hellwig <hch@infradead.org>
Subject: Re: streamlining the sym2 io submission path
Date: Wed, 20 Apr 2005 00:48:22 +0100
Message-ID: <20050419234822.GA22940@infradead.org>
References: <20050419234323.GA31352@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31113 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261217AbVDSXsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 19:48:22 -0400
Content-Disposition: inline
In-Reply-To: <20050419234323.GA31352@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2005 at 12:43:23AM +0100, Matthew Wilcox wrote:
> We fail the first command to the device if the device is marked as
> NOSCAN or the lun is non-0 and the device isn't marked as SCAN LUNS.
> I think the first part should be moved to slave_alloc(); it's a little
> weird, but supportable.  The second part troubles me a little -- is the
> blacklist in the midlayer good enough to handle this, or should I leave
> this mechanism in?

For the first make sure to return -ENXIO from ->slave_alloc, the scsi_scan
code special-cases that one and doesn't print an error.  For the second
I don't care too much.  The midlayer blacklist and if nessecary the
runtime updates to it will handle such devices just fine, but following
them nvram might not be a bad idea either.

> The driver currently fails commands sent to the lun of the host adapter.
> Is this the correct behaviour?  What should the driver do?

The driver will never receice a command for the host adapter (unless it
allocates a scsi_device for the host adapter itself, as e.g. gdth does)


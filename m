From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Mon, 19 May 2003 14:38:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030519143828.A7204@beaverton.ibm.com>
References: <20030516182039.A7369@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:437 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262955AbTESV3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 17:29:33 -0400
Content-Disposition: inline
In-Reply-To: <20030516182039.A7369@lst.de>; from hch@lst.de on Fri, May 16, 2003 at 06:20:39PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, May 16, 2003 at 06:20:39PM +0200, Christoph Hellwig wrote:
> Upper drivers now use the LDM ->probe/->remove callbacks and the
> core list code.  Note that this means there is only one driver per
> scsi device and not multiple, e.g. you can't have sd _and_ sg for
> the same device.  Personally I think that's not a problem anymore
> with the generic SG_IO in place, but if you scream loud enough I
> could come up with a hack that makes the sg nodes a property of the
> scsi midlayer instead of a LDM-style driver and we could get the
> old behaviour back.

The sg attributes (calls to device_create_file) should be removed (at
least until sg has its own class or place to put the attributes), since
sg_probe creates a "type" attribute, then when we return back into
scsi_device_register and try to create the scsi_device "type" attribute,
we fail and call scsi_device_unregister.

And scsi_scan.c ignores the failure, probably leading to some strangeness
or at best a memory leak.

The end result is that there is no scsi_device under sysfs if sg_probe
attached to the scsi_device.

-- Patrick Mansfield

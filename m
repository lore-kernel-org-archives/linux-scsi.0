From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Fri, 16 May 2003 16:57:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516235718.GA3260@beaverton.ibm.com>
References: <20030516182039.A7369@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:43195 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264623AbTEPXmG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 19:42:06 -0400
Content-Disposition: inline
In-Reply-To: <20030516182039.A7369@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> Upper drivers now use the LDM ->probe/->remove callbacks and the
> core list code.  Note that this means there is only one driver per
> scsi device and not multiple, e.g. you can't have sd _and_ sg for
> the same device.  Personally I think that's not a problem anymore
> with the generic SG_IO in place, but if you scream loud enough I
> could come up with a hack that makes the sg nodes a property of the
> scsi midlayer instead of a LDM-style driver and we could get the
> old behaviour back.
> 
> 

I ran your patch and I dead locked on st_probe. This is due to the code
in st_probe and osst_probe that do device registers on the
sdev_driverfs_dev.bus which is the bus that the probe is being called
from already. I had an old patch that removed these before due the driver
model requirement that objects on the device list must be of one type.
At the time I did not have a place to move these attributes.

We now have /bus/scsi/drivers/{uld} for driver attributes. We also could
create a class for other attributes if needed. We can also use udev for
the creation of special nodes.

ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/

In the short term is the st and osst maintainers are ok with it we could
remove them and then create them in there proper home.

-andmike
--
Michael Anderson
andmike@us.ibm.com


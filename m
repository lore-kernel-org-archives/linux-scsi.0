From: "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Tue, 23 Dec 2014 23:48:40 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1412232342040.4626@tosh-p75a>
References: <alpine.DEB.2.10.1412211420560.4323@tosh-p75a> <20141223083140.GB2303@lst.de>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from l2mail1.panix.com ([166.84.1.75]:59448 "EHLO l2mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaLXIG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Dec 2014 03:06:27 -0500
In-Reply-To: <20141223083140.GB2303@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


On Sun, Dec 21, 2014 at 02:44:20PM -0800, Kenneth R. Crudup wrote:

> > I had issues with my Samsung 4GB disk recently in Linus' master tree kernels,
> > and have bisected it to the above commit. When doing running bonnie++ (etc.
> > I get EIOs.

> > Is there a "quirks" available for this option so I may special-case this
> > particular disk?

On Tue, 23 Dec 2014, Christoph Hellwig wrote:

> Looks like we need to quirk it.  Can you try to echo different limits
> to the /sys/block/sdc/queue/max_hw_sectors_kb  file for the device to
> find the limit for it?

Looks like it's 32767; making it an even 32K sectors starts the EIOs again.

To recap for the various lists:

  Vendor: Samsung  Model: D3 Station       Rev: 0202
  Type:   Direct-Access                    ANSI  SCSI revision: 06

It's the 4TB model:

/sys/block/sdc/size:7814037160
/sys/block/sdc/queue/max_hw_sectors_kb:61440

Works OK if I echo 32767 > /sys/block/sdc/queue/max_sectors_kb

Has anyone seen a disk out there that's got a (properly-supported)
"max_hw_sectors_kb" >= 32K? If not, maybe we should clamp that value to
prevent other misreporting(?) disks?

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Silicon Valley

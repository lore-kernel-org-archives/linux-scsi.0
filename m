From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sd: always scan VPD pages if thin provisioning is
        enabled
Date: Wed, 25 Jan 2017 11:23:29 +0100
Message-ID: <20170125102329.GA17657@lst.de>
References: <1485329165-64825-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36612 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdAYKXb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 05:23:31 -0500
Content-Disposition: inline
In-Reply-To: <1485329165-64825-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jan 25, 2017 at 08:26:05AM +0100, Hannes Reinecke wrote:
> For any device with an older SCSI revision we might not
> be scanning VPD pages, which results in a wrongly configured
> discard mode if thin provisioned is enabled.
> According to sbc3 any thin provisioned device (ie devices which
> have the LBPME bit set in the output of READ CAPACITY(16)) need
> to support VPD pages. So this patch always enables VPD pages
> even for older SCSI revisions if thin provisioning is enabled.

Can you explain what you need this for?  A device with a per-SBC3
revision that wants us to use UNMAP?

> +		/*
> +		 * sbc3r36 states:
> +		 * The device server in a logical unit the supports
> +		 * logical block provisioning management shall support
> +		 * the Logical Block Provisioning VPD page.
> +		 * So VPD pages should be supported if lbpme is set.
> +		 */

It's a bit odd to quote SBC3 when the device clearly is pre-SBC3
to need this workaround..

> +		if (!scsi_device_supports_vpd(sdp))
> +			sdp->try_vpd_pages = 1;

Do the assignment unconditionally?

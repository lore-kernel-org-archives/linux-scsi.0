From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: add check_capacity flag and sd_read_last_sector()
Date: Wed, 22 Apr 2009 08:51:17 -0600
Message-ID: <20090422145116.GH1926@parisc-linux.org>
References: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33421 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZDVOvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 10:51:18 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Wed, Apr 22, 2009 at 10:42:36AM -0400, Alan Stern wrote:
> +	/* If the capacity is unknown, we can't test anything */
> +	if (sdkp->capacity <= 0)
> +		return rc;

sector_t is unsigned, so this should be just == 0.

> +	/* One test should be enough (unless it's inconclusive) */
> +	sdp->check_capacity = 0;
> +
> +	/* If the device doesn't use READ(10), assume we're okay */
> +	if (!sdp->use_10_for_rw)
> +		return rc;
> +
> +	/* If the capacity is too big for READ(10), assume we're okay */
> +	if (sdkp->capacity > 0xffffffff)
> +		return rc;

Won't gcc warn about this when sector_t is 32 bits?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

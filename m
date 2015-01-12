From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 0/4] scsi: ufs & ums-* & esp_scsi: fix module
	reference counting
Date: Mon, 12 Jan 2015 10:36:10 +0100
Message-ID: <20150112093610.GA25942@lst.de>
References: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40526 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbbALJgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2015 04:36:15 -0500
Content-Disposition: inline
In-Reply-To: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Sun, Jan 11, 2015 at 10:50:02PM +0900, Akinobu Mita wrote:
> While accessing a scsi_device, the use count of the underlying LLDD module
> is incremented.  The module reference is retrieved through .module field of
> struct scsi_host_template.
> 
> This mapping between scsi_device and underlying LLDD module works well
> except ufs, unusual usb storage drivers, and sub drivers for esp_scsi.
> These drivers consist with core driver and actual LLDDs, and
> scsi_host_template is defined in the core driver.  So the actual LLDDs can
> be unloaded even if the scsi_device is being accessed.
> 
> This patch series first adds ability to adjust module reference for
> scsi host by LLDDs and then fixes actual LLDDs by adjusting module
> reference after scsi host allocation.

Why don't we move the module into the Scsi_Host only, and use
the same macro that passes THIS_MODULE trick you are using in
the sub drivers?  That seems to be a fairly common scheme in other
subsystems as well.

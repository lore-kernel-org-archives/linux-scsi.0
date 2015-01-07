From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/3] scsi: ufs & ums-*: fix module reference counting
Date: Wed, 7 Jan 2015 15:28:30 +0100
Message-ID: <20150107142830.GA659@lst.de>
References: <1420639382-2219-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59742 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbbAGO2f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2015 09:28:35 -0500
Content-Disposition: inline
In-Reply-To: <1420639382-2219-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Wed, Jan 07, 2015 at 11:02:59PM +0900, Akinobu Mita wrote:
> While accessing a scsi_device, the use count of the underlying LLDD module
> is incremented.  The module reference is retrieved through .module field of
> struct scsi_host_template.
> 
> This mapping between scsi_device and underlying LLDD module works well
> except some scsi drivers (ufs and unusual usb storage drivers).  These
> drivers consist with core driver and actual LLDDs, and scsi_host_template
> is defined in the core driver.  So the actual LLDDs can be unloaded even if
> the scsi_device is being accessed.

Why don't ufs and usb-storage define the host templates in the sub drivers?
That's what libata or the mpt fusion driver do.

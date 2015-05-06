From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: storage: fix module reference for scsi host
Date: Wed, 6 May 2015 10:55:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505061054590.1094-100000@iolanthe.rowland.org>
References: <1430904261-5049-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750965AbbEFOzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 10:55:36 -0400
In-Reply-To: <1430904261-5049-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Wed, 6 May 2015, Akinobu Mita wrote:

> While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
> the module reference count is not incremented.  Because these drivers
> allocate scsi hosts with usb_stor_host_template defined in usb-storage
> module.  So these drivers always can be unloaded.
> 
> This fixes it by preparing scsi host template which is initialized
> at module_init() for each ums-* driver.  In order to minimize the
> difference in ums-* drivers, introduce module_usb_stor_driver() helper
> macro which is same as module_usb_driver() except that it also
> initializes scsi host template.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

This looks very good.

Acked-by: Alan Stern <stern@rowland.harvard.edu>


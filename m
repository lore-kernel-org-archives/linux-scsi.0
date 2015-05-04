From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module
 reference counting
Date: Mon, 04 May 2015 08:15:23 -0700
Message-ID: <1430752523.2177.15.camel@HansenPartnership.com>
References: <1430750769-11405-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34167 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbbEDPPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2015 11:15:25 -0400
In-Reply-To: <1430750769-11405-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, 2015-05-04 at 23:46 +0900, Akinobu Mita wrote:
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

This series is still missing an ack from ufs.  However, as we're on
series 6, final warning: object now or I'll take it without ufs ack.

However, it does also strike me that these three drivers have problems
because they're using the wrong initialisation pattern: the template is
supposed to be in the bus connector for compound drivers not in the
core.  To see how the pattern is supposed to work look at the 53c700
series of drivers.  They have a tiny template in the bus connector part
and then the function NCR_700_detect() fills in the rest.

53c700 is possibly not the best example because it fills in the template
for every host rather than once at module init time, but you get the
idea.  how difficult would it be to convert these things to use the
correct pattern rather than hacking it in the mid layer?

James



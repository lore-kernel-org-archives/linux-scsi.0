From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module
 reference counting
Date: Mon, 04 May 2015 14:41:04 -0700
Message-ID: <1430775664.2177.36.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1505041607350.1450-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35577 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbbEDVlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2015 17:41:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.1505041607350.1450-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, 2015-05-04 at 16:09 -0400, Alan Stern wrote:
> On Mon, 4 May 2015, James Bottomley wrote:
> 
> > However, it does also strike me that these three drivers have problems
> > because they're using the wrong initialisation pattern: the template is
> > supposed to be in the bus connector for compound drivers not in the
> > core.
> 
> Why is it supposed to be done that way?  Isn't that less efficient?  It 
> means you have to have a separate copy of the template for each bus 
> connector driver, instead of letting them all share a common template 
> in the core.

Well, no it doesn't.  The way 53c700 implements it is that there is a
common template in the core.  The drivers just initialise their variant
fields (for 53c700 it's name, proc_name and this_id) and the core fills
in the rest.  Admittedly wd33c93 doesn't quite get this right, that's
why I cited 53c700.

James




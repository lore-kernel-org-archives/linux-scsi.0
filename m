From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module reference
 counting
Date: Tue, 5 May 2015 15:14:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505051432090.1639-100000@iolanthe.rowland.org>
References: <1430849124.2173.40.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51977 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753295AbbEETOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 15:14:37 -0400
In-Reply-To: <1430849124.2173.40.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, 5 May 2015, James Bottomley wrote:

> > The cost is duplication of the .owner field in every Scsi_Host.  The 
> > savings is a reduction in the number of scsi_host_templates.
> 
> So your essential objection is the host template duplication?  I know
> it's a couple of hundred bytes, but surely its dwarfed by all the other
> stuff you have to duplicate ... the module size of each of these is
> around 0.25MB, so a couple of hundred bytes would seem a bit
> insignificant.

Agreed, the size is relatively insignificant.  I drop any objection on
that account.  (But turning things around, what's wrong with
duplicating the .owner field in the Scsi_Host structure when we're
already duplicating this_id, can_queue, sg_tablesize, and a large bunch
of others?)

On the other hand, your code to populate the template copies is a mess.  
I like Akinobu's approach much better, although I would change a few
details:

	Declare usb_stor_host_template as "const", and define a new, 
	separate usb_stor_template in usb.c for actual use.

	In usb_stor_host_template_init(), do a plain structure
	assignment rather than memcpy.

Alan Stern


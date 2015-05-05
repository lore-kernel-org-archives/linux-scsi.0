From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module
 reference counting
Date: Tue, 05 May 2015 14:42:28 -0700
Message-ID: <1430862148.2173.73.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1505051432090.1639-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40461 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423623AbbEEVma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 17:42:30 -0400
In-Reply-To: <Pine.LNX.4.44L0.1505051432090.1639-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Tue, 2015-05-05 at 15:14 -0400, Alan Stern wrote:
> On Tue, 5 May 2015, James Bottomley wrote:
> 
> > > The cost is duplication of the .owner field in every Scsi_Host.  The 
> > > savings is a reduction in the number of scsi_host_templates.
> > 
> > So your essential objection is the host template duplication?  I know
> > it's a couple of hundred bytes, but surely its dwarfed by all the other
> > stuff you have to duplicate ... the module size of each of these is
> > around 0.25MB, so a couple of hundred bytes would seem a bit
> > insignificant.
> 
> Agreed, the size is relatively insignificant.  I drop any objection on
> that account.  (But turning things around, what's wrong with
> duplicating the .owner field in the Scsi_Host structure when we're
> already duplicating this_id, can_queue, sg_tablesize, and a large bunch
> of others?)

It's really only the pattern wrongness.  However, as Rusty says (at
length) the best APIs are those that you can't get wrong and having the
owner in the template gives that (it's a Level 10 interface).
Duplicating the owner in the host gets us to the point where following
convention you get it right but nothing prevents abuse (it's a Level 4
interface).  I mean, it could be worse (his scale goes down to -10) but
I'd rather not move down if we don't have to.

> On the other hand, your code to populate the template copies is a mess.  
> I like Akinobu's approach much better

Unfortunately with that approach, values in the host template can't be
overridden.

> , although I would change a few
> details:
> 
> 	Declare usb_stor_host_template as "const", and define a new, 
> 	separate usb_stor_template in usb.c for actual use.
> 
> 	In usb_stor_host_template_init(), do a plain structure
> 	assignment rather than memcpy.

OK, so I'm happy with that: it solves the "can't be overridden" problem
if you mean a driver should 

declare a local template

call usb_stor_host_template_init() on the local template

override whatever they want (or nothing)

call usb_stor_probe1 with the new template.

I also note that you can

#define usb_stor_host_template_init(t, n) __usb_stor_host_template_init((t), (n), THIS_MODULE)

And make it just work for normal usage.

James



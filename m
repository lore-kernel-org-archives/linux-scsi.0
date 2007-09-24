From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 21:16:29 +0200
Message-ID: <200709242116.29635.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709241257070.5501-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:60770 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754879AbXIXTPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 15:15:42 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709241257070.5501-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Montag 24 September 2007 schrieb Alan Stern:
> On Mon, 24 Sep 2007, Oliver Neukum wrote:

> > But we don't bother when suspending the whole system. So why not simply
> > walk the subtrees under a USB device? Let the subsystem choose what
> > depth of sleep to use.
> 
> Because by doing so you are effectively telling the drivers in the
> subtree that the entire system is going to be suspended, which isn't

Unfortunately, that is correct.

> correct.  It may also turn out that the user wants to keep the
> subsystem active, even though the USB driver isn't aware of it.  Last
> but not least, the subsystem will need to have some form of autoresume.  

Not necessarily.
 
> The way it should work is for the lower subsystem to tell the USB
> driver when suspending is okay, not the other way around.  When the

Absolutely.

> subsystem implements its own form of runtime PM support, then you'll be
> able to use it properly.  But until then, there isn't anything much you
> can do.

Well, we can't simply cut power. Buffers must be flushed and the disk
spun down. The suspend() method of the storage driver will have to become
complex.
 
	Regards
		Oliver

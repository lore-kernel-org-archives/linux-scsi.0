From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Mon, 5 Apr 2004 15:30:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404051530.48743.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0404041216040.14668-100000@netrider.rowland.org> <1081098273.2112.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:18635 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S262439AbUDENbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2004 09:31:00 -0400
In-Reply-To: <1081098273.2112.18.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


> > 	Open process:			Disconnect process:
> >
> > 	Get minor number from inode
> > 	Lookup USB interface using
> > 	  minor number
> > 	Get device pointer from the
> > 	  interface's private data
> > 	  and check it's not NULL
>
> This is what's wrong.  Here you should get a reference to the device
> pointer (that's what scsi_device_get() actually does for us).  If the
> ref getting routine comes back with an error, you may not proceed.  If
> it comes back with a device, you own a reference to it and may go on
> (even if the device is now gone, the structure will behave correctly).

You are correct, if and only if the code doing the lookup and getting
the reference is atomic with respect to freeing the data structure.
Which lock is supposed to assure that?

	Regards
		Oliver


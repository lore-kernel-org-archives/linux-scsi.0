From: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Subject: Re: What is SCSI command 0xa0 ?
Date: Mon, 14 Feb 2005 23:06:45 +0100
Message-ID: <20050214230645.22eb3b3c@hebus>
References: <200502142112.j1ELC3bY032759@falcon30.maxeymade.com>
	<Pine.LNX.4.44L0.0502141623440.1843-100000@ida.rowland.org>
Reply-To: samuel.colin3@wanadoo.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from smtp4.wanadoo.fr ([193.252.22.27]:47450 "EHLO smtp4.wanadoo.fr")
	by vger.kernel.org with ESMTP id S261576AbVBNWGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 17:06:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502141623440.1843-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

The Mon, 14 Feb 2005 16:34:39 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> kernel:   Vendor: WDC WD25  Model: 00JB-00FUA0       Rev: 15.0
> kernel:   Type:   Direct-Access                      ANSI SCSI revision:
> 04
> 
> Since it claims to be SCSI revision 04, the command was sent.  But your 
> drive couldn't handle it and choked.
> 
> It's possible to prevent the SCSI driver from sending the REPORT_LUNS 
> command to your drive.  You can try this out by typing (as root):
> 
> 	echo 'WDC WD25:00JB-00FUA0:0x01' >/proc/scsi/device_info
> 
> before plugging in the drive.  If that solves the problem, it can be added
> permanently into the SCSI driver source code.
> 
OK, I just made the following tests :
- Plugged the disk and booted the openbrick
- Did the echo above
- Modprobed ehci-hcd and usb-storage
- Mounted the disk
- Made the copy of an iso image from /home (who is nfs mounted) to
/mnt/lacie1...

Absolutely no error, no odd display on the command line. Thus I guess we can
say the problem is solved so far.

You guys are wizards, you save my (geeky :-) life. I would hug you if I
could ! Also, realize that these openbricks can't have an IDE disk, and are
sometimes sold with lacie disks, so that might help other people.
What puzzles me is that a 2.6.8 kernel didn't exhibit this behaviour for the
same disk on another machine (and thus another usb2 chipset, but as that
wasn't the cause of the problem...)

In conclusion, I think that the patches from usb-devel I had applied solved
usb2 problems that had really happened (but now are solved), but some code
change introduced scsi errors (hence the working 2.6.8 kernel I tell about
above)... I don't really know, after all you're the experts.

USB devel and SCSI dev lists in Cc:

Many thanks,
Samuel Colin


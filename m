From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Sun, 20 Feb 2005 22:44:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502202236350.9805-100000@netrider.rowland.org>
References: <20050220195927.398c57e4.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from netrider.rowland.org ([192.131.102.5]:60936 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261752AbVBUDoW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 22:44:22 -0500
In-Reply-To: <20050220195927.398c57e4.vsu@altlinux.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Sergey Vlasov <vsu@altlinux.ru>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Sun, 20 Feb 2005, Sergey Vlasov wrote:

> On Thu, 17 Feb 2005 17:31:04 -0500 (EST) Alan Stern wrote:
> 
> > James:
> > 
> > This patch adds a NOREPORTLUN blacklist flag for a disk made by "WDC" 
> > (Winchester?).  The drive's firmware crashes when it receives
> > REPORT_LUNS,  even though it claims to be SCSI rev 04.
> > 
> > Alan Stern
> > 
> > 
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > ===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
> > --- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
> > +++ edited/drivers/scsi/scsi_devinfo.c	2005-02-16 11:30:56 -05:00
> > @@ -201,6 +201,7 @@
> >  	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
> >  	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
> >  	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
> > +	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
> 
> This does not look like a right solution.  WD2500JB is an IDE disk made
> by Western Digital:
> 
> http://www.wdc.com/en/products/Products.asp?DriveID=42
> 
> Therefore the problematic LaCie device is really an USB/Firewire-to-IDE
> adapter with the WD2500JB drive in a box.  And it is the USB-IDE part
> which fails on the REPORT_LUNS command, not the IDE disk.  Probably
> there are other LaCie devices with the same adapter but different disks
> inside; adding all such IDE disks to the SCSI blacklist does not seem
> like a good solution.  The usb-storage blacklist seems like a better
> place for such entry.

You are quite correct.  In fact, another user with a different brand of 
USB-IDE converter just wrote in with exactly the same problem.

James, please withdraw the patch above.

Matt, it looks like the best way to solve this problem is to go back to
the old strategy of always setting the SCSI revision to 2 (no matter what
it might actually be), at least for Direct Access devices.  That would
suppress the REPORT_LUNS command.  Would we lose anything by doing this?

Alan Stern


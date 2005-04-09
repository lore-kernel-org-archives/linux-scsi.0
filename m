From: Peter Missel <peter.missel@onlinehome.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sat, 9 Apr 2005 23:44:40 +0200
Message-ID: <200504092344.41310.peter.missel@onlinehome.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <200504090057.22687.peter.missel@onlinehome.de> <20050409140218.GC8669@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.176]:62161 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S261388AbVDIVpJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Apr 2005 17:45:09 -0400
In-Reply-To: <20050409140218.GC8669@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Hi Matthew!

I see ... so there is an alternate method for the kernel to find its system 
volume by not using the dynamically built /dev/sdX names? I'll dig into that, 
thanks for the pointer!

Back to the original topic ... do you have any news with regard to putting the 
code back into the sym8xx driver that reads the user configured 
channel/device negotiation settings (transfer speed and width limits, 
timeouts, disconnect, etc. etc.) from the EEPROM? This is really causing 
headaches here with those setups that use external devices, slightly buggy 
devices, long cables and similar stuff where the auto-detected defaults 
aren't working.

Many thanks!

regards,
Peter

On Saturday 09 April 2005 16:02, Matthew Wilcox wrote:
> On Sat, Apr 09, 2005 at 12:57:22AM +0200, Peter Missel wrote:
> > It also makes the driver ignore the adapter ordering in multiple-channel
> > setups. This machine here has an LSI 21002, where the LVD channel is on
> > device function 1 and the UW channel is on 0. Naturally the user will set
> > the adapter order in BIOS such that the system HDD (on the LVD channel)
> > becomes /dev/sda regardless of other drives on the UW channel. Now, with
> > the latest driver releases ignoring this BIOS adjustment, the channels
> > are scanned in order of appearance on the PCI bus rather than in the
> > order the user wants ... in this case, the LVD channel ends up becoming
> > sym1, which means that whenever I connect my external MO drive to the
> > U/UW channel, I get a kernel panic because Linux can't find its system
> > volume.
>
> This is an inevitable consequence of conversion to the pci_driver model.
> So it's a choice: either support this or support hotplug.  I chose to
> support hotplug.  This isn't a problem specific to sym2, it's something
> that all scsi systems face.  The intended way to solve this is to use
> a UUID or label to mount your root fs.  Unfortunately, this means you
> have to use an initrd.
>
> Yes, this sucks and isn't nearly as easy to configure as it needs to be.
> But there really is no way around it -- I can't control what order the
> devices are discovered in.

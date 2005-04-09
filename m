From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sat, 9 Apr 2005 15:02:18 +0100
Message-ID: <20050409140218.GC8669@parcelfarce.linux.theplanet.co.uk>
References: <200412311343.42484.peter.missel@onlinehome.de> <20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk> <200502262034.09406.peter.missel@onlinehome.de> <200504090057.22687.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10196 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261344AbVDIOCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Apr 2005 10:02:20 -0400
Content-Disposition: inline
In-Reply-To: <200504090057.22687.peter.missel@onlinehome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Missel <peter.missel@onlinehome.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Sat, Apr 09, 2005 at 12:57:22AM +0200, Peter Missel wrote:
> It also makes the driver ignore the adapter ordering in multiple-channel 
> setups. This machine here has an LSI 21002, where the LVD channel is on 
> device function 1 and the UW channel is on 0. Naturally the user will set the 
> adapter order in BIOS such that the system HDD (on the LVD channel) 
> becomes /dev/sda regardless of other drives on the UW channel. Now, with the 
> latest driver releases ignoring this BIOS adjustment, the channels are 
> scanned in order of appearance on the PCI bus rather than in the order the 
> user wants ... in this case, the LVD channel ends up becoming sym1, which 
> means that whenever I connect my external MO drive to the U/UW channel, I get 
> a kernel panic because Linux can't find its system volume. 

This is an inevitable consequence of conversion to the pci_driver model.
So it's a choice: either support this or support hotplug.  I chose to
support hotplug.  This isn't a problem specific to sym2, it's something
that all scsi systems face.  The intended way to solve this is to use
a UUID or label to mount your root fs.  Unfortunately, this means you
have to use an initrd.

Yes, this sucks and isn't nearly as easy to configure as it needs to be.
But there really is no way around it -- I can't control what order the
devices are discovered in.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

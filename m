From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 17:54:03 +0000
Message-ID: <20041130175403.GZ29035@parcelfarce.linux.theplanet.co.uk>
References: <1101835224.1779.1040.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11440 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262220AbUK3RyJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 12:54:09 -0500
Content-Disposition: inline
In-Reply-To: <1101835224.1779.1040.camel@rebel.corp.whenu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Richard F. Rebel" <rrebel@whenu.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 30, 2004 at 12:20:24PM -0500, Richard F. Rebel wrote:
> Well, the difference is that the fiber channel card seems to boot first,
> and thus reorders the scsi bus.  If I attach the fiber channel cables to
> the switch (making all of our storage visible) and re-probe the scsi bus
> by hand using the /dev interface, access to the SAN is fine etc.  Upon
> reboot with the fc connected, my system panics because now the root
> drive is no longer where it thinks it should be (sda is now a device on
> the fiber channel switch fabric).
> 
> Is there a way to control this process or to mitigate the problem?  I
> really need the system to boot properly off of local disk whether or not
> the fc is connected or the devices available.

The fusion driver uses the pci_driver model, so cards are discovered in
PCI bus order.  If you put the existing cards at lower PCI device IDs,
they'll be discovered first.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi "target1:0:0"
Date: Tue, 16 Nov 2004 17:10:18 +0000
Message-ID: <20041116171018.GK26623@parcelfarce.linux.theplanet.co.uk>
References: <1100622096.8606.104.camel@localhost.localdomain> <1100622800.2574.41.camel@mulgrave> <1100624154.8606.122.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41129 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262057AbUKPRKZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 12:10:25 -0500
Content-Disposition: inline
In-Reply-To: <1100624154.8606.122.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <jejb@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Nov 16, 2004 at 05:55:53PM +0100, Kay Sievers wrote:
> We sit there with the hald daemon and listen to sysfs add/remove events.
> We need an event for every /sys/devices/ devices to get a unbroken chain
> of devices we can sort together until we reach a root device. This is
> how _all_ devices in sysfs are working and scsi was before the change.

On *your* machine, maybe.  On a parisc machine, you get a PCI root device
with no bus type in the middle of a tree, like this:

/sys/devices/parisc/10/10:4/pci0000:02/0000:02:01.0/0000:03:07.0

here, parisc and pci0000:02 have no bus type.  10 and 10:4 are of type
"parisc" and 0000:02:01.0 and 0000:03:07.0 are "pci".

> device chain '/sys/devices/pci0000:00/0000:00:1d.1':
>     BUS="pci"
>     ID="0000:00:1d.1"
> 
> device chain '/sys/devices/pci0000:00':
>     BUS=""
>     ID="pci0000:00"
>     SYSFS{detach_state}="0"

There you go, it's just another example of this one.  It's just faulty
assumptions in hald by the looks of things.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

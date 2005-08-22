From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 22 Aug 2005 13:05:54 -0400
Message-ID: <430A05F2.10009@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:54751 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1750830AbVHVUOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 16:14:33 -0400
Received: from magic.adaptec.com (magic.adaptec.com [216.52.22.17])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7MH6Ccc007654
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 10:06:13 -0700
In-Reply-To: <20050822045502.GA7147@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/22/05 00:55, Matt Domsch wrote:
> On Sat, Aug 20, 2005 at 12:15:41AM -0400, James.Smart@Emulex.Com wrote:
> 
>>- There are some real challenges in supporting a udev-named boot
>>  device. For the most part, it's a distro issue, which is becoming
>>  better. PS: for $10, name a 2.6 distro that uses udev out
>>  of the box for disk names and its installation. For $10 more, 
>>  can it install/boot from one?
> 
> 
> I won't get your $10, but RHEL4 has a mechanism to specify "install
> onto BIOS disk N", where N is typically 80h (it's an int13 number,
> what BIOS typically boots from).  EDD in anaconda handles the mapping
> of BIOS disk number to /dev/whatever.

Hi Matt!  How is it going?

I wonder, do you think it would advantageous to provide
another label to a disk device which includes this mapping?

(This is in lieu to the "myriad of labels" notion I've been
talking about recently, where vendors (BIOS, Dell, disk manufacturer,
transport layer, etc, etc, etc.) provide yet another label.  This label
is tacked to the LU (most commonly a disk, it is *not* an FS label.))

This way, user space, or whoever, can look up the LU (disk device)
by a label, that label or whichever one.

> And a few folks at Dell are
> working on a udev helper to let udev know this mapping too, and
> incorporating the same capability into SLES in the future.
> 
> After install, file system labels have been working great for years.
> root=LABEL=/  syntax for example, and you can get as complex as you
> like with that label.

Yes, that's cool.

How about specifying the LU label _and_ the FS label to "root="?

root=[<disk label>:]<fs label>

<disc label> :=
	WWN,
	HCIL,
	Funky name 1,
	Funky name 2.

<fs label> :=
	filesystem specific label.
	
All those labels are tacked onto the LU, and are provided by
various layers: transport, LLDD, vendor, manufacturer, etc, etc, etc.

	Luben


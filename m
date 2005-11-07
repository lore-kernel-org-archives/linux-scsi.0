From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 12:18:05 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF45@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:31892 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S964923AbVKGUSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 15:18:09 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, usb-storage@lists.one-eyed-alien.net, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org


> > 
> > Can we trigger black listing based on the above 
> vendor/product values?
> > i.e. can you check for these values in usb-storage 
> slave_configure code?
> 
> Yes.  The patch below illustrates how.  You'll have to change 
> the name of 
> the sdev flag to something sensible...
> 
> I firmly believe this is the wrong approach, however.  It's a 
> specific 
> solution to a general problem.  I would much prefer to add a 
> new flag to 
> struct request.

I totally agree.

> 
> > Yeh, some other hardware might want lun inihibit in the 
> future, and that
> > could still be added back, but IMHO black list is better.
> 
> I'd say it's inevitable.  And it may even end up being 
> standard-based, not 
> vendor/product based.

Within a year from now, there are going to be USB devices
natively supporting the SAT passthru CDB.  Once this happens,
its going to be CDB based and not vendor/product based on
when to not mangle the CDB; chips from different vendors
will support the CDB.  The blacklist approach really isn't
going to scale, where the flag approch will.  Plus with
a blacklist there would always be a lead time until a
device with passthru supported works correctly under the
kernel (blacklist update), where with a flag approach,
support is automatic.

Regards,
Tim Thelin


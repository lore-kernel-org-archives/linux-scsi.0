From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 09:51:31 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF43@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:5189 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S964958AbVKGRvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 12:51:36 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>



> > Okay, what am I missing?
> > 
> > Looking at that patch, it looks to me like if sg.c set a 
> flag in the SCSI
> > command block then scsi_core.c could use that flag in the 
> test to determine
> > if the LUN should be masked-in.
> > 
> > HOWEVER, I keep hearing that the changes will be extensive. 
>  What am I
> > missing?
> 
> Not extensive AFAICT ... 
> 
> The scmd/cdb is not available until we call scsi_get_command() in the
> request function. So you would have to add a field into 
> scsi_request, set
> it in sg (in both sg.c block/scsi_ioctl.c, test via sd and sg 
> when you are
> done), and add the field in scsi_cmnd, and set scmd one in
> scsi_init_cmd_from_req().
> 

I'l sign up as a tester =D

> But as far as black listing, it does seem like a better 
> solution in that
> user apps do not need special code.
> 
> Do the devices that require it (well so far) have useable 
> vendor + model
> strings or usb id's?
> 

Actually, from my point of view its better to do the flag than
use a blacklist.  Blacklists require active maintenence, so
everytime WD releases a new product based on this cypress chip,
the kernel needs yet another entry (and there are a couple more
on our roadmap).  I actually see the flag solution as a more
generic forward looking solution; it's one patch verses one
patch per device. And from the point of view of someone who
creates utilities that need raw access to hard drives, this
flag is trivial to support in userspace and makes logical sense.

The two userspace cases I can think of:
1) Tool is aware of what device its trying to access.  Well since
it knows the device it wants to get access to, it will also
be aware of if it needs that flag or not.
2) Tool is generic (sdparm, hdparm) and tries to access whatever
device it's pointed at.  We'll based off of the cdb it tries to
construct, its going to know if it needs that flag or not.  Both
the ATACB and the SAT passthru CDB would need that flag since
they both have meaningful information in the LUN bits.  For cdbs
that don't have meaningful bits there, they don't have to use the
flag.

So by going the flag route, you need one kernel change, and one
userspace change per tool to be flag aware.  Then future products
that use the same passthru cdbs will get supported for free, unlike
the blacklist approach.


Regards,
Tim Thelin
Software Engineer
Western Digital








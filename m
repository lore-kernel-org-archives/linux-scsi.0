From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: scsi: fix target reset handling
Date: Tue, 4 Mar 2008 10:34:56 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70D55464@NAMAIL4.ad.lsil.com>
References: <47CD68F9.5060108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50576 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYCDRfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 12:35:52 -0500
Content-class: urn:content-classes:message
In-Reply-To: <47CD68F9.5060108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx, "Hagan, Steve" <Steve.Hagan@lsi.com>, "Rivera, Peter" <Peter.Rivera@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tuesday, March 04, 2008 8:21 AM,  Mike Christie wrote: 

> > The fusion firmware supports Logical Unit Reset, so why not fix
> > mptscsih_dev_reset so its passing
> > MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, and lun number to
> > mptscsih_TMHandler, and create the new function 
> mptscsih_target_reset as
> > you've done?
> > 
> 
> I did not do this because I was not trying to add new 
> functionality. I 
> was just trying to fix what was there.

No problem, lets go for what you've done already, thanks,

> 
> How about I add the LU reset support in a separate patch, so 
> git revert 
> will be kinder to me?
> 

Seperate patch, no problem.

> There was also some side discussion about side affects of doing a lu 
> reset and if we need to be doing something more than what we do today 
> from the device reset handler, so I did not want to dig into that in 
> this patchset. I am just trying to get target reset done in 
> the proper 
> place on this pass. In later patches I want to tackle TMFs like lu 
> reset, abort task set, etc.
> 

I'm pretty sure that windows supports LU Reset callback handlers,
instead of target reset.  I'm not sure if there are any side effects,
for instance non supported devices.  I've copied Steve Hagan, perhaps he
might have some feedback on that.

Is there any chance for TM callback support in the transport, for
instance in SAS, we have phy, link and hard reset.  I believe the
current support is manually invoked via sysfs.

Eric 


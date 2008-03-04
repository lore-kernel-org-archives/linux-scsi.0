From: "Hagan, Steve" <Steve.Hagan@lsi.com>
Subject: RE: scsi: fix target reset handling
Date: Tue, 4 Mar 2008 10:40:35 -0700
Message-ID: <61DA31637BAF774FB13AC59B6381C080A9CFC1@NAMAIL4.ad.lsil.com>
References: <47CD68F9.5060108@cs.wisc.edu> <664A4EBB07F29743873A87CF62C26D70D55464@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51000 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbYCDRmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 12:42:02 -0500
Content-class: urn:content-classes:message
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70D55464@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx, "Rivera, Peter" <Peter.Rivera@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Windows (StorPort drivers) supports LUN, target, and bus resets in a
hierarchical fashion.  If an I/O times out, Storport will issue a LUN
reset first.  If that fails, it will escalate to a target reset.  If
that fails, it will escalate to a bus reset.

What does "fail" mean?  If the TM request returns with a non-success
status, or if there are outstanding I/O's for the scope of the reset
remaining after we receive the TM reply, then the reset is considered
failed.  Our miniport driver will return error status back to Storport
and it will escalate to the next level of reset.  A bus reset cannot be
failed back to Storport.  If a bus reset fails (as above) then the only
recourse if for the miniport to do a hard reset of the adapter and
return all outstanding I/O's with reset status.

Steve H. 

-----Original Message-----
From: Moore, Eric 
Sent: Tuesday, March 04, 2008 11:35 AM
To: Mike Christie
Cc: linux-scsi@vger.kernel.org; james.smart@emulex.com;
andrew.vasquez@qlogic.com; christof.schmitt@de.ibm.com; mp3@de.ibm.com;
rmk@arm.linux.org.uk; matthew@wil.cx; Hagan, Steve; Rivera, Peter;
Prakash, Sathya
Subject: RE: scsi: fix target reset handling

On Tuesday, March 04, 2008 8:21 AM,  Mike Christie wrote: 

> > The fusion firmware supports Logical Unit Reset, so why not fix 
> > mptscsih_dev_reset so its passing 
> > MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, and lun number to 
> > mptscsih_TMHandler, and create the new function
> mptscsih_target_reset as
> > you've done?
> > 
> 
> I did not do this because I was not trying to add new functionality. I

> was just trying to fix what was there.

No problem, lets go for what you've done already, thanks,

> 
> How about I add the LU reset support in a separate patch, so git 
> revert will be kinder to me?
> 

Seperate patch, no problem.

> There was also some side discussion about side affects of doing a lu 
> reset and if we need to be doing something more than what we do today 
> from the device reset handler, so I did not want to dig into that in 
> this patchset. I am just trying to get target reset done in the proper

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


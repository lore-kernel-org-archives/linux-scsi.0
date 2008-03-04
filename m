From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi: fix target reset handling
Date: Tue, 04 Mar 2008 09:21:29 -0600
Message-ID: <47CD68F9.5060108@cs.wisc.edu>
References: <664A4EBB07F29743873A87CF62C26D70D55122@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50968 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760232AbYCDPYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 10:24:20 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70D55122@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

Moore, Eric wrote:
> On Friday, February 29, 2008 5:25 PM,  Mike Christie wrote:
>> This patchset fixes the problem where scsi-ml will call the 
>> device reset
>> handler for each logical unit, but some drivers are sending a target
>> reset. Because we do not need to send a target reset multiple times,
>> this patchset creates a new target reset callout which of course is
>> called once per target instead of once per lu. It also cleans up
>> the all the commands sent to the target when SUCCESS is returned.
>>
>> qla4xxx, qla2xxx and lpfc were test with a hacked up sg_reset. I also
>> sent lots of commands to the target and decreased the cmd timeout to
>> 1 second so the scsi would run (turned off the eh abort callout too).
>>
>> The arm scsi, mpt fusion, sym53c8xx_2, and a100u2w, and qla1280
>> drivers were only compile tested, but looked like the only needed
>> a rename of the scsi eh handler.
>>
>> The zfcp driver is also only compile tested. It was doing a lun
>> reset and possibly target reset, so I split that up to use
>> the device and target reset handlers. scsi-ml will escalate from
>> the device to the target reset for the driver.
>>
>>
> 
> The fusion firmware supports Logical Unit Reset, so why not fix
> mptscsih_dev_reset so its passing
> MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, and lun number to
> mptscsih_TMHandler, and create the new function mptscsih_target_reset as
> you've done?
> 

I did not do this because I was not trying to add new functionality. I 
was just trying to fix what was there.

How about I add the LU reset support in a separate patch, so git revert 
will be kinder to me?

There was also some side discussion about side affects of doing a lu 
reset and if we need to be doing something more than what we do today 
from the device reset handler, so I did not want to dig into that in 
this patchset. I am just trying to get target reset done in the proper 
place on this pass. In later patches I want to tackle TMFs like lu 
reset, abort task set, etc.

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/10] drivers: convert fc drivers calling scsi_track_queue_full
Date: Fri, 11 Sep 2009 11:18:50 -0500
Message-ID: <4AAA786A.6020303@cs.wisc.edu>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>	 <20090903222247.24946.60577.stgit@vi1.jf.intel.com>	 <412A05BA40734D4887DBC67661F433080FF72616@EXMAIL.ad.emulex.com> <1252100607.4516.35.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57965 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZIKQTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 12:19:03 -0400
In-Reply-To: <1252100607.4516.35.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Alex.Iannicelli@Emulex.Com, andrew.vasquez@qlogic.com, James.Bottomley@HansenPartnership.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com, robert.w.love@intel.com, christof.schmitt@de.ibm.com

On 09/04/2009 04:43 PM, Vasu Dev wrote:
> On Fri, 2009-09-04 at 06:47 -0700, Alex.Iannicelli@Emulex.Com wrote:
>> It looks like you moved the ramp up functionality into the scsi layer,
>> but did not move the ramp up code from the lpfc driver in the
>
> Correct.
>
>>   lpfc_scsi_cmd_iocb_cmpl routine (just above the code that was removed
>> for the ramp down in this patch) to the new lpfc_change_queue_depth
>> routine. I think that this new routine should handle both ramp up and
>> ramp down but you have it only handling the ramp down case.
>>
>
> I agree all FC HBA should handle both ramp down and up as per added new
> change_queue_depth interface by this series. I did this for libfc/fcoe
> and Chrirstof did this for zfcp driver but lpfc&  qla2xxx got only ramp
> down changes from Mike, now that Mike is busy with other stuff I don't
> know how to complete them in this series since I don't understand lpfc
> and qla2xxx enough and neither I have way to test changes to these
> drivers.
>
> So I'm going to update this series to have just libfc and zfcp driver
> changes for now and lpfc and qla2xxx can be updated later by someone
> familiar lpfc and qla2xxx, their ramp down changes can be collect from
> this series post.
>

I think it is fine not to convert a driver immediately and let the 
driver maintainer handle it. I normally like to take a stab at it to try 
and give the driver maintainer some more info on the how I think it 
should work.

I think at the very least you want to make sure your code will work for 
other drivers, so sometimes doing a pseudo patch is useful for another 
reason.

For the case of lpfc and rampup I think we need a little more code. It 
looks like lpfc will ramp down queues if it gets a reject on its port 
(when we get a IOSTAT_LOCAL_REJECT we call lpfc_rampdown_queue_depth). 
When it then tries to ramp up, it also takes that rampdown event into 
account. The common code being added by Vasu, only tracks rampdown 
events from QUEUE_FULLs.

You probably want to make a common fc class function which loops over 
vports and will ramp down queues. The fc LLD can then call this and that 
common fc function can make sure the common rampdown tracking is done so 
later on the ramp up code can take that into account.

Reviewing lpfc also brings up the question of why it was not doing the 
ramp up in the main IO path. It looks like it is done in a worker 
thread. The ramp down for a QUEUE_FULL is probably done in the main IO 
path because we are already getting errors and we want to prevent new 
ones. But for the ramp up, did Emulex experience performance hits when 
ramping up in the main IO path?

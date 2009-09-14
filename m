From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/10] drivers: convert fc drivers calling scsi_track_queue_full
Date: Mon, 14 Sep 2009 12:09:49 -0500
Message-ID: <4AAE78DD.9070808@cs.wisc.edu>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>	 <20090903222247.24946.60577.stgit@vi1.jf.intel.com>	 <412A05BA40734D4887DBC67661F433080FF72616@EXMAIL.ad.emulex.com>	 <1252100607.4516.35.camel@vi2.jf.intel.com>  <4AAA786A.6020303@cs.wisc.edu> <1252711553.13165.129.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50757 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375AbZINRKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 13:10:01 -0400
In-Reply-To: <1252711553.13165.129.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Alex.Iannicelli@Emulex.Com, andrew.vasquez@qlogic.com, James.Bottomley@HansenPartnership.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com, robert.w.love@intel.com, christof.schmitt@de.ibm.com

Vasu Dev wrote:
> On Fri, 2009-09-11 at 11:18 -0500, Mike Christie wrote:
>> On 09/04/2009 04:43 PM, Vasu Dev wrote:
>>> On Fri, 2009-09-04 at 06:47 -0700, Alex.Iannicelli@Emulex.Com wrote:
>>>> It looks like you moved the ramp up functionality into the scsi layer,
>>>> but did not move the ramp up code from the lpfc driver in the
>>> Correct.
>>>
>>>>   lpfc_scsi_cmd_iocb_cmpl routine (just above the code that was removed
>>>> for the ramp down in this patch) to the new lpfc_change_queue_depth
>>>> routine. I think that this new routine should handle both ramp up and
>>>> ramp down but you have it only handling the ramp down case.
>>>>
>>> I agree all FC HBA should handle both ramp down and up as per added new
>>> change_queue_depth interface by this series. I did this for libfc/fcoe
>>> and Chrirstof did this for zfcp driver but lpfc&  qla2xxx got only ramp
>>> down changes from Mike, now that Mike is busy with other stuff I don't
>>> know how to complete them in this series since I don't understand lpfc
>>> and qla2xxx enough and neither I have way to test changes to these
>>> drivers.
>>>
>>> So I'm going to update this series to have just libfc and zfcp driver
>>> changes for now and lpfc and qla2xxx can be updated later by someone
>>> familiar lpfc and qla2xxx, their ramp down changes can be collect from
>>> this series post.
>>>
>> I think it is fine not to convert a driver immediately and let the 
>> driver maintainer handle it. I normally like to take a stab at it to try 
>> and give the driver maintainer some more info on the how I think it 
>> should work.
>>
>> I think at the very least you want to make sure your code will work for 
>> other drivers, so sometimes doing a pseudo patch is useful for another 
>> reason.
>>
> 
> I'll try to come up with a compile tested code for lpfc and you already
> did that for qla2xx ramp up today. As you said "it is fine not to
> convert a driver immediately", so I'll provide this separately and will
> try to do it earliest possible.
> 
> Modified change_queue_depth interface changes by this series should be
> sufficient to later do lpfc and qla2xx changes.
>  
>> For the case of lpfc and rampup I think we need a little more code. It 
>> looks like lpfc will ramp down queues if it gets a reject on its port 
>> (when we get a IOSTAT_LOCAL_REJECT we call lpfc_rampdown_queue_depth). 
>> When it then tries to ramp up, it also takes that rampdown event into 
>> account. The common code being added by Vasu, only tracks rampdown 
>> events from QUEUE_FULLs.
>>
> 
> The qla2xx ramps down only on QUEUE_FULL beside added zfcp and lpfc
> doing same only on QUEUE_FULL condition, but still a HBAs could call
> their own change_queue_depth function for other conditions to ramp down
> e.g. lpfc for IOSTAT_LOCAL_REJECT.

If they do this will they have to duplicate the rampdown/up time 
tracking done by the common scsi_error code?

> 
> The lpfc and qla2xxx both are calling ramp up code only after specified
> time interval since last ramp down/up on a successful IO completion, so
> does the added code  does the same with tunable time interval. I chose
> least 120HZ from qla2xxx as default.
> 
> So added common code for ramp down/up is sufficient for majority of FC
> HBAs and lpfc specific additional criteria should be limited to only
> lpfc HBA code. 

Why should it only be limited to lpfc? Are you saying other drivers or 
hw do not have something like a local reject or out of hba port 
resources? Do you know this by just looking at the driver? A lot of 
times lpfc will add something then other drivers (myself included) will 
add it later when they have seen lpfc do it. Or are you saying you think 
other drivers are going to want to handle the problem in a different way?

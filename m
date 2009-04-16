From: James Smart <James.Smart@Emulex.Com>
Subject: Re: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 10:38:06 -0400
Message-ID: <49E742CE.3020302@emulex.com>
References: <20090416093604.GA7096@schmichrtp.de.ibm.com> <49E73D16.9030307@emulex.com> <49E74058.5010401@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63787 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZDPOjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 10:39:12 -0400
In-Reply-To: <49E74058.5010401@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Mike Christie wrote:
> James Smart wrote:
>   
>> The mid-layer queue depth handling is really designed/optimized around 
>> behavior for
>> a JBOD. This, if it's a single-lun device, the LLDD could largely ignore 
>> doing anything
>> with adjusting the queue depth.
>>
>> However, for arrays, with multiple luns, the queue depth is usually a 
>> target-level resource,
>> so the midlayer/block-layer's implementation falls on its face fairly 
>> quickly. I brought this
>> up 2 yrs ago at storage summit.  What needs to happen is the creation of 
>> queue ramp-down
>> and ramp-up policies that can be selected on a per-lun basis, and have 
>> these implemented
>> in the midlayer (why should the LLDD ever look at scsi command 
>> results).  What will make
>> this difficult is the ramp-up policies, as it can be very target 
>> device-specific or configuration/load
>> centric.
>>     
>
> For the rampup are you referring to code like lpfc_rampup_queue_depth? 
> Were were just talking about this on the fcoe list. Why did lpfc and 
> qla2xxx end up implememting their own code? We started to look into 
> moving this into the scsi layer. It does not seem like there was a major 
> reason why it should not have been more common. Was it just one of those 
> things where it got added in one driver then added in another?
>   
No good reason.  It should be in the midlayer, and that was the 
recommendation I made at
storage summit a couple of years ago. It hasn't as, for the drivers that 
care, they had already
implemented it. It also isn't a relished task, as there will be lots of 
discussion on how the
ramp-up should be implemented - which may mean, the need for more 
algorithms.
> If we moved code like that to the scsi layer, then is all the is needed 
> is a interface to config this?
>   
Yep. As mentioned, figuring out what algorithm, for what device and 
configuration, will be
the more interesting thing.

-- james


